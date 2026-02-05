-- Shared items definitions for fertilizers
-- This file can be added to your QBCore/ESX shared items configuration

Items = {}

-- Growth Fertilizer Item
Items['growth_fertilizer'] = {
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
}

-- Yield Fertilizer Item
Items['yield_fertilizer'] = {
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
}

-- Super Serum Item
Items['super_serum'] = {
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
}

-- Export items for use in other scripts
if IsDuplicityVersion() then
    -- Server-side export
    exports('GetFertilizerItems', function()
        return Items
    end)
else
    -- Client-side export
    exports('GetFertilizerItems', function()
        return Items
    end)
end
