-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Redo (U is more convenient than C-r which gets intercepted by terminal/tmux)
vim.keymap.set("n", "U", "<C-r>", { desc = "Redo" })

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

-- Zig keymaps (buffer-local, only active in .zig files)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function(event)
    vim.keymap.set("n", "<leader>zt", function()
      vim.fn.jobstart("zig build test 2>&1", {
        stdout_buffered = true,
        stderr_buffered = true,
        on_stdout = function(_, data)
          local output = table.concat(data, "\n"):gsub("^%s+", ""):gsub("%s+$", "")
          if output == "" then
            vim.schedule(function() vim.notify("zig build test: ALL PASSED", vim.log.levels.INFO) end)
          else
            vim.schedule(function() vim.notify(output, vim.log.levels.ERROR) end)
          end
        end,
      })
    end, { buffer = event.buf, desc = "Zig: Build & test" })
  end,
})

-- Find hidden + gitignored files (including .research/, .claude/, etc.)
vim.keymap.set("n", "<leader>fh", function()
  local snacks = require("snacks")
  snacks.picker.files({ hidden = true, ignored = true })
end, { desc = "Find hidden files" })
