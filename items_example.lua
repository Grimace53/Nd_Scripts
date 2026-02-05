--[[
    Example Items Configuration
    
    This file shows example item definitions for use with ox_inventory or qb-inventory.
    Add these to your items.lua or shared/items.lua file in your inventory resource.
]]

-- SEEDS (for growable drugs)
['weed_seed'] = {
    label = 'Weed Seed',
    weight = 10,
    stack = true,
    close = true,
    description = 'A seed that can be planted to grow weed',
},

['coca_seed'] = {
    label = 'Coca Seed',
    weight = 10,
    stack = true,
    close = true,
    description = 'A seed that can be planted to grow cocaine',
},

-- HARVESTED ITEMS (from growable drugs)
['weed_bud'] = {
    label = 'Weed Bud',
    weight = 50,
    stack = true,
    close = true,
    description = 'Fresh weed bud ready for processing',
},

['coca_leaf'] = {
    label = 'Coca Leaf',
    weight = 30,
    stack = true,
    close = true,
    description = 'Raw coca leaf for cocaine production',
},

-- METH ITEMS (from AI interactions)
['meth_ingredient'] = {
    label = 'Meth Ingredient',
    weight = 100,
    stack = true,
    close = true,
    description = 'Basic ingredient for meth production',
},

['meth_chemical'] = {
    label = 'Meth Chemical',
    weight = 150,
    stack = true,
    close = true,
    description = 'Chemical compound for meth synthesis',
},

-- HEROIN ITEMS (from AI interactions)
['heroin_ingredient'] = {
    label = 'Heroin Ingredient',
    weight = 80,
    stack = true,
    close = true,
    description = 'Raw ingredient for heroin production',
},

['heroin_powder'] = {
    label = 'Heroin Powder',
    weight = 120,
    stack = true,
    close = true,
    description = 'Refined heroin powder',
},

-- LSD ITEMS (from AI interactions)
['lsd_paper'] = {
    label = 'LSD Paper',
    weight = 5,
    stack = true,
    close = true,
    description = 'Paper tabs for LSD',
},

['lsd_liquid'] = {
    label = 'LSD Liquid',
    weight = 20,
    stack = true,
    close = true,
    description = 'Liquid LSD solution',
},

--[[
    For ox_inventory, you can also register usable items:
    
    -- In server/main.lua or similar
    exports.ox_inventory:registerUsableItem('weed_seed', function(source, item, inventory)
        TriggerClientEvent('nd_drugs:client:useSeed', source, 'weed')
    end)
    
    exports.ox_inventory:registerUsableItem('coca_seed', function(source, item, inventory)
        TriggerClientEvent('nd_drugs:client:useSeed', source, 'cocaine')
    end)
]]
