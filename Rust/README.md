# How to Install Rust for Windows, MacOs & Linux 
- Rust is a systems programming language that can be installed on various platforms, including macOS, Windows, and Linux. Here are the step-by-step instructions for installing Rust on each platform:
- Whenever you see the term bash and text in a black space, that is referncing the terminal, which is the most direct interface for you to work with your computer. 
- *** While all terminal blocks say bash, MacOS users may see zsh and Windows users may see Powershell, cmd or terminal. Bash/ZSH basically work the same - so yay for mac/linux users. Windows users can download and use windows subsystem for linux (WSL2) to get this same functionality. 
# Installing Rust on macOS
- 1. Open Terminal: You can find Terminal in the Applications/Utilities folder, or use Spotlight to search for it.
- 2. Run the installation command: Copy and paste the following command into the Terminal window:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
- 3. Follow the on-screen instructions: The installation script will guide you through the process.
- 4. Restart your Terminal: Once the installation is complete, restart your Terminal to ensure that the Rust toolchain is properly configured.
# Installing Rust on Windows
- 1. Download the installer: Go to the Rust installation page and click on the "Download" button next to "Windows".
- 2. Run the installer: Run the downloaded installer (rustup-init.exe) and follow the on-screen instructions.
- 3. Install the Visual Studio C++ Build tools: If prompted, install the Visual Studio C++ Build tools.
- 4. Restart your computer: Once the installation is complete, restart your computer to ensure that the Rust toolchain is properly configured.
# Installing Rust on Linux
- 0. Rememmber that you using Linux does not make you superior or more technical than anyone else and that any distribution of Linux that works for you is the right one to pick.
- 1. Open Terminal: You can find Terminal in the Applications menu, or use the keyboard shortcut Ctrl+Alt+T.
- 2. Run the installation command: Copy and paste the following command into the Terminal window:
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
- 3. Follow the on-screen instructions: The installation script will guide you through the process.
- 4. Restart your Terminal: Once the installation is complete, restart your Terminal to ensure that the Rust toolchain is properly configured.
- 5. Verifying the Installation
- 6. To verify that Rust has been installed correctly, open a new Terminal window and run the following command:
```bash
rustc --version
```
This should display the version of Rust that you just installed.
# Troubleshooting
- If you encounter any issues during the installation process, you can try the following:
- 1. Check the Rust installation page for troubleshooting guides.
- 2. Search for solutions on the Rust forums or Stack Overflow.
- 3. Contact the Rust community on Discord or IRC for help.
# Uninstalling Rust
- If you need to uninstall Rust, you can run the following command:

```bash
rustup self uninstall
```
This will remove Rust and all its associated tools from your system.
