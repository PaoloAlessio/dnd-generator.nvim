local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local c = ls.choice_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("header", fmt([[
---
title: {}
date: {}
author: {}
tags: [{}]
---

{}
  ]], {
    i(1, "Document title"),
    i(2, os.date("%Y-%m-%d")),
    i(3, require("dnd_generator.init").config.author),
    i(4, "dnd, notes"),
    i(5, ""),
  })),

  s("!caratteristiche", c(1, {
    fmt([[
| Stat | Score | Mod | Prof |
|------|-------|-----|------|
| **STR** |       |     |      |
| **DEX** |       |     |      |
| **CON** |       |     |      |
| **INT** |       |     |      |
| **WIS** |       |     |      |
| **CHA** |       |     |      |
  ]], {}),
    fmt([[
| STR | DEX | CON | INT | WIS | CHA |
|-----|-----|-----|-----|-----|-----|
|     |     |     |     |     |     |
  ]], {})
  })),

  s("!abilità", fmt([[
| Skill              | Stat | Mod | Prof | Notes |
|--------------------|------|-----|------|-------|
| Acrobatics         | DEX  |     |      |       |
| Animal Handling    | WIS  |     |      |       |
| Arcana             | INT  |     |      |       |
| Athletics          | STR  |     |      |       |
| Deception          | CHA  |     |      |       |
| History            | INT  |     |      |       |
| Insight            | WIS  |     |      |       |
| Intimidation       | CHA  |     |      |       |
| Investigation      | INT  |     |      |       |
| Medicine           | WIS  |     |      |       |
| Nature             | INT  |     |      |       |
| Perception         | WIS  |     |      |       |
| Performance        | CHA  |     |      |       |
| Persuasion         | CHA  |     |      |       |
| Religion           | INT  |     |      |       |
| Sleight of Hand    | DEX  |     |      |       |
| Stealth            | DEX  |     |      |       |
| Survival           | WIS  |     |      |       |
  ]], {})),

  s("!statistiche", fmt([[
| AC | Init | Spd | HP | Hit Dice |
|----|------|-----|----|----------|
|    |      |     |    |          |
  ]], {})),

  s("!salvezza", fmt([[
|     | MOD | SAVE |     | MOD | SAVE |
|-----|-----|------|-----|-----|------|
| STR |     |      | INT |     |      |
| DEX |     |      | WIS |     |      |
| CON |     |      | CHA |     |      |
  ]], {})),

  s("!creatura", fmt([[
# {} #creature
- **CR:** ## Stats
| AC | Init | Spd | HP |
|----|------|-----|----|
|    |      |     |    |

## Abilities
| STR | DEX | CON | INT | WIS | CHA |
|-----|-----|-----|-----|-----|-----|
|     |     |     |     |     |     |

- **Passive Perception:** - **Languages:** ### Proficiency:
- **Proficiency Bonus:** - **Skills:** - **Saving Throws:** ## Actions:
| Name | To Hit | Reach | Area | Damage (type) | Other |
|------|--------|-------|------|---------------|-------|
|      |        |       |      |               |       |

## Extra
  ]], {i(1, "creature name")})),

  s("!npc", fmt([[
# {} #npc
> [!INFO] Info
> **Race:** {}
> **Role:** {}

##  Roleplay
- **Appearance:** {}
- **Quirk:** {}
- **Attitude:** {}

##  Interaction
- **Motivation (What do they want?):** {}
- **Information/Secret:** {}

##  Quests:
- ...

##  Extra Info

## 󱁤 Items:
  ]], {
    i(1, "NPC Name"),
    i(2, "Human/Elf/Etc."),
    i(3, "Profession or Role"),
    i(4, "An obvious physical detail (e.g., broken nose, flashy clothes)"),
    i(5, "Curious/investigating/excited/skeptical/aggressive"),
    i(6, "A mannerism or way of speaking (e.g., stutters, scratches chin, weird accent)"),
    i(7, "What they are trying to achieve right now"),
    i(8, "A clue or rumor useful for the players"),
  })),

  s("!sessione", fmt([[
# Session {}: {} #session
> [!NOTE] Logistics
> **Date:** {}
> **Starting Location:** {}

## 󱇹  Recap: 
- ...

##  Objectives:
- [ ] ...

## ⚠ Events/Encounters
1. ...

## 󱓧 Live Notes:
- ...
  ]], {
    i(1,"Num"), i(2, "Title"), i(3, "DD-MM-YYYY"), i(4, "Where they are")
  })),

  s("!luogo", fmt([[
# Location: {} #location
> [!INFO] Geopolitics
> **Population:** {}
> **Government:** {}

##  NPCs:
- ...

##  Atmosphere and Description:
- ...

##  Points of Interest:
- **Tavern:** (Innkeeper: ...)
- **Shop:** (Merchant: ...)

##  Secrets:
- ...
  ]], {
    i(1, "Location name"), i(2, "e.g.: 500 inhabitants"), i(3, "Mayor/Lord/Empire...")
  })),

  s("!loot", fmt([[
# Item: {} #loot #item #magic
- **Rarity:** {}

## 󰓥 Visual Description:
- ...

## 󱡄 Effects:
- ...
  ]], {
    i(1, "Item Name"), i(2, "Common/Uncommon/Rare/Legendary")
  })),

  s( "!narrative", fmt([[
#  Background:
# 󰜂 Campaign Arc:
# 󰉻  Narrative Arcs: 
## Chapter 1
]], {})),

s("!chapter", fmt([[
#  Location:
#  Start:
#  Exploration:
# 󰛢 Hooks:
]], {})),

  s("!NPCs", fmt([[
#  Main:
#  Secondary:
# 󰇴 Enemies:
  ]], {})),

  s("!index", fmt(
    [[
#  General Information:
- Title       ::  {}
- System      ::  D&D 5e 
- Setting     ::  Forgotten Realms
- Theme       ::  High Fantasy

#     Party:
| Player | Character | Race | Class | Lvl | PP | AC |
|--------|-----------|------|-------|-----|----|----|
|        |           |      |       |     |    |    |

##  Character Objectives: 
- [ ] ...

# 󱣱 Navigation:
- links
    ]], {
    i(1, "Campaign title")
    })),

}
