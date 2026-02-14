#!/bin/bash
# =============================================================================
# SSH Key Generation Script (RSA 4096-bit)
# Email: rnswo42b@gmail.com
# =============================================================================

set -euo pipefail

EMAIL="rnswo42b@gmail.com"
KEY_TYPE="rsa"
KEY_BITS="4096"
KEY_FILE="$HOME/.ssh/id_${KEY_TYPE}_${KEY_BITS}"

echo "=== SSH Key Generation Script ==="
echo "Email          : $EMAIL"
echo "Key type       : $KEY_TYPE"
echo "Key size       : $KEY_BITS bits"
echo "Output location: $KEY_FILE"
echo ""

# Check if key already exists
if [ -f "${KEY_FILE}" ] || [ -f "${KEY_FILE}.pub" ]; then
    echo "⚠️  A key already exists at this location!"
    echo "    $KEY_FILE"
    echo "    $KEY_FILE.pub"
    echo ""
    read -p "Do you want to overwrite the existing key? (y/N): " answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
    echo ""
fi

# Generate the key
echo "Generating SSH key... (you can leave the passphrase empty)"
ssh-keygen \
    -t "$KEY_TYPE" \
    -b "$KEY_BITS" \
    -C "$EMAIL" \
    -f "$KEY_FILE" \
    -q

# Check result
if [ $? -eq 0 ] && [ -f "${KEY_FILE}" ] && [ -f "${KEY_FILE}.pub" ]; then
    echo ""
    echo "✔ Key generation successful!"
    echo ""
    echo "Private key: $KEY_FILE"
    echo "Public key : $KEY_FILE.pub"
    echo ""
    echo "Public key content (copy this to GitHub, GitLab, etc.):"
    echo "───────────────────────────────────────────────"
    cat "${KEY_FILE}.pub"
    echo "───────────────────────────────────────────────"
    echo ""

    # Set secure permissions
    chmod 700 ~/.ssh
    chmod 600 "$KEY_FILE"
    chmod 644 "${KEY_FILE}.pub"

    echo "Permissions set (700 ~/.ssh, 600 private key, 644 public key)"

    # Ask if user wants to add to ssh-agent
    echo ""
    read -p "Add this key to ssh-agent now? (y/N): " add_agent
    if [[ "$add_agent" =~ ^[Yy]$ ]]; then
        eval "$(ssh-agent -s)" >/dev/null 2>&1
        ssh-add "$KEY_FILE"
        echo "Key added to ssh-agent."
    fi

    echo ""
    echo "Quick tips:"
    echo "  • Copy public key to clipboard:"
    echo "      cat ~/.ssh/id_rsa_4096.pub | xclip -sel clip   (or wl-copy on Wayland)"
    echo "  • Example ~/.ssh/config entry:"
    echo "      Host github.com"
    echo "          IdentityFile ~/.ssh/id_rsa_4096"
    echo ""

else
    echo "× Key generation failed." >&2
    exit 1
fi

echo "Done! You can now register the public key with your services."