# Configuring GitHub CLI and SSH Key

This guide will walk you through the process of setting up GitHub CLI (gh) and pairing it with an SSH key for secure authentication.

## 1. Install GitHub CLI

First, ensure that GitHub CLI is installed on your system.

### For Arch Linux:
```bash
sudo pacman -S github-cli
```
For other operating systems, visit the official GitHub CLI page for installation instructions.
2. Authenticate GitHub CLI
Open your terminal and run:

```bash
gh auth login
```
Follow the prompts:
Choose "GitHub.com" for the account type
Choose "SSH" for the preferred protocol
If you don't have an SSH key, select "Generate a new SSH key"
If prompted, enter a passphrase for your SSH key
3. Configure Global Settings
Set up your global Git configuration:
bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

4. Generate SSH Key (if not done in step 2)
If you didn't generate an SSH key during the gh auth login process:
Generate a new SSH key:
bash
ssh-keygen -t ed25519 -C "your.email@example.com"

Start the SSH agent:
bash
eval "$(ssh-agent -s)"

Add your SSH key to the agent:
bash
ssh-add ~/.ssh/id_ed25519

5. Add SSH Key to GitHub
Copy your SSH public key:
bash
cat ~/.ssh/id_ed25519.pub | xclip -selection clipboard

Add the SSH key to your GitHub account:
bash
gh ssh-key add ~/.ssh/id_ed25519.pub -t "My SSH Key"

6. Verify Configuration
Test your SSH connection:
bash
ssh -T git@github.com

Verify GitHub CLI authentication:
bash
gh auth status

7. Set Default Git Protocol to SSH
Configure Git to always use SSH for GitHub operations:
bash
git config --global url."git@github.com:".insteadOf "https://github.com/"

8. (Optional) Configure GitHub CLI Aliases
Set up useful aliases for common GitHub CLI commands:
bash
gh alias set pv 'pr view'
gh alias set pc 'pr create'
gh alias set rs 'repo sync'

You're now set up to use GitHub CLI with SSH authentication! Remember to keep your SSH key secure and never share your private key.
