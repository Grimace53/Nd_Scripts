# ND Drugs - Advanced Drug System

A comprehensive FiveM drug system featuring placeable growing pots, crafting tables, NPC drug dealers, fertilizers, and plant health monitoring.

## 🌟 Features

### PR #4 Foundation - Growing & Crafting System
- **Placeable Growing Pots**: Place pots anywhere in the world to grow drugs
- **Plant Growth Stages**: Visual progression through 3 growth stages
- **Crafting Tables**: Process raw materials into final products
- **ox_target Integration**: Intuitive interaction system
- **ox_inventory Integration**: Full inventory support
- **Database Persistence**: All placed props saved to MySQL

### PR #2 - Drug Types & NPC Dealers
- **Growable Drugs**: Weed and Cocaine (pot-based)
- **Non-Growable Drugs**: Meth, Heroin, LSD (NPC dealer-based)
- **AI Drug Dealers**: NPCs spawn at configured locations
- **Minigame System**: ox_lib skillcheck integration for dealer interactions
- **Cooldown System**: Location-based cooldowns to prevent abuse
- **Database Tracking**: Full interaction logging

### PR #3 - Fertilizer System
- **Growth Fertilizer**: +25% growth speed
- **Yield Fertilizer**: +50% harvest yield
- **Super Serum**: +40% growth speed, +75% yield
- **One-Time Application**: Apply once per plant cycle
- **Smart Calculations**: Automatic time/yield adjustments

### PR #5 - Plant Health NUI
- **Visual Health Monitor**: Beautiful UI showing plant stats
- **Health Metrics**: Monitor water, light, and fertilizer levels
- **Real-Time Updates**: Live stat degradation over time
- **Interactive Actions**: Water plants to maintain health
- **Health Impact**: Poor health reduces harvest yield

## 📦 Installation

### 1. Dependencies
Ensure you have these resources installed:
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-project/qbx_core)
- [oxmysql](https://github.com/overextended/oxmysql)

### 2. Database Setup
Execute the SQL file to create required tables:
```bash
mysql -u your_user -p your_database < schema.sql
```

Or manually run the SQL in your database management tool.

### 3. Items Configuration
Add items from `items_example.lua` to your `ox_inventory/data/items.lua` file:
- Growing pots (drug_pot, coca_pot)
- Crafting table (craft_table)
- Fertilizers (growth_fertilizer, yield_fertilizer, super_serum)
- Raw materials (weed_leaf, coca_leaf, etc.)
- Drug dealer items (meth_ingredient, heroin_powder, lsd_paper, etc.)
- Final products (weed, coke, meth)

### 4. Resource Installation
1. Place `nd_drugs` folder in your `resources` directory
2. Add to your `server.cfg`:
```
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure qbx_core
ensure oxmysql
ensure nd_drugs
```

### 5. Configuration
Edit `config.lua` to customize:
- Growing times
- Harvest yields
- Crafting recipes
- NPC dealer locations
- Cooldown timers
- Fertilizer multipliers

## 🎮 Usage

### Growing System
1. **Place a Pot**: Use a growing pot item from inventory
2. **Apply Fertilizer** (Optional): Use ox_target → "Apply Fertilizer"
3. **Water Plant**: Keep water levels high for best health
4. **Monitor Health**: Use ox_target → "View Plant Health"
5. **Harvest**: When ready, use ox_target → "Harvest"

### Crafting System
1. **Place Crafting Table**: Use crafting table item from inventory
2. **Select Recipe**: Use ox_target → Choose what to craft
3. **Wait for Progress**: Progress bar shows crafting time
4. **Collect Product**: Automatically added to inventory

### NPC Drug Dealers
1. **Find Dealer**: NPCs spawn at configured locations
2. **Interact**: Use ox_target → "Talk to [Drug] Dealer"
3. **Complete Minigame**: ox_lib skillcheck based on drug type
4. **Receive Items**: Success gives random items based on chance
5. **Cooldown**: Wait before returning to same dealer

### Fertilizer System
- **When to Apply**: Apply fertilizer right after planting for maximum benefit
- **One Per Cycle**: Can only apply one fertilizer per growth cycle
- **Choose Wisely**: 
  - Growth Fertilizer for faster harvests
  - Yield Fertilizer for more items
  - Super Serum for both benefits

### Plant Health System
- **Water**: Decreases 2% per minute, water plants regularly
- **Light**: Varies by time of day (higher during daytime)
- **Fertilizer**: Depletes 1% per minute when applied
- **Health Calculation**: 40% light + 40% water + 20% fertilizer
- **Yield Impact**: Health below 100% reduces harvest amount

## ⚙️ Configuration Examples

### Add a New Growing Pot Type
```lua
Config.GrowingProps = {
    opium_pot = {
        model = 'prop_plant_01a',
        label = 'Opium Poppy Pot',
        item = 'opium_pot',
        growTime = 600000, -- 10 minutes
        stages = {
            {model = 'prop_plant_01a', stage = 1, time = 200000},
            {model = 'prop_plant_01b', stage = 2, time = 400000},
            {model = 'prop_plant_01c', stage = 3, time = 600000}
        },
        reward = {
            item = 'opium_flower',
            min = 2,
            max = 4
        }
    }
}
```

### Add a New Drug Dealer
```lua
Config.NonGrowableDrugs = {
    mdma = {
        label = 'MDMA',
        pedModel = 'a_m_y_clubcust_03',
        locations = {
            {x = 123.45, y = -678.90, z = 12.34, heading = 90.0}
        },
        items = {
            {item = 'mdma_crystal', amount = {min = 1, max = 3}, chance = 60}
        },
        minigameType = 'hacking'
    }
}
```

### Create a Custom Fertilizer
Edit `shared/fertilizers.lua`:
```lua
Fertilizers = {
    mega_boost = {
        name = 'mega_boost',
        label = 'Mega Boost',
        description = 'Extreme enhancement',
        growSpeedMultiplier = 2.0,  -- 100% faster
        yieldMultiplier = 2.0,      -- 100% more yield
        weight = 200
    }
}
```

## 🎯 Commands & Exports

### Server Exports
```lua
-- Get all placed props
local props = exports['nd_drugs']:getPlacedProps()

-- Remove a specific prop
exports['nd_drugs']:removeProp(propId)
```

### Client Exports
```lua
-- Open plant health UI
exports['nd_drugs']:openPlantHealthUI(propId, propData)

-- Get all drug dealer NPCs
local dealers = exports['nd_drugs']:GetDrugDealers()
```

## 🔧 Troubleshooting

### Props Not Saving
- Verify database connection in `oxmysql`
- Check SQL tables were created properly
- Review server console for MySQL errors

### NUI Not Showing
- Clear FiveM cache: `%localappdata%/FiveM/FiveM Application Data/cache`
- Verify `ui_page` and `files` in fxmanifest.lua
- Check browser console (F8 in-game, then browser dev tools)

### NPCs Not Spawning
- Ensure coordinates are valid
- Check Config.NonGrowableDrugs is properly configured
- Verify ox_target is running

### Fertilizers Not Working
- Confirm items are in ox_inventory
- Check shared/fertilizers.lua is loaded
- Verify fertilizer item names match config

## 📝 Database Tables

### drug_placed_props
Tracks all placed growing pots and crafting tables with health data.

### drug_weed / drug_cocaine
Legacy tables for direct drug planting (alternative to pots).

### drug_meth / drug_heroin / drug_lsd
Logs NPC dealer interactions and items received.

### drug_cooldowns
Prevents spam by tracking cooldown timers per player/location.

## 🤝 Support

For issues, questions, or suggestions:
1. Check configuration is correct
2. Review server console for errors
3. Verify all dependencies are up to date
4. Check database tables exist

## 📄 License

See LICENSE file for details.

## 🎉 Credits

- **PR #4**: Foundation with ox framework integration
- **PR #2**: Drug types and NPC dealer system
- **PR #3**: Fertilizer enhancement system
- **PR #5**: Plant health NUI interface

---

**Version**: 2.0.0  
**Framework**: QBX Core + Ox Framework  
**Database**: MySQL (via oxmysql)
