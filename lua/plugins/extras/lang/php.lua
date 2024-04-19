local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  ft = "php",
  parsers = { -- nvim-treesitter: language parsers
    "php",
  },
}

if vim.fn.executable("php") == 1 then
  conf = vim.tbl_extend("force", conf, {
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
    test = { -- neotest: language specific adapters
      "olimorris/neotest-phpunit",
      adapters = {
        ["neotest-phpunit"] = {
          env = {
            XDEBUG_CONFIG = "idekey=neotest",
          },
          dap = {
            -- log = true,
            type = "php",
            request = "launch",
            name = "PHPUnit: Listen for Xdebug",
            port = 9003,
            stopOnEntry = false,
            xdebugSettings = {
              max_children = 512,
              max_data = 1024,
              max_depth = 4,
            },
            breakpoints = {
              exception = {
                Notice = false,
                Warning = false,
                Error = false,
                Exception = false,
                ["*"] = false,
              },
            },
          },
        },
      },
    },
  } --[[@as LangConfig]])

  local dap = require("dap")
  dap.adapters.php = {
    type = "executable",
    command = vim.env.HOME .. "/.local/share/nvim/mason/bin/php-debug-adapter",
  }

  dap.configurations.php = {
    {
      type = "php",
      name = "Listen for Xdebug",
      request = "launch",
      program = "${file}",
      cwd = "${workspaceFolder}",
      port = 9003,
      runtimeArgs = {
        "-dxdebug.start_with_request=yes",
      },
      env = {
        XDEBUG_MODE = "debug,develop",
        XDEBUG_CONFIG = "client_port=${port}",
      },
    },
  }
end

return generator:generate(conf)
