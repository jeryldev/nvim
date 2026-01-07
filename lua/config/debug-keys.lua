-- Debug logging for keypress issues
-- Usage: Add `require("config.debug-keys")` to init.lua to enable
local log_file = vim.fn.stdpath("cache") .. "/keypress-debug.log"

local log_buffer = {}
local flush_timer = nil
local on_key_ns = nil

local function flush_logs()
  if #log_buffer > 0 then
    local f = io.open(log_file, "a")
    if f then
      f:write(table.concat(log_buffer, "\n") .. "\n")
      f:close()
    end
    log_buffer = {}
  end
  flush_timer = nil
end

local function log(msg)
  table.insert(log_buffer, os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg)
  if not flush_timer then
    flush_timer = vim.defer_fn(flush_logs, 2000)
  end
end

local function log_immediate(msg)
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

log_immediate("Neovim version: " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch)
log_immediate("Log file: " .. log_file)

-- Log all keypresses (batched every 2 seconds to avoid disk thrashing)
on_key_ns = vim.on_key(function(key, typed)
  if key and #key > 0 then
    local mode = vim.api.nvim_get_mode().mode
    local key_repr = vim.fn.keytrans(key)
    local typed_repr = typed and vim.fn.keytrans(typed) or "nil"
    log(string.format("Mode: %s | Key: %s | Typed: %s", mode, key_repr, typed_repr))
  end
end)

-- Flush logs and cleanup on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    log_immediate("=== VimLeavePre triggered - Neovim is exiting ===")
    flush_logs()
    if on_key_ns then
      vim.on_key(nil, on_key_ns)
    end
  end,
})

-- Check what : is mapped to (one-time startup check)
vim.defer_fn(function()
  local colon_map = vim.fn.maparg(":", "n")
  if colon_map and colon_map ~= "" then
    log_immediate("WARNING: ':' is remapped to: " .. colon_map)
  else
    log_immediate("':' has no custom mapping (using default)")
  end

  local semicolon_map = vim.fn.maparg(";", "n")
  if semicolon_map and semicolon_map ~= "" then
    log_immediate("';' is mapped to: " .. semicolon_map)
  end
end, 1000)

vim.notify("Debug logging enabled: " .. log_file, vim.log.levels.INFO)

return {
  disable = function()
    flush_logs()
    if on_key_ns then
      vim.on_key(nil, on_key_ns)
      on_key_ns = nil
    end
    vim.notify("Debug logging disabled", vim.log.levels.INFO)
  end,
  flush = flush_logs,
  log_file = log_file,
}
