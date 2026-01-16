-- Simplified pyworks.nvim setup
-- Pyworks handles .ipynb files directly using jupytext CLI (no jupytext.nvim needed)
-- Set PYWORKS_DEV=/path/to/local/pyworks.nvim to use local version
local pyworks_dev_path = os.getenv("PYWORKS_DEV")

local pyworks_spec = {
  dir = pyworks_dev_path,
  dependencies = {
    "benlubas/molten-nvim",
    "3rd/image.nvim",
  },
  config = function()
    require("pyworks").setup() -- Uses defaults: uv=true, image_backend="kitty"
  end,
  lazy = false, -- Load immediately for file detection
  priority = 100, -- Load early
}

-- Use GitHub repo when not in dev mode
if not pyworks_dev_path then
  pyworks_spec[1] = "jeryldev/pyworks.nvim"
  pyworks_spec.dir = nil
end

return { pyworks_spec }
