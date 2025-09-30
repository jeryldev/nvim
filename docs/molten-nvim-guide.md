# Molten.nvim Complete Guide

## Overview
Molten.nvim provides a Jupyter notebook-like experience in Neovim with inline code evaluation, output display, and **yes, it can display charts, graphs, and diagrams!**

## Chart & Graph Capabilities

### ✅ What Molten Can Display:
1. **Matplotlib plots** - Full support for all matplotlib figures
2. **Seaborn charts** - Statistical visualizations
3. **Plotly graphs** - Interactive plots (as static images)
4. **Pandas plots** - DataFrame visualizations
5. **NetworkX diagrams** - Network graphs
6. **Pillow/PIL images** - Any image processing
7. **LaTeX equations** - Mathematical formulas
8. **SVG diagrams** - Vector graphics
9. **Any image output** - PNG, JPG, SVG formats

### Terminal Requirements:
- **Kitty** (recommended) - Best image support
- **WezTerm** - Good alternative
- **iTerm2** (macOS) - Works well
- **Ghostty** - Works via Kitty graphics protocol
- **Regular terminals** - No image support (text output only)

## Installation Prerequisites

### Virtual Environment Setup (REQUIRED)

Molten requires Python dependencies to be installed in a virtual environment:

```bash
# Option 1: Using uv (recommended)
cd ~/your-project
uv venv
source .venv/bin/activate
uv pip install pynvim jupyter_client ipykernel cairosvg pnglatex plotly kaleido jupytext

# Option 2: Using standard venv
cd ~/your-project
python3 -m venv .venv
source .venv/bin/activate
pip install pynvim jupyter_client ipykernel cairosvg pnglatex plotly kaleido jupytext

# Set the Python host for Neovim
export NVIM_PYTHON3_HOST_PROG=$(which python3)
nvim --headless +"UpdateRemotePlugins" +qa
```

### Install kernels for other languages (optional)
```bash
pip install julia  # For Julia
R -e "install.packages('IRkernel'); IRkernel::installspec()"  # For R
```

### Important: Always activate your venv before using Neovim with Molten!
```bash
cd ~/your-project
source .venv/bin/activate
nvim your_file.py  # or .ipynb
```

## Key Bindings (from our config)

**Mnemonic**: All Molten commands start with `<leader>j` for **J**upyter

| Binding | Description | Mode |
|---------|-------------|------|
| `<leader>ji` | Initialize Jupyter kernel | Normal |
| `<leader>je` | Evaluate operator selection | Normal |
| `<leader>jl` | Evaluate current line | Normal |
| `<leader>jr` | Re-evaluate cell | Normal |
| `<leader>jv` | Evaluate visual selection | Visual |
| `<leader>jo` | Show/enter output window | Normal |
| `<leader>jh` | Hide output | Normal |
| `<leader>jd` | Delete cell | Normal |
| `<leader>jc` | Clear all images | Normal |
| `<leader>jC` | Clear images & re-run cell | Normal |
| `<leader>js` | Show Molten info/status | Normal |
| `[%` or `<leader>j[` | Go to previous cell (after running) | Normal |
| `]%` or `<leader>j]` | Go to next cell (after running) | Normal |
| `[j` | Previous # %% cell marker | Normal |
| `]j` | Next # %% cell marker | Normal |
| `<leader>jr` | Select current cell (then use jv to run) | Normal |
| `<leader>jV` | Visually select current cell | Normal |
| `vi%` | Visual select current cell | Normal |

## Creating and Using Cells

### What are cells?
Cells are code blocks that can be executed independently. Molten recognizes cells using special markers:

1. **Python percent format** (recommended):
   ```python
   # %%
   print("This is a cell")
   x = 10
   
   # %%
   print(f"x = {x}")
   y = x * 2
   
   # %% [markdown]
   # This is a markdown cell
   ```

2. **Jupyter notebook (.ipynb) files**:
   - Cells are automatically recognized
   - Use jupytext.nvim for seamless editing

3. **Markdown code blocks**:
   ```markdown
   ```python
   print("This is also a cell")
   ```
   ```

### How to use cells:

1. **First, initialize a kernel**:
   - Press `<leader>ji` (or run `:MoltenInit`)
   - Select Python3 (or your preferred kernel)

2. **Create a cell**:
   - Type `# %%` on a new line
   - Write your code below it
   - The cell ends at the next `# %%` or end of file

3. **Execute cells**:
   - `<leader>jr` - Run the cell your cursor is in
   - `<leader>jl` - Run just the current line
   - `<leader>jv` - Run visual selection
   - Navigate between cells with `[%`/`]%` or `<leader>j[`/`<leader>j]`
   - Navigate cell markers with `]j`/`[j` (works before running cells!)
   
   **IMPORTANT**: Place cursor BELOW the `# %%` line, not on it!

### Example workflow:
```python
# %% imports
import numpy as np
import matplotlib.pyplot as plt

# %% generate data
x = np.linspace(0, 10, 100)
y = np.sin(x)

# %% plot
plt.plot(x, y)
plt.title("Sine Wave")
plt.show()
```

Place your cursor anywhere in a cell and press `<leader>jr` to run it!

## Usage Examples

### 1. Basic Data Visualization

```python
# %% [markdown]
# # Data Analysis Example

# %%
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import seaborn as sns

# Set style for better-looking plots
plt.style.use('seaborn-v0_8-darkgrid')
sns.set_palette("husl")

# %%
# Generate sample data
x = np.linspace(0, 10, 100)
y1 = np.sin(x)
y2 = np.cos(x)

# Create plot
plt.figure(figsize=(10, 6))
plt.plot(x, y1, label='sin(x)', linewidth=2)
plt.plot(x, y2, label='cos(x)', linewidth=2)
plt.title('Trigonometric Functions')
plt.xlabel('x')
plt.ylabel('y')
plt.legend()
plt.grid(True, alpha=0.3)
plt.show()
```

### 2. Statistical Visualization

```python
# %%
# Create DataFrame
data = pd.DataFrame({
    'x': np.random.randn(1000),
    'y': np.random.randn(1000),
    'category': np.random.choice(['A', 'B', 'C'], 1000)
})

# %%
# Multiple subplot figure
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Histogram
data['x'].hist(ax=axes[0, 0], bins=30, alpha=0.7)
axes[0, 0].set_title('Histogram of X')

# Scatter plot
axes[0, 1].scatter(data['x'], data['y'], alpha=0.5, c=data['category'].map({'A': 'red', 'B': 'blue', 'C': 'green'}))
axes[0, 1].set_title('Scatter Plot')

# Box plot
data.boxplot(column='x', by='category', ax=axes[1, 0])
axes[1, 0].set_title('Box Plot by Category')

# Correlation heatmap
sns.heatmap(data[['x', 'y']].corr(), annot=True, ax=axes[1, 1], cmap='coolwarm')
axes[1, 1].set_title('Correlation Heatmap')

plt.tight_layout()
plt.show()
```

### 3. Interactive Plots (displayed as static)

```python
# %%
import plotly.graph_objects as go

# Create interactive plot (will be rendered as static image)
fig = go.Figure()
fig.add_trace(go.Scatter(x=x, y=y1, name='sin(x)', mode='lines'))
fig.add_trace(go.Scatter(x=x, y=y2, name='cos(x)', mode='lines'))
fig.update_layout(title='Interactive Plot (as static)', xaxis_title='x', yaxis_title='y')
fig.show()
```

### 4. Network Diagrams

```python
# %%
import networkx as nx

# Create a graph
G = nx.karate_club_graph()

# Draw the graph
plt.figure(figsize=(10, 8))
pos = nx.spring_layout(G)
nx.draw(G, pos, with_labels=True, node_color='lightblue', 
        node_size=500, font_size=10, font_weight='bold')
plt.title('Karate Club Network')
plt.show()
```

## Workflow Tips

### 1. Cell Management
- Use `# %%` to create code cells
- Use `# %% [markdown]` for markdown cells
- Navigate markers with `]j` and `[j` (works immediately!)
- Navigate executed cells with `[%` and `]%`
- **Remember**: Put cursor BELOW the `# %%` line!

### 2. Output Management
- Outputs appear as virtual text below cells
- Use `<leader>jo` to enter output (scrollable)
- Use `<leader>jh` to hide outputs

### 3. Image Quality
```python
# Set DPI for better quality
plt.rcParams['figure.dpi'] = 150
plt.rcParams['savefig.dpi'] = 150

# Or per figure
plt.figure(figsize=(10, 6), dpi=150)
```

### 4. Multiple Kernels
Press `<leader>ji` and select kernel, or use commands:
```vim
:MoltenInit python3  " Python kernel
:MoltenInit julia    " Julia kernel
:MoltenInit ir       " R kernel
```

## Jupyter Notebook Integration

### Working with .ipynb files:
1. Open `.ipynb` file (jupytext.nvim auto-converts)
2. Initialize kernel: `<leader>ji`
3. Run cells as normal
4. Save to sync back to `.ipynb`

### Converting files:
```bash
# Convert .py to .ipynb
jupytext --to notebook script.py

# Convert .ipynb to .py
jupytext --to py:percent notebook.ipynb
```

## Troubleshooting

### "MoltenInit command not found" error?
This is the most common issue! Solutions:

1. **Activate your virtual environment first**:
   ```bash
   cd ~/your-project
   source .venv/bin/activate
   nvim your_file.py
   ```

2. **Update remote plugins**:
   ```bash
   nvim --headless +"UpdateRemotePlugins" +qa
   ```

3. **Set Python host permanently** (add to ~/.zshrc or ~/.bashrc):
   ```bash
   export NVIM_PYTHON3_HOST_PROG="/path/to/your/.venv/bin/python3"
   ```

4. **Use the fix script**:
   ```bash
   cd ~/PycharmProjects/iron_training
   bash setup_molten_with_uv.sh
   ```

### "Not in a cell" error?
This is the second most common issue! Solutions:

1. **Cursor placement is critical**:
   ```python
   # %%          ← DON'T put cursor here!
   print("Hi")   ← PUT cursor here or below!
   x = 10        ← Or here!
   ```

2. **Make sure you have proper cell markers**:
   - Use exactly `# %%` (space after #, space after %%)
   - Don't use `#%%` or `# % %` or other variations

3. **For .ipynb files**, cells should work automatically

4. **Test with the example file**:
   ```bash
   cd ~/PycharmProjects/iron_training
   source .venv/bin/activate
   nvim test_molten_cells.py
   ```

### Images not showing?
1. Check terminal: `echo $TERM` (should be `xterm-kitty` for Kitty)
2. Verify image.nvim: `:checkhealth image`
3. Try simple test:
   ```python
   import matplotlib.pyplot as plt
   plt.plot([1, 2, 3], [1, 4, 9])
   plt.show()
   ```

### Kernel issues?
1. List kernels: `jupyter kernelspec list`
2. Install kernel: `python -m ipykernel install --user`
3. Restart Neovim

### Performance tips:
- Limit output height: `vim.g.molten_output_win_max_height = 20`
- Clear old outputs: `:MoltenDelete`
- Use `%matplotlib inline` equivalent (auto in Molten)

## Comparison with Jupyter/VSCode

| Feature | Jupyter Lab | VSCode | Molten.nvim |
|---------|------------|---------|-------------|
| Inline plots | ✅ | ✅ | ✅ |
| Interactive plots | ✅ | ✅ | ❌ (static only) |
| Multiple kernels | ✅ | ✅ | ✅ |
| Variable inspector | ✅ | ✅ | ❌ |
| Cell folding | ✅ | ✅ | Via Neovim folds |
| Git integration | ⚠️ | ✅ | ✅ |
| Vim motions | ⚠️ | ⚠️ | ✅ |
| Remote kernels | ✅ | ✅ | ✅ |

## Advanced Features

### Custom kernel configuration:
```lua
-- In molten.lua init function
vim.g.molten_output_crop_border = true
vim.g.molten_output_show_more = true
vim.g.molten_use_border_highlights = true
vim.g.molten_virt_text_max_lines = 12
vim.g.molten_tick_rate = 150
```

### Integration with other plugins:
- **Telescope**: Search through outputs
- **Which-key**: Show available commands
- **Treesitter**: Better syntax highlighting
- **LSP**: Code completion in cells

The combination of Molten.nvim + image.nvim + Kitty terminal gives you nearly full Jupyter functionality with the power of Neovim!