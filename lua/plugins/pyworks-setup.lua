-- Simplified pyworks.nvim setup
-- Pyworks now handles jupytext configuration and fallback internally
-- Set PYWORKS_DEV=/path/to/local/pyworks.nvim to use local version
local pyworks_dev_path = os.getenv("PYWORKS_DEV")

local pyworks_spec = {
  dir = pyworks_dev_path,
  dependencies = {
    {
      "GCBallesteros/jupytext.nvim",
      config = false, -- Let pyworks handle jupytext configuration
    },
    {
      "benlubas/molten-nvim",
      init = function()
        vim.g.molten_show_mimetype_debug = false
        vim.g.molten_enter_output_behavior = "open_float"
      end,
    },
    "3rd/image.nvim",
  },
  config = function()
    require("pyworks").setup({
      python = {
        use_uv = true, -- Use uv for faster package installation
      },
      image_backend = "kitty", -- Ghostty supports Kitty graphics protocol
    })
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
