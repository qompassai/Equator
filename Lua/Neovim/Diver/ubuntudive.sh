#!/usr/bin/env bash

set -e

echo -e "Installing dependencies for Ubuntu/Debian..."
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:openresty/ppa
sudo apt update
sudo apt install -y openresty nodejs npm python3 python3-pip ruby rustc jq curl
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
pip3 install --user jupyter

echo "All dependencies have been installed successfully for Ubuntu/Debian!"
