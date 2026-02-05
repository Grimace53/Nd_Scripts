# Installation Guide

This guide will walk you through the complete installation process for the ND Drug System.

## Prerequisites

Before installing, ensure you have the following resources installed on your FiveM server:

1. **ox_lib** - https://github.com/overextended/ox_lib
2. **ox_target** - https://github.com/overextended/ox_target
3. **ox_inventory** - https://github.com/overextended/ox_inventory
4. **qbx_core** - https://github.com/Qbox-project/qbx_core
5. **md-drugs** (optional) - https://github.com/Mustache-Mods/md-drugs

## Step-by-Step Installation

### 1. Download the Resource

Clone or download this repository into your server's resources folder:

```bash
cd resources
git clone https://github.com/Grimace53/Nd_Scripts.git nd_drugs
```

Or download the ZIP file and extract it to `resources/nd_drugs`

### 2. Configure ox_inventory Items

Open `ox_inventory/data/items.lua` and add the items from `items_example.lua`.

You can either:
- Copy the entire contents of `items_example.lua` into your items.lua
- Or manually add each item definition

**Important Items to Add:**
- `drug_pot` - The placeable growing pot
- `craft_table` - The placeable crafting table
- `weed_leaf`, `coca_leaf` - Raw materials from growing
- `rolling_paper`, `chemicals` - Crafting materials
- `weed`, `coke` - Final products

### 3. Update server.cfg

Add the resource to your `server.cfg` file. Make sure it's started **after** all dependencies:

```cfg
# Dependencies
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qbx_core

# Optional
ensure md-drugs

# ND Drug System
ensure nd_drugs
```

### 4. Configure the Resource (Optional)

Edit `config.lua` to customize the resource to your needs:

```lua
-- Example: Change growth time to 10 minutes
Config.GrowingProps.pot.growTime = 600000

-- Example: Add a new crafting recipe
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

### 5. Restart Your Server

Restart your FiveM server to load the new resource:

```bash
restart nd_drugs
```

Or if starting fresh:
```bash
refresh
start nd_drugs
```

## Verification

To verify the installation was successful:

1. **Check Server Console**: Look for any errors related to nd_drugs
2. **Test in Game**: 
   - Give yourself a `drug_pot` item: `/giveitem [your_id] drug_pot 1`
   - Try to place it in-game
   - Verify you can interact with it using ox_target

## Common Issues

### Resource Not Starting

**Problem**: Resource fails to start
**Solution**: 
- Check that all dependencies are installed and started first
- Verify the resource folder name matches what's in server.cfg
- Check server console for specific error messages

### Items Not Working

**Problem**: Items don't appear or can't be used
**Solution**:
- Verify items are added to ox_inventory/data/items.lua
- Restart ox_inventory after adding items
- Check item names match exactly (case-sensitive)

### Props Not Appearing

**Problem**: Props don't spawn when placed
**Solution**:
- Verify the models exist in your game files
- Check Config.lua for correct model names
- Try different models if default ones don't work

### Interactions Not Working

**Problem**: ox_target interactions don't appear
**Solution**:
- Ensure ox_target is properly installed and working
- Test ox_target with other resources
- Check Config.UseTarget is set to true

## Getting Items In-Game

Use these commands to get items for testing (admin only):

```
/giveitem [player_id] drug_pot 1
/giveitem [player_id] craft_table 1
/giveitem [player_id] weed_leaf 10
/giveitem [player_id] rolling_paper 10
```

## Support

For additional help:
- Check the main README.md
- Review the CHANGELOG.md for version updates
- Submit issues on the GitHub repository

## Next Steps

After installation:
1. Test the growing system by placing a pot
2. Test the crafting system by placing a table
3. Adjust config.lua to match your server's needs
4. Integrate with your existing drug systems if applicable
