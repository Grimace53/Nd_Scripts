-- Server-side logic for non-growable drugs (AI interactions with minigames)

-- Check if player is on cooldown for a specific location
local function IsOnCooldown(identifier, drugType, locationIndex)
    local result = MySQL.single.await('SELECT cooldown_until FROM drug_cooldowns WHERE identifier = ? AND drug_type = ? AND location_index = ? AND cooldown_until > NOW()', {
        identifier,
        drugType,
        locationIndex
    })
    return result ~= nil
end

-- Set cooldown for a location
local function SetCooldown(identifier, drugType, locationIndex)
    local cooldownTime = Config.AISettings.cooldownTime / 1000 -- Convert to seconds
    MySQL.insert('INSERT INTO drug_cooldowns (identifier, drug_type, location_index, cooldown_until) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? SECOND)) ON DUPLICATE KEY UPDATE cooldown_until = DATE_ADD(NOW(), INTERVAL ? SECOND)', {
        identifier,
        drugType,
        locationIndex,
        cooldownTime,
        cooldownTime
    })
end

-- Trigger minigame for non-growable drug
RegisterNetEvent('nd_drugs:server:startMinigame', function(drugType, locationIndex)
    local src = source
    local identifier = exports['nd_drugs']:GetPlayerIdentifier(src)
    
    if not identifier then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Error getting player identifier', 'error')
        return
    end
    
    local drugConfig = Config.Drugs[drugType]
    if not drugConfig or drugConfig.growable then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Invalid drug type', 'error')
        return
    end
    
    -- Check if location exists
    if not drugConfig.locations[locationIndex] then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Invalid location', 'error')
        return
    end
    
    -- Check cooldown
    if IsOnCooldown(identifier, drugType, locationIndex) then
        TriggerClientEvent('nd_drugs:client:notify', src, 'This location is on cooldown. Try again later.', 'error')
        return
    end
    
    -- Trigger client-side minigame
    local minigameType = drugConfig.minigameType
    local minigameConfig = Config.Minigames[minigameType]
    
    TriggerClientEvent('nd_drugs:client:startMinigame', src, minigameType, minigameConfig, drugType, locationIndex)
end)

-- Handle minigame success
RegisterNetEvent('nd_drugs:server:minigameSuccess', function(drugType, locationIndex)
    local src = source
    local identifier = exports['nd_drugs']:GetPlayerIdentifier(src)
    
    if not identifier then
        return
    end
    
    local drugConfig = Config.Drugs[drugType]
    if not drugConfig or drugConfig.growable then
        return
    end
    
    -- Set cooldown
    SetCooldown(identifier, drugType, locationIndex)
    
    -- Determine which items to give based on chance
    local itemsReceived = {}
    for _, itemData in ipairs(drugConfig.items) do
        local roll = math.random(1, 100)
        if roll <= itemData.chance then
            local amount = math.random(itemData.amount.min, itemData.amount.max)
            -- Give item to player
            exports.ox_inventory:AddItem(src, itemData.item, amount)
            table.insert(itemsReceived, {item = itemData.item, amount = amount})
        end
    end
    
    -- Log to database
    if #itemsReceived > 0 then
        MySQL.insert('INSERT INTO drug_'..drugType..' (identifier, location_index, items_received) VALUES (?, ?, ?)', {
            identifier,
            locationIndex,
            json.encode(itemsReceived)
        })
        
        -- Notify player
        local itemText = ""
        for i, received in ipairs(itemsReceived) do
            itemText = itemText .. received.amount .. "x " .. received.item
            if i < #itemsReceived then
                itemText = itemText .. ", "
            end
        end
        TriggerClientEvent('nd_drugs:client:notify', src, 'Received: ' .. itemText, 'success')
    else
        TriggerClientEvent('nd_drugs:client:notify', src, 'You didn\'t get anything this time', 'info')
    end
end)

-- Handle minigame failure
RegisterNetEvent('nd_drugs:server:minigameFailed', function(drugType, locationIndex)
    local src = source
    local identifier = exports['nd_drugs']:GetPlayerIdentifier(src)
    
    if not identifier then
        return
    end
    
    -- Still set a shorter cooldown on failure (half the time)
    local cooldownTime = (Config.AISettings.cooldownTime / 2) / 1000
    MySQL.insert('INSERT INTO drug_cooldowns (identifier, drug_type, location_index, cooldown_until) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? SECOND)) ON DUPLICATE KEY UPDATE cooldown_until = DATE_ADD(NOW(), INTERVAL ? SECOND)', {
        identifier,
        drugType,
        locationIndex,
        cooldownTime,
        cooldownTime
    })
    
    TriggerClientEvent('nd_drugs:client:notify', src, 'Minigame failed! Try again later.', 'error')
end)

-- Get cooldown status for a location
RegisterNetEvent('nd_drugs:server:checkCooldown', function(drugType, locationIndex, callback)
    local src = source
    local identifier = exports['nd_drugs']:GetPlayerIdentifier(src)
    
    if not identifier then
        return
    end
    
    local isOnCooldown = IsOnCooldown(identifier, drugType, locationIndex)
    TriggerClientEvent('nd_drugs:client:cooldownStatus', src, drugType, locationIndex, isOnCooldown)
end)
