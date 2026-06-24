# Agent Guide for `ueaner/nvimrc`

This is a personal Neovim configuration (not a plugin), heavily inspired by [LazyVim](https://github.com/LazyVim/LazyVim), managed with [lazy.nvim](https://github.com/folke/lazy.nvim). It targets Neovim nightly/latest.

## Project Type and Architecture

- **Language**: Lua (with a small amount of Vimscript in `plugin/` and `ftdetect/`).
- **Plugin manager**: `lazy.nvim`, bootstrapped in `lua/config/lazy.lua`.
- **Structure**:
  - `init.lua`: Entry point. Loads `config.options`, `config.lazy`, sets colorscheme, and defers `config.autocmds` + `config.keymaps` until `VeryLazy` when no files are opened.
  - `lua/config/`: Core config (options, autocmds, keymaps, lazy bootstrap, shared icons).
  - `lua/plugins/`: lazy.nvim plugin specs. Top-level files plus subdirectories `ui/`, `editor/`, `coding/` and `extras/` are imported via `lazy.setup({ import = "plugins" }, ...)`.
  - `lua/util/`: Shared utility modules exposed through a single global `_G.U`.
  - `ftdetect/`, `plugin/`, `queries/`: Standard Vim runtime directories.

## Essential Commands

- **Run / test config**: `nvim` (normal start), `nvim --headless +qa` (sanity check for startup errors), and `find lua -name '*.lua' -print0 | xargs -0 -n1 luac -p` (Lua syntax check).
- **Check health**: `:checkhealth` inside Neovim; use `:checkhealth nvim-treesitter` for Tree-sitter-specific validation.
- **Format Lua**: `stylua .` (uses `stylua.toml`; stylua itself may need to be installed separately — it is referenced as the Lua formatter but is not guaranteed to be on `$PATH` or in Mason here).
- **Inspect plugin state**: `:Lazy`, `:Mason`, `:LspInfo`, `:ConformInfo`, completion status commands when provided by the active completion plugin, and `:TSStatus`.
- **Tree-sitter maintenance**: `:Lazy update nvim-treesitter treesitter-parser-registry`, `:TSCacheClear`, and `:TSUpdate!`.
- **No Makefile / package.json / CI**: This is a dotfile-style repo. There are no automated test suites; correctness is validated by starting Neovim and running `:checkhealth`.

## Code Organization and Conventions

### The `_G.U` utility namespace

`lua/config/lazy.lua` sets:

```lua
_G.U = require("util")
U.config = require("config")
```

`lua/util/init.lua` uses a metatable so that `U.foo` lazily loads `lua/util/foo.lua`. Always use `U` (e.g. `U.root()`, `U.format()`, `U.has("plugin")`) rather than requiring util submodules directly unless you specifically need only that module.

Important submodules:

- `U.config` → `lua/config/init.lua`: shared icons, `close_with_q` / `close_with_esc` lists, kind filters, sidebar/panel widths, keymap table.
- `U.root` → `lua/util/root.lua`: project root detection (`lsp` → `.git`/`lua` → `cwd`).
- `U.format` → `lua/util/format.lua`: formatter registry with priority, used by `BufWritePre` autocmd.
- `U.lsp` → `lua/util/lsp.lua`: LSP keymap helper and `formatter()`.
- `U.lazier` → `lua/util/lazier.lua`: lazy.nvim helpers.

### Plugin specs

Plugin files return a list of lazy.nvim specs. Important patterns:

- `lua/plugins/ui/`, `lua/plugins/editor/`, `lua/plugins/coding/`, and `lua/plugins/extras/` are directories imported recursively by lazy.nvim because `lazy.setup` imports `plugins`, `plugins.ui`, `plugins.editor`, `plugins.coding`, `plugins.extras.tools`, and `plugins.extras.lang`.
- The top-level README file tree may lag behind the actual layout: `ui.lua`, `editor.lua`, and `coding.lua` have been split into `ui/`, `editor/`, and `coding/` directories.
- Many specs rely on `Snacks` from `folke/snacks.nvim` (e.g. `Snacks.keymap.set`, `Snacks.rename.on_rename_file`). `snacks.nvim` is loaded eagerly in `lazy.lua`.
- `LazyUtil` is a global alias for `lazy.core.util`, set in `lua/config/lazy.lua`.

### Language-specific configuration (`LangSpec`)

`lua/plugins/extras/langspec.lua` defines a `LangSpec` builder. Language files (e.g. `lua/plugins/extras/lang/go.lua`) do this:

```lua
local generator = require("plugins.extras.langspec"):new()
local conf = {
  ft = { "go" },
  parsers = { "go" },
  cmdtools = { "gopls", "gofumpt", ... },
  lsp = { servers = { gopls = { ... } } },
  formatters = { "gofumpt" },      -- string[] or table<string, conform.FormatterUnit[]>
  linters = { ... },               -- string[] or table<string, string[]>
  dap = { { "leoluz/nvim-dap-go" } },
  test = { "nvim-neotest/neotest-go", adapters = { ... } },
}
return generator:generate(conf)
```

`generate()` produces lazy.nvim specs that extend `nvim-treesitter`, `mason.nvim`, `nvim-lspconfig`, `conform.nvim`, `nvim-lint`, `nvim-dap`, and `neotest`. Prefer this generator when adding a new language.

Note: the generator does not automatically check host runtimes. Existing language modules often guard `cmdtools` and related LSP/DAP/test setup behind runtime checks (e.g. `if vim.fn.executable("go") == 1`) so Mason does not install tools for languages unavailable on the host.

### Keymaps

- Leader is `,` (`vim.g.mapleader = ","`).
- Plugin-specific keymaps are centralized in `lua/config/keymaps/keys.lua` as a table keyed by plugin name, e.g. `keys["nvim-dap"] = { ... }`.
- `U.lazier.lazy_plugin_keymaps(U.config.keys)` attaches these keys to the matching lazy.nvim plugin specs on the `LazyPlugins` autocmd. This lets keymaps live in one file while still being lazy-loaded with their plugin.
- Some keymaps use `has = "declaration"` or `has = "codeAction"` to enable only when the LSP server advertises that method; these are resolved by `U.lsp.set_keymaps`.
- General/editing keymaps are in `lua/config/keymaps/` (loaded by `init.lua`).
- Use `U.safe_keymap_set(mode, lhs, rhs, opts)` instead of `vim.keymap.set` when you want to avoid shadowing a lazy.nvim keys handler.

### Autocommands and custom events

- `LazyFile`: defined in `lua/util/lazier.lua` as `{ "BufReadPost", "BufNewFile", "BufWritePre" }`. Plugins use `event = "LazyFile"` to load on file open without blocking UI.
- `VeryLazy`: standard lazy.nvim event. `config.autocmds` and `config.keymaps` are loaded on `VeryLazy` when Neovim starts with no file argument.
- `lazy_notify()` delays/replays early `vim.notify` calls until a real notifier is installed.

### Formatting

- `U.format` is a registry of `LazyFormatter` objects.
- `lua/plugins/formatting.lua` registers `conform.nvim` as the primary formatter.
- `lua/plugins/lsp.lua` registers the LSP formatter with lower priority as fallback.
- `vim.g.autoformat = true` enables auto-format on `BufWritePre`.
- `:LazyFormat` formats manually; `:LazyFormatInfo` shows active formatters.
- `stylua` is configured as the Lua formatter in `stylua.toml` (2 spaces, 120 column width).

### LSP

- Uses Neovim's built-in `vim.lsp.config()` / `vim.lsp.enable()` (Neovim 0.11+) rather than `lspconfig.setup`.
- `lua/plugins/lsp.lua` sets `vim.lsp.config("*", opts.servers["*"])` for defaults and configures per-server entries.
- Mason installs servers; `mason-lspconfig` mapping is used to decide which servers to auto-configure.
- Inlay hints are enabled globally (`opts.inlay_hints.enabled = true`) except for `vue`.
- `inc-rename.nvim` provides the `:Rename` command.

### Treesitter

- Uses `neovim-treesitter/nvim-treesitter` on the `main` branch with the new API (`require("nvim-treesitter").setup()`, `.install()`).
- Requires `neovim-treesitter/treesitter-parser-registry`. The registry is loaded from that plugin's local `registry.json`; update it with the plugin manager, not with `:TSUpdate`.
- Parser/query version checks are cached in `~/.local/share/nvim/site/registry/registry-cache.lua` for 24 hours. Use `:TSCacheClear` or `:TSUpdate!` when forcing version refreshes; `:TSRegistryUpdate` is documented upstream but is not implemented by the currently installed plugin code.
- Installed parser metadata lives under `~/.local/share/nvim/site/parser-info/`; compiled parsers and downloaded queries live under `~/.local/share/nvim/site/parser/` and `~/.local/share/nvim/site/queries/`.
- Features are enabled manually on `FileType`: `vim.treesitter.start()` for highlighting and `require("nvim-treesitter").indentexpr()` for indentation.
- `ftdetect/detect.vim` sets custom filetypes (`*.service` → `systemd`, `go.mod` → `go.mod`, etc.).
- Custom Tree-sitter queries live in `queries/`.

## Style and Formatting

- `stylua.toml`: spaces (not tabs), indent width 2, column width 120.
- Use `-- stylua: ignore` or `-- stylua: ignore start` / `-- stylua: ignore end` to preserve intentional formatting.
- Keep plugin specs declarative; put logic in `config` / `init` / `opts` functions.
- Prefer `vim.api.nvim_create_autocmd` with an `augroup` over legacy `augroup`/`autocmd!` Vimscript.

## Important Gotchas

1. **Expected LSP warnings**: `lua-language-server` reports hundreds of "Undefined global `vim`" / `Snacks` / `LazyUtil` warnings. This is normal here; diagnostics for `vim` are intentionally disabled in the LuaLS settings (`Lua.diagnostics.enable = false`), and globals like `U`, `Snacks`, `LazyUtil` are provided at runtime via `lazydev.nvim` / `_G`. Do not "fix" these by adding globals everywhere.

2. **Do not use `lspconfig.setup`**: Server configuration is done through `opts.servers` in plugin specs and applied via `vim.lsp.config()`.

3. **Lazy loading keymaps**: If you add keymaps for a plugin in `lua/config/keymaps/keys.lua`, the plugin name in the table key must exactly match the lazy.nvim plugin spec name (e.g. `"nvim-dap"`, not `"dap"`). Otherwise the keys won't be attached and the keymap will silently not lazy-load.

4. **Adding a new language**: Use `lua/plugins/extras/lang/example.lua` as a template and the `LangSpec` generator. Do not manually create separate specs for treesitter/mason/lsp/conform/lint unless the generator cannot express what you need.

5. **Mason tool availability**: Language modules guard `cmdtools` behind host executable checks. Adding a tool to `cmdtools` does not guarantee it installs if the language runtime is missing.

6. **Global state**: `_G.dump`, `_G.is_debug`, `_G.U`, `_G.LazyUtil`, and the `Snacks` global are intentionally set. Avoid shadowing them.

7. **No tests**: There are no unit tests. Validate changes by starting Neovim, opening a relevant filetype, and exercising the feature (`:LspInfo`, `:LazyFormat`, `:Neotest`, etc.).

8. **External tool proxy**: `lua/plugins/lsp.lua` still supports `GITHUB_PROXY` for Mason/LSP server downloads. Tree-sitter parser/query downloads no longer use the old `GITHUB_PROXY` parser URL patch; configure `HTTPS_PROXY`, `ALL_PROXY`, curl, or Git proxy settings instead.

## When Modifying Code

- Read the matching LazyVim source URL in comments when present; many modules are derived from LazyVim's implementation.
- If adding a new utility, expose it through `lua/util/init.lua` so it is reachable as `U.<name>`.
- If adding a new plugin, consider whether its keys belong in `lua/config/keymaps/keys.lua` (for lazy attachment) or directly in the spec.
- Run `stylua .` before finishing if stylua is available.
