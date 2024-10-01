# Forking and Cloning Repositories with GitHub CLI
- This guide will walk you through the process of forking a repository and cloning it to your local machine using the GitHub CLI.
Prerequisites


```
    Install GitHub CLI: https://cli.github.com/
    Authenticate with your GitHub account: Run gh auth login and follow the prompts.
```
Step 1: Fork the Repository

    Open your terminal.
    Run the following command:

```
    gh repo fork OWNER/REPO
```
    Replace OWNER/REPO with the actual owner and repository name. Example: gh repo fork qompassai/Equator This command creates a fork of the specified repository under your GitHub account.

Step 2: Clone the Forked Repository
After forking, you'll be prompted to clone the repository. If you want to clone it immediately:

    Answer "Yes" to the prompt "Would you like to clone the fork?"

If you chose not to clone immediately or want to clone later:

    Run the following command:

```
    gh repo clone YOUR-USERNAME/REPO
```
   
Replace YOUR-USERNAME with your GitHub username and REPO with the repository name. Example: gh repo clone yourusername/Equator This command clones your forked repository to your local machine.

Step 3: Set Up the Upstream Remote
To keep your fork updated with the original repository:

    Navigate to your cloned repository:

```
    cd REPO
```
Add the upstream remote:

```
git remote add upstream https://github.com/ORIGINAL-OWNER/REPO.git
```
    Replace ORIGINAL-OWNER and REPO with the original repository's owner and name. Example: git remote add upstream https://github.com/qompassai/Equator.git

Step 4: Keeping Your Fork Updated
To sync your fork with the original repository:

    Fetch the branches and commits from the upstream repository:

```
    git fetch upstream
```

Check out your fork's local main branch:

```
git checkout main
```
Merge the changes from the upstream main branch (Only do this with permission from the owner of the repo!!!):

```
git merge upstream/main
```
Additional Commands

    To view your remotes:

```
    git remote -v
```
To push changes to your fork:

```
git push origin main
```
