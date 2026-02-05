Config = {}

-- Fertilizer configuration
Config.Fertilizers = {
    -- Growth Fertilizer - increases grow speed
    growth_fertilizer = {
        name = "Growth Fertilizer",
        label = "Growth Fertilizer",
        description = "Increases plant growth speed by 25%",
        growSpeedMultiplier = 1.25,  -- 25% faster growth
        yieldMultiplier = 1.0,        -- No yield change
        useable = true,
        unique = false,
        weight = 100
    },
    
    -- Yield Fertilizer - increases yield
    yield_fertilizer = {
        name = "Yield Fertilizer",
        label = "Yield Fertilizer",
        description = "Increases plant yield by 50%",
        growSpeedMultiplier = 1.0,    -- No speed change
        yieldMultiplier = 1.5,        -- 50% more yield
        useable = true,
        unique = false,
        weight = 100
    },
    
    -- Super Serum - increases both
    super_serum = {
        name = "Super Serum",
        label = "Super Serum",
        description = "Ultimate plant enhancer! Increases growth speed by 40% and yield by 75%",
        growSpeedMultiplier = 1.4,    -- 40% faster growth
        yieldMultiplier = 1.75,       -- 75% more yield
        useable = true,
        unique = false,
        weight = 150
    }
}

-- Plant configuration
Config.Plants = {
    -- Example plant type
    tomato = {
        name = "Tomato Plant",
        baseGrowTime = 600,  -- Base grow time in seconds (10 minutes)
        baseYield = 3,       -- Base number of items harvested
        harvestItem = "tomato"
    },
    
    wheat = {
        name = "Wheat",
        baseGrowTime = 900,  -- 15 minutes
        baseYield = 5,
        harvestItem = "wheat"
    },
    
    corn = {
        name = "Corn",
        baseGrowTime = 1200, -- 20 minutes
        baseYield = 4,
        harvestItem = "corn"
    }
}

-- Fertilizer application settings
Config.MaxFertilizerPerPlant = 1  -- Only one fertilizer can be applied per plant
Config.FertilizerDuration = 3600  -- Fertilizer effect duration in seconds (1 hour)
