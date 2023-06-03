-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/init.lua

local M = {
  excluded_filetypes = { "help", "alpha", "dashboard", "NvimTree", "aerial", "Trouble", "lazy", "mason", "notify" },

  -- icons used by other plugins
  icons = {
    -- https://microsoft.github.io/vscode-codicons/dist/codicon.html
    dap = {
      Stopped = { "", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint = " ",
      BreakpointCondition = "",
      BreakpointRejected = { "", "DiagnosticError" },
      LogPoint = "",
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
      Boolean = " ",
      Class = " ",
      Color = " ",
      Constant = " ",
      Constructor = " ",
      Copilot = " ",
      Enum = " ",
      EnumMember = " ",
      Event = " ",
      Field = " ",
      File = " ",
      Folder = " ",
      Function = " ",
      Interface = " ",
      Key = " ",
      Keyword = " ",
      Method = " ",
      Module = " ",
      Namespace = " ",
      Null = " ",
      Number = " ",
      Object = " ",
      Operator = " ",
      Package = " ",
      Property = " ",
      Reference = " ",
      Snippet = " ",
      String = " ",
      Struct = " ",
      Text = " ",
      TypeParameter = " ",
      Unit = " ",
      Value = " ",
      Variable = " ",
    },
  },
}

return M