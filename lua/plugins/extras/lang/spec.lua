local list_extend = require("utils").list_extend

-- https://stackoverflow.com/a/21062734
local M = {
  ---@type LangConfig
  defaults = {
    parsers = {}, -- nvim-treesitter: language parsers
    cmdtools = {}, -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    lsp = {
      servers = {}, -- nvim-lspconfig: setup lspconfig servers
      nls_sources = {}, -- null-ls.nvim: builtins formatters, diagnostics, code_actions
    },
    dap = {}, -- nvim-dap: language specific extension
    test_adapters = {}, -- neotest: language specific adapter functions
  },
  ---@type TestAdapterFn[]
  ---@private
  _all_test_adapters = {}, -- All configured neotest adapter functions
}

---@alias TestAdapterFn fun(): neotest.Adapter

---@class LangConfig
---@field parsers string[]
---@field cmdtools string[]
---@field lsp LangConfig.lsp
---@field dap table
---@field test_adapters TestAdapterFn[]

---@class LangConfig.lsp
---@field servers lspconfig.options
---@field null_ls table

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

  -- setup formatters, linters and code_actions
  if not vim.tbl_isempty(conf.lsp.nls_sources) then
    table.insert(specs, {
      "jose-elias-alvarez/null-ls.nvim",
      event = "BufReadPre",
      dependencies = { "mason.nvim" },
      opts = function(_, opts)
        list_extend(opts.sources, conf.lsp.nls_sources)
      end,
    })
  end

  -- setup DAP

  -- setup neotest adapter
  if not vim.tbl_isempty(conf.test_adapters) then
    list_extend(M._all_test_adapters, conf.test_adapters)
  end

  return specs
end

M.test_adapters = function()
  ---@type neotest.Adapter[]
  local adapters = {}
  for _, fn in ipairs(M._all_test_adapters) do
    table.insert(adapters, fn())
  end
  return adapters
end

return M
