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

## Installation
you can install this plugin using your favourite package manager.
**Lazy.nvim**
```lua

{
    "PaoloAlessio/dnd-generator.nvim",
    event = "VeryLazy"
    opts = {
    }
}
```

### Configuration:
The plugin comes with the following default configuration
```lua
{
    mode = "offline", -- Choose between "offline" (local cache) or "online" (doesn't save from API)
    cache_dir = vim.fn.stdpath("data") .. "/dnd_generator",
    unit = "m",
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


# RoadMap:
- [x] Generates names `:GenName` 
- [x] Generates NPCs `:GenNPC` 
- [ ] Snippets for dnd
- [ ] Open5e + Telescope
    - [x] cache clear
    - [x] online only mode
    - [ ] cache sync
    - [x] Monsters
    - [x] Spells
    - [x] rules
    - [x] conditions
    - [ ] races
    - [ ] classes
    - [x] weapons
    - [x] armor
    - [x] magic items
    - [ ] HomeBrewing
- [ ] Random dices
- [ ] generating directories workspace for campaign notes
