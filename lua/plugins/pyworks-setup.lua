-- Simplified pyworks.nvim setup
-- Pyworks now handles jupytext configuration and fallback internally
return {
  {
    -- Using local version for testing
    dir = "/Users/jeryldev/PycharmProjects/iron_training/pyworks.nvim",
    -- For production, use: "jeryldev/pyworks.nvim",
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
  },
}
