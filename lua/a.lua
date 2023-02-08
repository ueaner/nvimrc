if vim.fn.has('nvim-0.8') == 1 then
  -- require('feline').setup()
  -- require('feline').winbar.setup()

  vim.api.nvim_create_autocmd({ "CursorMoved", "BufWinEnter", "BufFilePost" }, {
    callback = function()
      local winbar_filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "neo-tree",
        "Trouble",
        "alpha",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "TelescopePrompt",
        "nerdtree"
      }

      if vim.tbl_contains(winbar_filetype_exclude, vim.bo.filetype) then
        vim.opt_local.winbar = nil
        return
      end

      -- local _, winbar = pcall(require, "winbar")
      -- if not present or type(winbar) == "boolean" then
      --   print("a not present or type(winbar) == \"boolean\"")
      --   print(not present)
      --   print("b not present or type(winbar) == \"boolean\"")
      --   print(type(winbar) == "boolean")
      --   vim.opt_local.winbar = nil
      --   return
      -- end
      -- print(winbar)

      -- local value = winbar.gps()

      -- if value == nil then
      --   value = winbar.filename()
      -- end

      -- vim.opt_local.winbar = value
      -- vim.opt_local.winbar = " %f "
      vim.o.winbar = "%{%v:lua.require'nvim.winbar'.eval()%}"
    end,
  })
  -- print("winbar setup after")
end
