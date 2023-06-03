local str_isempty = require("utils").str_isempty

-- https://stackoverflow.com/a/21062734
local M = {
  ---@type LangConfig
  defaults = {
    ft = "", -- filetype
    parsers = {}, -- nvim-treesitter: language parsers
    cmdtools = {}, -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    lsp = {
      servers = {}, -- nvim-lspconfig: lspconfig servers settings with filetype
      setup = {}, -- nvim-lspconfig: setup lspconfig servers, see https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
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
---@field setup table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
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

---@class LangSpecs: LazyPlugin[]
---@field append (fun(spec:LazyPlugin): LangSpecs)
---@field prepend (fun(spec:LazyPlugin): LangSpecs)

---Generate language specific specs
---@param conf LangConfig
---@return LangSpecs
M.generate = function(conf)
  ---@type LangConfig
  conf = vim.tbl_deep_extend("force", M.defaults, conf or {})

  ---@type LangSpecs
  local specs = {}
  specs.append = function(spec)
    table.insert(specs, spec)
    return specs
  end
  specs.prepend = function(spec)
    table.insert(specs, 1, spec)
    return specs
  end

  -- add language parsers to treesitter
  if not vim.tbl_isempty(conf.parsers) then
    table.insert(specs, {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, conf.parsers)
      end,
    })
  end

  -- cmdline tools for LSP servers, DAP servers, formatters and linters
  if not vim.tbl_isempty(conf.cmdtools) then
    table.insert(specs, {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, conf.cmdtools)
      end,
    })
  end

  -- setup lspconfig servers
  if not vim.tbl_isempty(conf.lsp.servers) then
    local opts = {
      ---@type lspconfig.options
      servers = conf.lsp.servers,
    }
    if not vim.tbl_isempty(conf.lsp.setup) then
      opts.setup = conf.lsp.setup
    end
    table.insert(specs, {
      "neovim/nvim-lspconfig",
      ---@class PluginLspOpts
      opts = opts,
    })
  end

  -- setup formatters, linters and code_actions
  if not vim.tbl_isempty(conf.lsp.nls_sources) then
    table.insert(specs, {
      "jose-elias-alvarez/null-ls.nvim",
      event = "BufReadPre",
      dependencies = { "mason.nvim" },
      opts = function(_, opts)
        vim.list_extend(opts.sources, conf.lsp.nls_sources)
      end,
    })
  end

  -- setup DAP
  if not vim.tbl_isempty(conf.dap) then
    for _, item in ipairs(conf.dap) do
      -- install dap adapter plugin
      if not str_isempty(item[1]) then
        -- Automatically run `require(MAIN).setup(opts)` with `config = true`
        local spec = { item[1], config = true }
        if type(item.config) == "function" then
          spec.config = item.config
        end
        if not str_isempty(conf.ft) then
          spec.ft = conf.ft
          if type(item.on_ft) == "function" then
            spec.init = function()
              require("utils").on_ft(conf.ft, item.on_ft)
            end
          end
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
        local spec = {
          "nvim-neotest/neotest",
          optional = true,
          dependencies = { item[1] },
          opts = function(_, opts)
            opts.adapters[#opts.adapters + 1] = item.adapter_fn
          end,
        }
        table.insert(specs, spec)
      end
    end
  end

  return specs
end

return M
