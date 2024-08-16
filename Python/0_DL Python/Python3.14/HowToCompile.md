# Qompass CPython Compilation of Python 3.14 with and without Global Interpreter Lock (GIL)
- Disclaimer: The Python Foundation has made clear that compiling CPython without the GIL is experimental. By extension, this is not something we recommend inexperienced developers do. Any system errors that occur as a result of following these instructions are done at the risk of the user.

# Arch Linux x86_64
First, ensure you have the necessary build tools installed:
```bash
sudo pacman -S base-devel git
```
Clone the CPython repository:
```bash
git clone https://github.com/python/cpython.git
cd cpython
```
Configure the build with the --disable-gil option and set the installation prefix to /opt/python3.14:
```bash
./configure --disable-gil  --enable-optimizations --prefix=/opt/python3.14
```
Compile CPython:
```bash
make -j$(nproc)
```
Install the compiled version:
```bash
sudo make install
```

## Open your ~/.bashrc file in a text editor:
```
nvim ~/.bashrc
```
Add the following line at the end of the file:
```
alias p3.14='/opt/python3.14/bin/python3'
```
- Save the file and exit the editor (in nano, press Ctrl+X, then Y, then Enter).To apply the changes immediately, source your .bashrc file:
```bash
source ~/.bashrc
```
- Now you can use p3.14 to run your custom Python version from anywhere in the terminal:
```bash
$ p3.14
Python 3.14.0a0 experimental free-threading build (heads/main:540fcc62f5, Aug  7 2024, 16:32:25) [GCC 14.2.1 20240805] on linux
Type "help", "copyright", "credits" or "license" for more information.
```
- This will start the Python interpreter, or you can run scripts with:
```
p3.14 your_script.py
```


## Ubuntu 24.04

1. Install build dependencies:
   ```bash
   sudo apt update
   sudo apt install build-essential git
   ```
2.
```bash
git clone https://github.com/python/cpython.git
cd cpython
```

3.
```bash
./configure --disable-gil --enable-optimizations --prefix=/opt/python3.14
make -j$(nproc)
sudo make install
```
4. Set up alias
```echo "alias p3.14='/opt/python3.14/bin/python3'" >> ~/.bashrc
source ~/.bashrc
```

5. Run the new python
```bash
p3.14
```

## macOS
- Install Xcode Command Line Tools and Homebrew:
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Install dependencies:
```bash
brew install openssl readline sqlite3 xz zlib
```
Clone and build CPython:
```bash
git clone https://github.com/python/cpython.git
cd cpython
./configure --disable-gil --prefix=/usr/local/opt/python3.14 --with-openssl=$(brew --prefix openssl)
make -j$(sysctl -n hw.ncpu)
sudo make install
```
- Set up alias:
```bash
echo "alias p3.14='/usr/local/opt/python3.14/bin/python3'" >> ~/.zshrc
source ~/.zshrc
```
Run the new Python:
```bash
p3.14
```
## Windows 11 with WSL2 (Ubuntu 24.04)

1. Install WSL2 and Ubuntu 24.04:
   Open PowerShell as Administrator and run:
   ```powershell
   wsl --install -d Ubuntu-24.04
   ```
2. Follow Ubuntu 24.04 instructions

