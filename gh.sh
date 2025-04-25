#!/bin/bash
# File: ~/bin/git-config-setup.sh
git config user.name "$(pass show gh/user)"
git config user.email "$(pass show gh/email)"
git config user.signingkey "$(pass show gh/sk)"
git config gpg.format ssh
git config commit.gpgsign true
printf "$(pass show gh/email) namespaces=\"git\" $(pass show gh/sk)" > ~/.ssh/allowed_signers
git config gpg.ssh.allowedSignersFile ~/.ssh/allowed_signers

printf "Git configuration updated with secure credentials"
