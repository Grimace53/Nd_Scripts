-- Server-side logic for growable drugs integrated with ox framework

-- Plant a drug in an existing pot (from PR #4)
RegisterNetEvent('nd_drugs:server:applyFertilizerToPot', function(potId, fertilizerType)
    local source = source
    
    if not placedProps[potId] or placedProps[potId].type ~= 'growing' then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Invalid pot'
        })
        return
    end
    
    local fertConfig = Fertilizers[fertilizerType]
    if not fertConfig then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Invalid fertilizer'
        })
        return
    end
    
    -- Check if player has fertilizer
    local hasFertilizer = exports.ox_inventory:GetItem(source, fertilizerType, nil, true)
    if not hasFertilizer or hasFertilizer < 1 then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You need ' .. fertConfig.label
        })
        return
    end
    
    -- Check if pot already has fertilizer
    if placedProps[potId].fertilizerType then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Pot already has fertilizer applied'
        })
        return
    end
    
    -- Remove fertilizer from inventory
    if not exports.ox_inventory:RemoveItem(source, fertilizerType, 1) then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Failed to use fertilizer'
        })
        return
    end
    
    -- Apply fertilizer to pot
    placedProps[potId].fertilizerType = fertilizerType
    placedProps[potId].growthMultiplier = fertConfig.growSpeedMultiplier
    placedProps[potId].yieldMultiplier = fertConfig.yieldMultiplier
    placedProps[potId].fertilizerLevel = 100
    
    -- Update database
    Database.UpdateProp(potId, {
        fertilizerType = fertilizerType,
        fertilizerLevel = 100
    })
    
    -- Update fertilizer boost on existing timer
    if growingTimers[potId] then
        -- Restart timer with new growth speed
        growingTimers[potId] = nil
        local prop = placedProps[potId]
        StartGrowingTimer(potId, prop.propType, prop.fertilizerType)
    end
    
    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = fertConfig.label .. ' applied! Growth speed: +' .. ((fertConfig.growSpeedMultiplier - 1) * 100) .. '%, Yield: +' .. ((fertConfig.yieldMultiplier - 1) * 100) .. '%'
    })
    
    -- Sync to all clients
    TriggerClientEvent('nd_drugs:client:updatePropData', -1, potId, placedProps[potId])
end)

-- Water a plant (updates water level for plant health)
RegisterNetEvent('nd_drugs:server:waterPlant', function(potId)
    local source = source
    
    if not placedProps[potId] or placedProps[potId].type ~= 'growing' then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Invalid pot'
        })
        return
    end
    
    -- Increase water level
    placedProps[potId].waterLevel = math.min(100, (placedProps[potId].waterLevel or 50) + 30)
    
    -- Recalculate plant health
    local health = CalculatePlantHealth(placedProps[potId])
    placedProps[potId].plantHealth = health
    
    -- Update database
    Database.UpdateProp(potId, {
        waterLevel = placedProps[potId].waterLevel,
        plantHealth = health
    })
    
    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Plant watered! Water level: ' .. placedProps[potId].waterLevel .. '%'
    })
    
    -- Sync to all clients
    TriggerClientEvent('nd_drugs:client:updatePropData', -1, potId, placedProps[potId])
end)

-- Calculate plant health based on water, light, and fertilizer
function CalculatePlantHealth(propData)
    local light = propData.lightLevel or 75
    local water = propData.waterLevel or 50
    local fertilizer = propData.fertilizerLevel or 0
    
    -- Health = 40% light + 40% water + 20% fertilizer
    local health = (light * 0.4) + (water * 0.4) + (fertilizer * 0.2)
    return math.floor(health)
end

-- Override StartGrowingTimer to support fertilizers
function StartGrowingTimer(id, propType, fertilizerType)
    local config = Config.GrowingProps[propType]
    
    CreateThread(function()
        growingTimers[id] = true
        
        for stage, stageData in ipairs(config.stages) do
            -- Calculate time with fertilizer boost
            local growTime = stageData.time
            if fertilizerType and Fertilizers[fertilizerType] then
                growTime = CalculateGrowTime(growTime, fertilizerType)
            end
            
            Wait(growTime)
            
            if not growingTimers[id] or not placedProps[id] then
                break
            end
            
            placedProps[id].currentStage = stage
            
            -- Update database
            Database.UpdateProp(id, {currentStage = stage})
            
            TriggerClientEvent('nd_drugs:client:updateGrowingStage', -1, id, stage)
            
            if stage == #config.stages then
                placedProps[id].ready = true
                Database.UpdateProp(id, {ready = true})
            end
        end
    end)
end

-- Override harvest to apply yield multiplier
RegisterNetEvent('nd_drugs:server:harvestPropWithFertilizer', function(id)
    local source = source
    
    if not placedProps[id] or placedProps[id].type ~= 'growing' then
        return
    end
    
    local prop = placedProps[id]
    
    if not prop.ready then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Not ready to harvest'
        })
        return
    end
    
    local config = Config.GrowingProps[prop.propType]
    
    -- Calculate amount with fertilizer boost
    local min, max = config.reward.min, config.reward.max
    if prop.yieldMultiplier then
        min = math.floor(min * prop.yieldMultiplier)
        max = math.floor(max * prop.yieldMultiplier)
    end
    
    local amount = math.random(min, max)
    
    -- Apply health multiplier (poor health reduces yield)
    local healthMultiplier = (prop.plantHealth or 100) / 100
    amount = math.max(1, math.floor(amount * healthMultiplier))
    
    if exports.ox_inventory:CanCarryItem(source, config.reward.item, amount) then
        exports.ox_inventory:AddItem(source, config.reward.item, amount)
        
        local fertBonus = prop.fertilizerType and ' (Fertilizer bonus applied!)' or ''
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = 'Harvested ' .. amount .. 'x ' .. config.reward.item .. fertBonus
        })
        
        -- Reset growing cycle
        prop.currentStage = 1
        prop.ready = false
        prop.fertilizerType = nil
        prop.growthMultiplier = 1.0
        prop.yieldMultiplier = 1.0
        prop.fertilizerLevel = 0
        
        -- Update database
        Database.UpdateProp(id, {
            currentStage = 1,
            ready = false,
            fertilizerType = nil,
            fertilizerLevel = 0
        })
        
        TriggerClientEvent('nd_drugs:client:updateGrowingStage', -1, id, 1)
        
        -- Restart timer
        StartGrowingTimer(id, prop.propType)
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Inventory full'
        })
    end
end)

-- Plant degradation over time
CreateThread(function()
    while true do
        Wait(60000) -- Every minute
        
        for id, prop in pairs(placedProps) do
            if prop.type == 'growing' then
                -- Reduce water level
                prop.waterLevel = math.max(0, (prop.waterLevel or 50) - 2)
                
                -- Reduce fertilizer level slowly
                if prop.fertilizerLevel and prop.fertilizerLevel > 0 then
                    prop.fertilizerLevel = math.max(0, prop.fertilizerLevel - 1)
                end
                
                -- Light varies by time of day (simple simulation)
                local hour = GetClockHours()
                if hour >= 6 and hour <= 18 then
                    prop.lightLevel = math.min(100, (prop.lightLevel or 75) + 1)
                else
                    prop.lightLevel = math.max(30, (prop.lightLevel or 75) - 2)
                end
                
                -- Recalculate health
                prop.plantHealth = CalculatePlantHealth(prop)
                
                -- Update database periodically
                if id and prop.plantHealth then
                    Database.UpdateProp(id, {
                        waterLevel = prop.waterLevel,
                        lightLevel = prop.lightLevel,
                        fertilizerLevel = prop.fertilizerLevel,
                        plantHealth = prop.plantHealth
                    })
                end
            end
        end
    end
end)
