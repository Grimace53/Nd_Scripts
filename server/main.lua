-- Server-side plant management system
local plants = {}  -- Store all active plants

-- Detect framework
local Framework = nil
local FrameworkName = nil

CreateThread(function()
    if GetResourceState('qbx_core') == 'started' then
        Framework = exports['qbx_core']:GetCoreObject()
        FrameworkName = 'qbx'
        print('[Nd_Scripts] Detected QBX-Core framework')
    elseif GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
        FrameworkName = 'qb'
        print('[Nd_Scripts] Detected QBCore framework')
    elseif GetResourceState('es_extended') == 'started' then
        Framework = exports['es_extended']:getSharedObject()
        FrameworkName = 'esx'
        print('[Nd_Scripts] Detected ESX framework')
    else
        print('[Nd_Scripts] No framework detected - running standalone')
    end
    print('[Nd_Scripts] Farming system initialized')
end)

-- Helper function to add item to player inventory
local function AddItemToPlayer(src, item, amount)
    if GetResourceState('ox_inventory') == 'started' then
        -- ox_inventory
        local success = exports.ox_inventory:AddItem(src, item, amount)
        return success ~= false
    elseif FrameworkName == 'qbx' or FrameworkName == 'qb' then
        -- QBX-Core or QBCore
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.AddItem(item, amount)
            return true
        end
    elseif FrameworkName == 'esx' then
        -- ESX
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.addInventoryItem(item, amount)
            return true
        end
    end
    return false
end

-- Helper function to remove item from player inventory
local function RemoveItemFromPlayer(src, item, amount)
    if GetResourceState('ox_inventory') == 'started' then
        -- ox_inventory
        local success = exports.ox_inventory:RemoveItem(src, item, amount)
        return success ~= false
    elseif FrameworkName == 'qbx' or FrameworkName == 'qb' then
        -- QBX-Core or QBCore
        local Player = Framework.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveItem(item, amount)
            return true
        end
    elseif FrameworkName == 'esx' then
        -- ESX
        local xPlayer = Framework.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeInventoryItem(item, amount)
            return true
        end
    end
    return false
end

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
    
    -- Give harvest items to player using framework-agnostic function
    local success = AddItemToPlayer(src, plantConfig.harvestItem, yieldAmount)
    
    if success then
        TriggerClientEvent('nd_farming:notify', src, 'Harvested ' .. yieldAmount .. 'x ' .. plantConfig.harvestItem, 'success')
        TriggerClientEvent('nd_farming:plantHarvested', -1, plantId)
        
        -- Remove plant from tracking
        plants[plantId] = nil
    else
        TriggerClientEvent('nd_farming:notify', src, 'Failed to harvest plant!', 'error')
    end
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
