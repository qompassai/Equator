# How to Install Miniconda3


## x86_64 (Most computers)
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh

## aarch64 (Arm-based)
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
