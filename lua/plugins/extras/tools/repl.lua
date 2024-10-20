-- REPL
return {
  "Vigemus/iron.nvim",
  -- https://github.com/Vigemus/iron.nvim/blob/master/lua/iron/fts/init.lua
  ft = { "go", "python", "lua", "typescript", "javascript", "php", "sh", "zsh", "rust" },
  cmd = { "IronRepl", "IronRestart", "IronFocus" },
  config = function()
    local iron = require("iron.core")

    iron.setup({
      config = {
        highlight_last = false,
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        repl_definition = {
          -- pip install ipython
          python = require("iron.fts.python").ipython,
          -- go install github.com/traefik/yaegi/cmd/yaegi@latest
          go = { command = { "yaegi" } },
          -- pnpm install -g tsx
          typescript = { command = { "tsx" } },
          -- cargo install evcxr_repl
          -- NOTE: switch to the repl window and press Enter
          rust = { command = { "evcxr", "--ide-mode" } },
        },
        repl_open_cmd = require("iron.view").right(60),
      },
    })
  end,
}
