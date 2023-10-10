if not require("utils").has("creativenull/efmls-configs-nvim") then
  return {}
end

local generator = require("plugins.extras.langspec"):new()

---@type LangConfig
local conf = {
  cmdtools = { -- mason.nvim: cmdline tools for LSP servers, DAP servers, formatters and linters
    "efm",
  },
  lsp = {
    servers = { -- nvim-lspconfig: setup lspconfig servers
      efm = {
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
          hover = true,
          documentSymbol = true,
          codeAction = true,
          completion = true,
        },
        filetypes = {
          "lua",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "html",
          "css",
          "markdown",
          "markdown.mdx",
          "sh",
          "bash",
          "yaml",
          "php",
          "python",
          "rust",
        },
        settings = {
          rootMarkers = { ".git/" },
          -- stylua: ignore
          languages = {
            lua = { require("efmls-configs.formatters.stylua") },
            javascript = { require("efmls-configs.linters.eslint_d"), require("efmls-configs.formatters.prettier_d") },
            javascriptreact = { require("efmls-configs.linters.eslint_d"), require("efmls-configs.formatters.prettier_d") },
            typescript = { require("efmls-configs.linters.eslint_d"), require("efmls-configs.formatters.prettier_d") },
            typescriptreact = { require("efmls-configs.linters.eslint_d"), require("efmls-configs.formatters.prettier_d") },
            html = { require("efmls-configs.formatters.prettier_d") },
            css = { require("efmls-configs.formatters.prettier_d") },
            markdown = { require("efmls-configs.formatters.prettier_d") },
            ["markdown.mdx"] = { require("efmls-configs.formatters.prettier_d") },
            sh = { require("efmls-configs.formatters.shfmt") },
            bash = { require("efmls-configs.formatters.shfmt") },
            yaml = { require("efmls-configs.linters.yamllint") },
            php = { require("efmls-configs.formatters.php_cs_fixer") },
            python = { require("efmls-configs.formatters.black") },
            rust = { require("efmls-configs.formatters.rustfmt") },
          },
        },
      },
    },
  },
}

return generator:generate(conf)
