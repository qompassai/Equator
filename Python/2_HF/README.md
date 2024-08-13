## HuggingFace: Open Source AI For the Win

[Little guide to building Large Language Models in 2024](Little%20guide%20to%20building%20Large%20Language%20Models%20in%202024.pdf)


# The most energy efficient way to access Open Source models from Huggingface 

## Step 1: Create a Hugging Face Account
- Go to the Hugging Face website: https://huggingface.co/
- Click on the "Sign Up" button in the top right corner.
- Fill out the registration form with your email address, username, and password.
- Verify your email address by clicking on the link sent to you by Hugging Face.
## Step 2: Install the Hugging Face Command Line Interface (CLI)
- Open a terminal or command prompt.
- Install the Hugging Face CLI using pip: pip install huggingface_hub
- Verify the installation by running huggingface-cli --version
## Step 3: Login to Hugging Face Hub with the CLI
R- un the following command to login to Hugging Face Hub: huggingface-cli login
- Enter your Hugging Face username and password when prompted.
- You will be asked to create a token. Follow the instructions to create a token.
## Step 4: Create a Hugging Face Token
- Go to the Hugging Face website: https://huggingface.co/
- Click on your profile picture in the top right corner.
- Click on "Settings" from the dropdown menu.
- Scroll down to the "Tokens" section.
- Click on "New Token".
- Fill out the token creation form with a name and description for your token.
- Click on "Create Token".
- Copy the token and save it securely.
## Step 5: Download a Hugging Face Model using the CLI
- Run the following command to download a Hugging Face model: huggingface-cli download <repo-name>/<model-name>
- Replace <repo-name> with the name of the repository that contains the model you want to download.
- Replace <model-name> with the name of the model you want to download.
- For example, to download the FLUX.1-dev model from the black-forest-labs repository, run the following command: huggingface-cli download black-forest-labs/FLUX.1-dev
## Additional Notes
- Make sure you have the latest version of the Hugging Face CLI installed.
- You need to be logged in to Hugging Face Hub to download models using the CLI.
- You can use the huggingface-cli command to download models from any Hugging Face repository.
