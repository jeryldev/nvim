# Jupyter Notebook Plugins for Neovim (2024)

## Overview
While iron.nvim is great for REPL interaction, if you want a true Jupyter notebook experience in Neovim with inline outputs and visualizations, here are the best options:

## 1. **Molten.nvim** (Most Recommended)
A fork of magma-nvim with significant improvements for Jupyter kernel interaction.

### Features:
- **Inline output display** below code cells
- **Image rendering** in terminal (with image.nvim)
- **Multiple buffers** can connect to same kernel
- **Persistent kernels** that survive file closure
- **Virtual text** for output display

### Recommended Stack:
```lua
-- Complete Jupyter-like setup
{
  "benlubas/molten-nvim",
  dependencies = {
    "3rd/image.nvim",        -- For inline images
    "GCBallesteros/jupytext.nvim",  -- .ipynb file support
    "quarto-dev/quarto-nvim",       -- Enhanced notebook features
    "jmbuhr/otter.nvim",            -- Embedded language support
  }
}
```

### Key Commands:
- `:MoltenInit` - Initialize kernel
- `:MoltenEvaluateLine` - Run current line
- `:MoltenEvaluateVisual` - Run selection
- `:MoltenReevaluateCell` - Re-run cell
- `:MoltenShowOutput` - Show/hide output

## 2. **Jupynium.nvim**
Selenium-based real-time synchronization with actual Jupyter notebooks.

### Features:
- **Real Jupyter notebook** running in browser
- **Bidirectional sync** between Neovim and browser
- **Full Jupyter features** including widgets
- **Live collaboration** possible

### Setup:
```lua
{
  "kiyoon/jupynium.nvim",
  build = "pip3 install --user .",
  config = function()
    require("jupynium").setup({
      python_host = "python3",
      default_notebook_URL = "localhost:8888",
    })
  end
}
```

## 3. **Jupytext.nvim**
Work with Jupyter notebooks as plain text files.

### Features:
- **Convert .ipynb ↔ .py/.md** automatically
- **Version control friendly**
- **Lightweight** - no kernel needed for editing
- **Pairs well** with molten.nvim

### Setup:
```lua
{
  "GCBallesteros/jupytext.nvim",
  config = true,
  lazy = false,
}
```

## 4. **Quarto.nvim**
Scientific publishing and notebook support.

### Features:
- **Multiple language** support (Python, R, Julia)
- **Rendering** to various formats
- **Code completion** for embedded languages
- **Preview** functionality

### Setup:
```lua
{
  "quarto-dev/quarto-nvim",
  dependencies = {
    "jmbuhr/otter.nvim",
    "hrsh7th/nvim-cmp",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
}
```

## 5. **Neopyter**
JupyterLab extension for Neovim integration.

### Features:
- **Runs inside JupyterLab**
- **Full JupyterLab features**
- **Direct or proxy mode**
- **Alternative to Jupynium**

## Comparison Table

| Plugin | Inline Output | Images | .ipynb Support | Widgets | Setup Complexity |
|--------|--------------|---------|----------------|---------|------------------|
| iron.nvim | ❌ | ❌ | ❌ | ❌ | Easy |
| molten.nvim | ✅ | ✅ | Via jupytext | ❌ | Medium |
| jupynium | ✅ | ✅ | ✅ | ✅ | Medium |
| jupytext | N/A | N/A | ✅ | N/A | Easy |
| quarto | ✅ | ✅ | Via jupytext | ❌ | Medium |

## Recommended Complete Setup

For a full Jupyter-like experience in Neovim:

```lua
-- In your plugins configuration
{
  -- Core notebook functionality
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
    end,
  },
  
  -- Image support (requires kitty/wezterm)
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
        },
      },
    },
  },
  
  -- Jupyter notebook file support
  {
    "GCBallesteros/jupytext.nvim",
    config = true,
  },
  
  -- Enhanced notebook features
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
```

## Terminal Requirements

For image display, you need:
- **Kitty** (recommended)
- **WezTerm**
- **iTerm2** (macOS)

Regular terminals won't display inline images.

## Workflow Tips

1. **Start simple**: Try molten.nvim first
2. **Add features gradually**: Image support, jupytext, etc.
3. **Use jupytext**: For version control of notebooks
4. **Keep iron.nvim**: For quick REPL tasks
5. **Terminal matters**: Use Kitty for best experience

## When to Use What

- **iron.nvim**: Quick scripts, debugging, simple REPL
- **molten.nvim**: Data science, inline plots, notebook-like workflow
- **jupynium**: Need full Jupyter features, widgets, collaboration
- **quarto**: Scientific documents, multi-language reports