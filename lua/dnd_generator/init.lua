local M = {}

M.config = {
  mode = "offline",
  cache_dir = vim.fn.stdpath("data") .. "/dnd_generator"
}

M.setup = function (opts)
  opts = opts or {}

  M.config = vim.tbl_deep_extend("force", M.config, opts)

  if M.config.mode == "offline" then
    if vim.fn.isdirectory(M.config.cache_dir) == 0 then
      vim.fn.mkdir(M.config.cache_dir, "p")
    end
  end
end


return M
