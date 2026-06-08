vim.api.nvim_create_user_command('GenName', function (opts)
  require("dnd_generator.core.commands").run_gen_name(opts.fargs)
end,
{
  nargs = '+',
  complete = function(ArgLead, CmdLine)
    return  require("dnd_generator.core.commands").cmd_complete_handler(ArgLead,CmdLine)
  end
})

vim.api.nvim_create_user_command('GenNPC', function (opts)
  require("dnd_generator.core.commands").run_gen_npcs(opts.fargs)
end, {
  nargs = '*',
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
  complete = function(ArgLead, CmdLine)
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
end, {})
