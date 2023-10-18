-- REPL
return {
  "ueaner/iron.nvim",
  config = function()
    local iron = require("iron.core")
    local supported_filetypes = { "go", "python", "lua", "typescript", "javascript", "php", "sh", "zsh", "rust" }

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

      -- keymaps = {
      --   send_motion = "<leader>rr", -- code block
      --   visual_send = "<leader>rr", -- selected code block
      --   send_line = "<leader>rl", -- cursor line
      --   send_file = "<leader>rf", -- file
      --   cr = "<leader>r<cr>", -- return
      --   interrupt = "<leader>rc", -- <c-c>
      --   exit = "<leader>rq", -- terminate
      --   clear = "<leader>rx", -- clear
      -- },
    })

    -- stylua: ignore
    -- https://github.com/Vigemus/iron.nvim/blob/master/lua/iron/fts/init.lua
    require("utils").on_ft(supported_filetypes, function(event)
      vim.keymap.set("n", "<leader>rr", function() iron.run_motion("send_motion") end, { desc = "Run code block", buffer = event.buf })
      vim.keymap.set("v", "<leader>rr", iron.visual_send, { desc = "Run selected code block", buffer = event.buf })
      vim.keymap.set("n", "<leader>rl", iron.send_line, { desc = "Run cursor line", buffer = event.buf })
      vim.keymap.set("n", "<leader>rf", iron.send_file, { desc = "Run file", buffer = event.buf })
      vim.keymap.set("n", "<leader>r<cr>", function() iron.send(nil, string.char(13)) end, { desc = "Return", buffer = event.buf })
      vim.keymap.set("n", "<leader>rc", function() iron.send(nil, string.char(03)) end, { desc = "Interrupt (<C-c>)", buffer = event.buf })
      vim.keymap.set("n", "<leader>rq", iron.close_repl, { desc = "Quit", buffer = event.buf })
      vim.keymap.set("n", "<leader>rx", function() iron.send(nil, string.char(12)) end, { desc = "Clear", buffer = event.buf })

      -- see :h iron-commands for all available commands
      vim.keymap.set("n", "<leader>ru", "<cmd>IronRepl<cr>", { desc = "Repl UI Toggle", buffer = event.buf })
      vim.keymap.set("n", "<leader>rR", "<cmd>IronRestart<cr>", { desc = "Repl Restart", buffer = event.buf })
      vim.keymap.set("n", "<leader>rF", "<cmd>IronFocus<cr>", { desc = "Repl Focus", buffer = event.buf })
    end)
  end,
}
