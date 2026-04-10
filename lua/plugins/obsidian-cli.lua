-- obsidian-cli.nvim — thin wrapper for the official Obsidian CLI
-- Set OBSIDIAN_CLI_DEV to a local path to use a local checkout for development.
local dev_path = os.getenv("OBSIDIAN_CLI_DEV") or vim.fn.expand("~/code/obsidian-cli.nvim")
local use_local = vim.fn.isdirectory(dev_path) == 1

local spec = {
  event = "VeryLazy",
  opts = {},
}

if use_local then
  spec.dir = dev_path
  spec.name = "obsidian-cli.nvim"
else
  spec[1] = "jeryldev/obsidian-cli.nvim"
end

return { spec }
