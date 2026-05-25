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

