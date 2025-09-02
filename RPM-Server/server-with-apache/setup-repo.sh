#!/bin/bash

set -euo pipefail

REPO_DIR=/var/www/html/RPM-Repo

mkdir -p $REPO_DIR

# GPG key info (customize)
NAME="Name Surname"
EMAIL="your-email@example1.com"
PASSPHRASE="RPM-Repository"
KEY_FILE="RPM-GPG-KEY-RPM-REPO"

cd "$REPO_DIR"

# Generate a fresh GPG key for each image build
gpg --batch --pinentry-mode loopback --passphrase "$PASSPHRASE" --generate-key <<EOF
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: $NAME
Name-Email: $EMAIL
Expire-Date: 0
EOF

# Export public key
gpg --armor --export "$EMAIL" > "$REPO_DIR/$KEY_FILE"

# Import key into rpm signing system
gpg --import "$KEY_FILE"

# Create ~/.rpmmacros file to tell rpm which key to use
echo "%_gpg_name $EMAIL" > ~/.rpmmacros

# Sign all RPMs in the repo directory
for rpm in *.rpm; do
  if [ -f "$rpm" ]; then
    echo "Signing $rpm..."
    rpm --addsign "$rpm"
  fi
done

# Create repository metadata
createrepo --update "$REPO_DIR"

# Disable Apache default welcome page
rm -rf /etc/httpd/conf.d/welcome.conf
touch /etc/httpd/conf.d/welcome.conf
