vim.api.nvim_create_user_command('GenName', function (opts)
  require("dnd_generator.core.commands").run_gen_name(opts.fargs)
end,
{
  nargs = '+',
  desc = "Generate names for NPCs",
  complete = function(ArgLead, CmdLine)
    return  require("dnd_generator.core.commands").cmd_complete_handler(ArgLead,CmdLine)
  end
})

vim.api.nvim_create_user_command('GenNPC', function (opts)
  require("dnd_generator.core.commands").run_gen_npcs(opts.fargs)
end, {
  nargs = '*',
  desc = "Generate an NPC",
  complete = function(ArgLead, CmdLine)
    return require("dnd_generator.core.commands").cmd_complete_handler(ArgLead,CmdLine)
  end
})

vim.api.nvim_create_user_command('DNDFind', function(opts)
  local arg = opts.args
  if require("dnd_generator.core.commands").is_valid_DNDFind(arg) then
   require("dnd_generator.ui.telescope") .find(arg)
  else
    vim.notify("ERROR: " .. arg .. "is not a valid category", vim.log.levels.ERROR)
  end
end,{
  nargs = 1,
  desc = "Uses Telescope to search across dnd rules",
  complete = function(ArgLead, _)
    local options = require("dnd_generator.core.commands").valid_DNDFind()

    return vim.tbl_filter(function (item)
      return vim.startswith(item, ArgLead)
    end, options)
  end
})

vim.api.nvim_create_user_command('DNDClearCache', function ()
  require("dnd_generator.core.commands").clear_cache()
end, {})

vim.api.nvim_create_user_command('DNDSyncCache', function ()
  if  require("dnd_generator.init").config.mode == "online" then
    vim.notify("DND Generator: Chosen mode online, if you want to download Open5e files, change mode to \"offline\"", vim.log.levels.WARN)
    return
  end
  require("dnd_generator.core.commands").sync_cache()
end, {
  desc = "Empties dnd-generator cache directory"
})


vim.api.nvim_create_user_command('DNDRoll', function(opts)

  if opts.args == "" then
    vim.notify("WARN: must specify dices to throw, Es: :DNDRoll 1d20+3", vim.log.levels.WARN)
    return
  end

  require("dnd_generator.dice.roll").rolldice(opts.args)

end, {
  nargs = '?',
  desc = "Throws dnd Dices",
})

vim.api.nvim_create_user_command('DNDInit', function(opts)
    local campaign_name = opts.args

    if campaign_name == "" then
        campaign_name = vim.fn.input("Campaign Name: ")
    end

    if campaign_name == "" then
        vim.notify("Operation Aborted", vim.log.levels.WARN)
        return
    end

    require("dnd_generator.workspace").init_campaign(campaign_name)

    local safe_name = campaign_name:gsub("%s+", "_")
    local index_path = vim.fn.getcwd() .. "/" .. safe_name .. "/index.md"
    vim.cmd("edit " .. index_path)

end, {
    nargs = '?',
    desc = "Generate whole Campaign note Tree for dnd"
})
