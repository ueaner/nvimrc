-- https://github.com/LazyVim/starter/blob/main/lua/config/lazy.lua

-- lazy.nvim v10.21.0
-- Triggered after LazyPlugins User Event
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyPlugins",
  callback = function()
    local keymaps = require("config").keys
    for name, _ in pairs(require("lazy.core.config").spec.plugins) do
      local keys = keymaps[name]
      if keys then
        -- keys for specific filetypes
        if keys.ft then
          local ft = keys.ft
          keys.ft = nil
          if type(ft) == "function" then
            ft = ft()
          end
          for i, mapping in ipairs(keys) do
            keys[i].ft = ft
          end
        end

        require("lazy.core.config").spec.plugins[name].keys = keymaps[name]
      end
    end
  end,
})

-- Install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("util.lazier").setup()

-- Configure lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.coding" },

    { import = "plugins.extras.tools" },

    -- language specific extension modules
    { import = "plugins.extras.lang" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
