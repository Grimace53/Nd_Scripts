-- ox_inventory item definitions
-- Add these to your ox_inventory/data/items.lua file

return {
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
}
