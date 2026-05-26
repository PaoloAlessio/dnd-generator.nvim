local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local conf = require("telescope.config").values
local client = require("dnd_generator.open5e.client")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local convert = require("dnd_generator.ui.unit_converter")

local M = {}

local function clean_text(text)
  if not text then return {} end
  return vim.split(text, "\n")
end

local function make_preview(endpoint, info)
  local lines = {}

  table.insert(lines, "# " .. info.name)
  table.insert(lines, "---")

  -- Monsters:
  if endpoint == "monsters" then
    table.insert(lines,"**Size/Type:** "
    .. (info.size or "") .. " "
    .. (info.type or "") .. " ("
    .. (info.alignment or "") .. ")")
    table.insert(lines, "**Challenge Rating (CR):** " .. (info.challenge_rating or ""))
    table.insert(lines, "**Armor Class (AC):** "
    .. (info.armor_class or "???"))
    table.insert(lines, "**Hit Points (HP):** "
    .. (info.hit_points or "???") .. " (" .. (info.hit_dice or "") .. ")")
    table.insert(lines, "**Speed:** "
    .. convert.text((info.speed and info.speed.walk and (info.speed.walk .. "ft.") or "0 ft.")))
    table.insert(lines, "")
    table.insert(lines, "### Stats:")
    table.insert(lines, string.format("| STR: %d | DEX: %d | CON: %d | INT: %d | WIS: %d | CHA: %d |",
      info.strength or 10, info.dexterity or 10, info.constitution or 10,
      info.intelligence or 10, info.wisdom or 10, info.charisma or 10))
    table.insert(lines, "")
  table.insert(lines, "### Lore:")
  local description = clean_text(info.description or info.desc)
  for _, line in ipairs(description) do
    table.insert(lines, convert.text(line))
  end
  return lines

  -- Spells:
  elseif endpoint == "spells" then
    table.insert(lines, "**Level:** "
    .. (info.level or "Cantrip")
    .. " | **School:** " .. (info.school or ""))
    table.insert(lines, "**Casting Time:** "
    .. (info.casting_time or "")
    .. " | **Range:** " .. convert.text((info.range or "")))
    table.insert(lines, "**Components:** " .. (info.components or "")
    .. " | **Duration:** " .. (info.duration or ""))
    table.insert(lines, "**Materials:** " .. (info.material or ""))
    if info.concentration == "yes" or info.requires_concentration then
      table.insert(lines, "⚠️ *Requires Concentration*")
    end
    table.insert(lines, "")

  -- Rules and Conditions
  elseif endpoint == "sections" or endpoint == "conditions" then
    local description = clean_text(info.desc or info.description)
    for _, line in  ipairs(description) do
      table.insert(lines, convert.text(line))
    end
    return lines
  -- Magic Items
  elseif endpoint == "magicitems" then
    table.insert(lines, "**Type:** " .. (info.type or "")
  .. " | **Rarity:** " .. (info.rarity or ""))
    if  (info.requires_attunement or "") ~= "" then
      table.insert(lines, "⚠️ *Requires Attunement*")     
    end
  -- Feats 
  elseif endpoint== "feats" then
    if type(info.prerequisite) == "string" then table.insert(lines, info.prerequisite) end
    table.insert(lines, "")
  -- weapon
  elseif endpoint== "weapons" then
    table.insert(lines, "**Category:** ".. (info.category or ""))
    table.insert(lines, "**Cost:** ".. (info.cost or "")
    .. " | **Weight:** ".. (info.weight or ""))
    table.insert(lines, "**Damage Dice and Type:** ".. (info.damage_dice or "").. " " .. (info.damage_type or ""))
    return lines
  -- armor
  elseif endpoint == "armor" then
    local weight = (info.weight or "") ~= "" and info.weight or "---"
    table.insert(lines, "**Category:** ".. (info.category or ""))
    table.insert(lines, "**Cost:** ".. (info.cost or "") .. " | **Weight:** ".. weight)
    table.insert(lines, "**Armor Class (AC):** " .. (info.ac_string or info.base_ac or "???" ))
    if info.stealth_disadvantage then
      table.insert(lines, "⚠️ *Stealth Disadvantage*")
    end
    return lines
  elseif endpoint == "races" then
    local speed = "30 ft."
    if type(info.speed) == "table" and info.speed.walk then
      speed = info.speed.walk .. "ft."
    end
    table.insert(lines,"**Size:** ".. (info.size_raw or "Madium").. " | **Speed:** ".. convert.text(speed))
    table.insert(lines, "")

    if(info.asi_desc or "") ~= "" then
      table.insert(lines, info.asi_desc)
    end

    if (info.vision or "") ~= "" then
      table.insert(lines, convert.text(info.vision))
    end
    if (info.languages or "") ~= "" then
      table.insert(lines, info.languages)
    end

    if (info.traits or "") ~= "" then
      table.insert(lines, "")
      table.insert(lines, "### Racial Traits:")
      local traits = clean_text(info.traits)
      for _, line in ipairs(traits) do 
        table.insert(lines, convert.text(line))
      end
    end
    return lines
  end
  -- General
  table.insert(lines, "### Description / Effects:")
  local description = clean_text(info.effect_desc or info.description or info.desc)
  for _, line in ipairs(description) do
    table.insert(lines, convert.text(line))
  end
  return lines
end

local function make_buffer(endpoint, info)
  local lines = {}
  -- title
  table.insert(lines, "# " .. info.name .. " | " .. endpoint)
  table.insert(lines, "---")

  -- Spells
  if endpoint == "spells" then
    table.insert(lines, "**Level:** "
    .. (info.level or "Cantrip")
    .. " | **School:** " .. (info.school or ""))
    if (info.higher_level or "") ~= "" then
      table.insert(lines, "**Hiher level**: " .. info.higher_level)
    end
    table.insert(lines, "**Casting Time:** "
    .. (info.casting_time or "")
    .. " | **Range:** " .. convert.text(( info.range or "" )))
    table.insert(lines, "**Components:** " .. (info.components or "")
    .. " | **Duration:** " .. (info.duration or ""))
    table.insert(lines, "**Materials:** " .. (info.material or ""))
    if info.concentration == "yes" or info.requires_concentration then 
      table.insert(lines, "⚠️ *Requires Concentration*")
    end
    table.insert(lines, "**Can be cast as a Ritual:** "  .. (info.ritual or ""))
    table.insert(lines, "")

    table.insert(lines, "**Spell lists:**" .. (info.dnd_class or ""))
    -- Description
    table.insert(lines, "## Description / Effects:")
    local description = clean_text(info.description or info.desc)
    for _, line in ipairs(description) do
      table.insert(lines, convert.text(line))
    end
    return lines

  -- Monsters
  elseif endpoint == "monsters" then
    table.insert(lines,"**Size/Type:** "
    .. (info.size or "") .. " "
    .. (info.type or "") .. " "
    .. (info.subtype or "")) 
    table.insert(lines,"**Alignment:** ".. (info.alignment or ""))
    table.insert(lines, "**Challenge Rating (CR):** " .. (info.challenge_rating or ""))
    -- Armor class
    table.insert(lines, "**Armor Class (AC):** ".. (info.armor_class or "???"))
    if (info.armor_desc or "") ~= "" then table.insert(lines, "- " .. (info.armor_desc or "")) end
    -- HP
    table.insert(lines, "**Hit Points (HP):** "
    .. (info.hit_points or "???") .. " (" .. (info.hit_dice or "") .. ")")
    -- Speed
    local speed_texts = {}
    if type(info.speed) == "table" then
      for move_type, distance in pairs(info.speed) do
        table.insert(speed_texts, move_type .. " " .. distance .. " ft.")
      end
      local all_speeds = table.concat(speed_texts, ", ")
      table.insert(lines, "**Speed:** " .. convert.text(all_speeds))
    else
      table.insert(lines, "**Speed:** " .. convert.text("0 ft."))
    end
    table.insert(lines, "")

    -- Stats
    table.insert(lines, "### Stats:")
    table.insert(lines, string.format("| STR: %d | DEX: %d | CON: %d | INT: %d | WIS: %d | CHA: %d |",
      info.strength or 10, info.dexterity or 10, info.constitution or 10,
      info.intelligence or 10, info.wisdom or 10, info.charisma or 10))
    table.insert(lines, "")

    -- Saves
    local saves = {}
    if type(info.strength_save) == "number" then table.insert(saves, "Str +" .. info.strength_save) end
    if type(info.dexterity_save) == "number" then table.insert(saves, "Dex +" .. info.dexterity_save) end
    if type(info.constitution_save) == "number" then table.insert(saves, "Con +" .. info.constitution_save) end
    if type(info.intelligence_save) == "number" then table.insert(saves, "Int +" .. info.intelligence_save) end
    if type(info.wisdom_save) == "number" then table.insert(saves, "Wis +" .. info.wisdom_save) end
    if type(info.charisma_save) == "number" then table.insert(saves, "Cha +" .. info.charisma_save) end
    if #saves > 0 then
      table.insert(lines, "**Saving Throws:** " .. table.concat(saves, ", "))
    end

    -- Skills
    if type(info.skills) == "table" then
      local skill_list = {}
      for skill, bonus in pairs(info.skills) do
        local skill_name = skill:gsub("^%l", string.upper)
        table.insert(skill_list, skill_name .. " +" .. bonus)
      end
      if #skill_list > 0 then
        table.insert(lines, "**Skills:** " .. table.concat(skill_list, ", "))
      end
    end

    -- Resistances and Immunities
    if (info.damage_vulnerabilities or "") ~= "" then
      table.insert(lines, "**Damage Vulnerabilities:** " .. info.damage_vulnerabilities)
    end
    if (info.damage_resistances or "") ~= "" then
      table.insert(lines, "**Damage Resistances:** " .. info.damage_resistances)
    end
    if (info.damage_immunities or "") ~= "" then
      table.insert(lines, "**Damage Immunities:** " .. info.damage_immunities)
    end
    if (info.condition_immunities or "") ~= "" then
      table.insert(lines, "**Condition Immunities:** " .. info.condition_immunities)
    end
    -- Senses and languages
    if (info.senses or "") ~= "" then
      table.insert(lines, "**Senses:** "..convert.text(info.senses))
    end
    if (info.languages or "") ~= "" then
      table.insert(lines, "**Languages:** " .. convert.text(info.languages))
    else
      table.insert(lines, "**Languages: -**")
    end

    -- Fight
    table.insert(lines, "## Fight:")

    -- Special Abilities
    if type(info.special_abilities) == "table" and #info.special_abilities > 0 then
      table.insert(lines, "### Special Traits")
      for _, ability in ipairs(info.special_abilities) do
        table.insert(lines, "**" .. ability.name .. ".** " .. convert.text(ability.desc))
        table.insert(lines, "")
      end
    end
    -- Actions
    if type(info.actions) == "table" and #info.actions > 0 then
      table.insert(lines, "### Actions")
      for _, action in ipairs(info.actions) do
        table.insert(lines, "**" .. action.name .. ".** " .. convert.text(action.desc))
        table.insert(lines, "")
      end
    end
    -- Legendary Actions
    if type(info.legendary_actions) == "table" and #info.legendary_actions > 0 then
      table.insert(lines, "### Legendary Actions")
      if (info.legendary_desc or "") ~= "" then
        table.insert(lines, convert.text(info.legendary_desc))
        table.insert(lines, "")
      end
      for _, action in ipairs(info.legendary_actions) do
        table.insert(lines, "**" .. action.name .. ".** " .. convert.text(action.desc))
        table.insert(lines, "")
      end
    end

    -- Reactions
    if type(info.reactions) == "table" and #info.reactions > 0 then
      table.insert(lines, "### Reactions")
      for _, reaction in ipairs(info.reactions) do
        table.insert(lines, "**" .. reaction.name .. ".** " .. convert.text(reaction.desc))
        table.insert(lines, "")
      end
    end

    -- Lore
    if (info.description or info.desc) ~= "" then 
      table.insert(lines, "## Lore:")
      local description = clean_text(info.description or info.desc)
      for _, line in ipairs(description) do
        table.insert(lines, convert.text(line))
      end
    end
    return lines

  -- Magic Items
  elseif endpoint == "magicitems" then
    table.insert(lines, "**Type:** " .. (info.type or "")
  .. " | **Rarity:** " .. (info.rarity or ""))
    if  (info.requires_attunement or "") ~= "" then
      table.insert(lines, "⚠️ *Requires Attunement*")     
    end
    local description = clean_text(info.desc or info.description)
    for _, line in  ipairs(description) do
      table.insert(lines, convert.text(line))
    end
    return lines

  -- Feats 
  elseif endpoint== "feats" then
    if type(info.prerequisite) == "string" then table.insert(lines, info.prerequisite) end
    if (info.effect_desc or "") ~= "" then
        table.insert(lines, "## Effect Description:")
      local description = clean_text(info.effect_desc)
      for _, line in  ipairs(description) do
        table.insert(lines, convert.text(line))
      end
    end
    if (info.desc or "") ~= "" or (info.description or "") ~= "" then
      local description = clean_text(info.desc or info.description)
      for _, line in  ipairs(description) do
        table.insert(lines, convert.text(line))
      end
    end
    return lines

  --weapons
  elseif endpoint== "weapons" then
    table.insert(lines, "**Category:** ".. (info.category or ""))
    table.insert(lines, "**Cost:** ".. (info.cost or "")
    .. " | **Weight:** ".. (info.weight or ""))
    table.insert(lines, "**Damage Dice and Type:** ".. (info.damage_dice or "").. " " .. (info.damage_type or ""))
    local Properties = {}
    if type(info.properties) == "table" then
      for _, property in ipairs(info.properties) do
        table.insert(Properties, property)
      end
      table.insert(lines, "**Properties:** " .. table.concat(Properties, ", "))
    end
    return lines 

  -- armor
  elseif endpoint == "armor" then
    local weight = (info.weight or "") ~= "" and info.weight or "---"
    table.insert(lines, "**Category:** ".. (info.category or ""))
    table.insert(lines, "**Cost:** ".. (info.cost or "") .. " | **Weight:** ".. weight)
    table.insert(lines, "**Armor Class (AC):** " .. (info.ac_string or info.base_ac or "???" ))
    if info.stealth_disadvantage then
      table.insert(lines, "⚠️ *Stealth Disadvantage*")
    end
    if type(info.strength_requirement) == "number" then
      table.insert(lines, "**Strength Requirement:** Str " .. info.strength_requirement)
    end
    
    if info.stealth_disadvantage == true then
      table.insert(lines, "⚠️ *Stealth Disadvantage*")
    else
      table.insert(lines, "🥷 *No Stealth Disadvantage*")
    end
    
    return lines

  -- Rules and Conditions
  elseif endpoint == "sections" or endpoint == "conditions" then
    local description = clean_text(info.desc or info.description)
    for _, line in  ipairs(description) do
      table.insert(lines, convert.text(line))
    end
    return lines
  end
end

function M.find(endpoint)
  client.get_data(endpoint, function(items)
    pickers.new({}, {
      prompt_title = "D&D 5e - " .. endpoint:gsub("^%l", string.upper),

      finder = finders.new_table({
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),

      previewer = previewers.new_buffer_previewer({
        title = "Preview",
        define_preview = function(self, entry, status)
          local info = entry.value
          local lines = make_preview(endpoint, info)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.bo[self.state.bufnr].filetype = "markdown"
        end,
        }),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            local lines = make_buffer(endpoint, selection.value)

            actions.close(prompt_bufnr)

            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            vim.bo[buf].filetype = "markdown"
            vim.bo[buf].buftype = "nofile"
            vim.bo[buf].bufhidden = "wipe"
            vim.bo[buf].modifiable = false
            vim.cmd("vsplit")
            vim.api.nvim_win_set_buf(0, buf)
          end)

          map("i", "<C-y>", function()
            local selection = action_state.get_selected_entry()
            local lines = make_preview(endpoint, selection.value)

            actions.close(prompt_bufnr)
            
            vim.api.nvim_put(lines, "l", true, true)
          end)
        return true
        end,
    }):find()
  end)
end


return M
