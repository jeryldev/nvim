-- pyworks.nvim setup
-- Set PYWORKS_DEV=/path/to/local/pyworks.nvim to use local version
-- local pyworks_dev_path = os.getenv("PYWORKS_DEV")

-- pyworks.nvim setup
-- Set PYWORKS_DEV=/path/to/local/pyworks.nvim to use local version

return {
  {
    "jeryldev/pyworks.nvim",
    config = function()
      require("pyworks").setup()
    end,
    lazy = false,
    priority = 100,
  },
}
