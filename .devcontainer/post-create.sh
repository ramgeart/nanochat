#!/bin/bash
# Post-create setup script for devcontainer
set -e

echo "🚀 Setting up nanochat development environment..."

# Ensure we're in the workspace directory
cd /workspace

# Source Rust and uv environments
source "$HOME/.cargo/env"
export PATH="$HOME/.local/bin:$PATH"

# Create virtual environment if it doesn't exist
if [ ! -d ".venv" ]; then
    echo "📦 Creating Python virtual environment..."
    uv venv
fi

# Install Python dependencies
# For Codespaces, we'll default to CPU version but allow GPU if CUDA is available
echo "📥 Installing Python dependencies..."
if command -v nvidia-smi &> /dev/null; then
    echo "🎮 NVIDIA GPU detected, installing GPU version of PyTorch..."
    uv sync --extra gpu
else
    echo "💻 No GPU detected, installing CPU version of PyTorch..."
    uv sync --extra cpu
fi

# Activate the virtual environment
source .venv/bin/activate

# Build the Rust tokenizer
echo "🦀 Building rustbpe tokenizer..."
uv run maturin develop --release --manifest-path rustbpe/Cargo.toml

# Create cache directory
mkdir -p "$HOME/.cache/nanochat"
mkdir -p "/workspace/.cache/nanochat"

echo "✅ Setup complete!"
echo ""
echo "To get started:"
echo "  1. Activate the virtual environment: source .venv/bin/activate"
echo "  2. Run tests: python -m pytest tests/test_rustbpe.py -v"
echo "  3. For CPU/small-scale training, see: dev/runcpu.sh"
echo "  4. For GPU training (if available), see: speedrun.sh"
echo "  5. To launch web UI: python -m scripts.chat_web"
echo ""
echo "Happy coding! 🎉"
