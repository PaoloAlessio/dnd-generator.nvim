<h1> WORK IN PROGRESS ⚠️</h1>

# DND GENERATOR 🎲 
> by Paolo Alessio Pelliccia

## Introduction
this plugin aim is to **generate** random NPC names, sorted by species, sub-species, sex and more.
By default, it comes with a small list of fantasy and historical names, but it's designed to let
you easily plug in yout own custom `.txt` lists!

## Features:
### Adding names:
Adding names is extremely easy, you can just modify every file inside the folder names

### Adding species:
Adding new species, sub-species, new files, is extremely easy and will be mapped automatically,
you'll just need to create the respective folders and files

For example, if you wanna add a new species, let's say *Goliath* and their respective sub-species
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

#### Semantic Search:
The Telescope integrations allows semantic filtering: while searching you can type specific keywords to filter results.

##### Examples:
- In **monsters**: `cr 5` to see Challenge Rating 5 monsters, `large` for see large size monsters...
- In **spells**: type `cantrip`...
- In **weapons**: type `slashing` or `martial`...

### Custom Homebrew:
You can easily integrate your own custom campaigns, monsters, items, classes and much more:
Simply drop a `.json` file containing your data into the corresponding folder.
The plugin will automatically parse it and show it in Telescope, marking it with a special icon.

By typing `homebrew` inside Telescope you can filter to view your custom content

### Want to use official D&D content?
Due to copyright reasons, this plugin only ships with open-source and SDR content. However the tool is entirely
yours! You're highly encouraged to transcribe your favourite *names*, *monsters*, *subclasses* and much more in your
local `.txt`, `.json` or `.lua` files from the rulebooks you own.
Just drop them in the correct local `names` or `homebrew` directories and they'll be seamlessly 
integrated for you to use.

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
:GenName <path-to-file> [<quantity>]
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

### Rolling Dices:
``` cmd
:DNDRoll <quantity>d<dice>[+/-<modifier>] [adv/dis]
```
#### Examples:
- `:DNDRoll 3d6` -> rolls 3 d6 and sums the results
- `:DNDRoll 5d4+3` -> rolls 5 d4, sums them and adds 3 to the result
- `:DNDRoll 1d20 adv` -> rolls 1 d20 twice, keeps the higher result
- `:DNDRoll 2d20-1 dis` -> rolls a pool of 2 d20s twice, keeps the lower total, and subtracts 1

### DND Init:
``` cmd
:DNDInit [<campaign name>]
```
This command generate an organized directory tree for taking notes for a D&D campaign

## Installation
you can install this plugin using your favourite package manager.
**Lazy.nvim**
```lua
{
    "PaoloAlessio/dnd-generator.nvim",
    event = "VeryLazy",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "L3MON4D3/LuaSnip"
    },
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
    default_names = true, -- By default generate a short list of names and files in the folder of the names
    names_files = { "child", "names", "male", "female" }, -- files from where the program expectes to find the names
    homebrew_icon = "", -- icon for homebrew files
    classic_icon = "󰗪", -- icon for files from Open5e
    load_default_snippets = true, -- By default, loads default snippets for takind notes on dnd campaigns for markdown
    author = "Your Name",  -- You can change it to your name so the !header snippet will adapt
}
```
## Contributing
Pull requests are welcome! If you want to add new name lists, features or fix bugs, feel free to open an issue or submit a PR.

## License
Distributed under the MIT License. See `LICENSE` for more information.

#### Measurement Unit:
For *non-FreedomUnit-Users* like me, you can change the unit system:
- for all *"What in the name of God is a kilometer 🇺🇸🦅"* people by default it will use the Freedom Unit since D&D,
Wizards of The Coast and Open5e use it
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
> always prefer `.json` files


#### Names files:
The plugin expectes to find the names of the NPCs in the `.txt` files named after the content of the
table `names_files`, so it'll look for files such as `female.txt`, `male.txt`, `names.txt`...


# RoadMap:
- [x] Generates names `:GenName` 
- [x] Generates NPCs `:GenNPC` 
- [x] Snippets for dnd
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
    - [x] HomeBrewing
- [x] Random dices `:DNDRoll`
- [x] generating directories workspace for campaign notes `:DNDInit`

## Contributing
Pull requests are welcome! If you want to add new name lists, features or fix bugs, feel free to open an issue or submit a PR.

## License
Distributed under the MIT License. See `LICENSE` for more information.
