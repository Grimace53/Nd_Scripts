local isNuiOpen = false
local plantData = {
    health = 100,
    light = 75,
    water = 50,
    fertilizer = 0
}

-- Toggle NUI
RegisterCommand('plantnui', function()
    isNuiOpen = not isNuiOpen
    SetNuiFocus(isNuiOpen, isNuiOpen)
    SendNUIMessage({
        type = 'toggle',
        show = isNuiOpen,
        data = plantData
    })
end, false)

-- Close NUI from JavaScript
RegisterNUICallback('close', function(data, cb)
    isNuiOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Update plant levels
RegisterNUICallback('updateLevels', function(data, cb)
    if data.light then
        plantData.light = math.max(0, math.min(100, data.light))
    end
    if data.water then
        plantData.water = math.max(0, math.min(100, data.water))
    end
    if data.fertilizer then
        plantData.fertilizer = math.max(0, math.min(100, data.fertilizer))
    end
    
    -- Calculate plant health based on light and water
    -- Plant needs light and water to be healthy, fertilizer is optional bonus
    local healthScore = 0
    
    -- Light contributes 40% to health
    healthScore = healthScore + (plantData.light * 0.4)
    
    -- Water contributes 40% to health
    healthScore = healthScore + (plantData.water * 0.4)
    
    -- Fertilizer is optional and gives 20% bonus
    healthScore = healthScore + (plantData.fertilizer * 0.2)
    
    plantData.health = math.floor(healthScore)
    
    cb({
        health = plantData.health,
        light = plantData.light,
        water = plantData.water,
        fertilizer = plantData.fertilizer
    })
end)

-- Simulate natural degradation over time
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000) -- Every 10 seconds
        
        -- Light decreases slowly (clouds, time of day)
        plantData.light = math.max(0, plantData.light - 1)
        
        -- Water decreases faster
        plantData.water = math.max(0, plantData.water - 2)
        
        -- Fertilizer depletes slowly
        if plantData.fertilizer > 0 then
            plantData.fertilizer = math.max(0, plantData.fertilizer - 0.5)
        end
        
        -- Recalculate health
        local healthScore = (plantData.light * 0.4) + (plantData.water * 0.4) + (plantData.fertilizer * 0.2)
        plantData.health = math.floor(healthScore)
        
        -- If NUI is open, update it
        if isNuiOpen then
            SendNUIMessage({
                type = 'update',
                data = plantData
            })
        end
    end
end)
