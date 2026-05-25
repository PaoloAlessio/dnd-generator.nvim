local M = {}

local function table_to_string(table_to_evaluate)
	local evaluated_string = ""
	for _, element in ipairs(table_to_evaluate) do
		evaluated_string = evaluated_string .. element
	end
	return evaluated_string
end

local function tabulate(names)
	local tabulated_names = {}
	local evaluated_strings = {}
	for index, name in ipairs(names) do
		table.insert(tabulated_names, "| ")
		table.insert(tabulated_names, name .. " ")
		if index % 5 == 0 then
			table.insert(tabulated_names, "|")
			table.insert(evaluated_strings, table_to_string(tabulated_names))
			tabulated_names = {}
		end
	end
	if #tabulated_names ~= 0 then
		table.insert(tabulated_names, "|")
		table.insert(evaluated_strings, table_to_string(tabulated_names))
	end
	return evaluated_strings
end

function M.insert_names(names)
	local names_table = tabulate(names)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		vim.api.nvim_buf_set_text(0, row - 1 , col, row -1, col, names_table)
end

function M.insert_npc(NPC_data)
	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(0, row -1, col, row -1, col, NPC_data)
end

return M
