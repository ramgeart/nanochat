# nanochat Dev Container

This directory contains the configuration for running nanochat in a dev container using GitHub Codespaces or VS Code with Docker.

## What's Included

The dev container provides a complete development environment with:

- **NVIDIA CUDA 12.4** with cuDNN support for GPU acceleration
- **Python 3.12** with virtual environment pre-configured
- **Rust toolchain** for building the rustbpe tokenizer
- **uv package manager** for fast Python dependency management
- **VS Code extensions** for Python and Rust development
- **All project dependencies** pre-installed and configured

## Quick Start

### Using GitHub Codespaces

1. Click the green "Code" button on the GitHub repository
2. Select "Codespaces" tab
3. Click "Create codespace on main" (or your branch)
4. Wait for the container to build and initialize (~5-10 minutes first time)
5. Once ready, you'll have a full development environment in your browser

### Using VS Code with Docker

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) for VS Code
3. Open the nanochat repository in VS Code
4. Press `F1` and select "Dev Containers: Reopen in Container"
5. Wait for the container to build and initialize

## Features

### Automatic Setup

The `post-create.sh` script automatically:
- Creates a Python virtual environment
- Installs all dependencies (GPU or CPU version based on availability)
- Builds the rustbpe tokenizer
- Sets up the nanochat cache directory

### Port Forwarding

Port 8000 is automatically forwarded for the web UI. When you run:
```bash
python -m scripts.chat_web
```
You can access the chat interface through the forwarded port.

### VS Code Extensions

Pre-installed extensions include:
- Python language support with IntelliSense
- Rust analyzer for Rust development
- Jupyter notebook support
- Git integration with GitHub
- TOML file support

## GPU Support

### Codespaces
GitHub Codespaces typically don't have GPU access. The container will automatically detect this and install the CPU version of PyTorch. You can still develop and test code, but training will be much slower.

### Local Docker
If you have an NVIDIA GPU and want to use it:
1. Install [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)
2. The container will automatically detect and use your GPU

## Running Tests

Once the environment is set up:
```bash
# Activate the virtual environment (usually automatic in terminal)
source .venv/bin/activate

# Run tokenizer tests
python -m pytest tests/test_rustbpe.py -v
```

## Training Models

### CPU/Small Scale (Codespaces-friendly)
```bash
# See the CPU-optimized script
cat dev/runcpu.sh

# You can run smaller experiments on CPU
```

### GPU (Local with GPU or cloud)
```bash
# Full training pipeline
bash speedrun.sh
```

## Troubleshooting

### Container won't build
- Ensure Docker has enough disk space (at least 20GB free)
- Check Docker is running and up to date

### Dependencies not installing
- The post-create script logs are visible in VS Code's terminal
- Try rebuilding the container: `F1` -> "Dev Containers: Rebuild Container"

### GPU not detected
- Verify NVIDIA Container Toolkit is installed
- Check `nvidia-smi` works in the container
- Ensure Docker has GPU access configured

## Customization

You can customize the dev container by editing:
- `devcontainer.json` - VS Code settings, extensions, and ports
- `Dockerfile` - System packages and base image
- `post-create.sh` - Setup commands run after container creation

## Resources

- [VS Code Dev Containers Documentation](https://code.visualstudio.com/docs/devcontainers/containers)
- [GitHub Codespaces Documentation](https://docs.github.com/en/codespaces)
- [nanochat Main README](../README.md)
