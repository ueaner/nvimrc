-- See https://github.com/LazyVim/LazyVim/blob/965a469ca8cb1d58b49c4e5d8b85430e8c6c0a25/lua/lazyvim/util/init.lua
---@class util.lazier
local M = {}

M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

-- Properly load file based plugins without blocking the UI
function M.lazy_file()
  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  Event.mappings.LazyFile = { id = "LazyFile", event = M.lazy_file_events }
  Event.mappings["User LazyFile"] = Event.mappings.LazyFile
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.uv.new_timer()
  local check = assert(vim.uv.new_check())

  local replay = function()
    timer:stop()
    check:stop()
    if vim.notify == temp then
      vim.notify = orig -- put back the original notify if needed
    end
    vim.schedule(function()
      ---@diagnostic disable-next-line: no-unknown
      for _, notif in ipairs(notifs) do
        vim.notify(vim.F.unpack_len(notif))
      end
    end)
  end

  -- wait till vim.notify has been replaced
  check:start(function()
    if vim.notify ~= temp then
      replay()
    end
  end)
  -- or if it took more than 500ms, then something went wrong
  timer:start(500, 0, replay)
end

---@param keymaps { [string]: LazyKeysSpec[] }
function M.lazy_plugin_keymaps(keymaps)
  -- lazy.nvim v10.24.3
  -- Triggered after LazyPlugins User Event
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyPlugins",
    callback = function()
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
end

function M.install()
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
end

return M
