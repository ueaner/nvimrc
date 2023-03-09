local list_extend = require("utils").list_extend

-- https://stackoverflow.com/a/21062734
local M = {
  defaults = {
    parsers = {}, -- nvim-treesitter: language parsers
    cmdtools = {}, -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    lsp = {
      servers = {}, -- nvim-lspconfig: setup lspconfig servers
      formatters = {}, -- null-ls.nvim: builtins formatters
      linters = {}, -- null-ls.nvim: builtins diagnostics
    },
    dap = {}, -- nvim-dap: language specific extension
    test = {}, -- neotest: language specific adapter
  },
}

---@class LangConfig
---@field parsers string[]
---@field cmdtools string[]
---@field lsp LangConfig.lsp
---@field dap table
---@field test table

---@class LangConfig.lsp
---@field servers table
---@field formatters table<string, table>
---@field linters table<string, table>

---Generate language specific specs
---@param conf LangConfig
M.generate = function(conf)
  conf = vim.tbl_deep_extend("force", M.defaults, conf or {})
  local specs = {}

  -- add language parsers to treesitter
  if not vim.tbl_isempty(conf.parsers) then
    table.insert(specs, {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        list_extend(opts.ensure_installed, conf.parsers)
      end,
    })
  end

  -- cmdline tools for LSP servers, DAP servers, formatters and linters
  if not vim.tbl_isempty(conf.cmdtools) then
    table.insert(specs, {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        list_extend(opts.ensure_installed, conf.cmdtools)
      end,
    })
  end

  -- setup lspconfig servers
  if not vim.tbl_isempty(conf.lsp.servers) then
    table.insert(specs, {
      "neovim/nvim-lspconfig",
      ---@class PluginLspOpts
      opts = {
        ---@type lspconfig.options
        servers = conf.lsp.servers,
      },
    })
  end

  -- formatters & linters
  local sources = list_extend(conf.lsp.formatters, conf.lsp.linters)
  if not vim.tbl_isempty(sources) then
    table.insert(specs, {
      "jose-elias-alvarez/null-ls.nvim",
      event = "BufReadPre",
      dependencies = { "mason.nvim" },
      opts = function(_, opts)
        list_extend(opts.sources, sources)
      end,
    })
  end

  -- DAP
  -- test

  return specs
end

return M
