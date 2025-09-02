# Kubernetes etcd Encryption at Rest Setup & Key Rotation

This guide provides scripts and instructions to **set up etcd encryption at rest** in Kubernetes and **rotate encryption keys** securely.

---

## Directory Structure
```
etcd_encrypt/
├── encryption_script.sh # Main script for init & rotation
├── # Stores encryption keys
│ ├── new-key
│ └── old-key
├── encryption-config.yaml # Generated config for kube-apiserver
└── README.md # This file
```
---

## Features

- **Initialization**: Creates a secure encryption configuration with a new AES key.
- **Rotation**: Safely adds a new key while keeping the old one for decryption.
- **Fail-safes**: Prevents re-running `init` if already initialized.
- **Distribution**: Copies encryption config to all control plane nodes.
- **Manifest Patching**: Updates `kube-apiserver` manifest to enable encryption.
- **Re-Encryption**: Provides helper commands to re-encrypt data.

---

## 🛠️ Usage

```bash
./encrypt_rotate.sh init      # Initialize encryption
./encrypt_rotate.sh rotate    # Rotate encryption key
```

---
## 🔑 Initialization (`init`)

1. Generates a **new AES 32-byte key**.
2. Creates `encryption-config.yaml`:
    ```yaml
    apiVersion: apiserver.config.k8s.io/v1
    kind: EncryptionConfiguration
    resources:
      - resources:
          - '*.*'
        providers:
          - aesgcm:
              keys:
                - name: key1
                  secret: <generated-key>
          - identity: {}
    ```
3. Saves the generated key in `key1.txt`.
4. Copies the encryption config to **all control plane nodes**.
5. Patches the `kube-apiserver` manifest to enable encryption.

---
## Rotation (`rotate`)

1. Renames `key1.txt` → `key2.txt`.
2. Generates a **new key** → `key1.txt`.
3. Updates `encryption-config.yaml` so the **new key is at the top**:
    ```yaml
    keys:
      - name: key-new
        secret: <new-key>
      - name: key-old
        secret: <old-key>
    ```
4. Copies updated config to all control plane nodes.
5. Restarts `kube-apiserver`.

## Re-Encrypting Resources

After rotation, **existing data remains encrypted with the old key** until replaced.

Re-encrypt all supported resources:

```bash
# Secrets
kubectl get secrets --all-namespaces -o json | kubectl replace -f -

# ConfigMaps (if encrypted)
kubectl get configmaps --all-namespaces -o json | kubectl replace -f -

# ServiceAccounts (if encrypted)
kubectl get serviceaccounts --all-namespaces -o json | kubectl replace -f -
```

---
