# How to Install Miniconda3 (Anaconda without the Frills)

## x86_64 Linux
```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
```
- After installing, initialize your newly-installed Miniconda. The following commands initialize for bash and zsh shells:
```bash
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```
## aarch64 Linux (Arm-based)
- 1. Open a new terminal session enter script below
```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
```
- 2. Run the installation script
```bash
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
```

- 3. Clean up the installer
```bash
rm -rf ~/miniconda3/miniconda.sh
```

- 4. Startup conda
```bash
~/miniconda3/bin/conda init bash
```

- 5. Restart your shell

```bash
source ~/.bashrc
```
## MacOS
```bash
mkdir -p ~/miniconda3
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm -rf ~/miniconda3/miniconda.sh
```
- After installing, initialize your newly-installed Miniconda. The following commands initialize for bash and zsh shells:
```bash
~/miniconda3/bin/conda init bash
~/miniconda3/bin/conda init zsh
```

## Windows
```bash
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Windows-x86_64.exe -o miniconda.exe
start /wait "" miniconda.exe /S
del miniconda.exe
```
- After installing, open the “Anaconda Prompt (miniconda3)” program to use Miniconda3. For the Powershell version, use “Anaconda Powershell Prompt (miniconda3)”.

## Reference
https://docs.anaconda.com/miniconda/
