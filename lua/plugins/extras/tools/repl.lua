-- https://github.com/Vigemus/iron.nvim/blob/master/lua/iron/fts/init.lua
local supported_filetypes = { "go", "python", "lua", "typescript", "javascript", "php", "sh", "zsh", "rust" }

-- REPL
return {
  "ueaner/iron.nvim",
  ft = supported_filetypes,
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
          rust = { command = { "evcxr" } },
        },
        repl_open_cmd = require("iron.view").right(60),
      },
    })
  end,
  -- stylua: ignore
  keys = {
    { "<leader>rr", function() require("iron.core").run_motion("send_motion") end, desc = "Run code block", ft = supported_filetypes },
    { "<leader>rr", function() require("iron.core").visual_send() end, desc = "Run selected code block", mode = { "v" }, ft = supported_filetypes },
    { "<leader>rl", function() require("iron.core").send_line() end, desc = "Run cursor line", ft = supported_filetypes },
    { "<leader>rf", function() require("iron.core").send_file() end, desc = "Run file", ft = supported_filetypes },
    { "<leader>r<rc>", function() require("iron.core").send(nil, string.char(13)) end, desc = "Return", ft = supported_filetypes },
    { "<leader>rc", function() require("iron.core").send(nil, string.char(03)) end, desc = "Interrupt (<C-c>)", ft = supported_filetypes },
    { "<leader>rq", function() require("iron.core").close_repl() end, desc = "Quit", ft = supported_filetypes },
    { "<leader>rx", function() require("iron.core").send(nil, string.char(12)) end, desc = "Clear", ft = supported_filetypes },

    ---@see iron-commands for all available commands
    -- NOTE: There needs to be a mapping for all file types so that the default +prefix does not appear in whichkey
    { "<leader>ru", "<cmd>IronRepl<cr>", desc = "Repl UI Toggle", mode = { "n", "v" } },
    -- { "<leader>ru", "<cmd>IronRepl<cr>", desc = "Repl UI Toggle", ft = supported_filetypes },
    { "<leader>rR", "<cmd>IronRestart<cr>", desc = "Repl Restart", ft = supported_filetypes },
    { "<leader>rF", "<cmd>IronFocus<cr>", desc = "Repl Focus", ft = supported_filetypes },
  },
}
