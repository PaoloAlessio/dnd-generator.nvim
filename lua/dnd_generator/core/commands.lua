local M = {}
local tree = require("dnd_generator.core.tree")
local generator = require("dnd_generator.core.generator")
local insert_in_buffer = require("dnd_generator.core.insert_in_buffer")
local valid_DNDFind = {"magicitems", "weapons", "armor", "feats", "spells", "monsters", "sections", "conditions"}

function M.valid_DNDFind()
  return vim.deepcopy(valid_DNDFind)
end

function M.clear_cache()

  local cache_dir = require("dnd_generator").config.cache_dir

  if vim.fn.isdirectory(cache_dir) == 1 then
    vim.fn.delete(cache_dir, "rf")
    vim.mkdir(cache_dir, "p")
    vim.notify("DnD Generator Cache emptied succesfully", vim.log.levels.INFO)
  else
    vim.notify("Cache directory not fount", vim.log.levels.WARN)
  end
end

function M.is_valid_DNDFind(element)
  for _, valid in ipairs(valid_DNDFind) do
    if valid == element then
      return true
    end
  end
  return false
end

local function get_options(dir)
  local options = {}
  for key_name in pairs(dir) do
    table.insert(options, key_name)
  end
  return options
end


local function traverse_tree_for_options(depth,arguments, dir)
  if depth > #arguments then
    return get_options(dir)
  end
  local node = dir[arguments[depth]]
  if node == nil then
    return {}
  end
  if node.children == nil then
    return {}
  end
  if depth < #arguments then
    return traverse_tree_for_options(depth+1,arguments, node.children)
  end
  return get_options(node.children)
end

function M.cmd_complete_handler(ArgLead, CmdLine)
  local arguments = vim.split(CmdLine, "%s+", {trimempty = true})
  local suggestions = {}
  local valid_filters = generator.get_valid_files()
  local use_filters = false
  local has_filters = false
  if arguments[1] == "GenNPC" then
    use_filters = true
  end
  table.remove(arguments,1)
  if ArgLead ~= "" then
    table.remove(arguments)
  end
  if #arguments > 0 and use_filters then
    for _, filter in ipairs(valid_filters) do
      if arguments[1] == filter then
        has_filters = true
        break
      end
    end
    if has_filters then 
      table.remove(arguments,1)
    end
  end

  if use_filters and #arguments == 0 and not has_filters then
    for _, filter in ipairs(valid_filters) do
      table.insert(suggestions, filter)
    end
  end

  local tree_suggestions = traverse_tree_for_options(1, arguments, tree.get_tree())
  for _, opt in ipairs(tree_suggestions) do
    table.insert(suggestions, opt)
  end

  if #suggestions == 0 then
    return {}
  end
  return vim.tbl_filter(function(item)
    return vim.startswith(item:lower(), ArgLead:lower())
  end,suggestions)
end

local function get_quantity(args)
  local last_arg = args[#args]
  local quantity = tonumber(last_arg)

  if quantity ~= nil then
    table.remove(args)
  else
    quantity = 1
  end
  if quantity < 0 or quantity > 50 or math.floor(quantity) ~= quantity then
      quantity = 1
  end
  return quantity
end
function M.run_gen_name(opts)
  local args = opts
  local quantity = get_quantity(args)
  local node=tree.get_tree()

  for i = 1, #args do
    if node[args[i]] ~= nil then
      if node[args[i]].type == "directory" then
        node = node[args[i]].children
      elseif node[args[i]].type == "file" then
        node = node[args[i]]
        if i ~= #args then
          vim.notify("ERROR: too many arguments", vim.log.levels.ERROR)
          return
        end
        break
      end
    else
      vim.notify("ERROR: path not found", vim.log.levels.ERROR)
      return
    end
  end

  if node.type ~= "file" then
    vim.notify("ERROR: must specify a valid file", vim.log.levels.ERROR)
    return
  end
  local names = generator.gen_names(node, quantity)
  if names ~= nil then
    insert_in_buffer.insert_names(names)
  end
  
end

function M.run_gen_npcs(opts)
  local args = opts
  local NPC_race = {}
  local NPC_file_name = {}
  local current_node = {
    name = "root",
    type = "directory",
    children = tree.get_tree()
  }
  for i = 1, #args do
    if generator.is_valid_file_name(args[i]) and i == 1 then
      table.insert(NPC_file_name, 1, args[i])
    elseif current_node.children ~= nil and current_node.children[args[i]] ~=  nil then
      current_node = current_node.children[args[i]]

      if current_node.type == "directory" then
        table.insert(NPC_race, current_node.name)

      elseif current_node.type == "file" then

        if i ~= #args then
          vim.notify("ERROR: not valid arguments: use TAB to see correct arguments", vim.log.levels.ERROR)
          return
        end

        if NPC_file_name[1] ~= nil then
          vim.notify("ERROR: the file from where to select a name has been specified multiple times", vim.log.levels.ERROR)
          return
        end
        
        if generator.is_valid_file_name(current_node.name) then
          NPC_file_name[1] = current_node.name
        else
          vim.notify("ERROR: the specified file is not valid for an NPC name", vim.log.levels.ERROR)
          return
        end
        break

      end
    else
      vim.notify("ERROR: not valid arguments: use TAB to see correct arguments", vim.log.levels.ERROR)
      break
    end
  end
  local npc_generated = generator.gen_npc(current_node, NPC_race, NPC_file_name)
  insert_in_buffer.insert_npc(npc_generated)
end

return M
