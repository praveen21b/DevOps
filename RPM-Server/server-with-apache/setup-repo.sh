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

# Create repository metadata
createrepo --update "$REPO_DIR"
