FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu20.04

# Install wget and curl
RUN apt-get update && apt-get install -y wget curl build-essential

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.80.0 -y

# Install Ultraviolet
RUN /bin/bash -c "source $HOME/.cargo/env && cargo install uv"

# Install other dependencies
RUN /bin/bash -c "source $HOME/.cargo/env && cargo install cargo-binstall"

# Clone the Whisper Medusa repository
RUN git clone https://github.com/aiola-lab/whisper-medusa.git

# Change into the repository directory
WORKDIR /whisper-medusa

# Build and install the package using Cargo
RUN /bin/bash -c "source $HOME/.cargo/env && cargo install cargo-binstall"
RUN /bin/bash -c "source $HOME/.cargo/env && cargo build --release"
RUN /bin/bash -c "source $HOME/.cargo/env && cargo install --path ."
