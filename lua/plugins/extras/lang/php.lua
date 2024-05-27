local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "php",
  parsers = { -- nvim-treesitter: language parsers
    "php",
  },
}

if vim.fn.executable("php") == 1 then
  local UDap = require("util.dap")

  conf = vim.tbl_extend("force", conf, {
    -- NOTE: When the `composer` mirror is not synchronized, it may not match the version in `Mason` and cannot be installed.
    cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
      "phpactor",
      "php-cs-fixer",
      "php-debug-adapter", -- https://github.com/xdebug/vscode-php-debug
    },
    lsp = {
      servers = { -- nvim-lspconfig: setup lspconfig servers
        phpactor = {},
      },
    },
    formatters = { -- conform.nvim
      "php_cs_fixer",
    },
    dap = {
      function()
        local dap = require("dap")
        dap.adapters.php = {
          type = "executable",
          command = vim.env.HOME .. "/.local/share/nvim/mason/bin/php-debug-adapter",
        }

        dap.configurations.php = {
          {
            type = "php",
            request = "launch",
            name = "Launch file (Xdebug)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            port = 9003,
            stopOnEntry = false,
            runtimeArgs = {
              "-dxdebug.start_with_request=yes",
            },
            env = {
              XDEBUG_MODE = "develop,coverage,debug",
              XDEBUG_CONFIG = "idekey=nvim",
            },
          },
          {
            type = "php",
            request = "launch",
            name = "Launch file with arguments (Xdebug)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            port = 9003,
            stopOnEntry = false,
            args = UDap.get_args,
            runtimeArgs = {
              "-dxdebug.start_with_request=yes",
            },
            env = {
              XDEBUG_MODE = "develop,coverage,debug",
              XDEBUG_CONFIG = "idekey=nvim",
            },
          },
        }
      end,
    },
    test = { -- neotest: language specific adapters
      "olimorris/neotest-phpunit",
      adapters = {
        ["neotest-phpunit"] = {
          env = {
            XDEBUG_CONFIG = "idekey=nvim",
          },
          dap = {
            type = "php",
            request = "launch",
            name = "Launch file (Xdebug)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            port = 9003,
            stopOnEntry = false,
          },
        },
      },
    },
  } --[[@as LangConfig]])
end

return generator:generate(conf)
