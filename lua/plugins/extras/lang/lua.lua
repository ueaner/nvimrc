local generator = require("plugins.extras.langspecs"):new()
local nls = require("null-ls")

---@type LangConfig
local conf = {
  ft = "lua",
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
          -- https://github.com/LuaLS/lua-language-server/blob/master/doc/zh-cn/config.md
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
              disable = {
                "missing-fields",
              },
            },
            hint = {
              enable = true,
            },
          }, -- end Lua
        },
      },
    },
    nls_sources = { -- null-ls.nvim: builtins formatters, diagnostics, code_actions
      nls.builtins.formatting.stylua,
    },
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "jbyuki/one-small-step-for-vimkind",
      -- stylua: ignore
      on_ft = function(event)
        vim.keymap.set("n", "<leader>ds", function() require("osv").launch({ port = 8086 }) end, { desc = "Launch Lua Debugger Server", buffer = event.buf })
        vim.keymap.set("n", "<leader>dd", function() require("osv").run_this() end, { desc = "Launch Lua Debugger", buffer = event.buf })
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
    },
  },
  test = { -- neotest: language specific adapters
    {
      "nvim-neotest/neotest-plenary",
      adapter_fn = function()
        return require("neotest-plenary")
      end,
    },
  },
}

return generator:generate(conf)
