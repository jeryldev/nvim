-- Elixir Language Expert configuration for LazyVim
-- Expert: The official Elixir language server from the Elixir team
-- GitHub: https://github.com/elixir-lang/expert
-- Installation docs: https://github.com/elixir-lang/expert/blob/main/pages/installation.md

return {
  -- Configure LSP for Expert using Neovim 0.11.3+ built-in LSP config
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Disable other Elixir LSPs
      opts.servers.elixirls = { enable = false }

      -- Configure Expert LSP
      opts.servers.lexical = {
        cmd = { vim.fn.expand("~/.local/bin/expert-lsp"), "--stdio" },
        root_dir = function(fname)
          local util = require("lspconfig.util")
          return util.root_pattern("mix.exs", ".git")(fname) or vim.loop.cwd()
        end,
        filetypes = { "elixir", "eelixir", "heex" },
        settings = {},
        -- Increase timeout to prevent LSP timeout errors
        flags = {
          debounce_text_changes = 150,
        },
        -- Increase timeout for initial compilation
        timeout = 10000,
      }

      -- Ensure setup table exists
      opts.setup = opts.setup or {}
      opts.setup.lexical = function(_, server_opts)
        local lspconfig = require("lspconfig")
        local configs = require("lspconfig.configs")

        -- Register the Expert LSP server config
        if not configs.lexical then
          configs.lexical = {
            default_config = {
              cmd = server_opts.cmd,
              filetypes = server_opts.filetypes,
              root_dir = server_opts.root_dir,
              settings = server_opts.settings or {},
            },
          }
        end

        -- Setup the server with the provided options
        lspconfig.lexical.setup(server_opts)
        return true
      end

      return opts
    end,
  },

  -- Configure conform to use mix format for Elixir
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft.elixir = { "mix" }
      opts.formatters_by_ft.eelixir = { "mix" }
      opts.formatters_by_ft.heex = { "mix" }
      opts.formatters_by_ft.surface = { "mix" }

      opts.formatters = opts.formatters or {}
      opts.formatters.mix = {
        command = "mix",
        args = { "format", "-" },
        stdin = true,
      }

      return opts
    end,
    init = function()
      -- Add keybinding for Elixir files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "elixir", "heex", "eelixir", "surface" },
        callback = function(event)
          vim.keymap.set({ "n", "v" }, "<leader>mf", function()
            require("conform").format({ async = true, lsp_fallback = false })
          end, {
            buffer = event.buf,
            desc = "Format buffer with mix format",
          })
        end,
      })
    end,
  },
}