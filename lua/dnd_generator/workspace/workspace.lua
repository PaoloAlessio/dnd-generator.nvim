local M = {}

function M.init_campaign(campaign_name)
    if not campaign_name or campaign_name == "" then
        campaign_name = "New_Campaign"
    end

    local safe_name = campaign_name:gsub("%s+", "_")
    local cwd = vim.fn.getcwd()
    local base_path = cwd .. "/" .. safe_name

    local folders = {
        "Narrative",
        "NPCs",
        "Players",
        "Sessions",
        "World/Places",
        "World/Lore"
    }

    for _, folder in ipairs(folders) do
        vim.fn.mkdir(base_path .. "/" .. folder, "p")
    end

    local function create_file(path, content)
        local file = io.open(base_path .. "/" .. path, "w")
        if file then
            file:write(content)
            file:close()
        end
    end
    local function header(tags)

      local header_ = string.format([[
---
title: %s
date: %s
author: %s
tags: [%s]
---
      ]], campaign_name, os.date("%Y-%m-%d"), require("dnd_generator").config.author, tags)

    return header_
    end

    create_file("marksman.toml", "")


    create_file("index.md", header("HUD,Campaign,DND,index") .. string.format([=[
#  General Info:
- Title     ::  %s
- System    ::  D&D 5e 
- Location  ::  Forgotten Realms
- Theme     ::  High Fantasy
- Tema      ::  High Fantasy

#     party:
| Player    | Character   | Species  | Class      | lv | PP | AC |
|-----------|-------------|----------|------------|----|----|----|
|           |             |          |            |    |    |    |


##  Characters Objectives:
- [ ] Player1 : find inner peace...


# 󱣱 Navigator:
- [[Narrative]]
- [[NPCs]]
- [[Players]]
- [[Sessions]]
- [[World]]
]=], campaign_name))

    create_file("Narrative/Narrative.md", header("Narrative,DND,index") .. [=[
[[index]]


#  Background:


# 󰜂 Campaing Arc:


# 󰉻  Narrative Arc:
## [[Chap1]]

]=])

    create_file("NPCs/NPCs.md", header("NPCs,DND,index") .. [=[
[[index]]

#  Main NPCs:
- [[NPCname]]
 
#   Secondary NPCs:
 
# 󰇴  Enemies: 

]=])

    create_file("Players/Players.md", header("Players,DND,index") .. [=[
# [[Character_name]]
]=])

    create_file("Sessions/Sessions.md", header("Sessions,DND,notes,index") .. [=[
# Sessions:
1. [[Session1]] (date...)
]=])

    create_file("World/World.md", header("World,places,DND,index") [=[
# 󰜂 World

##  places
- [[starting_city]]

##  Lore and Myths
- [[lorethings?]]
]=])

end

return M
