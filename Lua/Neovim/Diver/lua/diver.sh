#!/usr/bin/env bash

set -e

# Function to detect the operating system
function detect_os {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ "$(uname)" == "Darwin" ]; then
        OS=" (macOS)"
    else
        echo "Unsupported OS"
        exit 1
    fi
}

# Install dependencies for macOS
function install_macos {
    # Homebrew is required
    if ! command -v brew &>/dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo -e " Installing dependencies for macOS..."
    brew install openresty node python ruby rustup jq
    rustup install stable
    pip3 install --user jupyter
}

# Install dependencies for Arch Linux
function install_ (Arch Linux) {
    echo -e " Installing dependencies for Arch Linux..."
    sudo pacman -Syu --needed --noconfirm openresty nodejs python ruby rustup jq
    rustup install stable
    python -m ensurepip --user
    pip install --user jupyter
}

# Install dependencies for Ubuntu
function install_ (Ubuntu/Debian) {
    echo -e " Installing dependencies for Ubuntu/Debian..."
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:openresty/ppa
    sudo apt update
    sudo apt install -y openresty nodejs npm python3 python3-pip ruby rustc jq curl
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    pip3 install --user jupyter
}

# Function to install dependencies based on detected OS
function install_dependencies {
    case $OS in
        "arch")
            install_arch
            ;;
        "ubuntu"|"debian")
            install_ubuntu
            ;;
        "macos")
            install_macos
            ;;
        *)
            echo "Unsupported operating system: $OS"
            exit 1
            ;;
    esac
}

# Main script execution
function main {
    detect_os
    install_dependencies

    echo "All dependencies have been installed successfully!"
}

main
