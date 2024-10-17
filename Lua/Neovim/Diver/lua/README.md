# Qompass Diver for Neovim

**Qompass Diver** was inspired by the great folks who made [NvChad](https://github.com/NvChad/NvChad). The intent of Diver is to build on the original configuration framework to provide an even more powerful, customizable, and user-friendly experience that bridges the skills gap left by education and industry. Qompass Diver enhances the flexibility of the original project while focusing on AI, cloud integrations, education, and developer productivity.

## Features

Qompass Diver builds upon the solid foundation of NvChad, offering the following enhancements:

### AI Integration
- **Hugging Face Transformers**: Provides support for machine learning workflows with integration into Hugging Face transformers.
- **CUDA Support**: Tools and integrations for CUDA-based AI development, helping you leverage your GPU for machine learning tasks.
- **Ollama integration**: A plugin that provides AI-assisted code generation capabilities, integrating seamlessly with Neovim for improved productivity.
- **Open-Source Cursor via Avante**: Enhances AI-driven workflows, offering advanced completions and intelligent suggestions within Neovim.

### Cloud Development
- **Remote Editing**: Allows seamless editing of files over SSH and remote machines using plugins like distant.lua, sshfs.lua, and more.
- **GPG & SSH Management**: Manage GPG and SSH keys effortlessly within Neovim for secure remote development environments.

### Educational Tools
- **nvim-be-good**: Helps users practice and improve their Neovim proficiency with gamified learning tools.
- **Twilight**: A focus mode plugin that dims inactive portions of code to keep you concentrated on your current task.

### Developer Productivity
- **Jupyter Integration**: Enables running Jupyter notebooks inside Neovim, streamlining data science and development workflows.
- **Markdown to PDF Conversion**: Quickly convert Markdown documents into PDF files without leaving Neovim.
- **Completions and LSP**: Enhanced autocompletion and language server configurations with completion.lua and nvim-lsp.lua, supporting multiple languages and tools.
- **Debugging Tools**: Integrated debugging support using the Debug Adapter Protocol (DAP) and additional utilities.

### Enhanced UI and UX
- **Telescope Themes**: Easily toggle between themes via telescope integrated with transparent backgrounds
- **Lualine Integration**: Enhanced status line management with lualine.lua for better customization and UI experience.
- **Gitsigns**: Visual indicators for Git changes in the gutter for quick code reviews and version control management.

### Developer Tools
- **Rust Development**: Rust-specific configurations with rustaceanvim.lua to make Rust development seamless.
- **Treesitter**: Robust syntax highlighting and code parsing powered by treesitter.lua, improving the Neovim editing experience.
- **Telescope Fuzzy Finder**: Quick file and buffer navigation with telescope.lua, providing a fast way to access your project.

## Getting Started

### Install Dependencies with diver.sh

To set up Qompass Diver, you will first need to install the necessary dependencies using the provided `diver.sh` script. This script automatically detects your operating system and installs the required tools. 

To run `diver.sh`:

```bash
#!/usr/bin/env bash

set -e

# Function to detect the operating system
function detect_os {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    elif [ "$(uname)" == "Darwin" ]; then
        OS="macos"
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

    echo -e "Installing dependencies for macOS..."
    brew install openresty node python ruby rustup jq
    rustup install stable
    pip3 install --user jupyter
}

# Install dependencies for Arch Linux
function install_arch {
    echo -e "Installing dependencies for Arch Linux..."
    sudo pacman -Syu --needed --noconfirm openresty nodejs python ruby rustup jq
    rustup install stable
    python -m ensurepip --user
    pip install --user jupyter
}

# Install dependencies for Ubuntu
function install_ubuntu {
    echo -e "Installing dependencies for Ubuntu/Debian..."
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
```

### Clone the Repository
After installing the dependencies, you can clone the Qompass Diver repository and set up Neovim:

```bash
# Clone the repository to your Neovim configuration folder
git clone https://github.com/qompassai/Diver ~/.config/nvim
```

Once the repository is cloned, start Neovim and Qompass Diver will be ready for you to use.

### Final Steps
Launch Neovim:
```bash
nvim
```
Qompass Diver will automatically set up and load the required plugins for a streamlined coding experience whether you're new or a seasoned pro. 

And unlike other folks in the AI space, will never collect data on your use. 


