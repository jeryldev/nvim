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

-- Obsidian.nvim keymaps
vim.keymap.set("n", "<leader>on", ":ObsidianNew ", { desc = "Obsidian: New note" })
vim.keymap.set("n", "<leader>ot", ":ObsidianToday<CR>", { desc = "Obsidian: Today's note" })
vim.keymap.set("n", "<leader>oy", ":ObsidianYesterday<CR>", { desc = "Obsidian: Yesterday's note" })
vim.keymap.set("n", "<leader>of", ":ObsidianQuickSwitch<CR>", { desc = "Obsidian: Find note" })
vim.keymap.set("n", "<leader>os", ":ObsidianSearch ", { desc = "Obsidian: Search notes" })
vim.keymap.set("n", "<leader>oT", ":ObsidianTemplate ", { desc = "Obsidian: Insert template" })
vim.keymap.set("n", "<leader>ob", ":ObsidianBacklinks<CR>", { desc = "Obsidian: Show backlinks" })
vim.keymap.set("n", "<leader>og", ":ObsidianTags<CR>", { desc = "Obsidian: Browse tags" })
vim.keymap.set("n", "<leader>ol", ":ObsidianLink ", { desc = "Obsidian: Link to note" })
vim.keymap.set("n", "<leader>oL", ":ObsidianLinkNew ", { desc = "Obsidian: Create new link" })
vim.keymap.set("n", "<leader>or", ":ObsidianRename ", { desc = "Obsidian: Rename note" })
vim.keymap.set("n", "<leader>op", ":ObsidianPasteImg ", { desc = "Obsidian: Paste image" })
vim.keymap.set("n", "<leader>oo", ":ObsidianOpen<CR>", { desc = "Obsidian: Open in app" })
vim.keymap.set("n", "<leader>ow", ":ObsidianWorkspace ", { desc = "Obsidian: Switch workspace" })

-- Find hidden + gitignored files (including .research/, .claude/, etc.)
vim.keymap.set("n", "<leader>fh", function()
  local snacks = require("snacks")
  snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find hidden files" })
