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

For exemple, if you wanna add a new specie, let's say *Goliath* and their respective sub-specie
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
By pressing `TAB` you can view at any moment suggestions to help you navigate between options

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

## Installation
you can install this plugin using your favourite package manager.
**Lazy.nvim**
```lua

{
    "PaoloAlessio/dnd-generator.nvim",
    cmd = {"GenName", "GenNPC"}
    opts = {
        mode = "offline",
    }
}
```

### Configuration:
The plugin comes with the following default configuration
```lua
{
    mode = "offline", -- Choose between "offline" (local cache) or "online" (doesn't save from API)
    cache_dir = vim.fn.stdpath("data") .. "/dnd_generator",
}
```

