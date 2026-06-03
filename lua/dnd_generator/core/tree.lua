local M = {}

local tree_cache = nil
local name_path = require("dnd_generator.init").config.names_dir

local function load_tree(dir_path)
  local tree = {}
  local dir = vim.uv.fs_scandir(dir_path)

  if not dir then
    return tree
  end
  while true do
    local handler_name, handler_type = vim.uv.fs_scandir_next(dir)

    if not handler_name then
      break
    end
    local full_path = dir_path .. "/" .. handler_name
    if handler_type == "directory" then
      tree[handler_name]= {
        name = handler_name,
        type = handler_type,
        path = full_path,
        children = load_tree(full_path)
      }
    elseif handler_type == "file" and handler_name:match("%.txt$") then
      handler_name = handler_name:gsub("%.txt$", "")
    tree[handler_name] = {
      name = handler_name,
      type = handler_type,
      path = full_path
    }
    end

  end
  return tree
end

function M.get_tree()
  if tree_cache == nil then
    tree_cache = load_tree(name_path)
  end
  if tree_cache == nil then
    vim.notify("Error while reading the tree", vim.log.levels.ERROR)
  end
  return tree_cache
end

function M.clear_cache()
  tree_cache = nil
  print("DB: tree cleared")
end

return M
