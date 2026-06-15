local M = {}

local config = require("dnd_generator").config
local homebrew_dir = config.homebrew_dir

local function load_homebrew_files(folder)
  local path = vim.fs.joinpath(homebrew_dir, folder)
  vim.fn.mkdir(path, "p")
  local results = {}

local json_files = vim.fn.glob(path .. "/*.json", false, true)
  for _, file in ipairs(json_files) do
    local content = table.concat(vim.fn.readfile(file), "\n")
    local ok, data = pcall(vim.json.decode, content)

    if ok and type(data) == "table" then
      if data.name then
        data.is_homebrew = true
        table.insert(results, data)
      else
        for _, item in ipairs(data) do
          item.is_homebrew = true
          table.insert(results, item)
        end
      end
    else
      vim.notify("DND Generator (HomeBrew) : Error in JSON file '" .. file .. "'", vim.log.levels.WARN)
    end
  end

  if not config.lua_homebrew then
    return results
  end

local lua_files = vim.fn.glob(path .. "/*.lua", false, true)

  for _, file in ipairs(lua_files) do
    local ok, data = pcall(dofile, file)

    if ok and type(data) == "table" then
      if data.name then
        data.is_homebrew = true
        table.insert(results, data)
      else
        for _, item in ipairs(data) do
          item.is_homebrew = true
          table.insert(results, item)
        end
      end
    else
      -- Estrae solo il nome del file (es: "boss.lua") invece di tutto il percorso
      vim.notify("DND Generator (HomeBrew) : Error in LUA file '" .. file .. "' does not contain a valid structure."
      , vim.log.levels.WARN)
    end
  end

  return results
end

function M.merge_data(endpoint, api_data)

  local custom_items = load_homebrew_files(endpoint)
  local final_data = vim.list_extend(api_data, custom_items)

  if endpoint == "classes" then
    local custom_subclasses = load_homebrew_files("subclasses")
    for _, subclass in ipairs(custom_subclasses) do
      for _, class in ipairs(final_data) do
        if subclass.parent_class and string.lower(subclass.parent_class) == string.lower(class.name) then
          class.archetypes = class.archetypes or {}
          table.insert(class.archetypes, subclass)
        end
      end
    end

    elseif endpoint == "races" then
      local custom_subraces = load_homebrew_files("subraces")
      for _, subrace in ipairs(custom_subraces) do
        for _,race in ipairs(final_data) do
          if subrace.parent_race and string.lower(subrace.parent_race) == string.lower(race.name) then
            race.subraces = race.subraces or {}
            table.insert(race.subraces, subrace)
          end
        end
      end
    end

  return final_data
end


return M
