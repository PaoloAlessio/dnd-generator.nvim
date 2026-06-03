local M = {}

local file_names_list = require("dnd_generator.init").config.names_files

function M.is_valid_file_name(name)
	for index in ipairs(file_names_list) do
		if name == file_names_list[index] then
			return true
		end
	end
	return false
end

function M.get_valid_files()
	return vim.deepcopy(file_names_list)
end

local function has_value(tab, val)
	for _, value in ipairs(tab) do
		if val == value then
			return true
		end
	end

	return false
end

local function load_file(node)
	if node.type ~= "file" then
		vim.notify("ERROR: the file" .. node.path .. "is not a file", vim.log.levels.ERROR)
		return {}
	end
	return vim.fn.readfile(node.path)
end

local function get_names(lines_array, quantity)
	local numbers = {}
	local rand

	for i = 1, quantity do
		repeat
			rand = math.random(#lines_array)
		until not has_value(numbers, rand)

		numbers[i] = rand
	end

	local names = {}

	for i = 1, quantity do
		names[i] = lines_array[numbers[i]]
	end

	return names
end

function M.gen_names(node, quantity)
	if node == nil then
		vim.notify("ERROR a nill value entered name generator", vim.log.levels.ERROR)
		return nil
	end

	local lines_array = load_file(node)
	local names = get_names(lines_array, quantity)
	return names
end

local function random_walk(current_node, NPC_race)
	local children = current_node.children
	local valid_nodes = {}

	for child_name, child_data in pairs(children) do
		if child_data.type == "directory" then
			table.insert(valid_nodes, children[child_name])
		end
	end

	if #valid_nodes == 0 then
		return current_node
	end

	local random_index = math.random(#valid_nodes)
	local nextNode = valid_nodes[random_index]

	table.insert(NPC_race, nextNode.name)
	return random_walk(nextNode, NPC_race)
end

local function rand_node(node, NPC_race, NPC_name_file)
	node = random_walk(node, NPC_race)
	if node.type ~= "directory" then
		vim.notify("ERROR: while generating the data found a non valid node" .. node.path, vim.log.levels.ERROR)
		return
	end

	local children = node.children
	if children == nil or next(children) == nil then
		vim.notify("ERROR: the found folder does not conains files: " .. node.path, vim.log.levels.ERROR)
	end

	if NPC_name_file ~= nil and M.is_valid_file_name(NPC_name_file[1]) then
    local final_node = children[NPC_name_file[1]]
    if final_node ~= nil then
      return final_node
    end
	end

	local valid_files = {}
	for child_name in pairs(children) do
		if M.is_valid_file_name(child_name) then
			table.insert(valid_files, children[child_name])
		end
	end

	if #valid_files ~= 0 then
		local rand_index = math.random(#valid_files)
    NPC_name_file[1] = valid_files[rand_index].name
		return valid_files[rand_index]
	end

	vim.notify("ERROR: not valid files in folder: " .. node.path, vim.log.levels.ERROR)
	return nil
end

function M.gen_npc(node, NPC_race, NPC_names_file)
	if node.type == "directory" then
		node = rand_node(node, NPC_race, NPC_names_file)
	end
  
	if node == nil or node.name == nil then
		vim.notify("ERROR: npc generation failed", vim.log.levels.ERROR)
		return
	end
	local name = M.gen_names(node, 1)[1]
	local races = ""
	for _, race in ipairs(NPC_race) do
		races = races .. " " .. race
	end
	local NPC_strings = {}
	NPC_strings[1] = "# " .. name .. " #npc"
	NPC_strings[2] = "> [!INFO] Dati"
	NPC_strings[3] = "> " .. NPC_names_file[1]
	NPC_strings[4] = "> **Razza:** " .. races
	NPC_strings[5] = "> **Ruolo:** Professione o Ruolo"
	return NPC_strings
end

return M
