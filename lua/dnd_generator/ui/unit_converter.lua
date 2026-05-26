local dnd = require("dnd_generator")

local M = {}

function M.text(text)
  if not text then
    return ""
  end


  local unit = dnd.config.unit
  if unit == "ft" then
    return text
  end

  local function round(numb)
    return math.floor(numb*2+0.5)/2
  end

  local converted_text = string.gsub(text, "(%d+)%s*([a-zA-Z%.]+)", function(num, u)
    if u == "ft" or u == "ft." or u == "feet" then
      local metres = round(tonumber(num)*0.3)
      if unit == "m" then
        return metres .. "m"
      elseif unit == "ft/m" then
        return num .. " " .. u .. " (" .. metres .. " m)"
      end
    end
  end)
  return converted_text
end

return M
