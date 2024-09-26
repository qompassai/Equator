# Setup

- **To manage our learning, we'll set up a data science tool called miniconda**



```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```

- After installing, start miniconda

```bash
~/miniconda3/bin/conda init bash
```

- Create a new virtual environment

```
conda create -n dli python=3.10
```

- Install CUDA Toolkit 12.5

```bash
conda install nvidia/label/cuda-12.5.0::cuda-toolkit
```

- Install our packages for our virtual environment

```bash
conda install -c rapidsai -c nvidia -c conda-forge rapids=24.08 python=3.10 cuda-version=12.5
conda install -c conda-forge cudatoolkit
conda install -c pytorch pytorch torchvision torchaudio cudatoolkit
conda install -c conda-forge tensorflow-gpu
conda install -c conda-forge jupyterlab notebook
conda install -c conda-forge numpy pandas matplotlib scipy scikit-learn
pip install jupyterlab-nvdashboard
jupyter labextension install jupyterlab-nvdashboard
```

- Start your Jupyter lab up!

```bash
jupyter lab
```
