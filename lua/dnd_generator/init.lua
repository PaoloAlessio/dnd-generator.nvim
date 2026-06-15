local M = {}

local function bootstrap_names(names_dir)
  if vim.fn.isdirectory(names_dir) == 1 then
    return
  end

  vim.notify("DND Generator: Initialization names DB...", vim.log.levels.INFO)
  local default_names = {
    ["dwarf/male.txt"] = "Thorin\nBruenor\nBalin\nBofur",
    ["dwarf/female.txt"] = "Dis\nHelga\nKildrak\n",
    ["elf/male.txt"] = "Legolas\nElrond\nThranduil\n",
    ["elf/female.txt"] = "Galadriel\nArwen\nTauriel\n",
    ["human/celtic/male.txt"] = "Arthur\nFinn\nLiam\n",
    ["human/celtic/female.txt"] = "Gwen\nMaeve\nFiona\n"
  }

  for file_path, content in pairs(default_names) do
    local full_path = vim.fs.normalize(vim.fs.joinpath(names_dir, file_path))
    local folder_path = vim.fn.fnamemodify(full_path, ":h")

    vim.fn.mkdir(folder_path, "p")

    local file = io.open(full_path, "w")
    if file then
      file:write(content)
      file:close()
    end
  end

  vim.notify("DND Generator: Names DB ready", vim.log.levels.INFO)
end

M.config = {
  names_files = { "child", "names", "male", "female" },
  mode = "offline",
  cache_dir = vim.fs.joinpath(vim.fn.stdpath("cache"), "dnd_generator","open5e"),
  homebrew_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "dnd_generator", "homebrew"),
  names_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "dnd_generator","names"),
  unit = "ft",
  lua_homebrew = false,
  default_names = true,
  homebrew_icon = "",
  classic_icon = "󰗪",
  load_default_snippets = true,
  author = "Your name",
}

M.setup = function (opts)
  opts = opts or {}

  M.config = vim.tbl_deep_extend("force", M.config, opts)

  M.config.cache_dir = vim.fs.normalize( vim.fn.expand(M.config.cache_dir))
  M.config.homebrew_dir = vim.fs.normalize(vim.fn.expand(M.config.homebrew_dir))
  M.config.names_dir = vim.fs.normalize(vim.fn.expand(M.config.names_dir))

  if M.config.mode == "offline" then
    if vim.fn.isdirectory(M.config.cache_dir) == 0 then
      vim.fn.mkdir(M.config.cache_dir, "p")
    end
  end
  if M.config.unit ~= "ft" and M.config.unit ~= "m" and M.config.unit ~= "ft/m" then
      M.config.unit = "ft"
  end
  local contents = vim.fn.glob(M.config.names_dir .. "/*", false, true)
  if not (#contents > 0) and M.config.default_names then
    bootstrap_names(M.config.names_dir)
  end

  if M.config.load_default_snippets then
    local has_luasnip, _ = pcall(require, "luasnip")
    if has_luasnip then
      require("luasnip.loaders.from_lua").lazy_load({
        paths = vim.api.nvim_get_runtime_file("snippets", false)
      })
    else
      vim.notify("dnd_generator: LuaSnip not found, snippets not enabled", vim.log.levels.WARN)
    end
  end

  if type(M.config.author) ~= "string" then
    M.config.author = "Your name"
  end
end


return M
