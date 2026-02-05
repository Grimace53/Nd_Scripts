# Nd_Scripts - Drug System

A comprehensive drug system for FiveM featuring both growable drugs (plants) and non-growable drugs (AI interactions).

## Features

### Growable Drugs
- Each drug type has its own database table
- Plant seeds in pots that grow over time
- Configurable growth times and harvest amounts
- Visual pot objects in the game world
- Anyone can harvest mature plants

### Non-Growable Drugs
- AI-controlled dealers at specific locations (vec4)
- Interactive minigames to obtain items
- Configurable item drops with chance-based rewards
- Location-based cooldown system
- Multiple items can be obtained from each interaction

## Installation

1. **Database Setup**
   - Import the `schema.sql` file to your database, OR
   - Let the script auto-create tables on first start
   - The script will create a table for each drug type defined in config

2. **Dependencies**
   - `oxmysql` - For database operations
   - An inventory system (ox_inventory, qb-inventory, etc.)
   - Optional: Minigame resource (ox_lib, ps-ui, qb-skillcheck, etc.)

3. **Configuration**
   - Edit `config.lua` to customize:
     - Drug types and properties
     - Growth times and harvest amounts
     - AI locations (vec4 coordinates)
     - Item drops and chances
     - Minigame types and difficulty
     - Cooldown times

4. **Resource Start**
   - Add `ensure nd_drugs` to your `server.cfg`
   - Restart your server or start the resource with `/start nd_drugs`

## Configuration Guide

### Adding a Growable Drug

```lua
Config.Drugs.newdrug = {
    label = "New Drug",
    growable = true,
    growTime = 600000, -- Time in milliseconds
    harvestAmount = {min = 2, max = 5},
    requiredItem = "newdrug_seed", -- Item needed to plant
    harvestedItem = "newdrug_bud", -- Item received on harvest
    potModel = "prop_plant_01a", -- 3D model for the pot
}
```

### Adding a Non-Growable Drug

```lua
Config.Drugs.newdrug = {
    label = "New Drug",
    growable = false,
    locations = {
        {x = 100.0, y = 200.0, z = 30.0, heading = 90.0},
        -- Add more locations as needed
    },
    pedModel = "a_m_m_business_01", -- NPC model
    items = {
        {item = "drug_item1", amount = {min = 1, max = 3}, chance = 70},
        {item = "drug_item2", amount = {min = 1, max = 2}, chance = 50},
    },
    minigameType = "lockpick", -- or "hacking", "skillcheck"
}
```

## Database Tables

Each drug type gets its own table:

### Growable Drugs
- `drug_[drugtype]` - Stores planted drug information
  - `id` - Unique plant ID
  - `identifier` - Player identifier
  - `planted_at` - Timestamp of planting
  - `position` - JSON coordinates
  - `growth_stage` - Growth stage (0: planted, 1: growing, 2: ready)
  - `last_watered` - Last watering time (optional)
  - `harvestable` - Boolean flag

### Non-Growable Drugs
- `drug_[drugtype]` - Stores interaction history
  - `id` - Unique interaction ID
  - `identifier` - Player identifier
  - `location_index` - Which location was used
  - `last_interaction` - Timestamp
  - `items_received` - JSON array of items

### Cooldowns
- `drug_cooldowns` - Tracks cooldowns for non-growable drug locations
  - `identifier` - Player identifier
  - `drug_type` - Type of drug
  - `location_index` - Location index
  - `cooldown_until` - Cooldown expiration timestamp

## Usage

### For Players

**Growable Drugs:**
1. Obtain seeds (defined in config as `requiredItem`)
2. Use the seed item to plant
3. Wait for the growth time
4. Return and press `E` to harvest

**Non-Growable Drugs:**
1. Find AI dealer locations (vec4 coordinates in config)
2. Approach the dealer and press `E`
3. Complete the minigame
4. Receive items based on chance
5. Wait for cooldown before interacting again

### For Developers

**Inventory Integration:**
The script uses ox_inventory by default. To integrate with other inventory systems, modify:
- `server/growable.lua` - Lines with `exports.ox_inventory`
- `server/nongrowable.lua` - Lines with `exports.ox_inventory`

**Notification System:**
Edit `client/utils.lua` to integrate with your notification system (QBCore, ESX, ox_lib, etc.)

**Minigame Integration:**
Edit `client/nongrowable.lua` in the `startMinigame` event to integrate with your minigame system:
- ox_lib skillcheck
- ps-ui minigames
- qb-skillcheck
- Custom minigames

## Exports

### Server
```lua
-- Get player identifier
local identifier = exports['nd_drugs']:GetPlayerIdentifier(source)
```

### Client
```lua
-- Plant a drug
exports['nd_drugs']:PlantDrug('weed')

-- Get spawned peds
local peds = exports['nd_drugs']:GetSpawnedPeds()
```

## Events

### Server Events
- `nd_drugs:server:plantDrug` - Plant a drug seed
- `nd_drugs:server:harvestDrug` - Harvest a mature plant
- `nd_drugs:server:waterPlant` - Water a plant (optional)
- `nd_drugs:server:startMinigame` - Start AI interaction minigame
- `nd_drugs:server:minigameSuccess` - Handle successful minigame
- `nd_drugs:server:minigameFailed` - Handle failed minigame
- `nd_drugs:server:loadPlants` - Load all plants for a player

### Client Events
- `nd_drugs:client:spawnPot` - Spawn a pot object
- `nd_drugs:client:updatePotStage` - Update pot growth stage
- `nd_drugs:client:removePot` - Remove a pot object
- `nd_drugs:client:startMinigame` - Start minigame UI
- `nd_drugs:client:cooldownStatus` - Update cooldown status
- `nd_drugs:client:notify` - Show notification
- `nd_drugs:client:useSeed` - Use a seed item

## Support

For issues, questions, or contributions, please visit the GitHub repository.

## License

This project is open source. Feel free to modify and use it for your server.
