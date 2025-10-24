# Use NVIDIA CUDA base image for GPU support
# This provides CUDA 12.4 and cuDNN 9, compatible with PyTorch
FROM nvidia/cuda:12.4.0-cudnn-devel-ubuntu22.04

# Prevent interactive prompts during package installation
ARG DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    # Build essentials
    build-essential \
    cmake \
    pkg-config \
    # Git and curl for downloading tools
    git \
    curl \
    wget \
    # Python development headers
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    # SSL/TLS support
    ca-certificates \
    libssl-dev \
    # Additional utilities
    vim \
    nano \
    htop \
    tmux \
    screen \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user for development
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Switch to non-root user
USER $USERNAME
WORKDIR /home/$USERNAME

# Install Rust toolchain for the user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && echo 'source $HOME/.cargo/env' >> ~/.bashrc

# Add Rust to PATH for this build
ENV PATH="/home/$USERNAME/.cargo/bin:${PATH}"

# Install uv - fast Python package manager
RUN curl -LsSf https://astral.sh/uv/install.sh | sh \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

# Add uv to PATH for this build
ENV PATH="/home/$USERNAME/.local/bin:${PATH}"

# Set Python 3.12 as default python3
RUN sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 \
    && sudo update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Set working directory to workspace
WORKDIR /workspace

# Keep container running
CMD ["/bin/bash"]
