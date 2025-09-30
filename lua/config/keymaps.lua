-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Copy relative path from project root
vim.keymap.set("n", "<leader>cy", function()
  local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  if vim.v.shell_error ~= 0 then
    -- Fallback to current working directory if not in git repo
    root = vim.fn.getcwd()
  end

  local filepath = vim.fn.expand("%:p")
  local relative_path = filepath:sub(root:len() + 2) -- +2 to account for the trailing slash

  vim.fn.setreg("+", relative_path)
  vim.notify("Copied: " .. relative_path, vim.log.levels.INFO)
end, { desc = "Copy relative file path" })
