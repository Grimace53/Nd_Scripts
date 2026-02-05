-- Server-side plant management system
local plants = {}  -- Store all active plants

-- Initialize plant tracking
CreateThread(function()
    print('[Nd_Scripts] Farming system initialized')
end)

-- Function to create a new plant
function CreatePlant(plantId, plantType, coords, owner)
    if not Config.Plants[plantType] then
        print('[Nd_Scripts] Invalid plant type: ' .. plantType)
        return false
    end
    
    local plantConfig = Config.Plants[plantType]
    
    plants[plantId] = {
        id = plantId,
        type = plantType,
        coords = coords,
        owner = owner,
        plantedTime = os.time(),
        growTime = plantConfig.baseGrowTime,
        yield = plantConfig.baseYield,
        fertilizerApplied = nil,
        growSpeedMultiplier = 1.0,
        yieldMultiplier = 1.0,
        ready = false
    }
    
    -- Start growth timer
    SetTimeout(plants[plantId].growTime * 1000, function()
        if plants[plantId] then
            plants[plantId].ready = true
            TriggerClientEvent('nd_farming:plantReady', -1, plantId)
        end
    end)
    
    return true
end

-- Function to apply fertilizer to a plant
RegisterNetEvent('nd_farming:applyFertilizer', function(plantId, fertilizerType)
    local src = source
    
    if not plants[plantId] then
        TriggerClientEvent('nd_farming:notify', src, 'Plant not found!', 'error')
        return
    end
    
    if plants[plantId].ready then
        TriggerClientEvent('nd_farming:notify', src, 'Plant is already grown!', 'error')
        return
    end
    
    if plants[plantId].fertilizerApplied then
        TriggerClientEvent('nd_farming:notify', src, 'Fertilizer already applied to this plant!', 'error')
        return
    end
    
    if not Config.Fertilizers[fertilizerType] then
        TriggerClientEvent('nd_farming:notify', src, 'Invalid fertilizer type!', 'error')
        return
    end
    
    -- Apply fertilizer effects
    local fertilizer = Config.Fertilizers[fertilizerType]
    plants[plantId].fertilizerApplied = fertilizerType
    plants[plantId].growSpeedMultiplier = fertilizer.growSpeedMultiplier
    plants[plantId].yieldMultiplier = fertilizer.yieldMultiplier
    
    -- Adjust growth time based on multiplier
    local timeElapsed = os.time() - plants[plantId].plantedTime
    local timeRemaining = plants[plantId].growTime - timeElapsed
    local newTimeRemaining = math.floor(timeRemaining / fertilizer.growSpeedMultiplier)
    
    -- Update final yield
    plants[plantId].yield = math.floor(plants[plantId].yield * fertilizer.yieldMultiplier)
    
    TriggerClientEvent('nd_farming:notify', src, 'Applied ' .. fertilizer.label .. ' successfully!', 'success')
    TriggerClientEvent('nd_farming:fertilizerApplied', -1, plantId, fertilizerType)
    
    print(string.format('[Nd_Scripts] Player %s applied %s to plant %s', src, fertilizerType, plantId))
end)

-- Function to harvest a plant
RegisterNetEvent('nd_farming:harvestPlant', function(plantId)
    local src = source
    
    if not plants[plantId] then
        TriggerClientEvent('nd_farming:notify', src, 'Plant not found!', 'error')
        return
    end
    
    if not plants[plantId].ready then
        TriggerClientEvent('nd_farming:notify', src, 'Plant is not ready to harvest!', 'error')
        return
    end
    
    local plantConfig = Config.Plants[plants[plantId].type]
    local yieldAmount = plants[plantId].yield
    
    -- Give harvest items to player
    -- This would integrate with your inventory system (QBCore, ESX, etc.)
    -- Example: exports['qb-inventory']:AddItem(src, plantConfig.harvestItem, yieldAmount)
    
    TriggerClientEvent('nd_farming:notify', src, 'Harvested ' .. yieldAmount .. 'x ' .. plantConfig.harvestItem, 'success')
    TriggerClientEvent('nd_farming:plantHarvested', -1, plantId)
    
    -- Remove plant from tracking
    plants[plantId] = nil
end)

-- Get plant information
RegisterNetEvent('nd_farming:getPlantInfo', function(plantId)
    local src = source
    
    if plants[plantId] then
        TriggerClientEvent('nd_farming:receivePlantInfo', src, plants[plantId])
    end
end)

-- Export functions for other resources
exports('CreatePlant', CreatePlant)
exports('GetPlant', function(plantId)
    return plants[plantId]
end)
exports('GetAllPlants', function()
    return plants
end)
