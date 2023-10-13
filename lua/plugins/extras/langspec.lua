---@class LangConfig
---@field ft string|string[]
---@field parsers string[]
---@field cmdtools string[]
---@field lsp LangConfig.lsp
---@field formatters string[]|table<string, conform.FormatterUnit[]>
---@field linters string[]|table<string, string[]>
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

---@class LangSpec
---@field defaults LangConfig
---@field plugin_specs LazyPluginSpec[]
---@field append fun(self: LangSpec, spec: LazyPluginSpec): LangSpec
---@field prepend fun(self: LangSpec, spec: LazyPluginSpec): LangSpec
---@field generate fun(self: LangSpec, conf: LangConfig): LazyPluginSpec[]

-- Checks if a string or table is empty.
local isempty = function(s)
  return s == nil or (type(s) == "string" and s == "") or (type(s) == "table" and next(s) == nil)
end

---@type LangConfig
local defaults = {
  ft = "", -- filetype
  parsers = {}, -- nvim-treesitter: language parsers
  cmdtools = {}, -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
  lsp = {
    servers = {}, -- nvim-lspconfig: lspconfig servers settings with filetype
    setup = {}, -- nvim-lspconfig: setup lspconfig servers, see https://www.lazyvim.org/plugins/lsp#nvim-lspconfig
    nls_sources = {}, -- null-ls.nvim: builtins formatters, diagnostics, code_actions
  },
  formatters = {}, -- conform.nvim
  linters = {}, -- nvim-lint
  dap = { -- nvim-dap: language specific extensions
  },
  test = { -- neotest: language specific adapters
  },
}

---@class LangSpec
local M = {
  defaults = defaults,
  plugin_specs = {},
}

---@param o table?
---@return LangSpec
function M:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  self.defaults = defaults
  self.plugin_specs = {}
  return o
end

function M:append(spec)
  table.insert(self.plugin_specs, spec)
  return M
end

function M:prepend(spec)
  table.insert(self.plugin_specs, spec)
  return M
end

---Generate language specific specs
---@param conf LangConfig
---@return LazyPlugin[]
function M:generate(conf)
  ---@type LangConfig
  conf = vim.tbl_deep_extend("force", M.defaults, conf or {})

  local specs = self.plugin_specs

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
  if not vim.tbl_isempty(conf.lsp.nls_sources) and require("utils").has("none-ls.nvim") then
    table.insert(specs, {
      "nvimtools/none-ls.nvim",
      optional = true,
      opts = function(_, opts)
        vim.list_extend(opts.sources, conf.lsp.nls_sources)
      end,
    })
  end

  -- setup formatters
  if not vim.tbl_isempty(conf.formatters) and require("utils").has("conform.nvim") then
    ---@type table<string, conform.FormatterUnit[]>
    local formatters_by_ft = {}

    local ft, _ = next(conf.formatters)
    if type(ft) == "string" then -- conf.formatters is table<string, conform.FormatterUnit[]>
      formatters_by_ft = conf.formatters
    else -- conf.formatters is string[]
      local fts = type(conf.ft) == "string" and { conf.ft } or conf.ft
      ---@cast fts string[]
      for _, f in pairs(fts) do
        formatters_by_ft[f] = conf.formatters
      end
    end

    table.insert(specs, {
      "stevearc/conform.nvim",
      optional = true,
      opts = {
        formatters_by_ft = formatters_by_ft,
      },
    })
  end

  -- setup linters
  if not vim.tbl_isempty(conf.linters) and require("utils").has("nvim-lint") then
    ---@type table<string, conform.FormatterUnit[]>
    local linters_by_ft = {}

    local ft, _ = next(conf.linters)
    if type(ft) == "string" then -- conf.linters is table<string, string[]>
      linters_by_ft = conf.linters
    else -- conf.linters is string[]
      local fts = type(conf.ft) == "string" and { conf.ft } or conf.ft
      ---@cast fts string[]
      for _, f in pairs(fts) do
        linters_by_ft[f] = conf.linters
      end
    end

    table.insert(specs, {
      "mfussenegger/nvim-lint",
      optional = true,
      opts = {
        linters_by_ft = linters_by_ft,
      },
    })
  end

  -- setup DAP
  if not vim.tbl_isempty(conf.dap) then
    for _, item in ipairs(conf.dap) do
      -- install dap adapter plugin
      if not (item[1] == nil or item[1] == "") then
        -- Automatically run `require(MAIN).setup(opts)` with `config = true`
        local spec = { item[1], event = "VeryLazy", config = true }
        if type(item.config) == "function" then
          spec.config = item.config
        end
        if not isempty(conf.ft) then
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
      if not (item[1] == nil or item[1] == "") then
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

  self.plugin_specs = specs

  return specs
end

return M
