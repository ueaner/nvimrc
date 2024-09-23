return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    opts = function(_, opts)
      local config = require("fzf-lua.config")
      local actions = require("fzf-lua.actions")

      -- Quickfix
      config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
      config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
      config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
      config.defaults.keymap.fzf["ctrl-x"] = "jump"
      config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
      config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
      config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
      config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

      -- Trouble
      if U.has("trouble.nvim") then
        config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
      end

      -- use the same prompt for all
      local defaults = require("fzf-lua.profiles.default-title")
      local function fix(t)
        t.prompt = t.prompt ~= nil and " " or nil
        for _, v in pairs(t) do
          if type(v) == "table" then
            fix(v)
          end
        end
      end
      fix(defaults)

      local img_previewer ---@type string[]?
      for _, v in ipairs({
        { cmd = "ueberzug", args = {} },
        { cmd = "chafa", args = { "{file}", "--format=symbols" } },
        { cmd = "viu", args = { "-b" } },
      }) do
        if vim.fn.executable(v.cmd) == 1 then
          img_previewer = vim.list_extend({ v.cmd }, v.args)
          break
        end
      end

      return vim.tbl_deep_extend("force", defaults, {
        -- stylua: ignore
        -- https://github.com/ueaner/dotfiles/blob/main/.config/zsh/rc.d/90-fzf.zsh
        fzf_colors = {
          ["fg"]      = { "fg", "CursorLine" },
          ["bg"]      = { "bg", "Normal" },
          ["hl"]      = { "fg", "Search" },
          ["fg+"]     = { "fg", "Normal" },
          ["bg+"]     = { "bg", "CursorLine" },
          ["hl+"]     = { "fg", "Statement" },
          ["info"]    = { "fg", "PreProc" },
          ["prompt"]  = { "fg", "Conditional" },
          ["pointer"] = { "fg", "Exception" },
          ["marker"]  = { "fg", "Keyword" },
          ["spinner"] = { "fg", "Label" },
          ["header"]  = { "fg", "Comment" },
          ["gutter"]  = "-1",
        },
        fzf_opts = {
          ["--no-scrollbar"] = true,
        },
        defaults = {
          -- formatter = "path.filename_first",
          formatter = "path.dirname_first",
        },
        previewers = {
          builtin = {
            extensions = {
              ["png"] = img_previewer,
              ["jpg"] = img_previewer,
              ["jpeg"] = img_previewer,
              ["gif"] = img_previewer,
              ["webp"] = img_previewer,
            },
            ueberzug_scaler = "fit_contain",
          },
        },
        winopts = {
          width = 0.90,
          height = 0.90,
          row = 0.5,
          col = 0.5,
          preview = {
            scrollchars = { "┃", "" },
          },
        },
        files = {
          cwd_prompt = false,
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        grep = {
          actions = {
            ["alt-i"] = { actions.toggle_ignore },
            ["alt-h"] = { actions.toggle_hidden },
          },
        },
        lsp = {
          symbols = {
            symbol_hl = function(s)
              return "TroubleIcon" .. s
            end,
            symbol_fmt = function(s)
              return s:lower() .. "\t"
            end,
            child_prefix = false,
          },
          code_actions = {
            previewer = vim.fn.executable("delta") == 1 and "codeaction_native" or nil,
          },
        },
      })
    end,
    config = function(_, opts)
      require("fzf-lua").setup(opts)
    end,
  },
}
