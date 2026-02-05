local function get_terminal_colors()
  local path = vim.fn.expand("~/.config/alacritty/alacritty.toml")
  local colors = {}
  local file = io.open(path, "r")
  if not file then
    return colors
  end

  local section = ""
  for line in file:lines() do
    -- 匹配区块 [colors.xxx]
    local s = line:match("^%[colors%.(%w+)%]")
    if s then
      section = s
    end

    -- 匹配 key = "#hex"
    local key, hex = line:match("^([%w_]+)%s*=%s*[\"'](#%x+)[\"']")
    if key and hex then
      local prefix = ""
      if section == "bright" then
        prefix = "bright"
      elseif section == "dim" then
        prefix = "dim"
      end

      -- dim_foreground
      local index = string.find(key, "_")
      if index then
        colors[key] = hex
        prefix = string.sub(key, 1, index - 1)
        key = string.sub(key, index + 1)
      end

      -- 生成全小写名称 (如 "blue" "brightblue")
      local name_lower = prefix .. key:lower()
      colors[name_lower] = hex

      -- 生成驼峰式名称 (如 "Blue" "BrightBlue")
      local name_camel = prefix:sub(1, 1):upper() .. prefix:sub(2) .. key:sub(1, 1):upper() .. key:sub(2)
      colors[name_camel] = hex
    end
  end
  file:close()
  return colors
end
vim.g.term_colors = get_terminal_colors()

return {

  -- tokyonight
  {
    "folke/tokyonight.nvim",
    lazy = true,
    ---@module 'tokyonight'
    ---@type tokyonight.Config
    opts = {
      style = "night",
      transparent = false,
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_colors = function(colors)
        local blue = vim.g.term_colors.blue or colors.border_highlight
        local dark = vim.g.term_colors.background or colors.bg_dark
        local black = (vim.g.term_colors.black ~= dark and vim.g.term_colors.black or vim.g.term_colors.dimblack)
          or colors.bg
        colors.bg = dark
        colors.bg_dark = black
        colors.bg_statusline = os.getenv("TMUX") and black or dark
        colors.border_highlight = blue
      end,
      -- on_highlights = function(hl, c)
      --   hl.Normal = {
      --     bg = "#0d1117", -- #07090c
      --   }
      -- end,
    },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      integrations = {
        aerial = true,
        cmp = true,
        dap = {
          enabled = true,
          enable_ui = true, -- enable nvim-dap-ui
        },
        flash = true,
        gitsigns = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        navic = { enabled = true, custom_bg = "lualine" },
        neotest = true,
        neotree = true,
        noice = true,
        notify = true,
        overseer = true,
        semantic_tokens = true,
        telescope = true,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
}
