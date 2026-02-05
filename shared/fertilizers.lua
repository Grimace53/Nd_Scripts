-- Fertilizer configurations
Fertilizers = {
    growth_fertilizer = {
        name = 'growth_fertilizer',
        label = 'Growth Fertilizer',
        description = 'Increases plant growth speed by 25%',
        growSpeedMultiplier = 1.25,
        yieldMultiplier = 1.0,
        weight = 100
    },
    
    yield_fertilizer = {
        name = 'yield_fertilizer',
        label = 'Yield Fertilizer',
        description = 'Increases plant yield by 50%',
        growSpeedMultiplier = 1.0,
        yieldMultiplier = 1.5,
        weight = 100
    },
    
    super_serum = {
        name = 'super_serum',
        label = 'Super Serum',
        description = 'Ultimate plant enhancer! Increases growth speed by 40% and yield by 75%',
        growSpeedMultiplier = 1.4,
        yieldMultiplier = 1.75,
        weight = 150
    }
}

-- Helper function to get fertilizer config
function GetFertilizerConfig(fertilizerType)
    return Fertilizers[fertilizerType]
end

-- Calculate growth time with fertilizer
function CalculateGrowTime(baseTime, fertilizerType)
    if fertilizerType and Fertilizers[fertilizerType] then
        return math.floor(baseTime / Fertilizers[fertilizerType].growSpeedMultiplier)
    end
    return baseTime
end

-- Calculate yield with fertilizer
function CalculateYield(baseMin, baseMax, fertilizerType)
    if fertilizerType and Fertilizers[fertilizerType] then
        local multiplier = Fertilizers[fertilizerType].yieldMultiplier
        return math.floor(baseMin * multiplier), math.floor(baseMax * multiplier)
    end
    return baseMin, baseMax
end

return Fertilizers
