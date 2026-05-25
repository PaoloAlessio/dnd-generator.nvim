local M = {}
local curl = require("plenary.curl")


function M.test_api()
  local url = "https://api.open5e.com/v1/monsters/?limit=5"
  vim.notify("Contacting Open5e...", vim.log.levels.INFO)
  
  curl.get(url, {
    callback = function(response)
      vim.schedule(function()
        if response.status == 200 then
          local data = vim.json.decode(response.body)

          if data and data.results then
            vim.notify("Success! Found ".. #data.results .. " monsters. ", vim.log.levels.INFO)
            vim.notify("First one is: "..data.results[1].name, vim.log.levels.INFO)
          end
        else
          vim.notify("Error while connecting to API ".. response.status, vim.log.levels.ERROR)
        end
      end)
    end
  })
end

return M
