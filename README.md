<h1> WORK IN PROGRESS ⚠️</h1>

# DND GENERATOR 🎲 
> by Paolo Alessio Pelliccia

## Introduction
this plugin aim is to **generate** random NPC names, sorted by species, sub-species, sex and more.
It contains the names from *Xanathar's Guide to Everything*

## Features:
### Adding names:
Adding names is extremely easy, you can just modify every file inside the folder names

### Adding species:
Adding new species, sub-species, new files, is extremely easy and will be mapped automatically,
you'll just need to create the respective folders and files

For example, if you wanna add a new specie, let's say *Goliath* and their respective sub-specie
*Cloud's Jaunt*, you can easily add the new folders in names:
```
names
├───dragonborn
├───dwarf
...
└───goliath
    └───clouds
        ├───male.txt
        └───female.txt

```
just by adding those folders, the system will work and also give you automatic 
suggestion while writing commands: `:GenName goliath clouds male 2`

### Autocompletion:
By pressing `<TAB>` you can view at any moment suggestions to help you navigate between options

### DNDFind:
you can use Telescope to search across **Open5e API** and by default download the cache to the pc to save time on future
requests

#### Zoom:
when you want more information you can hit `<Enter>` on a selected element in Telescope to open a temporary buffer

#### Paste:
when you want to save information about a monster, spell, item... you can press `<C-y>` to paste the preview

## Commands:
### Name Generator:
- `:GenName` 
Generates a *Markdown* table of names from specified file:
```markdown
| Shrakk | Dak  | Xorm   | Greth | Duurth |
| Muurg  | Nurm | Ferzth | Kalla | Hurm   |
```


``` cmd
:GenName <path-to-file> [quantity]
```
- `:GenName dwarf male 5` -> generates 5 male names for dwarfs

### NPC Generator:
Generates a simple NPC sheet in *Markdown*:
``` markdown
# Cecilia #npc
> [!INFO] Data
> female
> **Race:**  human french
> **Role:** 
```

```cmd
:GenNPC [<filter-gender>] [<race-path>]
```
- `:GenNPC` -> generates a totally random NPC, it chooses a random gender and race and prints the sheet
- `:GenNPC male gith` -> chooses a random name for a male gith navigating through the subraces of giths
- `:GenNPC human arabic female` -> Standard complete path, chooses a name from the file 

### Opening DNDFind:
``` cmd
:DNDFind <category>
```  
opens Telescope to search between information about dnd, hitting `<TAB>` shows valid categories

### Clear cache:
```cmd
:DNDClearCache
```
this command empties the Cache directory

### Sync Cache:
``` cmd
:DNDSyncCache
```
This command empties and repopulate the Cache directory with all the `.json` file from **Open5e**

## Installation
you can install this plugin using your favourite package manager.
**Lazy.nvim**
```lua

{
    "PaoloAlessio/dnd-generator.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim"
    }
    opts = {
        -- Configuration here
    }
}
```

### Configuration:
The plugin comes with the following default configuration
```lua
{
    mode = "offline", -- Choose between "offline" (local cache) or "online" (doesn't save from API)
    cache_dir = vim.fn.stdpath("cache") .. "/dnd_generator/open5e",
    homebrew_dir = vim.fn.stdpath("data") .. "/dnd_generator/homebrew",
    names_dir = vim.fn.stdpath("data") .. "/dnd_generator/names",
    unit = "ft", -- Choose between "m", "ft", "ft/m"
    lua_homebrew = false, -- By default
    default_names = true, -- By defaylt generate a short list of names and files in the folder of the names
}
```

#### Mesurment Unit:
For *non-FreedomUnit-Users* like me, you can change the unit system:
- for all *"What in the name of God is a kilometer 🇺🇸🦅"* people by default it will use the Freedom Unit since D&D,
Wizzard of The Coast and Open5e use it
- for all the others you can choose between `unit = "m"` and `unit = "ft/m"`
>[!NOTE]
>the latter will display `15 ft. (4.5 m)`  

#### Offline mode:
The plugin by default downloads inside the cache from **Open5e** the categories visited by the user,
if you want to disable this feature you can change `mode = "online"`, this way the plugin won't save the cache
but even small requests might take a few seconds

#### Homebrew in lua:
By setting it to `lua_homebrew = true` the plugin can read from `.lua` files

>[!CAUTION]
> BEWARE of what you download: `.lua` files are compiled, so it could contain malicious code,
> always prefere `.json` files


# RoadMap:
- [x] Generates names `:GenName` 
- [x] Generates NPCs `:GenNPC` 
- [ ] Snippets for dnd
- [x] Open5e + Telescope
    - [x] cache clear `:DNDClearCache`
    - [x] online only mode
    - [x] cache sync `:DNDSyncCache`
    - [x] Monsters
    - [x] Spells
    - [x] rules
    - [x] conditions
    - [x] races
    - [x] classes
    - [x] weapons
    - [x] armor
    - [x] magic items
    - [x] HomeBcewing
- [ ] Random dices
- [ ] generating directories workspace for campaign notes

## License:
This software 
