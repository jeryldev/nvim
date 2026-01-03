-- Debug logging for keypress issues
-- Usage: Add `require("config.debug-keys")` to init.lua to enable
local log_file = vim.fn.stdpath("cache") .. "/keypress-debug.log"

local function log(msg)
  local f = io.open(log_file, "a")
  if f then
    f:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
    f:close()
  end
end

-- Clear log file on start
local f = io.open(log_file, "w")
if f then
  f:write("=== Debug session started ===\n")
  f:close()
end

log("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
log("Log file: " .. log_file)

-- Log all keypresses in normal mode
vim.on_key(function(key, typed)
  if key and #key > 0 then
    local mode = vim.api.nvim_get_mode().mode
    local key_repr = vim.fn.keytrans(key)
    local typed_repr = typed and vim.fn.keytrans(typed) or "nil"
    log(string.format("Mode: %s | Key: %s | Typed: %s", mode, key_repr, typed_repr))
  end
end)

-- Log when exiting
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    log("=== VimLeavePre triggered - Neovim is exiting ===")
  end,
})

vim.api.nvim_create_autocmd("ExitPre", {
  callback = function()
    log("=== ExitPre triggered ===")
  end,
})

-- Check what : is mapped to
vim.defer_fn(function()
  local colon_map = vim.fn.maparg(":", "n")
  if colon_map and colon_map ~= "" then
    log("WARNING: ':' is remapped to: " .. colon_map)
  else
    log("':' has no custom mapping (using default)")
  end

  -- Also check ; since user mentioned shift+;
  local semicolon_map = vim.fn.maparg(";", "n")
  if semicolon_map and semicolon_map ~= "" then
    log("';' is mapped to: " .. semicolon_map)
  end
end, 1000)

vim.notify("Debug logging enabled: " .. log_file, vim.log.levels.INFO)

return {}
