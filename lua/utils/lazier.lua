-- See https://github.com/LazyVim/LazyVim/blob/862e140a7ad8452cd5a103982687fca63a2f44da/lua/lazyvim/config/init.lua
local M = {}
M.lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

-- Add support for the LazyFile event
function M.add_lazy_file_event()
  local Event = require("lazy.core.handler.event")
  local _event = Event._event
  ---@diagnostic disable-next-line: duplicate-set-field
  Event._event = function(self, value)
    return value == "LazyFile" and "User LazyFile" or _event(self, value)
  end
end

-- Properly load file based plugins without blocking the UI
function M.lazy_file()
  local events = {} ---@type {event: string, buf: number, data?: any}[]

  local function load()
    if #events == 0 then
      return
    end
    local Event = require("lazy.core.handler.event")
    local Util = require("lazy.core.util")
    vim.api.nvim_del_augroup_by_name("lazy_file")

    Util.track({ event = "LazyVim.lazy_file" })

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      Event.trigger({
        event = event.event,
        exclude = skips[event.event],
        data = event.data,
        buf = event.buf,
      })
      if vim.bo[event.buf].filetype then
        Event.trigger({
          event = "FileType",
          buf = event.buf,
        })
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
    Util.track()
  end

  -- schedule wrap so that nested autocmds are executed
  -- and the UI can continue rendering without blocking
  load = vim.schedule_wrap(load)

  vim.api.nvim_create_autocmd(M.lazy_file_events, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)
      load()
    end,
  })
end

-- delay notifications till vim.notify was replaced or after 500ms
function M.lazy_notify()
  local notifs = {}
  local function temp(...)
    table.insert(notifs, vim.F.pack_len(...))
  end

  local orig = vim.notify
  vim.notify = temp

  local timer = vim.loop.new_timer()
  local check = assert(vim.loop.new_check())

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

function M.setup()
  M.lazy_notify()

  M.add_lazy_file_event()
  M.lazy_file()
end

return M
