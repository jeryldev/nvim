return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      -- Add group descriptions for your custom keybindings
      { "<space>r", group = "repl" },
      { "<space>s", group = "send" },
      { "<space>m", group = "mark" },

      -- You can also add more specific subgroups if needed
      { "<space>sc", group = "send code" },
      { "<space>s<cr>", desc = "Send CR to REPL" },
      { "<space>s<space>", desc = "Interrupt REPL (Ctrl+C)" },

      -- Add descriptions for other groups you might have
      { "<space>c", group = "code/clear" },
    },
  },
}
