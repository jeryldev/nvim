-- Elixir Language Expert configuration for LazyVim
-- The official Elixir language server from the Elixir team

return {
  -- Configure LSP for Expert
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Disable other Elixir LSPs
        elixirls = {
          enable = false,
        },
        -- Configure Expert (using lexical config name for compatibility with nvim-lspconfig)
        lexical = {
          cmd = { vim.fn.expand("~/.local/bin/expert-lsp") }, -- Use the built expert binary
          root_dir = function(fname)
            return require('lspconfig').util.root_pattern("mix.exs", ".git")(fname)
              or vim.loop.cwd()
          end,
          filetypes = { "elixir", "eelixir", "heex", "surface" },
          settings = {},
          -- Disable formatting to use mix format via conform
          init_options = {
            provideFormatter = false,
          },
        },
      },
      setup = {
        -- Additional setup if needed
        lexical = function(_, opts)
          -- You can add custom on_attach or other handlers here
        end,
      },
    },
  },

  -- Ensure conform uses mix format for Elixir
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        elixir = { "mix" },
        eelixir = { "mix" },
        heex = { "mix" },
        surface = { "mix" },
      },
      formatters = {
        mix = {
          command = "mix",
          args = { "format", "-" },
          stdin = true,
          cwd = require("conform.util").root_file({
            ".formatter.exs",
            "mix.exs",
          }),
          require_cwd = true,
        },
      },
    },
    -- Add Elixir-specific format keybinding
    keys = {
      {
        "<leader>mf",
        function()
          require("conform").format({ async = true, lsp_fallback = false })
        end,
        mode = { "n", "v" },
        desc = "Format with mix format",
        ft = { "elixir", "heex", "eelixir" },
      },
    },
  },
}