-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

local M = {
  excluded_filetypes = {
    "",
    "NvimTree",
    "Outline",
    "TelescopePrompt",
    "TelescopeResults",
    "Trouble",
    "aerial",
    "alpha",
    "checkhealth",
    "dashboard",
    "gitcommit",
    "help",
    "lazy",
    "lspinfo",
    "man",
    "mason",
    "neo-tree",
    "notify",
  },

  -- close some filetypes with <q>
  close_with_q = {
    "PlenaryTestPopup",
    "checkhealth",
    "help",
    "hierarchy-tree-go",
    "httpResult",
    "lspinfo",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "dap-float",
    "notify",
    "oil",
    "qf",
    "query", -- :InspectTree
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },

  -- icons used by other plugins
  icons = {
    general = {
      lsp = "",
      dap = "",
      treesitter = "",
    },
    -- https://microsoft.github.io/vscode-codicons/dist/codicon.html
    dap = {
      Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = " ",
      BreakpointRejected = { " ", "DiagnosticError" },
      LogPoint = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn = " ",
      Hint = " ",
      Info = " ",
    },
    git = {
      added = " ",
      modified = " ",
      removed = " ",
    },
    kinds = {
      Array = " ",
      Boolean = "󰨙 ",
      Class = " ",
      Codeium = "󰘦 ",
      Color = " ",
      Control = " ",
      Collapsed = " ",
      Constant = "󰏿 ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = "󰊕 ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = "󰊕 ",
      Module = " ",
      Namespace = "󰦮 ",
      Null = " ",
      Number = "󰎠 ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = "󰆼 ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = "󰀫 ",
    },
  },

  ---@type table<string, string[]>?
  kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Property",
      "Struct",
      "Trait",
    },
    -- you can specify a different filter for each filetype
    -- lua = {
    --   "Function",
    -- },
  },
}

---@param buf? number
---@return string[]?
function M.get_kind_filter(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if M.kind_filter == false then
    return
  end
  return M.kind_filter[ft] or M.kind_filter.default
end

return M
