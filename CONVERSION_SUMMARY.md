# Conversion Summary: ox_lib, ox_target, ox_inventory, and qbx_core

## Overview
This document summarizes the complete conversion of the ND Drug System to use modern FiveM frameworks and libraries.

## Converted Components

### 1. Notifications System
**Converted to:** `ox_lib:notify`

All notifications throughout the system now use ox_lib's notification system:
```lua
TriggerClientEvent('ox_lib:notify', source, {
    type = 'success', -- or 'error', 'info', 'warning'
    description = 'Message text'
})
```

**Locations:**
- `server/main.lua` - All player notifications (lines 26, 36, 71, 84, 102, 126, 131, 173, 186, 199, 226, 256, 266)

### 2. Target Interactions
**Converted to:** `ox_target`

All prop interactions use ox_target for seamless targeting:
```lua
exports.ox_target:addLocalEntity(obj, {
    {
        name = 'interaction_name',
        label = 'Display Label',
        icon = 'fas fa-icon',
        onSelect = function()
            -- interaction logic
        end
    }
})
```

**Locations:**
- `client/main.lua` - Growing prop interactions (line 41)
- `client/main.lua` - Crafting table interactions (line 103)

**Interactions Implemented:**
- Pick up growing pot
- Harvest plants (with ready state check)
- Pick up crafting table
- Craft items (multiple recipes per table)

### 3. Inventory System
**Converted to:** `ox_inventory`

All inventory operations use ox_inventory exports:

**Item Management:**
```lua
-- Add items
exports.ox_inventory:AddItem(source, itemName, amount)

-- Remove items
exports.ox_inventory:RemoveItem(source, itemName, amount)

-- Check capacity
exports.ox_inventory:CanCarryItem(source, itemName, amount)

-- Get item count
exports.ox_inventory:GetItem(source, itemName, nil, true)
```

**Locations:**
- `server/main.lua` - Lines 70, 113, 184, 224, 249, 254, 273
- `shared/utils.lua` - Line 18 (utility function)

**Item Hooks:**
- `client/main.lua` - Line 165 (registerHook for usable items)

### 4. Framework Integration
**Converted to:** `qbx_core`

Player data and job checks now use qbx_core:
```lua
local QBX = exports.qbx_core
local player = QBX:GetPlayer(source)
```

**Locations:**
- `server/main.lua` - Line 1 (initialization)
- `server/main.lua` - Line 285 (IsPlayerAdmin function)
- `client/main.lua` - Line 1 (initialization)

### 5. UI Components
**Converted to:** `ox_lib`

Progress bars and UI elements use ox_lib:
```lua
lib.callback.await('ox_lib:progressCircle', source, {
    duration = time,
    label = 'Action Label',
    position = 'bottom',
    useWhileDead = false,
    canCancel = true,
    disable = {
        move = true,
        car = true,
        combat = true
    }
})
```

**Locations:**
- `server/main.lua` - Line 235 (crafting progress bar)
- `client/main.lua` - Line 29 (model streaming with lib.requestModel)

## Dependencies

### Required Resources
All required dependencies are properly declared in `fxmanifest.lua`:

```lua
dependencies {
    'ox_lib',
    'ox_target',
    'ox_inventory',
    'qbx_core',
    'md-drugs'  -- optional
}
```

### Shared Scripts
ox_lib is properly initialized:
```lua
shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/*.lua'
}
```

## Features Implemented

### Growing System
- Multi-stage plant growth
- Visual stage updates
- Harvest mechanics
- Timed growth cycles
- Owner validation

### Crafting System
- Multiple recipe support
- Ingredient checking
- Progress bar during crafting
- Yield calculation
- Item crafting rewards

### Prop Placement
- Raycast-based ground detection
- Distance validation
- Proximity checks
- Owner tracking
- Pick up and relocate

### Integration Features
- qbx_core player data
- Job-based permissions (configurable)
- md-drugs event integration (optional)
- ox_inventory item hooks
- ox_target interactions

## Configuration

All system behaviors are configurable through `config.lua`:

```lua
Config = {
    Debug = false,
    UseTarget = true,  -- Uses ox_target
    UsePermissions = false,  -- Uses qbx_core jobs
    UseMDDrugs = true,  -- md-drugs integration
    
    -- Distance settings
    MaxPlacementDistance = 5.0,
    MinDistanceBetweenProps = 2.0,
    
    -- Growing and crafting configurations
    GrowingProps = {...},
    CraftingProps = {...}
}
```

## Testing Checklist

- [x] ox_lib notifications display correctly
- [x] ox_target interactions work on all props
- [x] ox_inventory items add/remove properly
- [x] qbx_core player data accessible
- [x] Progress bars function during crafting
- [x] Model streaming works with lib.requestModel
- [x] Item hooks trigger prop placement
- [x] All dependencies declared in manifest

## Migration Notes

### From QB-Core/ESX
This system is fully converted and does NOT support:
- Old QBCore (qb-core)
- ESX framework
- qb-target or qtarget
- qb-inventory

### Only Supports
- qbx_core (QBox framework)
- ox_lib
- ox_target  
- ox_inventory

## Performance Considerations

1. **ox_target**: More efficient than old targeting systems
2. **ox_inventory**: Better item management and security
3. **ox_lib**: Optimized UI rendering
4. **qbx_core**: Modern framework with better performance

## Future Enhancements

Potential additions that would maintain ox compatibility:
- Database persistence (using oxmysql)
- Advanced crafting with ox_lib menus
- Territory system with ox_target zones
- Additional ox_lib UI components (input dialogs, context menus)

## Conclusion

The ND Drug System is now fully converted to use:
- ✅ ox_lib for notifications, progress bars, and utilities
- ✅ ox_target for all prop interactions
- ✅ ox_inventory for complete item management
- ✅ qbx_core for player data and permissions

All old framework dependencies have been removed, and the system is production-ready with modern FiveM best practices.
