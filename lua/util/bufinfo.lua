local M = setmetatable({}, {
  __call = function(m, ...)
    return m.info(...)
  end,
})

function M.langserver_names()
  local info = U.config.icons.general.lsp .. " client(s): "
  local clients = vim.lsp.get_clients()
  if next(clients) == nil then
    return info .. "<empty>"
  end
  local ls = {}
  local bufnr = vim.api.nvim_get_current_buf()
  for _, client in ipairs(clients) do
    if client.attached_buffers[bufnr] then
      table.insert(ls, "**" .. client.name .. "**")
    end
  end
  return info .. table.concat(ls, ", ")
end

function M.treesitter_has_parser()
  local info = U.config.icons.general.treesitter .. " treesitter has parser(s): "
  if package.loaded["nvim-treesitter"] and require("nvim-treesitter.parsers").has_parser() then
    return info .. "YES"
  end
  return info .. "NO"
end

function M.dap_has_adapter()
  local info = U.config.icons.general.dap .. " dap has adapter(s): "
  if require("dap").configurations[vim.bo.filetype] ~= nil then
    return info .. "YES"
  end
  return info .. "NO"
end

function M.info()
  local vtype = "info42"
  if vim.bo.filetype == vtype then
    print("This buffer is an info window")
    return
  end

  -- buffer options or window options
  local options = {
    "filetype",
    "buftype",
    "buflisted",
    "modified",
    "modifiable",
    "conceallevel",
    "tabstop",
    "softtabstop",
    "shiftwidth",
    "expandtab",
    "smarttab",
    "autoindent",
    "smartindent",
  }

  local toggles = U.toggle.toggles()

  local lines = {}
  local l = ""

  -- Options
  table.insert(lines, "# Options")
  for _, o in ipairs(options) do
    local v = vim.opt_local[o]:get()
    local s = ""
    if type(v) == "string" then
      s = v ~= "" and v or "<empty>"
    elseif type(v) == "boolean" then
      s = tostring(v)
    else
      s = vim.inspect(v)
    end
    l = string.format("- %s: %s", o, s)
    table.insert(lines, l)
  end

  -- Toggles
  table.insert(lines, "")
  table.insert(lines, "# Toggles")
  for _, t in ipairs(toggles) do
    l = string.format(" %s %s: %s", t[2], t[1], tostring(t[3]))
    table.insert(lines, l)
  end

  -- Window
  table.insert(lines, "")
  table.insert(lines, "# Window")
  l = string.format("- %s: %s", "winwidth", vim.fn.winwidth(0))
  table.insert(lines, l)

  -- LSP servers
  table.insert(lines, "")
  table.insert(lines, "# LspInfo")
  table.insert(lines, M.langserver_names())
  -- DAP adapters
  table.insert(lines, "")
  table.insert(lines, "# DAP adapters")
  table.insert(lines, M.dap_has_adapter())
  -- TS parsers
  table.insert(lines, "")
  table.insert(lines, "# TS parsers")
  table.insert(lines, M.treesitter_has_parser())

  -- MORE

  local buf, win = U.floatwin.make(lines)

  -- Highlight information windows using Markdown syntax
  local lang = "markdown"
  local ok = pcall(function()
    vim.treesitter.language.add("markdown")
  end)
  if not ok then
    pcall(require, "nvim-treesitter")
  end
  vim.wo[win].conceallevel = 2
  vim.wo[win].concealcursor = ""
  vim.wo[win].spell = false
  if not pcall(vim.treesitter.start, buf, lang) then
    vim.bo[buf].filetype = lang
    vim.bo[buf].syntax = lang
  end
end

return M
