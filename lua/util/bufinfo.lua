local M = setmetatable({}, {
  __call = function(m, ...)
    return m.info(...)
  end,
})

function M.langserver_names()
  local info = U.config.icons.general.lsp .. " lsp: "
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if next(clients) == nil then
    return info .. "<empty>"
  end
  local ls = {}
  for _, client in ipairs(clients) do
    table.insert(ls, ("**%s#%d**"):format(client.name, client.id))
  end
  return info .. table.concat(ls, ", ")
end

function M.treesitter_parser()
  local info = U.config.icons.general.treesitter .. " treesitter: "
  local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
  if not lang then
    return info .. "<empty>"
  end

  local ok, parser = pcall(vim.treesitter.get_parser, 0, lang)
  if ok and parser then
    return info .. lang
  end
  return info .. ("no parser for %s"):format(lang)
end

function M.dap_has_adapter()
  local info = U.config.icons.general.dap .. " dap: "
  if not U.is_loaded("nvim-dap") then
    return info .. "<not loaded>"
  end

  local ok, dap = pcall(require, "dap")
  local ft = vim.bo.filetype
  if ok and dap.configurations[ft] ~= nil then
    return info .. ("configured for %s"):format(ft)
  end
  return info .. ("no adapter for %s"):format(ft ~= "" and ft or "<empty>")
end

function M.formatter_names()
  local info = "format: "
  -- Formatter providers are registered on VeryLazy; before that this can be empty.
  local ok, formatters = pcall(U.format.resolve, vim.api.nvim_get_current_buf())
  if not ok then
    return info .. "<empty>"
  end

  local names = {}
  for _, formatter in ipairs(formatters) do
    if formatter.active then
      vim.list_extend(names, formatter.resolved)
    end
  end
  if #names == 0 then
    return info .. "<empty>"
  end
  return info .. table.concat(names, ", ")
end

function M.linter_names()
  local info = "lint: "
  local ok, lint = pcall(require, "lint")
  if not ok or type(lint._resolve_linter_by_ft) ~= "function" then
    return info .. "<empty>"
  end

  local ft = vim.bo.filetype
  local names = vim.deepcopy(lint._resolve_linter_by_ft(ft) or {})

  if #names == 0 then
    vim.list_extend(names, lint.linters_by_ft["_"] or {})
  end
  vim.list_extend(names, lint.linters_by_ft["*"] or {})

  local ctx = { filename = vim.api.nvim_buf_get_name(0) }
  ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
  names = vim.tbl_filter(function(name)
    local linter = lint.linters[name]
    return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
  end, names)

  if #names == 0 then
    return info .. "<empty>"
  end
  return info .. table.concat(U.dedup(names), ", ")
end

function M.file_path()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    return "path: <empty>"
  end
  return "path: " .. vim.fn.fnamemodify(path, ":~:.")
end

function M.root_path()
  local ok, root = pcall(U.root.get)
  if not ok or root == nil or root == "" then
    return "root: <empty>"
  end
  return "root: " .. vim.fn.fnamemodify(root, ":~")
end

function M.git_branch()
  local branch = vim.b.gitsigns_head
  if (branch == nil or branch == "") and type(vim.b.gitsigns_status_dict) == "table" then
    branch = vim.b.gitsigns_status_dict.head
  end
  return "git: " .. ((branch and branch ~= "") and branch or "<empty>")
end

function M.info()
  if vim.b.bufinfo_window then
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

  -- File
  table.insert(lines, "# File")
  table.insert(lines, "- " .. M.file_path())
  table.insert(lines, "- " .. M.root_path())
  table.insert(lines, "- " .. M.git_branch())

  -- Tools
  table.insert(lines, "")
  table.insert(lines, "# Tools")
  table.insert(lines, M.langserver_names())
  table.insert(lines, M.formatter_names())
  table.insert(lines, M.linter_names())
  table.insert(lines, M.dap_has_adapter())
  table.insert(lines, M.treesitter_parser())

  -- Options
  table.insert(lines, "")
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

  -- MORE

  local buf, win = U.floatwin.make(lines)
  vim.b[buf].bufinfo_window = true

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
