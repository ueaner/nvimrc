local M = {}
M.toggles = {}

-- name -> ToggleItemInterface
--            - Toggle Bindkey  绑定快捷键
--            - Toggle Opened/Closed  状态：打开、关闭
--            - turnedOn       是否已打开

-- :lua require('toggle').list()
function M.list()
  dump(M.toggles)
end

function M.show(name)
  local fn = M.toggles[name]
  dump(fn)
  if not fn then
    -- printf("Warning: toggle could be either %s.", join(keys(toggles), "|"))
    string.format("Warning: toggle could be either %s.", table.concat(M.toggles, '|'))
  end
    fn()
--     if !has_key(toggles, a:name)
--         echo printf("Warning: toggle could be either %s.", join(keys(toggles), "|"))
--         return
--     endif
--
--     " 首字母大写: substitute(a:name, '^.', '\u&', '')
--     echo printf("%s: %s", a:name, strpart("offon", 3 * toggles[a:name], 3))
end

function M.add(name, fn)
  -- bindkey
  M.toggles[name] = fn
end

function M.remove(name)
  M.toggles[name] = nil
end

--         \ 'clipboard': strridx(&clipboard, 'unnamed') > -1,
--         \ 'zoom': exists('t:zoomed') && t:zoomed,
--         \ 'fold': &foldenable,
--         \ 'paste': &paste,
--         \ 'spell': &spell,

--print(vim.o.clipboard)


--str = "tiger"
--if string.find(vim.o.clipboard, "unnamed") then
--  print ("The word tiger was found.")
--else
--  print ("The word tiger was not found.")
--end

local function aaa()
  print("call aaa")
  return vim.fn.exists('t:zoomed') and vim.t.zoomed
end


M.add("clipboard", function () return string.find(vim.o.clipboard, "unnamed") end)
M.add("paste", function () return vim.o.paste end)
--M.add("zoom", function () return vim.fn.exists('t:zoomed') and vim.t.zoomed end)
M.add("zoom", aaa)
M.show("zoom")
--vim.t.zoomed
--M.list()


-- function keys(table)
--   local keyset = {}
--   for k,v in pairs(table) do
--     keyset[#keyset + 1] = k
--   end
--   return keyset
-- end

local a = keys(M.toggles)
print("a 的类型是 ",type(a))

print("toggles: ", table.concat(M.toggles, '|'))

dump(a)


local BB = {}
print("xxxxx", BB.aaaaaa)



-- name -> ToggleItemInterface
--            - Toggle Bindkey  绑定快捷键
--            - Toggle Opened/Closed  状态：打开、关闭
local clipboard = {}
function clipboard.bindkey()
  vim.api.nvim_set_keymap('n', '<leader>c', ':lua clipboard.switch()<CR>', { noremap = true, silent = true })
  -- local result = vim.api.nvim_exec([[
  -- nnoremap <silent> <leader>c :ClipboardToggle<CR>
  -- ]], true)
  -- dump(result)
end
clipboard.bindkey()

function clipboard.opened()
  local result = vim.api.nvim_exec([[
    strridx(&clipboard, 'unnamed') > -1
  ]], true)
  dump(result)
  return result
end

function clipboard.switch()
  local result = vim.api.nvim_exec([[
    if strridx(&clipboard, "unnamed") > -1
        set clipboard-=unnamed
        set clipboard-=unnamedplus
    else
        set clipboard^=unnamed
        set clipboard^=unnamedplus
    endif
  ]], true)
  dump(result)
end


return M
-- " map -> closure
-- " func! my#toggle#list(name) abort
--     " my#toggle#list += xxx
--
-- let my#toggle#list = {}
--
-- func! my#toggle#add(name) abort
-- endfunc
--
--
-- func! my#toggle#show(name) abort
--     " my#toggle#list += xxx
--     :let foo = {'a': 1}
-- :let foo.a = 100
-- :let foo.b = 200
-- :echo foo
--     let toggles = {
--         \ 'clipboard': strridx(&clipboard, 'unnamed') > -1,
--         \ 'zoom': exists('t:zoomed') && t:zoomed,
--         \ 'fold': &foldenable,
--         \ 'paste': &paste,
--         \ 'spell': &spell,
--     \}
--
--     if !has_key(toggles, a:name)
--         echo printf("Warning: toggle could be either %s.", join(keys(toggles), "|"))
--         return
--     endif
--
--     " 首字母大写: substitute(a:name, '^.', '\u&', '')
--     echo printf("%s: %s", a:name, strpart("offon", 3 * toggles[a:name], 3))
-- endfunc
--
-- " Vim 使用系统剪切板开关
-- func s:ClipboardToggle()
--     if strridx(&clipboard, "unnamed") > -1
--         set clipboard-=unnamed
--         set clipboard-=unnamedplus
--     else
--         set clipboard^=unnamed
--         set clipboard^=unnamedplus
--     endif
-- endfunc
-- command! ClipboardToggle call s:ClipboardToggle()
