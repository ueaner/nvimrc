-- :
function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
end

function _G.keys(table)
  local keyset = {}
  for k,v in pairs(table) do
    keyset[#keyset + 1] = k
  end
  return keyset
end

-- dump(vim.fn.stdpath('cache'))
-- dump(vim.fn.stdpath('config'))
-- dump(vim.fn.stdpath('config_dirs'))
-- dump(vim.fn.stdpath('data'))
-- dump(vim.fn.stdpath('data_dirs'))

-- "~/.cache/nvim"
-- "~/.config/nvim"
-- { "/etc/xdg/nvim" }
-- "~/.local/share/nvim"
-- { "/usr/local/share/nvim", "/usr/share/nvim" }


-- cache        String  Cache directory. Arbitrary temporary
--                      storage for plugins, etc.
-- config       String  User configuration directory. The
--                      |init.vim| is stored here.
-- config_dirs  List    Additional configuration directories.
-- data         String  User data directory. The |shada-file|
--                      is stored here.
-- data_dirs    List    Additional data directories.
