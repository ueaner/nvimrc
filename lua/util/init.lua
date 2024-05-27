-- ~/.config/nvim/lua/util.lua

local M = {}

M.root_patterns = { ".git", "lua" }

-- Create a FileType autocommand event handler.
-- Examples:
-- ```lua
--    require("util").on_ft("go", function(event)
--      vim.keymap.set("n", "<leader>dt", function()
--        require("dap-go").debug_test()
--      end, { desc = "debug test", buffer = event.buf })
--    end, "daptest")
-- ```
--- @param ft string|string[]
--- @param cb function|string
--- @param group? string
M.on_ft = function(ft, cb, group)
  local opts = { pattern = ft, callback = cb }
  if not (group == nil or group == "") then
    opts["group"] = group
    vim.api.nvim_create_augroup(opts["group"], { clear = false })
  end
  vim.api.nvim_create_autocmd("FileType", opts)
end

--- Gets the highlight `fg` or `bg` color by name.
---@param group string Highlight group name
---@param attr "fg"|"bg"
M.hl_color = function(group, attr)
  -- neovim 0.9.0+: vim.api.nvim_get_hl()
  local hl = vim.api.nvim_get_hl(0, { name = group })
  if not hl or not hl[attr] then
    return
  end
  return string.format("#%06x", hl[attr])
end

function M.fg(name)
  return M.hl_color(name, "fg")
end

function M.bg(name)
  return M.hl_color(name, "bg")
end

-- Opens a floating terminal (interactive by default)
---@param cmd? string[]|string
---@param opts? LazyTermOpts
function M.terminal(cmd, opts)
  return require("util.terminal").open(cmd, opts)
end

-- returns the root directory based on:
-- * lsp workspace folders
-- * lsp root_dir
-- * root pattern of filename of the current buffer
-- * root pattern of cwd
---@param opts? {git?:boolean}
---@return string
function M.root(opts)
  if opts and opts.git then
    return require("util.root").git()
  end
  return require("util.root").get()
end

---@param plugin string
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

---@class util.telescope.opts
---@field cwd? string|boolean
---@field show_untracked? boolean

-- this will return a function that calls telescope.
-- cwd will default to util.get_root
-- for `files`, git_files or find_files will be chosen depending on .git
---@param builtin string
---@param opts? util.telescope.opts
function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = require("util.root").get() }, opts or {}) --[[@as util.telescope.opts]]
    if builtin == "files" then
      if vim.uv.fs_stat((opts.cwd or vim.uv.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.uv.cwd() then
      ---@diagnostic disable-next-line: inject-field
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end

    require("telescope.builtin")[builtin](opts)
  end
end

function M.is_loaded(name)
  local Config = require("lazy.core.config")
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

---@generic T
---@param list T[]
---@return T[]
function M.dedup(list)
  local ret = {}
  local seen = {}
  for _, v in ipairs(list) do
    if not seen[v] then
      table.insert(ret, v)
      seen[v] = true
    end
  end
  return ret
end

-- M.dump = function(...)
--   local objects = vim.tbl_map(vim.inspect, { ... })
--   print(unpack(objects))
-- end

return M
