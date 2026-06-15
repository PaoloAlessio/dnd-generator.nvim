local M = {}

function M.rolldice(input_string)
	input_string = input_string:lower()

	local qty_str, faces_str, sign, mod_str, adv_dis = input_string:match("^(%d+)d(%d+)([%+%-]?)(%d*)%s*(%a*)")

	if not qty_str or not faces_str then
		vim.notify("ERROR: Must use the following format: 1d20+4 adv", vim.log.levels.ERROR)
		return
	end

	local qty = tonumber(qty_str)
	local faces = tonumber(faces_str)

  if not qty or not faces or qty <= 0 or faces <= 0 then
    vim.notify("ERROR: Invalid numbers", vim.log.levels.ERROR)
    return
  end

  local mod = tonumber(mod_str) or 0

	if sign == "-" then
		mod = -mod
	end

	local function roll_poll()
		local total = 0
		local rolls = {}
		for _ = 1, qty do
			local r = math.random(1, faces)
			table.insert(rolls, r)
			total = total + r
		end
		return total, rolls
	end

	local pool1_total, pool1_rolls = roll_poll()
	local final_total = pool1_total

	local status_msg = ""
	local roll_string = "[ ".. table.concat(pool1_rolls, ", ") .. " ]"

	if adv_dis == "adv" or adv_dis == "dis" then
	  local pool2_total, pool2_rolls = roll_poll()
		if adv_dis == "adv" then
			if pool2_total > pool1_total then
				final_total = pool2_total
			end
			status_msg = "[Advantage]"
		elseif adv_dis == "dis" then
			if pool2_total < pool1_total then
				final_total = pool2_total
			end
			status_msg = "[Disadvantage]"
		end
		roll_string = roll_string .. ", [ " .. table.concat(pool2_rolls, ", ") .. " ]"
	end
	local grand_total = final_total + mod

	local mod_string = ""

	if mod > 0 then
		mod_string = "+" .. mod
	elseif mod < 0 then
		mod_string = "" .. mod
	end

  local output = string.format("Dices: %s %s %s \nTotal: %d", roll_string, status_msg, mod_string, grand_total)
  vim.notify(output, vim.log.levels.INFO, {title= "D&D Roll"})
end

return M
