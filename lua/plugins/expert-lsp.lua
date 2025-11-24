-- Elixir Language Expert configuration for LazyVim
-- Expert: The official Elixir language server from the Elixir team
-- GitHub: https://github.com/elixir-lang/expert
-- Installation docs: https://github.com/elixir-lang/expert/blob/main/pages/installation.md

return {
  -- Disable Mason auto-installation of Elixir LSPs
  {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      -- Remove any Elixir LSPs from auto-install
      opts.ensure_installed = vim.tbl_filter(function(server)
        return server ~= "elixirls" and server ~= "lexical"
      end, opts.ensure_installed)

      -- Explicitly disable handlers for Elixir LSPs
      opts.handlers = opts.handlers or {}
      opts.handlers.elixirls = function() end  -- No-op handler
      opts.handlers.lexical = function() end   -- No-op handler
    end,
  },

  -- Configure Expert LSP using Neovim 0.11.3+ built-in LSP config
  -- See: https://github.com/elixir-lang/expert/blob/main/pages/installation.md
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Ensure servers table exists
      opts.servers = opts.servers or {}

      -- Explicitly disable elixirls and lexical
      opts.servers.elixirls = false
      opts.servers.lexical = false

      -- Ensure setup table exists and disable their setup functions
      opts.setup = opts.setup or {}
      opts.setup.elixirls = function() return true end  -- Skip setup
      opts.setup.lexical = function() return true end   -- Skip setup

      return opts
    end,
    init = function()
      -- Use Neovim 0.11.3+ built-in LSP configuration per official docs:
      -- https://github.com/elixir-lang/expert/blob/main/pages/installation.md
      vim.lsp.config('expert', {
        cmd = { vim.fn.expand("~/.local/bin/expert-lsp"), '--stdio' },
        root_markers = { 'mix.exs', '.git' },
        filetypes = { 'elixir', 'eelixir', 'heex' },
        -- Disable formatting - use conform.nvim with mix format instead
        capabilities = {
          documentFormattingProvider = false,
          documentRangeFormattingProvider = false,
        },
      })

      -- Enable Expert for current buffer
      vim.lsp.enable('expert')
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
        args = function(self, ctx)
          return { "format", ctx.filename }
        end,
        stdin = false,
        cwd = require("conform.util").root_file({ "mix.exs" }),
      }

      return opts
    end,
    init = function()
      -- Add format-on-save for Elixir files
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.ex", "*.exs", "*.heex", "*.eelixir", "*.surface" },
        callback = function(event)
          if vim.g.autoformat then
            require("conform").format({
              bufnr = event.buf,
              lsp_fallback = false,
              timeout_ms = 2000,
            })
          end
        end,
      })

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