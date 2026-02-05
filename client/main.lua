-- Client-side farming interactions
local playerPlants = {}

-- Detect framework
local Framework = nil
local FrameworkName = nil

CreateThread(function()
    if GetResourceState('qbx_core') == 'started' then
        Framework = exports['qbx_core']:GetCoreObject()
        FrameworkName = 'qbx'
    elseif GetResourceState('qb-core') == 'started' then
        Framework = exports['qb-core']:GetCoreObject()
        FrameworkName = 'qb'
    elseif GetResourceState('es_extended') == 'started' then
        Framework = exports['es_extended']:getSharedObject()
        FrameworkName = 'esx'
    end
end)

-- Helper function to show notifications
function ShowNotification(message, type)
    -- Use ox_lib if available
    if GetResourceState('ox_lib') == 'started' then
        lib.notify({
            title = 'Farming',
            description = message,
            type = type or 'info'
        })
    -- Use framework notification
    elseif FrameworkName == 'qbx' or FrameworkName == 'qb' then
        Framework.Functions.Notify(message, type)
    elseif FrameworkName == 'esx' then
        Framework.ShowNotification(message)
    else
        -- Fallback to native GTA notification
        SetNotificationTextEntry('STRING')
        AddTextComponentString(message)
        DrawNotification(0, 1)
    end
end

-- Register notification handler
RegisterNetEvent('nd_farming:notify', function(message, type)
    ShowNotification(message, type)
end)

-- Function to use fertilizer on a plant
function UseFertilizer(fertilizerType)
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    -- Find nearby plant (you would implement proper plant detection here)
    -- For now, this is a placeholder
    local nearbyPlant = GetNearbyPlant(playerCoords)
    
    if nearbyPlant then
        TriggerServerEvent('nd_farming:applyFertilizer', nearbyPlant.id, fertilizerType)
    else
        ShowNotification('No plant nearby!', 'error')
    end
end

-- Function to get nearby plant (placeholder - implement based on your plant system)
function GetNearbyPlant(coords)
    -- This would integrate with your existing plant system
    -- Return the closest plant within interaction range
    for plantId, plant in pairs(playerPlants) do
        if plant.coords then
            local distance = #(coords - plant.coords)
            if distance < 2.0 then  -- 2 meter interaction range
                return plant
            end
        end
    end
    return nil
end

-- Function to plant a crop
function PlantCrop(plantType)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Generate unique plant ID
    local plantId = 'plant_' .. GetPlayerServerId(PlayerId()) .. '_' .. os.time()
    
    -- Create plant on server
    TriggerServerEvent('nd_farming:createPlant', plantId, plantType, coords)
end

-- Handle plant ready notification
RegisterNetEvent('nd_farming:plantReady', function(plantId)
    if playerPlants[plantId] then
        ShowNotification('Your plant is ready to harvest!', 'success')
    end
end)

-- Handle fertilizer application notification
RegisterNetEvent('nd_farming:fertilizerApplied', function(plantId, fertilizerType)
    if playerPlants[plantId] then
        playerPlants[plantId].fertilizerApplied = fertilizerType
    end
end)

-- Handle plant harvest notification
RegisterNetEvent('nd_farming:plantHarvested', function(plantId)
    if playerPlants[plantId] then
        playerPlants[plantId] = nil
    end
end)

-- Receive plant information
RegisterNetEvent('nd_farming:receivePlantInfo', function(plantInfo)
    print('[Nd_Scripts] Plant Info:')
    print(json.encode(plantInfo, { indent = true }))
end)

-- Client event handlers for framework integration
RegisterNetEvent('Nd_Scripts:client:useGrowthFertilizer', function()
    UseFertilizer('growth_fertilizer')
end)

RegisterNetEvent('Nd_Scripts:client:useYieldFertilizer', function()
    UseFertilizer('yield_fertilizer')
end)

RegisterNetEvent('Nd_Scripts:client:useSuperSerum', function()
    UseFertilizer('super_serum')
end)

-- Export functions for use with items
exports('UseGrowthFertilizer', function()
    UseFertilizer('growth_fertilizer')
end)

exports('UseYieldFertilizer', function()
    UseFertilizer('yield_fertilizer')
end)

exports('UseSuperSerum', function()
    UseFertilizer('super_serum')
end)

-- Command to use fertilizer (for testing)
RegisterCommand('usefertilizer', function(source, args)
    local fertilizerType = args[1] or 'growth_fertilizer'
    UseFertilizer(fertilizerType)
end, false)

-- Command to plant a crop (for testing)
RegisterCommand('plant', function(source, args)
    local plantType = args[1] or 'tomato'
    PlantCrop(plantType)
end, false)

-- Initialize
CreateThread(function()
    print('[Nd_Scripts] Client farming system loaded')
end)
