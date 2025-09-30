# Keymap Conflicts Resolution

## Recent Updates (January 2025)

### Molten.nvim Navigation Keys Changed
- **Old**: `[c`/`]c` for cell navigation
- **New**: `[[`/`]]` and `<leader>j[`/`<leader>j]`
- **Reason**: Conflict with LazyVim's mini.ai text objects (`[c` = "previous class")
- **Benefit**: More consistent with Vim's section navigation paradigm

## Identified Conflicts

### Critical Conflicts:
1. **`<space>rr`** used by both iron.nvim (restart) and molten.nvim (re-evaluate)
2. **`<space>md`** used by both iron.nvim (delete mark) and molten.nvim (delete cell)
3. **`<space>cl`** used by iron.nvim but conflicts with LazyVim LSP mappings
4. **Leader key confusion**: iron.nvim uses `<space>`, LazyVim uses `<space>` as `<leader>`

## Proposed Solution

### New Keymap Organization:
- **`<leader>i`** - Iron.nvim prefix (Interactive REPL)
- **`<leader>j`** - Molten.nvim prefix (Jupyter-style)
- **`<leader>c`** - Keep for LSP/code actions (LazyVim default)

## Updated Keymaps

### Iron.nvim (Traditional REPL)
```lua
-- Replace <space> with <leader>i
keys = {
  -- REPL Management
  { "<leader>is", "<cmd>IronRepl<cr>", desc = "Start/toggle REPL" },
  { "<leader>ir", "<cmd>IronRestart<cr>", desc = "Restart REPL" },
  { "<leader>if", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
  { "<leader>ih", "<cmd>IronHide<cr>", desc = "Hide REPL" },
  
  -- Send Commands (using 'i' for iron)
  { "<leader>ic", desc = "Send motion to REPL", mode = { "n" } },
  { "<leader>ic", desc = "Send selection to REPL", mode = { "v" } },
  { "<leader>iF", desc = "Send file to REPL" },
  { "<leader>il", desc = "Send line to REPL" },
  { "<leader>iu", desc = "Send until cursor to REPL" },
  { "<leader>im", desc = "Send marked text to REPL" },
  
  -- Mark Commands
  { "<leader>imc", desc = "Mark motion", mode = { "n" } },
  { "<leader>imc", desc = "Mark selection", mode = { "v" } },
  { "<leader>imd", desc = "Delete mark" },
  
  -- REPL Control
  { "<leader>i<cr>", desc = "Send CR to REPL" },
  { "<leader>i<space>", desc = "Interrupt REPL (Ctrl+C)" },
  { "<leader>iq", desc = "Quit REPL" },
  { "<leader>iC", desc = "Clear REPL" },  -- Changed from cl to iC
}
```

### Molten.nvim (Jupyter-style)
```lua
keys = {
  { "<leader>ji", ":MoltenInit<CR>", desc = "Initialize Jupyter kernel" },
  { "<leader>je", ":MoltenEvaluateOperator<CR>", desc = "Evaluate operator", mode = "n" },
  { "<leader>jl", ":MoltenEvaluateLine<CR>", desc = "Evaluate line" },
  { "<leader>jr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate cell" },
  { "<leader>jv", ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Evaluate visual", mode = "v" },
  { "<leader>jo", ":noautocmd MoltenEnterOutput<CR>", desc = "Show/enter output" },
  { "<leader>jh", ":MoltenHideOutput<CR>", desc = "Hide output" },
  { "<leader>jd", ":MoltenDelete<CR>", desc = "Delete cell" },
  { "[c", ":MoltenPrev<CR>", desc = "Previous cell" },
  { "]c", ":MoltenNext<CR>", desc = "Next cell" },
}
```

## Quick Reference

### REPL Operations Comparison
| Action | Iron.nvim | Molten.nvim |
|--------|-----------|-------------|
| Start | `<leader>is` | `<leader>ji` |
| Run line | `<leader>il` | `<leader>jl` |
| Run selection | `<leader>ic` | `<leader>jv` |
| Run file | `<leader>iF` | - |
| Run cell | - | `<leader>jr` |
| Clear output | `<leader>iC` | `<leader>jh` |

### Which to Use When?
- **Iron.nvim** (`<leader>i`): Quick scripts, debugging, simple REPL interaction
- **Molten.nvim** (`<leader>j`): Data science, notebooks, visualization

## Implementation Steps

1. Update `/lua/plugins/iron.lua` with new keymaps
2. Update `/lua/plugins/molten.lua` with new keymaps
3. Restart Neovim
4. Test both plugins to ensure no conflicts

## Optional: Which-key Integration

Add to your which-key config:
```lua
{
  "<leader>i", group = "iron (REPL)",
  "<leader>j", group = "jupyter (Molten)",
}
```

This provides clear visual separation and helps remember the keymaps.