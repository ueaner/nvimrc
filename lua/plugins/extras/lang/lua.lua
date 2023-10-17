local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "lua",
  parsers = { -- nvim-treesitter: language parsers
    "lua",
    "luadoc",
    "luap",
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
                ---@diagnostic disable: assign-type-mismatch
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
                ---@diagnostic enable: assign-type-mismatch
              },
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
            runtime = {
              version = "LuaJIT",
            },
            type = {
              castNumberToInteger = true,
            },
            diagnostics = {
              globals = {
                "vim",
                "require",
              },
              disable = { "incomplete-signature-doc", "trailing-space" },
              groupSeverity = {
                strong = "Warning",
                strict = "Warning",
              },
              groupFileStatus = {
                ["ambiguity"] = "Opened",
                ["await"] = "Opened",
                ["codestyle"] = "None",
                ["duplicate"] = "Opened",
                ["global"] = "Opened",
                ["luadoc"] = "Opened",
                ["redefined"] = "Opened",
                ["strict"] = "Opened",
                ["strong"] = "Opened",
                ["type-check"] = "Opened",
                ["unbalanced"] = "Opened",
                ["unused"] = "Opened",
              },
            },
            format = { -- EmmyLuaCodeStyle
              enable = false,
            },
            hint = {
              enable = false,
            },
          }, -- end Lua
        },
      },
    },
  },
  formatters = { -- conform.nvim
    "stylua",
  },
  dap = { -- nvim-dap: language specific extensions
    {
      "jbyuki/one-small-step-for-vimkind",
      ---@diagnostic disable: undefined-field, duplicate-set-field
      config = function()
        local dap = require("dap")
        dap.adapters.nlua = function(callback, conf)
          local adapter = {
            type = "server",
            host = conf.host or "127.0.0.1",
            port = conf.port or 8086,
          }
          if conf.start_neovim then
            local dap_run = dap.run
            dap.run = function(c)
              adapter.port = c.port
              adapter.host = c.host
            end
            require("osv").run_this()
            dap.run = dap_run
          end
          callback(adapter)
        end
        dap.configurations.lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Run this file",
            start_neovim = {},
          },
          -- Listening port waiting for client attach:
          -- require("osv").launch({ port = 8086 })
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance (port = 8086)",
            port = 8086,
          },
        }
      end,
      ---@diagnostic enable: undefined-field, duplicate-set-field
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
