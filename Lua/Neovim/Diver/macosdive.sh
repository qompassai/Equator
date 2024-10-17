#!/usr/bin/env bash

set -e

# Function to install dependencies for macOS
function install_macos {
	# Homebrew is required
	if ! command -v brew &>/dev/null; then
		echo "Homebrew not found. Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	echo -e "Installing dependencies for macOS..."
	brew install openresty node python ruby rustup jq
	rustup install stable
	pip3 install --user jupyter

	echo "All dependencies have been installed successfully for macOS!"
}

install_macos
