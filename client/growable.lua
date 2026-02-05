-- Client-side logic for growable drugs (pot planting and harvesting)

local spawnedPots = {} -- {[drugType] = {[plantId] = {object, position, stage}}}

-- Initialize spawned pots table
for drugType, drugConfig in pairs(Config.Drugs) do
    if drugConfig.growable then
        spawnedPots[drugType] = {}
    end
end

-- Plant a drug in a pot
local function PlantDrug(drugType)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Calculate position in front of player
    local forward = GetEntityForwardVector(playerPed)
    local plantPos = vector3(
        coords.x + forward.x * 1.5,
        coords.y + forward.y * 1.5,
        coords.z - 1.0
    )
    
    -- Trigger server event to plant
    TriggerServerEvent('nd_drugs:server:plantDrug', drugType, {
        x = plantPos.x,
        y = plantPos.y,
        z = plantPos.z,
        heading = heading
    })
end

-- Spawn a pot object
RegisterNetEvent('nd_drugs:client:spawnPot', function(drugType, plantId, position, stage)
    local drugConfig = Config.Drugs[drugType]
    if not drugConfig or not drugConfig.growable then return end
    
    stage = stage or 0
    
    local coords = vector3(position.x, position.y, position.z)
    local heading = position.heading or 0.0
    
    -- Load model
    local modelHash = GetHashKey(drugConfig.potModel)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    
    -- Create object
    local object = CreateObject(modelHash, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(object, heading)
    PlaceObjectOnGroundProperly(object)
    FreezeEntityPosition(object, true)
    
    -- Store pot data
    spawnedPots[drugType][plantId] = {
        object = object,
        position = coords,
        stage = stage,
        heading = heading
    }
end)

-- Update pot stage (visual change if needed)
RegisterNetEvent('nd_drugs:client:updatePotStage', function(drugType, plantId, stage)
    if spawnedPots[drugType] and spawnedPots[drugType][plantId] then
        spawnedPots[drugType][plantId].stage = stage
    end
end)

-- Remove a pot
RegisterNetEvent('nd_drugs:client:removePot', function(drugType, plantId)
    if spawnedPots[drugType] and spawnedPots[drugType][plantId] then
        local potData = spawnedPots[drugType][plantId]
        if DoesEntityExist(potData.object) then
            DeleteObject(potData.object)
        end
        spawnedPots[drugType][plantId] = nil
    end
end)

-- Interaction thread for growable drugs
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for drugType, pots in pairs(spawnedPots) do
            for plantId, potData in pairs(pots) do
                local distance = #(coords - potData.position)
                
                if distance < Config.PotSettings.maxDistance then
                    sleep = 0
                    
                    -- Draw 3D text
                    local drugConfig = Config.Drugs[drugType]
                    local text = potData.stage == 2 and "[E] Harvest " .. drugConfig.label or drugConfig.label .. " (Growing...)"
                    
                    DrawText3D(potData.position.x, potData.position.y, potData.position.z + 0.5, text)
                    
                    -- Check for harvest interaction
                    if potData.stage == 2 and IsControlJustReleased(0, 38) then -- E key
                        TriggerServerEvent('nd_drugs:server:harvestDrug', drugType, plantId)
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Load plants on player spawn
AddEventHandler('playerSpawned', function()
    TriggerServerEvent('nd_drugs:server:loadPlants')
end)

-- Also load on resource start
CreateThread(function()
    Wait(1000)
    TriggerServerEvent('nd_drugs:server:loadPlants')
end)

-- Helper function to draw 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 75)
end

-- Export planting function for use with items
exports('PlantDrug', PlantDrug)

-- Register usable items (this depends on your inventory system)
-- Example for ox_inventory:
--[[
exports.ox_inventory:registerUsableItem('weed_seed', function(source)
    TriggerClientEvent('nd_drugs:client:useSeed', source, 'weed')
end)
]]

RegisterNetEvent('nd_drugs:client:useSeed', function(drugType)
    PlantDrug(drugType)
end)
