--[[
    ESX Integration Guide
    
    This file shows how to integrate the fertilizer items with ESX.
    Follow these steps to add the items to your ESX server.
]]

--[[
    Step 1: Add items to your database
    
    Run the following SQL in your database:
]]

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
    ('growth_fertilizer', 'Growth Fertilizer', 100, 0, 1),
    ('yield_fertilizer', 'Yield Fertilizer', 100, 0, 1),
    ('super_serum', 'Super Serum', 150, 0, 1);

--[[
    Step 2: Register item usage
    
    Add the following to your es_extended/server/main.lua or create a separate resource:
]]

ESX.RegisterUsableItem('growth_fertilizer', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('Nd_Scripts:client:useGrowthFertilizer', source)
        xPlayer.removeInventoryItem('growth_fertilizer', 1)
    end
end)

ESX.RegisterUsableItem('yield_fertilizer', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('Nd_Scripts:client:useYieldFertilizer', source)
        xPlayer.removeInventoryItem('yield_fertilizer', 1)
    end
end)

ESX.RegisterUsableItem('super_serum', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer then
        TriggerClientEvent('Nd_Scripts:client:useSuperSerum', source)
        xPlayer.removeInventoryItem('super_serum', 1)
    end
end)

--[[
    Step 3: Add item images
    
    Create or obtain images for the fertilizers and place them in your inventory resource:
    For esx_inventoryhud: html/img/items/
    For other inventories: check the documentation
    
    Image files needed:
    - growth_fertilizer.png
    - yield_fertilizer.png
    - super_serum.png
]]

--[[
    Step 4: Add to shops (optional)
    
    Example for esx_shops or any shop system:
]]

-- In esx_shops config or your custom shop

Config.Shops = {
    FarmingShop = {
        Type = "farming",
        Locations = {
            {x = 2230.45, y = 5577.89, z = 53.73}  -- Example location
        },
        Items = {
            {name = "growth_fertilizer", price = 50},
            {name = "yield_fertilizer", price = 75},
            {name = "super_serum", price = 150}
        }
    }
}

--[[
    Alternative: Add to existing shops
]]

-- In esx_shops/config.lua
Config.Items = {
    -- ... existing items ...
    
    growth_fertilizer = {
        price = 50,
        label = 'Growth Fertilizer'
    },
    
    yield_fertilizer = {
        price = 75,
        label = 'Yield Fertilizer'
    },
    
    super_serum = {
        price = 150,
        label = 'Super Serum'
    }
}

--[[
    Step 5: Client event handlers
    
    The client-side handlers are already implemented in client/main.lua.
    They will be triggered when a player uses the items.
]]

--[[
    Optional: Crafting recipes
    
    If you have a crafting system, you can add recipes:
]]

-- Example for esx_crafting or similar
Config.CraftingRecipes = {
    growth_fertilizer = {
        label = 'Growth Fertilizer',
        items = {
            {name = 'water', amount = 2},
            {name = 'fertilizer_base', amount = 1}
        },
        craftTime = 5000,
        amount = 1
    },
    
    yield_fertilizer = {
        label = 'Yield Fertilizer',
        items = {
            {name = 'water', amount = 2},
            {name = 'fertilizer_base', amount = 1},
            {name = 'nutrients', amount = 1}
        },
        craftTime = 5000,
        amount = 1
    },
    
    super_serum = {
        label = 'Super Serum',
        items = {
            {name = 'growth_fertilizer', amount = 1},
            {name = 'yield_fertilizer', amount = 1},
            {name = 'chemicals', amount = 1}
        },
        craftTime = 10000,
        amount = 1
    }
}
