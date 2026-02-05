-- Client-side logic for non-growable drugs (NPC interactions)

local spawnedPeds = {}

-- Spawn drug dealer NPCs
local function SpawnDrugDealers()
    Utils.Debug('Spawning drug dealer NPCs...')
    
    for drugType, drugConfig in pairs(Config.NonGrowableDrugs) do
        spawnedPeds[drugType] = {}
        
        for locationIndex, location in ipairs(drugConfig.locations) do
            lib.requestModel(drugConfig.pedModel, 10000)
            
            local ped = CreatePed(4, drugConfig.pedModel, location.x, location.y, location.z, location.heading, false, true)
            SetEntityAsMissionEntity(ped, true, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            SetPedCanPlayAmbientAnims(ped, true)
            SetPedCanRagdoll(ped, false)
            
            spawnedPeds[drugType][locationIndex] = ped
            
            -- Add ox_target interaction
            exports.ox_target:addLocalEntity(ped, {
                {
                    name = 'drug_dealer_' .. drugType .. '_' .. locationIndex,
                    label = 'Talk to ' .. drugConfig.label .. ' Dealer',
                    icon = 'fas fa-user-secret',
                    distance = 2.5,
                    onSelect = function()
                        -- Check cooldown first
                        lib.callback('nd_drugs:checkCooldown', false, function(isOnCooldown)
                            if isOnCooldown then
                                lib.notify({
                                    type = 'error',
                                    description = 'This dealer is on cooldown. Try again later.'
                                })
                            else
                                TriggerServerEvent('nd_drugs:server:startMinigame', drugType, locationIndex)
                            end
                        end, drugType, locationIndex)
                    end
                }
            })
            
            Utils.Debug('Spawned ' .. drugConfig.label .. ' dealer at location ' .. locationIndex)
        end
    end
end

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

-- Initialize NPCs
CreateThread(function()
    Wait(2000)
    SpawnDrugDealers()
end)

-- Start minigame (triggered by server)
RegisterNetEvent('nd_drugs:client:startMinigame', function(drugType, locationIndex, drugConfig)
    Utils.Debug('Starting minigame for ' .. drugType)
    
    local minigameType = drugConfig.minigameType
    local success = false
    
    -- Use ox_lib skillcheck for minigames
    if minigameType == 'lockpick' then
        -- Easy lockpick challenge
        success = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 1}}, {'w', 'a', 's', 'd'})
        
    elseif minigameType == 'hacking' then
        -- Medium hacking challenge
        success = lib.skillCheck({'easy', 'medium', {areaSize = 50, speedMultiplier = 1.5}}, {'w', 'a', 's', 'd'})
        
    elseif minigameType == 'skillcheck' then
        -- Multiple skillchecks
        success = lib.skillCheck({'easy', 'easy', 'medium'}, {'w', 'a', 's', 'd'})
        
    else
        -- Default: simple skillcheck
        success = lib.skillCheck({'easy', 'easy'}, {'w', 'a', 's', 'd'})
    end
    
    -- Report result to server
    if success then
        TriggerServerEvent('nd_drugs:server:minigameSuccess', drugType, locationIndex)
    else
        TriggerServerEvent('nd_drugs:server:minigameFailed', drugType, locationIndex)
    end
end)

-- Export function to get spawned peds
exports('GetDrugDealers', function()
    return spawnedPeds
end)
