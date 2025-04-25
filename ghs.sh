#!/bin/bash
# File: ~/bin/git-config-setup.sh

# Set up user info
git config user.name "$(pass show gh/user)"
git config user.email "$(pass show gh/email)"

# Get the signing key dynamically using GitHub CLI
# This finds the key specifically marked as "signing"
SIGNING_KEY_DATA=$(gh ssh-key list --json id,key,type | jq -r '.[] | select(.type=="signing") | .key' | head -1)

if [ -z "$SIGNING_KEY_DATA" ]; then
    echo "No signing key found. Falling back to authentication key with specific ID"
    # Alternatively, fall back to a specific authentication key by ID
    # Using the map@qompass.ai key with ID 114258411 from your list
    SIGNING_KEY_DATA=$(gh ssh-key list --json id,key | jq -r '.[] | select(.id==114258411) | .key')
fi

if [ -z "$SIGNING_KEY_DATA" ]; then
    echo "Error: Could not find a suitable SSH key for signing"
    exit 1
fi

# Extract key path from SSH agent
KEY_PATH=$(ssh-add -L | grep -F "$SIGNING_KEY_DATA" | awk '{print $NF}')

if [ -n "$KEY_PATH" ]; then
    # If key is loaded in agent with a path
    git config user.signingkey "$KEY_PATH"
else
    # Store the key temporarily and use it
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    
    echo "$SIGNING_KEY_DATA" > "$TEMP_DIR/id_signing.pub"
    KEY_PATH="$TEMP_DIR/id_signing"
    
    # Configure to use the key by content rather than path
    git config user.signingkey "key::$SIGNING_KEY_DATA"
fi

git config gpg.format ssh
git config commit.gpgsign true

# Create allowed_signers file with the SSH public key
printf "$(pass show gh/email) namespaces=\"git\" %s\n" "$SIGNING_KEY_DATA" > ~/.ssh/allowed_signers
git config gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers

printf "Git configuration updated with secure credentials\n"

