# ox_lib & ox_inventory Integration Guide

This guide shows how to integrate the fertilizer items with ox_lib and ox_inventory.

## Requirements

- ox_lib installed and started
- ox_inventory installed and started (optional but recommended)

## Installation Steps

### Step 1: Ensure ox_lib is installed

Add to your `server.cfg` before Nd_Scripts:

```cfg
ensure ox_lib
ensure ox_inventory
ensure Nd_Scripts
```

### Step 2: Add items to ox_inventory

Open `ox_inventory/data/items.lua` and add the following items (or copy from `shared/ox_items.lua`):

```lua
['growth_fertilizer'] = {
    label = 'Growth Fertilizer',
    weight = 100,
    stack = true,
    close = true,
    description = 'A special fertilizer that speeds up plant growth by 25%',
    client = {
        image = 'growth_fertilizer.png',
    }
},

['yield_fertilizer'] = {
    label = 'Yield Fertilizer',
    weight = 100,
    stack = true,
    close = true,
    description = 'A nutrient-rich fertilizer that increases harvest yield by 50%',
    client = {
        image = 'yield_fertilizer.png',
    }
},

['super_serum'] = {
    label = 'Super Serum',
    weight = 150,
    stack = true,
    close = true,
    description = 'The ultimate plant enhancer! Increases growth speed by 40% and yield by 75%',
    client = {
        image = 'super_serum.png',
    }
},
```

### Step 3: Register useable items

The script automatically detects ox_inventory and handles item usage. However, you need to register the items as useable.

Create or add to your item usage handler:

```lua
-- In your resource that handles item usage
exports('growth_fertilizer', function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        TriggerEvent('Nd_Scripts:client:useGrowthFertilizer')
    end
end)

exports('yield_fertilizer', function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        TriggerEvent('Nd_Scripts:client:useYieldFertilizer')
    end
end)

exports('super_serum', function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        TriggerEvent('Nd_Scripts:client:useSuperSerum')
    end
end)
```

### Step 4: Add item images

Place item images in: `ox_inventory/web/images/`

**Image files needed:**
- `growth_fertilizer.png`
- `yield_fertilizer.png`
- `super_serum.png`

### Step 5: Add to shops (optional)

If using ox_inventory shops, add to your shop config:

```lua
Config.Shops = {
    FarmingSupply = {
        name = 'Farming Supply Store',
        groups = {},
        blip = {
            id = 480, sprite = 480, colour = 2, scale = 0.8
        },
        inventory = {
            { name = 'growth_fertilizer', price = 50 },
            { name = 'yield_fertilizer', price = 75 },
            { name = 'super_serum', price = 150 },
        },
        locations = {
            vec3(2230.45, 5577.89, 53.73)  -- Example location
        },
        targets = {}
    }
}
```

## Testing

In-game commands for testing:

```
/plant tomato          - Plant a test crop
/usefertilizer super_serum - Apply super serum to nearby plant
```

## Advanced: Using with ox_target

If you want to use ox_target for plant interaction:

```lua
-- In your plant creation script
exports.ox_target:addLocalEntity(plantEntity, {
    {
        name = 'apply_fertilizer',
        icon = 'fas fa-spray-can',
        label = 'Apply Fertilizer',
        onSelect = function()
            -- Trigger fertilizer menu or direct application
            TriggerEvent('Nd_Scripts:client:useGrowthFertilizer')
        end,
        distance = 2.0
    },
    {
        name = 'harvest_plant',
        icon = 'fas fa-hand-holding',
        label = 'Harvest Plant',
        onSelect = function()
            TriggerServerEvent('nd_farming:harvestPlant', plantId)
        end,
        distance = 2.0,
        canInteract = function()
            return isPlantReady
        end
    }
})
```

## Features with ox_lib

- ✅ Modern notifications with ox_lib
- ✅ Automatic framework detection
- ✅ ox_inventory integration
- ✅ Optimized performance
- ✅ No additional dependencies

## Compatibility

| Component | Status |
|-----------|--------|
| ox_lib | ✅ Full support |
| ox_inventory | ✅ Full support |
| ox_target | ✅ Compatible (optional) |
| Standalone | ✅ Yes |
| QBX-Core | ✅ Yes |
| QBCore | ✅ Yes |
| ESX | ✅ Yes |

## Performance Notes

- ox_lib is lightweight and optimized
- ox_inventory handles items efficiently
- No performance impact on server
- Recommended for modern FiveM servers
