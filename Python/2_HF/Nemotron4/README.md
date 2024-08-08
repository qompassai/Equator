# How to use this repo (after download miniconda3) for Mac, Windows, or Linux: https://docs.anaconda.com/miniconda/

- Step 1: Create the Virtual Environment
- Open a terminal or command prompt and navigate to the directory where your nemotron4.yml file is located. Run the following command to create the virtual environment:
```bash
conda env create -f nemotron4.yml
```
- This command will create a new virtual environment with the specified name and dependencies.

Step 2: Activate the Virtual Environment
To activate the virtual environment, run:
```bash
conda activate myenv
```
Your command prompt should now indicate that you are in the myenv environment.
- Step 3: Verify the Environment
To verify that the environment was created correctly, run:
```bash
conda list
```
This command will list all the packages installed in the myenv environment.

- Step 3.5 (Optional- only if you want to download local models).To download Nemotron4 340 B, make sure that you have the appropriate ~/.bashrc or ~/.zshrc config and run source ~/.bashrc or source ~/.zshrc depending on what you're using. You can only use the huggingface-cli command if you have a huggingface account and have a huggingface token. Both of which are free.
```bash
huggingface-cli download nvidia/Nemotron-4-340B-Base

huggingface-cli download nvidia/Nemotron-4-340B-Instruct

huggingface-cli download nvidia/Nemotron-4-340B-Reward
```
Step 4: Deactivate the Environment
When you are finished working in the virtual environment, deactivate it by running:
```bash
conda deactivate
```
This will return you to your base environment.

# GLHF
