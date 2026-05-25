local M = {}

M.config = {

}

M.setup = function (opts)
  opts = opts or {}

  M.config = vim.tbl_deep_extend("force", M.config, opts)
end


return M
