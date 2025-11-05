local lazier = require("util.lazier")

---@type util
_G.U = require("util")
U.config = require("config")

-- keys requires U variable
lazier.lazy_plugin_keymaps(U.config.keys)

-- Install lazy.nvim
lazier.install()
_G.LazyUtil = require("lazy.core.util")

lazier.lazy_notify()
lazier.lazy_file()

-- Configure lazy.nvim
require("lazy").setup({
  concurrency = 10,
  -- sudo dnf install compat-lua-devel compat-lua luarocks
  -- sudo ln -sf /usr/bin/lua-5.1 /usr/bin/lua5.1
  rocks = {
    enabled = true,
    hererocks = false, -- always use luarocks
  },
  spec = {
    -- { "folke/lazy.nvim", version = "10.24.3" },
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
  checker = { enabled = true, concurrency = 10, frequency = 86400 * 7 }, -- automatically check for plugin updates
  ui = {
    size = { width = 0.85, height = 0.8 },
  },
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
