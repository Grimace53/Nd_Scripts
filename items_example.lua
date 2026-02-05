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
    
    ['coca_pot'] = {
        label = 'Coca Growing Pot',
        weight = 5000,
        stack = false,
        close = true,
        description = 'A pot for growing coca plants',
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

    -- Fertilizers (PR #3)
    ['growth_fertilizer'] = {
        label = 'Growth Fertilizer',
        weight = 100,
        stack = true,
        close = true,
        description = 'Increases plant growth speed by 25%'
    },
    
    ['yield_fertilizer'] = {
        label = 'Yield Fertilizer',
        weight = 100,
        stack = true,
        close = true,
        description = 'Increases plant yield by 50%'
    },
    
    ['super_serum'] = {
        label = 'Super Serum',
        weight = 150,
        stack = true,
        close = true,
        description = 'Ultimate plant enhancer! Increases growth speed by 40% and yield by 75%'
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
    },
    
    ['meth'] = {
        label = 'Meth',
        weight = 200,
        stack = true,
        close = true,
        description = 'Processed meth'
    },
    
    -- Non-Growable Drug Items (PR #2)
    ['meth_ingredient'] = {
        label = 'Meth Ingredient',
        weight = 150,
        stack = true,
        close = true,
        description = 'Basic ingredient for meth production'
    },
    
    ['meth_chemical'] = {
        label = 'Meth Chemical',
        weight = 200,
        stack = true,
        close = true,
        description = 'Chemical needed for meth synthesis'
    },
    
    ['heroin_ingredient'] = {
        label = 'Heroin Ingredient',
        weight = 150,
        stack = true,
        close = true,
        description = 'Basic ingredient for heroin'
    },
    
    ['heroin_powder'] = {
        label = 'Heroin Powder',
        weight = 100,
        stack = true,
        close = true,
        description = 'Refined heroin powder'
    },
    
    ['lsd_paper'] = {
        label = 'LSD Paper',
        weight = 10,
        stack = true,
        close = true,
        description = 'Blotter paper for LSD'
    },
    
    ['lsd_liquid'] = {
        label = 'LSD Liquid',
        weight = 50,
        stack = true,
        close = true,
        description = 'Liquid LSD solution'
    }
}
