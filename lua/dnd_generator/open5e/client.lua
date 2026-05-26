local M = {}
local curl = require("plenary.curl")
local config = require("dnd_generator").config

local function save_to_cache(filename, data)
  local path = config.cache_dir .. "/" .. filename
  vim.fn.mkdir(config.cache_dir, "p")
  local file = io.open(path, "w")
  if file then
    file:write(vim.json.encode(data))
    file:close()
    vim.notify("Cache saved in: "..path, vim.log.levels.INFO)
  else
    vim.notify("CRITICAL ERROR: unable to save in ".. path, vim.log.levels.ERROR)
  end
end

local function read_from_cache(filename)
  local path = config.cache_dir .. "/" .. filename
  local file = io.open(path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    return vim.json.decode(content)
  end
  return nil
end

function M.get_data(endpoint, callback)
  local filename = endpoint .. ".json"

  if config.mode == "offline" then
    local cached_data = read_from_cache(filename)
    if cached_data then
      callback(cached_data)
      return
    end
  end

  vim.notify("Download database '" .. endpoint .. "' from Open5e... Could take a few seconds", vim.log.levels.INFO)
  
  local all_results = {}
  local current_url = "https://api.open5e.com/v1/" .. endpoint .. "/?limit=100"

  local function fetch_next()
    curl.get(current_url, {
      callback = function(response)
        vim.schedule(function()
          if response.status ~= 200 then
            vim.notify("ERROR API Open5e: code " .. response.status, vim.log.levels.ERROR)
            return
          end

          local data = vim.json.decode(response.body)
          
          for _, item in ipairs(data.results) do
            table.insert(all_results, item)
          end

          if data.next and data.next ~= vim.NIL then
            current_url = data.next
            fetch_next()
          else
            vim.notify("Download completed: " .. #all_results .. " elements found", vim.log.levels.INFO)
            
            if config.mode == "offline" then
              save_to_cache(filename, all_results)
            end
            callback(all_results)
          end
        end)
      end
    })
  end

  fetch_next()
end

return M
