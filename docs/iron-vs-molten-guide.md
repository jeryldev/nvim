# Iron.nvim vs Molten.nvim: When to Use Which

## Quick Decision Guide

### Use Iron.nvim (`<leader>i`) when:
- 🚀 **Quick testing** - Testing snippets or debugging
- 🔄 **Interactive work** - Working with databases, APIs
- 📝 **Simple scripts** - No need for visualizations
- ⚡ **Lightweight** - Fast REPL without overhead

### Use Molten.nvim (`<leader>j`) when:
- 📊 **Data science** - Working with pandas, numpy, matplotlib
- 📈 **Visualizations** - Need inline plots and images
- 📓 **Notebooks** - Working with .ipynb files
- 🔬 **Research** - Exploratory data analysis

## Feature Comparison

| Feature | Iron.nvim | Molten.nvim |
|---------|-----------|-------------|
| **Startup** | Instant | Requires kernel init |
| **Images** | ❌ No | ✅ Yes (Ghostty/Kitty) |
| **Notebooks** | ❌ No | ✅ Full .ipynb support |
| **Memory** | Light | Heavier (Jupyter) |
| **Languages** | Many | Python, R, Julia |
| **Workflow** | REPL-style | Cell-based |

## Key Bindings Overview

### Iron.nvim - Traditional REPL (`<leader>i`)
```
<leader>is    - Start REPL
<leader>il    - Send line
<leader>ic    - Send code (motion/visual)
<leader>iF    - Send entire file
<leader>ih    - Hide REPL
<leader>if    - Focus REPL
```

### Molten.nvim - Jupyter-style (`<leader>j`)
```
<leader>ji    - Initialize kernel (required!)
<leader>jl    - Run line (creates cell)
<leader>jv    - Run visual selection
<leader>jr    - Re-run existing cell
<leader>jo    - Show output
<leader>jc    - Clear images
<leader>js    - Show status
```

## Practical Examples

### Iron Example - Quick Python Testing
```python
# Start with <leader>is
# Send lines with <leader>il

def add(a, b):
    return a + b

result = add(5, 3)
print(result)  # Shows in REPL pane
```

### Molten Example - Data Analysis
```python
# Start with <leader>ji
# Run cells with <leader>jl or <leader>jv

import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('data.csv')
df.describe()  # Shows inline

plt.plot(df['x'], df['y'])
plt.show()  # Shows inline image!
```

## Memory Considerations

- **Iron**: Minimal overhead, just the REPL process
- **Molten**: Runs Jupyter kernel + image rendering

## Tips for Choosing

1. **Default to Iron** for general programming
2. **Switch to Molten** when you need:
   - Inline visualizations
   - Notebook compatibility
   - Cell-based workflow
   - Data science libraries

3. **You can use both!** They don't conflict:
   - Iron for quick tests
   - Molten for analysis

## Virtual Environment Note

**Important**: Molten requires virtual environment activation:
```bash
cd ~/your-project
source .venv/bin/activate
nvim your_file.py
```

Iron works with system Python but respects virtual environments too.