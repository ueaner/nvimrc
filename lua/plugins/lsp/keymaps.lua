-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/lsp/keymaps.lua

local M = {}

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string}
---@alias LazyKeysLsp LazyKeys|{has?:string}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@return LazyKeysLspSpec[]
function M.get()
  if M._keys then
    return M._keys
  end
  local keys = U.config.keys
  M._keys = keys["nvim-lspconfig keys"] and keys["nvim-lspconfig keys"] or {}
  return M._keys
end

---@return (LazyKeys|{has?:string})[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = M.get()
  local opts = U.opts("nvim-lspconfig")
  local clients = vim.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    if not keys.has or U.lsp.has(buffer, keys.has) then
      ---@type table
      local opts = Keys.opts(keys)
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
    end
  end
end

return M
