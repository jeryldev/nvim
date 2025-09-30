# Iron.nvim Features and Usage Guide

## Overview
Iron.nvim is an Interactive REPL (Read-Eval-Print Loop) plugin for Neovim that allows you to interact with various programming languages directly from your editor.

**Purpose**: Lightweight REPL for quick testing and debugging
**Mnemonic**: All commands start with `<leader>i` for **I**ron
**Best for**: Quick scripts, API testing, database queries, algorithm testing

## Key Features

### 1. **Multi-Language Support**
Currently configured languages in your setup:
- **Python** - Uses `python3` command
- **JavaScript** - Uses `node` 
- **TypeScript** - Uses `ts-node`
- **Lua** - Uses `lua`
- **Ruby** - Uses `irb`
- **Elixir** - Uses `iex`
- **Julia** - Uses `julia`
- **R** - Uses `R`
- **Shell** - Uses `fish`

### 2. **Flexible REPL Window Placement**
- Split windows (horizontal/vertical)
- Floating windows
- Customizable size (percentage or fixed)
- Your current setup: Right side at 40% width

### 3. **Code Execution Methods**
- **Send line**: Send current line to REPL (`<leader>il`)
- **Send file**: Send entire file (`<leader>iF`)
- **Send motion**: Send text object (`<leader>ic` + motion)
- **Send visual**: Send selected text (`<leader>ic` in visual mode)
- **Send until cursor**: From start to cursor (`<leader>iu`)
- **Send marked text**: Previously marked text (`<leader>im`)

### 4. **REPL Management**
- **Start/Toggle REPL**: `<leader>is`
- **Restart REPL**: `<leader>ir`
- **Focus REPL**: `<leader>if`
- **Hide REPL**: `<leader>ih`
- **Quit REPL**: `<leader>iq`
- **Clear REPL**: `<leader>iC`
- **Interrupt execution**: `<leader>i<space>`

### 5. **Text Marking System**
- **Mark motion**: `<leader>imc` + motion
- **Mark visual**: `<leader>imc` in visual mode
- **Delete mark**: `<leader>imd`
- Send marked text repeatedly without reselecting

### 6. **Advanced Features**
- **Scratch REPL**: Temporary REPLs that don't persist
- **Multiple REPLs**: Different REPLs for different file types
- **Custom REPL commands**: Configure specific interpreters
- **Bracketed paste**: Proper indentation handling
- **Ignore blank lines**: Skip empty lines when sending code

## Testing Iron.nvim

### Basic Python Test
1. Create a test file: `test.py`
```python
# Basic calculation
print(2 + 2)

# Define a function
def greet(name):
    return f"Hello, {name}!"

# Test the function
print(greet("World"))

# Create a list
numbers = [1, 2, 3, 4, 5]
print(sum(numbers))
```

2. Open the file in Neovim
3. Press `<leader>is` to start Python REPL
4. Try these commands:
   - `<leader>il` on line 2 to send the print statement
   - Select lines 5-6 and press `<leader>ic` to send the function
   - `<leader>iF` to send the entire file

### Data Science Test (Python)
```python
import numpy as np
import pandas as pd

# Create sample data
data = pd.DataFrame({
    'x': np.linspace(0, 10, 100),
    'y': np.sin(np.linspace(0, 10, 100))
})

# Display data info
print(data.head())
print(data.describe())
```

## Jupyter Notebook Alternative

### What Iron.nvim CAN do:
- Execute code blocks interactively
- See output immediately in REPL
- Work with data science libraries (numpy, pandas, etc.)
- Maintain session state between executions
- Execute code in any order

### What Iron.nvim CANNOT do:
- **Display inline graphs/plots**: Plots open in separate windows
- **Rich media output**: No inline images, HTML, or widgets
- **Notebook file format**: Doesn't work with `.ipynb` files directly
- **Cell-based execution**: No built-in cell concept (but you can mark regions)

**Note**: For inline visualization, use Molten.nvim with `<leader>j` keybindings

### For Visualization with Iron.nvim:
When using matplotlib or similar libraries:
```python
import matplotlib.pyplot as plt
import numpy as np

# Create plot
x = np.linspace(0, 10, 100)
y = np.sin(x)
plt.plot(x, y)
plt.title("Sine Wave")

# This will open in a separate window
plt.show()
```

## Tips for Data Science Workflow

1. **Use marks** for frequently executed code blocks
2. **Keep imports at top** and send with `<space>sf` once
3. **Use `%matplotlib` magic** in Python for better plot handling:
   ```python
   %matplotlib qt  # For separate window
   # or
   %matplotlib inline  # Won't work in terminal REPL
   ```

4. **Save plots** instead of displaying when needed:
   ```python
   plt.savefig('output.png')
   ```

5. **Use rich output libraries** like `rich` or `tabulate` for better terminal display:
   ```python
   from rich import print
   from rich.table import Table
   ```

## Alternatives for Jupyter-like Experience

If you need true Jupyter notebook features in Neovim:
1. **jupytext**: Convert between `.ipynb` and `.py` files
2. **vim-jupytext**: Work with notebook as Python files
3. **molten-nvim**: Jupyter kernel integration (more complex setup)
4. **jupynium.nvim**: Selenium-based Jupyter integration

Iron.nvim excels at REPL interaction but isn't designed for notebook-style workflows with inline visualization.