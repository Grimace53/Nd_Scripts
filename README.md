# ND Drug System - Placeable Props

A comprehensive FiveM drug system featuring placeable growing pots and crafting tables with full integration for ox_target, ox_inventory, ox_lib, qbx_core, and md-drugs.

## Features

- **Placeable Drug Growing Pots**
  - Place growing pots anywhere in the world
  - Multi-stage growth system
  - Harvest when ready
  - Pick up and relocate pots

- **Placeable Crafting Tables**
  - Place crafting tables anywhere
  - Multiple crafting recipes
  - Progress bar for crafting
  - Pick up and relocate tables

- **Full Framework Integration**
  - ox_target for all interactions
  - ox_inventory for item management
  - ox_lib for UI elements
  - qbx_core for player data
  - md-drugs for drug system integration

## Dependencies

This resource requires the following resources to be installed and started before it:

1. [ox_lib](https://github.com/overextended/ox_lib)
2. [ox_target](https://github.com/overextended/ox_target)
3. [ox_inventory](https://github.com/overextended/ox_inventory)
4. [qbx_core](https://github.com/Qbox-project/qbx_core)
5. [md-drugs](https://github.com/Mustache-Mods/md-drugs) (optional)

## Installation

1. Clone or download this repository into your server's resources folder
2. Rename the folder to `nd_drugs` (or your preferred name)
3. Add the following items to your `ox_inventory/data/items.lua`:

```lua
-- Growing Props
['drug_pot'] = {
    label = 'Drug Growing Pot',
    weight = 5000,
    stack = false,
    close = true,
    description = 'A pot for growing plants',
    client = {
        export = 'nd_drugs.placeProp'
    }
},

-- Crafting Props
['craft_table'] = {
    label = 'Crafting Table',
    weight = 10000,
    stack = false,
    close = true,
    description = 'A table for crafting items',
    client = {
        export = 'nd_drugs.placeProp'
    }
},

-- Growing Resources
['weed_leaf'] = {
    label = 'Weed Leaf',
    weight = 100,
    stack = true,
    close = true,
    description = 'Raw weed leaf'
},

['coca_leaf'] = {
    label = 'Coca Leaf',
    weight = 100,
    stack = true,
    close = true,
    description = 'Raw coca leaf'
},

-- Crafting Materials
['rolling_paper'] = {
    label = 'Rolling Paper',
    weight = 10,
    stack = true,
    close = true,
    description = 'Paper for rolling'
},

['chemicals'] = {
    label = 'Chemicals',
    weight = 500,
    stack = true,
    close = true,
    description = 'Chemical compounds'
},

-- Final Products
['weed'] = {
    label = 'Weed',
    weight = 200,
    stack = true,
    close = true,
    description = 'Processed weed'
},

['coke'] = {
    label = 'Cocaine',
    weight = 200,
    stack = true,
    close = true,
    description = 'Processed cocaine'
}
```

4. Add the resource to your `server.cfg`:

```cfg
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qbx_core
ensure md-drugs
ensure nd_drugs
```

## Usage

### Placing Props

1. Obtain a `drug_pot` or `craft_table` item
2. Use the item from your inventory
3. The prop will be placed in front of you
4. Use ox_target to interact with the prop

### Growing Drugs

1. Place a drug pot
2. Wait for the growth stages to complete (configurable in `config.lua`)
3. When ready, target the pot and select "Harvest"
4. Receive your harvested items

### Crafting Drugs

1. Place a crafting table
2. Ensure you have the required materials
3. Target the table and select a recipe
4. Wait for the crafting progress to complete
5. Receive your crafted item

### Picking Up Props

1. Target any placed prop
2. Select "Pick Up" option
3. The prop will be returned to your inventory (if you have space)

## Configuration

Edit `config.lua` to customize:

- Growth times and stages
- Crafting recipes and requirements
- Prop models
- Item rewards
- Distance limits
- Permissions

### Example Config Changes

```lua
-- Change growth time to 10 minutes
Config.GrowingProps.pot.growTime = 600000

-- Add a new crafting recipe
table.insert(Config.CraftingProps.tablet.recipes, {
    name = 'Meth',
    item = 'meth',
    requirements = {
        {item = 'pseudoephedrine', amount = 2},
        {item = 'chemicals', amount = 1}
    },
    craftTime = 20000,
    output = {item = 'meth', amount = 1}
})
```

## Models Used

This script uses default GTA V models:
- Growing Pots: `bkr_prop_weed_01_small_01a/b/c`
- Crafting Table: `bkr_prop_meth_table01a`

You can change these in `config.lua` to use custom models.

## Exports

### Client Exports

```lua
-- Place a prop programmatically
exports.nd_drugs:placeProp(propType, isGrowing)
```

### Server Exports

```lua
-- Get all placed props
local props = exports.nd_drugs:getPlacedProps()

-- Remove a specific prop
exports.nd_drugs:removeProp(propId)
```

## Integration with md-drugs

If you have md-drugs installed and `Config.UseMDDrugs = true`, the script will trigger events when items are crafted, allowing md-drugs to track drug production.

## Troubleshooting

### Props not appearing
- Check that all dependencies are started before nd_drugs
- Verify the models exist in your game files
- Check server console for errors

### Cannot place props
- Ensure you have the correct items in your inventory
- Check that you're not too close to another prop
- Verify ox_inventory is working correctly

### Interactions not working
- Ensure ox_target is properly configured
- Check that third eye/target is working with other resources
- Verify distance settings in config

## Support

For issues and feature requests, please visit the GitHub repository.

## Credits

- Created for Neon Dream
- Uses ox_lib, ox_target, ox_inventory
- Compatible with qbx_core and md-drugs

## License

This resource is provided as-is for use on FiveM servers.
