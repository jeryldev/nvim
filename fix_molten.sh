#!/bin/bash

echo "=== Fixing Molten.nvim setup ==="

# Check if pynvim is installed
echo "1. Checking pynvim installation..."
if python3 -c "import pynvim" 2>/dev/null; then
  echo "✓ pynvim is installed"
else
  echo "✗ pynvim is NOT installed"
  echo "Please run: pip3 install pynvim"
  exit 1
fi

# Check Python3 provider
echo -e "\n2. Checking Neovim Python3 provider..."
PYTHON3_HOST=$(python3 -c "import sys; print(sys.executable)")
echo "Python3 path: $PYTHON3_HOST"

# Update remote plugins
echo -e "\n3. Updating remote plugins..."
nvim --headless +"UpdateRemotePlugins" +qa

# Check if rplugin.vim was updated
echo -e "\n4. Checking rplugin.vim..."
if grep -q "molten" ~/.local/share/nvim/rplugin.vim 2>/dev/null; then
  echo "✓ Molten is registered in rplugin.vim"
else
  echo "✗ Molten is NOT registered in rplugin.vim"
  echo "Content of rplugin.vim:"
  cat ~/.local/share/nvim/rplugin.vim
fi

echo -e "\n=== Setup complete ==="
echo "Now try starting Neovim and using <leader>ji"

