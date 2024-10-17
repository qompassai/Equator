@echo off
setlocal

REM Check for Chocolatey installation
IF NOT EXIST "%ProgramData%\chocolatey" (
    echo "Chocolatey not found. Installing Chocolatey..."
    @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
)

echo "Installing dependencies for Windows..."
choco install -y openresty nodejs python ruby rustup jq

REM Install Rust
rustup install stable

REM Install Jupyter
pip install --user jupyter

echo "All dependencies have been installed successfully for Windows!"
endlocal

