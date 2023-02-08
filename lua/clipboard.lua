local M = {}

-- :lua require('clipboard').toggle()
function M.toggle(msg)
    print("")
end

-- turned on, 是否已打开，
function M.v(msg)
  vim.fn['health#report_info'](msg)
end

function M.report_ok(msg)
  vim.fn['health#report_ok'](msg)
end

function M.report_warn(msg, ...)
  vim.fn['health#report_warn'](msg, ...)
end

function M.report_error(msg, ...)
  vim.fn['health#report_error'](msg, ...)
end

return M
