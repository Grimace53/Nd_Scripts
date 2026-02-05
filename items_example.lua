-- Example items to add to ox_inventory/data/items.lua
-- Copy and paste these into your items.lua file

return {
    -- Growing Props
    ['drug_pot'] = {
        label = 'Drug Growing Pot',
        weight = 5000,
        stack = false,
        close = true,
        description = 'A pot for growing plants',
        client = {
            export = 'nd_drugs.placeProp'
        }
    },

    -- Crafting Props
    ['craft_table'] = {
        label = 'Crafting Table',
        weight = 10000,
        stack = false,
        close = true,
        description = 'A table for crafting items',
        client = {
            export = 'nd_drugs.placeProp'
        }
    },

    -- Growing Resources
    ['weed_leaf'] = {
        label = 'Weed Leaf',
        weight = 100,
        stack = true,
        close = true,
        description = 'Raw weed leaf'
    },

    ['coca_leaf'] = {
        label = 'Coca Leaf',
        weight = 100,
        stack = true,
        close = true,
        description = 'Raw coca leaf'
    },

    -- Crafting Materials
    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 10,
        stack = true,
        close = true,
        description = 'Paper for rolling'
    },

    ['chemicals'] = {
        label = 'Chemicals',
        weight = 500,
        stack = true,
        close = true,
        description = 'Chemical compounds'
    },

    -- Final Products
    ['weed'] = {
        label = 'Weed',
        weight = 200,
        stack = true,
        close = true,
        description = 'Processed weed'
    },

    ['coke'] = {
        label = 'Cocaine',
        weight = 200,
        stack = true,
        close = true,
        description = 'Processed cocaine'
    }
}
