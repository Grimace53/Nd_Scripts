-- Client-side logic for non-growable drugs (AI interactions with minigames)

local spawnedPeds = {} -- {[drugType] = {[locationIndex] = ped}}
local activeCooldowns = {} -- {[drugType] = {[locationIndex] = true/false}}

-- Spawn AI peds at configured locations
local function SpawnDrugPeds()
    for drugType, drugConfig in pairs(Config.Drugs) do
        if not drugConfig.growable then
            spawnedPeds[drugType] = {}
            activeCooldowns[drugType] = {}
            
            for locationIndex, location in ipairs(drugConfig.locations) do
                local modelHash = GetHashKey(drugConfig.pedModel)
                RequestModel(modelHash)
                while not HasModelLoaded(modelHash) do
                    Wait(10)
                end
                
                local ped = CreatePed(4, modelHash, location.x, location.y, location.z, location.heading, false, true)
                SetEntityAsMissionEntity(ped, true, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                
                if Config.AISettings.pedInvincible then
                    SetEntityInvincible(ped, true)
                end
                
                if Config.AISettings.pedFrozen then
                    FreezeEntityPosition(ped, true)
                end
                
                -- Make ped look more natural
                SetPedCanPlayAmbientAnims(ped, true)
                SetPedCanRagdoll(ped, false)
                
                spawnedPeds[drugType][locationIndex] = ped
                activeCooldowns[drugType][locationIndex] = false
            end
        end
    end
end

-- Initialize peds on resource start
CreateThread(function()
    Wait(1000)
    SpawnDrugPeds()
end)

-- Cleanup peds on resource stop
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for drugType, peds in pairs(spawnedPeds) do
            for _, ped in pairs(peds) do
                if DoesEntityExist(ped) then
                    DeletePed(ped)
                end
            end
        end
    end
end)

-- Interaction thread for AI peds
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        for drugType, drugConfig in pairs(Config.Drugs) do
            if not drugConfig.growable then
                for locationIndex, location in ipairs(drugConfig.locations) do
                    local pedCoords = vector3(location.x, location.y, location.z)
                    local distance = #(coords - pedCoords)
                    
                    if distance < Config.AISettings.interactionDistance then
                        sleep = 0
                        
                        local isOnCooldown = activeCooldowns[drugType] and activeCooldowns[drugType][locationIndex]
                        local text = isOnCooldown and "[!] On Cooldown" or "[E] Interact with " .. drugConfig.label .. " dealer"
                        
                        DrawText3D(location.x, location.y, location.z + 1.0, text)
                        
                        if not isOnCooldown and IsControlJustReleased(0, 38) then -- E key
                            TriggerServerEvent('nd_drugs:server:startMinigame', drugType, locationIndex)
                        end
                    end
                end
            end
        end
        
        Wait(sleep)
    end
end)

-- Start minigame
RegisterNetEvent('nd_drugs:client:startMinigame', function(minigameType, minigameConfig, drugType, locationIndex)
    -- This is a placeholder for minigame implementation
    -- You would integrate with your actual minigame system here
    -- Examples: ps-ui, qb-minigames, ox_lib skillcheck, etc.
    
    local success = false
    
    -- Example minigame implementations (you'll need to adapt these to your actual minigame system)
    if minigameType == "lockpick" then
        -- Example with ox_lib
        -- success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}})
        
        -- Placeholder: Simple random chance for demonstration
        success = math.random(1, 100) > 30
        
    elseif minigameType == "hacking" then
        -- Example with ps-ui
        -- exports['ps-ui']:Scrambler(function(result)
        --     success = result
        -- end, "numeric", 30, 0)
        
        -- Placeholder
        success = math.random(1, 100) > 50
        
    elseif minigameType == "skillcheck" then
        -- Example with qb-skillcheck
        -- local result = exports['qb-skillcheck']:SkillCheck(2, {'easy', 'easy'})
        -- success = result
        
        -- Placeholder
        success = math.random(1, 100) > 20
    end
    
    Wait(minigameConfig.duration or 5000)
    
    if success then
        TriggerServerEvent('nd_drugs:server:minigameSuccess', drugType, locationIndex)
        -- Set local cooldown indicator
        if activeCooldowns[drugType] then
            activeCooldowns[drugType][locationIndex] = true
            SetTimeout(Config.AISettings.cooldownTime, function()
                activeCooldowns[drugType][locationIndex] = false
            end)
        end
    else
        TriggerServerEvent('nd_drugs:server:minigameFailed', drugType, locationIndex)
        -- Set shorter cooldown on failure
        if activeCooldowns[drugType] then
            activeCooldowns[drugType][locationIndex] = true
            SetTimeout(Config.AISettings.cooldownTime / 2, function()
                activeCooldowns[drugType][locationIndex] = false
            end)
        end
    end
end)

-- Update cooldown status from server
RegisterNetEvent('nd_drugs:client:cooldownStatus', function(drugType, locationIndex, isOnCooldown)
    if activeCooldowns[drugType] then
        activeCooldowns[drugType][locationIndex] = isOnCooldown
    end
end)

-- Helper function to draw 3D text (reused from growable.lua, but included here for independence)
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

-- Export for external use
exports('GetSpawnedPeds', function()
    return spawnedPeds
end)
