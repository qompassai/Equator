#!/usr/bin/env bash

set -e

echo -e "Installing dependencies for Arch Linux..."
sudo pacman -Syu --needed --noconfirm openresty nodejs python ruby rustup jq
rustup install stable
python -m ensurepip --user
pip install --user jupyter

echo "All dependencies have been installed successfully for Arch Linux!"
