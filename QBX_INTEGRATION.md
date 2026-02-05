# QBX-Core Integration Guide

This guide shows how to integrate the fertilizer items with QBX-Core (QBCore fork).

## What is QBX-Core?

QBX-Core is an optimized fork of QBCore with better performance and native ox_lib support.

## Installation Steps

### Step 1: Add items to qbx_core

Open `qbx_core/shared/items.lua` and add the following items:

```lua
-- Growth Fertilizer
['growth_fertilizer'] = {
    name = 'growth_fertilizer',
    label = 'Growth Fertilizer',
    weight = 100,
    type = 'item',
    image = 'growth_fertilizer.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'A special fertilizer that speeds up plant growth by 25%'
},

-- Yield Fertilizer
['yield_fertilizer'] = {
    name = 'yield_fertilizer',
    label = 'Yield Fertilizer',
    weight = 100,
    type = 'item',
    image = 'yield_fertilizer.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'A nutrient-rich fertilizer that increases harvest yield by 50%'
},

-- Super Serum
['super_serum'] = {
    name = 'super_serum',
    label = 'Super Serum',
    weight = 150,
    type = 'item',
    image = 'super_serum.png',
    unique = false,
    useable = true,
    shouldClose = true,
    combinable = nil,
    description = 'The ultimate plant enhancer! Increases growth speed by 40% and yield by 75%'
},
```

### Step 2: Register useable items

The script automatically detects QBX-Core. Add item callbacks for proper integration:

```lua
-- Register useable items in your resource or qbx_core
exports.qbx_core:CreateUseableItem('growth_fertilizer', function(source, item)
    TriggerClientEvent('Nd_Scripts:client:useGrowthFertilizer', source)
end)

exports.qbx_core:CreateUseableItem('yield_fertilizer', function(source, item)
    TriggerClientEvent('Nd_Scripts:client:useYieldFertilizer', source)
end)

exports.qbx_core:CreateUseableItem('super_serum', function(source, item)
    TriggerClientEvent('Nd_Scripts:client:useSuperSerum', source)
end)
```

### Step 3: Add item images

**For qb-inventory:**
- Place images in: `qb-inventory/html/images/`

**For ox_inventory (with QBX):**
- Place images in: `ox_inventory/web/images/`

**Image files needed:**
- `growth_fertilizer.png`
- `yield_fertilizer.png`
- `super_serum.png`

### Step 4: Add to shops (optional)

If using qb-shops or qbx-shops:

```lua
Config.Shops = {
    ['farming_shop'] = {
        ['label'] = 'Farming Supply Store',
        ['items'] = {
            [1] = {
                name = 'growth_fertilizer',
                price = 50,
                amount = 50,
                info = {},
                type = 'item',
                slot = 1,
            },
            [2] = {
                name = 'yield_fertilizer',
                price = 75,
                amount = 50,
                info = {},
                type = 'item',
                slot = 2,
            },
            [3] = {
                name = 'super_serum',
                price = 150,
                amount = 25,
                info = {},
                type = 'item',
                slot = 3,
            },
        },
        ['locations'] = {
            vector3(2230.45, 5577.89, 53.73),  -- Example location
        },
    }
}
```

## Advanced Integration

### Using with ox_lib (QBX compatible)

QBX-Core works seamlessly with ox_lib. The script automatically uses:
- ox_lib notifications if available
- QBX notifications as fallback

### Database integration (optional)

If you want to track fertilizer usage:

```sql
CREATE TABLE IF NOT EXISTS `fertilizer_usage` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `citizenid` VARCHAR(50) NOT NULL,
    `fertilizer_type` VARCHAR(50) NOT NULL,
    `plant_id` VARCHAR(100) NOT NULL,
    `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### Using qbx-target

```lua
exports['qbx-target']:AddTargetEntity(plantEntity, {
    options = {
        {
            type = 'client',
            event = 'Nd_Scripts:client:useGrowthFertilizer',
            icon = 'fas fa-spray-can',
            label = 'Apply Growth Fertilizer',
        },
        {
            type = 'client',
            event = 'Nd_Scripts:client:useYieldFertilizer',
            icon = 'fas fa-spray-can',
            label = 'Apply Yield Fertilizer',
        },
        {
            type = 'client',
            event = 'Nd_Scripts:client:useSuperSerum',
            icon = 'fas fa-syringe',
            label = 'Apply Super Serum',
        },
    },
    distance = 2.0
})
```

### Using ox_target (also compatible with QBX)

```lua
exports.ox_target:addLocalEntity(plantEntity, {
    {
        name = 'apply_growth_fertilizer',
        icon = 'fas fa-spray-can',
        label = 'Apply Growth Fertilizer',
        onSelect = function()
            TriggerEvent('Nd_Scripts:client:useGrowthFertilizer')
        end,
        distance = 2.0
    }
})
```

## Testing

In-game commands:

```
/plant tomato          - Plant a test crop
/usefertilizer super_serum - Apply super serum
```

## QBX-Core Specific Features

- ✅ Automatic framework detection
- ✅ Player.Functions.AddItem integration
- ✅ Player.Functions.RemoveItem integration
- ✅ QBX notification support
- ✅ ox_lib compatibility
- ✅ Modern code structure

## Compatibility Matrix

| Component | Status |
|-----------|--------|
| QBX-Core | ✅ Full support |
| qb-inventory | ✅ Compatible |
| ox_inventory | ✅ Compatible |
| ps-inventory | ✅ Compatible |
| qbx-target | ✅ Compatible |
| ox_target | ✅ Compatible |
| ox_lib notifications | ✅ Compatible |
| QBX native notifications | ✅ Compatible |

## Migration from QBCore to QBX

If migrating from QBCore:

1. Update `server.cfg`: Change `qb-core` to `qbx_core`
2. Restart server
3. Script automatically detects QBX
4. No code changes needed!

## Performance Notes

- QBX-Core is an optimized fork of QBCore
- Better performance than legacy QB
- Native ox_lib support
- Recommended for new servers

## Support & Resources

- **QBX-Core**: [https://github.com/Qbox-project/qbx_core](https://github.com/Qbox-project/qbx_core)
- **ox_lib**: [https://github.com/overextended/ox_lib](https://github.com/overextended/ox_lib)
- **Documentation**: See README.md
