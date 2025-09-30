# Iron.nvim Window Configuration Options

Based on the official documentation, here are various ways to configure your REPL window:

## Split Windows

### Vertical Splits
```lua
-- Right side with percentage
repl_open_cmd = view.split.vertical.botright("40%")

-- Right side with fixed columns
repl_open_cmd = view.split.vertical.botright(80)

-- Left side
repl_open_cmd = view.split.vertical.leftabove("40%")

-- Dynamic sizing based on golden ratio
repl_open_cmd = view.split.vertical.botright(0.61803398875)
```

### Horizontal Splits
```lua
-- Bottom with percentage
repl_open_cmd = view.split.horizontal.botright("30%")

-- Bottom with fixed lines
repl_open_cmd = view.split.horizontal.botright(20)

-- Top
repl_open_cmd = view.split.horizontal.leftabove("30%")
```

### Function-based Dynamic Sizing
```lua
-- Size based on window size
repl_open_cmd = view.split.vertical.botright(function()
  if vim.o.columns > 200 then
    return vim.o.columns * 0.3  -- 30% for wide screens
  else
    return vim.o.columns * 0.5  -- 50% for narrow screens
  end
end)
```

## Floating Windows

### Simple Floats
```lua
-- Top 10% of screen
repl_open_cmd = view.top("10%")

-- Bottom 40% of screen
repl_open_cmd = view.bottom("40%")

-- Centered with percentage
repl_open_cmd = view.center("30%", 20)  -- 30% width, 20 lines height

-- Centered with dynamic sizing
repl_open_cmd = view.center(function(vertical)
  if vertical then
    return 50  -- width
  end
  return 30    -- height
end)
```

### Advanced Float Configuration
```lua
-- Custom positioned float
repl_open_cmd = view.offset{
  width = 60,
  height = vim.o.lines * 0.75,
  w_offset = 0,  -- offset from left
  h_offset = "5%"  -- offset from top
}

-- Float with helper functions
repl_open_cmd = view.offset{
  width = 80,
  height = 30,
  -- Flip puts it on the right/bottom
  w_offset = view.helpers.flip(2),
  -- Center it vertically
  h_offset = view.helpers.proportion(0.5)
}
```

## Multiple REPL Commands

You can define multiple ways to open REPLs:

```lua
repl_open_cmd = {
  view.split.vertical.botright("40%"),  -- Default: <space>rs
  view.bottom(20),                       -- Available as toggle_repl_with_cmd_1
  view.center("50%", 30)                 -- Available as toggle_repl_with_cmd_2
}

-- Then in keymaps:
keymaps = {
  toggle_repl = "<space>rs",  -- Uses first command
  toggle_repl_with_cmd_1 = "<space>rv",
  toggle_repl_with_cmd_2 = "<space>rh",
}
```

## Window Options

You can pass additional window options:

```lua
repl_open_cmd = view.split.vertical.botright("40%", {
  winfixwidth = false,    -- Allow resizing
  winfixheight = false,
  number = true,          -- Show line numbers
  relativenumber = false,
  signcolumn = "no",      -- Hide sign column
  cursorline = true       -- Highlight current line
})
```

## Current Configuration

Your current setup uses:
```lua
repl_open_cmd = view.split.vertical.botright("40%")
```

This opens the REPL in a vertical split on the right side, taking up 40% of the window width. This is a good default that works well for most workflows.