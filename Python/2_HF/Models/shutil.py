import shutil
import os

# Paths to the original weights files
original_flux_dev_path = '/home/phaedrus/.cache/huggingface/hub/models--black-forest-labs--FLUX.1-dev/snapshots/01aa605f2c300568dd6515476f04565a954fcb59/flux1-dev.sft'
original_ae_path = '/home/phaedrus/.cache/huggingface/hub/models--black-forest-labs--FLUX.1-dev/snapshots/01aa605f2c300568dd6515476f04565a954fcb59/ae.sft'

# New location to move the weights files
new_location = '/home/phaedrus/Forge/HF/Models/'

# Create the directory if it doesn't exist
os.makedirs(new_location, exist_ok=True)

# Move the files
shutil.move(original_flux_dev_path, os.path.join(new_location, 'flux1-dev.sft'))
shutil.move(original_ae_path, os.path.join(new_location, 'ae.sft'))
