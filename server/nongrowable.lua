-- Server-side logic for non-growable drugs (NPC interactions)

-- Minigame trigger
RegisterNetEvent('nd_drugs:server:startMinigame', function(drugType, locationIndex)
    local source = source
    local player = exports.qbx_core:GetPlayer(source)
    
    if not player then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Player not found'
        })
        return
    end
    
    local identifier = player.PlayerData.citizenid
    local drugConfig = Config.NonGrowableDrugs[drugType]
    
    if not drugConfig then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Invalid drug type'
        })
        return
    end
    
    if not drugConfig.locations[locationIndex] then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Invalid location'
        })
        return
    end
    
    -- Check cooldown
    if Database.IsOnCooldown(identifier, drugType, locationIndex) then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'This dealer is on cooldown. Try again later.'
        })
        return
    end
    
    -- Trigger client-side minigame
    TriggerClientEvent('nd_drugs:client:startMinigame', source, drugType, locationIndex, drugConfig)
end)

-- Handle minigame success
RegisterNetEvent('nd_drugs:server:minigameSuccess', function(drugType, locationIndex)
    local source = source
    local player = exports.qbx_core:GetPlayer(source)
    
    if not player then return end
    
    local identifier = player.PlayerData.citizenid
    local drugConfig = Config.NonGrowableDrugs[drugType]
    
    if not drugConfig then return end
    
    -- Set cooldown
    local cooldownTime = Config.NonGrowableSettings.cooldownTime / 1000
    Database.SetCooldown(identifier, drugType, locationIndex, cooldownTime)
    
    -- Determine items to give based on chance
    local itemsReceived = {}
    for _, itemData in ipairs(drugConfig.items) do
        local roll = math.random(1, 100)
        if roll <= itemData.chance then
            local amount = math.random(itemData.amount.min, itemData.amount.max)
            
            if exports.ox_inventory:CanCarryItem(source, itemData.item, amount) then
                exports.ox_inventory:AddItem(source, itemData.item, amount)
                table.insert(itemsReceived, {item = itemData.item, amount = amount})
            end
        end
    end
    
    -- Log to database
    if #itemsReceived > 0 then
        Database.LogDrugInteraction(drugType, identifier, locationIndex, itemsReceived)
        
        -- Notify player
        local itemText = ''
        for i, received in ipairs(itemsReceived) do
            itemText = itemText .. received.amount .. 'x ' .. received.item
            if i < #itemsReceived then
                itemText = itemText .. ', '
            end
        end
        
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = 'Received: ' .. itemText
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'info',
            description = 'The dealer had nothing for you this time'
        })
    end
end)

-- Handle minigame failure
RegisterNetEvent('nd_drugs:server:minigameFailed', function(drugType, locationIndex)
    local source = source
    local player = exports.qbx_core:GetPlayer(source)
    
    if not player then return end
    
    local identifier = player.PlayerData.citizenid
    
    -- Set shorter cooldown on failure
    local cooldownTime = (Config.NonGrowableSettings.cooldownTime / 2) / 1000
    Database.SetCooldown(identifier, drugType, locationIndex, cooldownTime)
    
    TriggerClientEvent('ox_lib:notify', source, {
        type = 'error',
        description = 'You messed up! The dealer is suspicious. Try again later.'
    })
end)

-- Check cooldown status
lib.callback.register('nd_drugs:checkCooldown', function(source, drugType, locationIndex)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return true end
    
    local identifier = player.PlayerData.citizenid
    return Database.IsOnCooldown(identifier, drugType, locationIndex)
end)
