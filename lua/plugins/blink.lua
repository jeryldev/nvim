-- Add the obsidian-cli vault-aware [[wiki link]] source to blink.cmp.
-- LazyVim ships blink.cmp by default; this file extends its `sources` config.
--
-- Inside `[[...` context, only the obsidian source fires — everything else
-- (LSP, snippets, buffer, path) is suppressed so the popup is clean.
local function in_wiki_context()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(1, col)
  return before:match("%[%[[^%[%]]*$") ~= nil
end

local function not_in_wiki()
  return not in_wiki_context()
end

return {
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "obsidian" },
        providers = {
          obsidian = {
            name = "Obsidian",
            module = "obsidian-cli.completion.blink",
            score_offset = 100,
          },
          lsp = { enabled = not_in_wiki },
          path = { enabled = not_in_wiki },
          snippets = { enabled = not_in_wiki },
          buffer = { enabled = not_in_wiki },
          copilot = { enabled = not_in_wiki },
        },
      },
    },
  },
}
