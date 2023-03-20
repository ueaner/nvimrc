local generate = require("plugins.extras.lang.spec").generate
local nls = require("null-ls")

---@type LangConfig
local conf = {
  parsers = { -- nvim-treesitter: language parsers
    "lua",
  },
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "lua-language-server",
    "stylua",
    -- "selene", -- linter
  },
  lsp = {
    ---@type lspconfig.options
    servers = { -- nvim-lspconfig: setup lspconfig servers
      lua_ls = {
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        settings = {
          Lua = {
            workspace = {
              library = {
                "~/.config/luameta",
                -- Make the server aware of Neovim runtime files
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
              },
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = {
                "vim",
                "require",
              },
            },
          }, -- end Lua
        },
      },
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.stylua,
    },
  },
  test_adapters = { -- neotest: language specific adapter functions
    function()
      return require("neotest-plenary")
    end,
  },
}

local specs = generate(conf)

table.insert(specs, {
  "nvim-neotest/neotest-plenary",
})

table.insert(specs, {
  "jbyuki/one-small-step-for-vimkind",
  ft = "lua",
  init = function()
    -- stylua: ignore start
    vim.keymap.set("n", "<leader>ds", function() require("osv").launch({ port = 8086 }) end, { desc = "Launch Lua Debugger Server" })
    vim.keymap.set("n", "<leader>dd", function() require("osv").run_this() end, { desc = "Launch Lua Debugger" })
    -- stylua: ignore end
  end,
  config = function()
    local dap = require("dap")
    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }
    dap.adapters.nlua = function(callback, config)
      callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
    end
  end,
})

return specs
