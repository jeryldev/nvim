-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Virtual environment handling is now done by pyworks.nvim
-- pyworks.nvim handles:
-- - VimEnter: Automatic PATH configuration and Python host setup
-- - TermOpen: Auto-activation in terminals when auto_activate_venv = true
-- See: https://github.com/jeryldev/pyworks.nvim

-- Format-on-save is now handled in lua/plugins/expert-lsp.lua
-- via conform.nvim's BufWritePre autocmd
-- Toggle autoformat with <leader>uf (LazyVim default)
