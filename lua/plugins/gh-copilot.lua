return {
  -- Override copilot.lua to explicitly enable Python and notebook filetypes
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        python = true,
        markdown = true,
        help = true,
        -- Enable for all filetypes by default (copilot.lua disables some by default)
        yaml = true,
        json = true,
        -- Jupyter notebooks converted by jupytext become python filetype
        -- but we also explicitly allow these just in case
        ["*"] = function()
          -- Disable for very large files (performance)
          if vim.api.nvim_buf_line_count(0) > 5000 then
            return false
          end
          return true
        end,
      },
    },
  },
  -- {
  --   "CopilotC-Nvim/CopilotChat.nvim",
  --   keys = {
  --     { "<leader>ae", ":CopilotChatExplain<CR>",  mode = "v", desc = "Explain Code" },
  --     { "<leader>ar", ":CopilotChatReview<CR>",   mode = "v", desc = "Review Code" },
  --     { "<leader>af", ":CopilotChatFix<CR>",      mode = "v", desc = "Fix Code Issues" },
  --     { "<leader>ao", ":CopilotChatOptimize<CR>", mode = "v", desc = "Optimize Code" },
  --     { "<leader>ad", ":CopilotChatDocs<CR>",     mode = "v", desc = "Generate Docs" },
  --     { "<leader>at", ":CopilotChatTests<CR>",    mode = "v", desc = "Generate Tests" },
  --     { "<leader>am", ":CopilotChatCommit<CR>",   mode = "n", desc = "Generate Commit Message" },
  --     { "<leader>as", ":CopilotChatCommit<CR>",   mode = "v", desc = "Generate Commit for Selection" },
  --   },
  -- },
}
