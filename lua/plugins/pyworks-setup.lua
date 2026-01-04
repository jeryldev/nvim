-- Simplified pyworks.nvim setup
-- Pyworks now handles jupytext configuration and fallback internally
return {
  {
    "jeryldev/pyworks.nvim",
    dependencies = {
      {
        "GCBallesteros/jupytext.nvim",
        config = false, -- Let pyworks handle jupytext configuration
      },
      "benlubas/molten-nvim",
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
  },
}
