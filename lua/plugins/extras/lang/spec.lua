local list_extend = require("utils").list_extend
local str_isempty = require("utils").str_isempty

-- https://stackoverflow.com/a/21062734
local M = {
  ---@type LangConfig
  defaults = {
    ft = "", -- filetype
    parsers = {}, -- nvim-treesitter: language parsers
    cmdtools = {}, -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    lsp = {
      servers = {}, -- nvim-lspconfig: setup lspconfig servers
      nls_sources = {}, -- null-ls.nvim: builtins formatters, diagnostics, code_actions
    },
    dap = { -- nvim-dap: language specific extensions
    },
    test = { -- neotest: language specific adapters
    },
  },
  ---@type TestAdapterFn[]
  ---@private
  _all_test_adapters = {}, -- All configured neotest adapter functions
}

---@alias TestAdapterFn fun(): neotest.Adapter

---@class LangConfig
---@field ft string
---@field parsers string[]
---@field cmdtools string[]
---@field lsp LangConfig.lsp
---@field dap LangConfig.dap
---@field test LangConfig.test

---@class LangConfig.lsp
---@field servers lspconfig.options
---@field nls_sources table

---@alias LangConfig.dap LangDapAdapter[]

---@class LangDapAdapter
---@field [1] string? package name
---@field on_ft (fun(event:object?))
---@field config fun()

---@alias LangConfig.test LangTestAdapter[]

---@class LangTestAdapter
---@field [1] string? package name
---@field adapter_fn (fun(): neotest.Adapter) neotest language specific adapter function

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
  if not vim.tbl_isempty(conf.dap) then
    for _, item in ipairs(conf.dap) do
      -- install dap adapter plugin
      if not str_isempty(item[1]) then
        -- Automatically run `require(MAIN).setup(opts)` with `config = true`
        -- @type boolean|function
        local config = true
        if type(item.config) == "function" then
          config = item.config
        end
        local spec = { item[1], config = config }
        if not str_isempty(conf.ft) then
          spec = {
            item[1],
            ft = conf.ft,
            init = function()
              require("utils").on_ft(conf.ft, item.on_ft)
            end,
            config = config,
          }
        end
        table.insert(specs, spec)
      end
    end
  end

  -- setup neotest adapter
  if not vim.tbl_isempty(conf.test) then
    for _, item in ipairs(conf.test) do
      -- install neotest adapter plugin
      if not str_isempty(item[1]) then
        local spec = { item[1] }
        if not str_isempty(conf.ft) then
          spec = { item[1], ft = conf.ft }
        end
        table.insert(specs, spec)
      end

      -- append neotest adapter instance
      table.insert(M._all_test_adapters, item.adapter_fn)
    end
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
