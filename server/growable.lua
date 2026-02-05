-- Server-side logic for growable drugs (planting in pots)

-- Plant a drug seed in a pot
RegisterNetEvent('nd_drugs:server:plantDrug', function(drugType, position)
    local src = source
    local identifier = exports['nd_drugs']:GetPlayerIdentifier(src)
    
    if not identifier then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Error getting player identifier', 'error')
        return
    end
    
    local drugConfig = Config.Drugs[drugType]
    if not drugConfig or not drugConfig.growable then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Invalid drug type', 'error')
        return
    end
    
    -- Check if player has required item (seed)
    -- This assumes you're using an inventory system like ox_inventory or qb-inventory
    -- You'll need to adapt this to your inventory system
    local hasItem = exports.ox_inventory:Search(src, 'count', drugConfig.requiredItem)
    
    if hasItem and hasItem > 0 then
        -- Remove the seed item
        exports.ox_inventory:RemoveItem(src, drugConfig.requiredItem, 1)
        
        -- Insert into database
        MySQL.insert('INSERT INTO drug_'..drugType..' (identifier, position, growth_stage, harvestable) VALUES (?, ?, ?, ?)', {
            identifier,
            json.encode(position),
            0,
            false
        }, function(insertId)
            if insertId then
                -- Notify client to spawn the pot
                TriggerClientEvent('nd_drugs:client:spawnPot', -1, drugType, insertId, position)
                TriggerClientEvent('nd_drugs:client:notify', src, 'Successfully planted '..drugConfig.label, 'success')
                
                -- Start growth timer
                SetTimeout(drugConfig.growTime, function()
                    MySQL.update('UPDATE drug_'..drugType..' SET growth_stage = ?, harvestable = ? WHERE id = ?', {
                        2,
                        true,
                        insertId
                    })
                    TriggerClientEvent('nd_drugs:client:updatePotStage', -1, drugType, insertId, 2)
                end)
            else
                -- Return the item if database insert failed
                exports.ox_inventory:AddItem(src, drugConfig.requiredItem, 1)
                TriggerClientEvent('nd_drugs:client:notify', src, 'Failed to plant drug', 'error')
            end
        end)
    else
        TriggerClientEvent('nd_drugs:client:notify', src, 'You need a '..drugConfig.requiredItem..' to plant', 'error')
    end
end)

-- Harvest a drug from a pot
RegisterNetEvent('nd_drugs:server:harvestDrug', function(drugType, plantId)
    local src = source
    local identifier = exports['nd_drugs']:GetPlayerIdentifier(src)
    
    if not identifier then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Error getting player identifier', 'error')
        return
    end
    
    local drugConfig = Config.Drugs[drugType]
    if not drugConfig or not drugConfig.growable then
        TriggerClientEvent('nd_drugs:client:notify', src, 'Invalid drug type', 'error')
        return
    end
    
    -- Check if plant is ready to harvest
    MySQL.single('SELECT * FROM drug_'..drugType..' WHERE id = ? AND harvestable = ?', {
        plantId,
        true
    }, function(plant)
        if plant then
            -- Check if it belongs to the player or allow anyone to harvest
            -- For now, anyone can harvest
            
            -- Calculate harvest amount
            local amount = math.random(drugConfig.harvestAmount.min, drugConfig.harvestAmount.max)
            
            -- Give harvested items to player
            exports.ox_inventory:AddItem(src, drugConfig.harvestedItem, amount)
            
            -- Remove from database
            MySQL.query('DELETE FROM drug_'..drugType..' WHERE id = ?', {plantId})
            
            -- Notify client to remove pot
            TriggerClientEvent('nd_drugs:client:removePot', -1, drugType, plantId)
            TriggerClientEvent('nd_drugs:client:notify', src, 'Harvested '..amount..' '..drugConfig.harvestedItem, 'success')
        else
            TriggerClientEvent('nd_drugs:client:notify', src, 'Plant is not ready to harvest', 'error')
        end
    end)
end)

-- Load all existing plants on player join
RegisterNetEvent('nd_drugs:server:loadPlants', function()
    local src = source
    
    for drugType, drugConfig in pairs(Config.Drugs) do
        if drugConfig.growable then
            MySQL.query('SELECT * FROM drug_'..drugType, {}, function(plants)
                if plants then
                    for _, plant in ipairs(plants) do
                        local position = json.decode(plant.position)
                        TriggerClientEvent('nd_drugs:client:spawnPot', src, drugType, plant.id, position, plant.growth_stage)
                    end
                end
            end)
        end
    end
end)

-- Water a plant (optional feature based on config)
RegisterNetEvent('nd_drugs:server:waterPlant', function(drugType, plantId)
    local src = source
    
    if Config.PotSettings.wateringRequired then
        MySQL.update('UPDATE drug_'..drugType..' SET last_watered = NOW() WHERE id = ?', {plantId})
        TriggerClientEvent('nd_drugs:client:notify', src, 'Plant watered', 'success')
    end
end)
