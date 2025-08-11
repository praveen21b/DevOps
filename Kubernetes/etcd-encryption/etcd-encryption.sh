#!/bin/bash

set -Xeuo pipefail

# === Check user input ===
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <init|rotate>"
  exit 1
fi

MODE="$1"

if [[ "$MODE" == "init" ]]; then
  if [[ -f "key1.txt" ]]; then
    echo "ERROR: Encryption appears to be already initialized!"
    echo "Found key file: 'key1.txt'"
    echo "If you really want to reinitialize, delete the key file manually"
    exit 1
  fi
fi

# Control plane nodes (update with hostnames or IPs)
CONTROL_PLANES=("10.2.10.11" "10.2.10.12" "10.2.10.13")

# === Configuration ===
CONFIG_FILE_NAME=encryption-config.yaml
ENC_FILE="/etc/kubernetes/enc"
CONFIG_FILE=$ENC_FILE/$CONFIG_FILE_NAME
MANIFEST="/etc/kubernetes/manifests/kube-apiserver.yaml"
BACKUP_DIR="/root/kube-manifest-backups"

# === install yq  if needed===
BIN="/usr/local/bin"
YQ_BIN="/usr/local/bin/yq"
if ! command -v $YQ_BIN &> /dev/null; then
  VERSION=v4.2.0
  BINARY=yq_linux_amd64
  curl -L "https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY}" -o "$YQ_BIN"
  chmod +x "$YQ_BIN"
fi

# === 1. Generate AES Key ===
generate_key(){
  head -c 32 /dev/urandom | base64
}

# === MODE: init ===
init_encryption() {
  echo "Initializing encryption..."

  KEY=$(generate_key)
  echo "$KEY" > "key1.txt"

  cat <<EOF > "$CONFIG_FILE_NAME"
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - '*.*'
    providers:
      - aesgcm:
          keys:
            - name: key1
              secret: $KEY
      - identity: {}
EOF

  distribute_config
  patch_manifests

  echo "Initial etcd encryption configuration applied."
}

rotate_key() {
  echo "Rotating encryption key..."

  # Ensure key1 exists
  if [ ! -f "key1.txt" ]; then
    echo "Error: key1.txt (initial key) not found. Run init first."
    exit 1
  fi

  # Move key1 → key2
  mv "key1.txt" "key2.txt"

  # Create new key1
  NEW_KEY=$(generate_key)
  echo "$NEW_KEY" > "key1.txt"

  # Read keys
  KEY_NEW=$(cat "key1.txt")
  KEY_OLD=$(cat "key2.txt")

  cat <<EOF > "$CONFIG_FILE_NAME"
apiVersion: apiserver.config.k8s.io/v1
kind: EncryptionConfiguration
resources:
  - resources:
      - '*.*'
    providers:
      - aesgcm:
          keys:
            - name: key-new
              secret: $KEY_NEW
            - name: key-old
              secret: $KEY_OLD
      - identity: {}
EOF

  distribute_config
  echo "Distribution of encryption config and yq completed on all control plane nodes."
  patch_manifests

  echo "Rotation complete. New key applied."
}

distribute_config() {
  for node in "${CONTROL_PLANES[@]}"; do
    echo "Copying encryption config to $node"
    ssh "$node" "sudo mkdir -p $ENC_FILE $BIN"
    scp "$CONFIG_FILE_NAME" "$node:$CONFIG_FILE"
    scp "$YQ_BIN" "$node:$YQ_BIN"
    ssh "$node" "chmod +x $YQ_BIN"
  done
}

patch_manifests() {
  for node in "${CONTROL_PLANES[@]}"; do
    echo "Patching kube-apiserver manifest on $node"

    # BACKUP remote manifest
    ssh "$node" sudo mkdir -p "$BACKUP_DIR"
    ssh "$node" sudo cp "$MANIFEST" "$BACKUP_DIR/kube-apiserver.yaml.bak-$(date +%F_%T)"

    # Patch --encryption-provider-config flag
    ssh "$node" "
    if ! grep -q -- '--encryption-provider-config=$CONFIG_FILE' '$MANIFEST'; then
        $YQ_BIN e -i '.spec.containers[0].command |= . + [\"--encryption-provider-config=$CONFIG_FILE\"]' '$MANIFEST'
    fi
    "

    # Patch volumeMounts if not present
    ssh "$node" "if ! $YQ_BIN e '.spec.containers[0].volumeMounts[].name' $MANIFEST | grep -q '^encryption-config$'; then
    $YQ_BIN e -i '
        .spec.containers[0].volumeMounts += [{
        \"name\": \"encryption-config\",
        \"mountPath\": \"$ENC_FILE\",
        \"readOnly\": true
        }]
    ' $MANIFEST
    fi"

    # Patch volumes if not present
    ssh "$node" "if ! $YQ_BIN e '.spec.volumes[].name' $MANIFEST | grep -q '^encryption-config$'; then
    $YQ_BIN e -i '
        .spec.volumes += [{
        \"name\": \"encryption-config\",
        \"hostPath\": {
            \"path\": \"$ENC_FILE\",
            \"type\": \"DirectoryOrCreate\"
        }
        }]
    ' $MANIFEST
    fi"
  done

  # updating modifying time
  touch $MANIFEST
}

# === MAIN ENTRY ===
case "$MODE" in
  init)
    init_encryption
    ;;
  rotate)
    rotate_key
    ;;
  *)
    echo "Invalid option: $MODE"
    echo "Usage: $0 {init|rotate}"
    exit 1
    ;;
esac

rm -rf encryption-config.yaml

echo "etcd encryption config applied across all control planes."

# re-encrypt all resources please add required resources accordingly
# Secrets
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

# ConfigMaps (only if encrypted)
kubectl get configmaps --all-namespaces -o json | kubectl replace -f -

# ServiceAccounts (if configured)
kubectl get serviceaccounts --all-namespaces -o json | kubectl replace -f -
