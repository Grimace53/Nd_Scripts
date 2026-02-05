--[[
    QBCore Integration Guide
    
    This file shows how to integrate the fertilizer items with QBCore.
    Follow these steps to add the items to your QBCore server.
]]

--[[
    Step 1: Add items to qb-core/shared/items.lua
    
    Copy the following items into your qb-core/shared/items.lua file:
]]

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

--[[
    Step 2: Register item usage in qb-core or your inventory resource
    
    Add the following to your item usage handler (usually in qb-inventory or qb-core):
]]

-- In qb-inventory/server/main.lua or qb-core/server/main.lua

QBCore.Functions.CreateUseableItem('growth_fertilizer', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('Nd_Scripts:client:useGrowthFertilizer', source)
    end
end)

QBCore.Functions.CreateUseableItem('yield_fertilizer', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('Nd_Scripts:client:useYieldFertilizer', source)
    end
end)

QBCore.Functions.CreateUseableItem('super_serum', function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        TriggerClientEvent('Nd_Scripts:client:useSuperSerum', source)
    end
end)

--[[
    Step 3: Handle the client events in client/main.lua (already added)
    
    The client-side handlers are already implemented in client/main.lua:
    - Nd_Scripts:client:useGrowthFertilizer
    - Nd_Scripts:client:useYieldFertilizer
    - Nd_Scripts:client:useSuperSerum
]]

--[[
    Step 4: Add item images
    
    Create or obtain images for the fertilizers and place them in:
    qb-inventory/html/images/
    
    Image files needed:
    - growth_fertilizer.png
    - yield_fertilizer.png
    - super_serum.png
]]

--[[
    Step 5: Add to shops (optional)
    
    Example for qb-shops or any shop system:
]]

-- In qb-shops/config.lua or your shop config

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
}
