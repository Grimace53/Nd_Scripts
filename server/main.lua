local QBX = exports.qbx_core
local placedProps = {}
local growingTimers = {}

-- Initialize
CreateThread(function()
    -- Seed random number generator for better randomness
    math.randomseed(os.time())
    Utils.Debug('Server initialized')
end)

-- Load props (would normally be from database)
RegisterNetEvent('nd_drugs:server:loadProps', function()
    local source = source
    TriggerClientEvent('nd_drugs:client:syncProps', source, placedProps)
end)

-- Place prop
RegisterNetEvent('nd_drugs:server:placeProp', function(coords, propType, isGrowing)
    local source = source
    local playerPed = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Validate distance
    if Utils.GetDistance(playerCoords, coords) > Config.MaxPlacementDistance then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Too far to place prop'
        })
        return
    end
    
    -- Check if too close to other props
    for _, prop in pairs(placedProps) do
        if Utils.GetDistance(coords, prop.coords) < Config.MinDistanceBetweenProps then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'Too close to another prop'
            })
            return
        end
    end
    
    -- Generate ID
    local id = Utils.GenerateId()
    
    -- Create prop data
    local propData = {
        id = id,
        coords = coords,
        owner = source,
        type = isGrowing and 'growing' or 'crafting',
        propType = propType,
        placed = os.time()
    }
    
    if isGrowing then
        propData.model = Config.GrowingProps[propType].model
        propData.currentStage = 1
        propData.ready = false
        
        -- Start growing timer
        StartGrowingTimer(id, propType)
    else
        propData.model = Config.CraftingProps[propType].model
    end
    
    -- Remove item from inventory
    local itemName = isGrowing and Config.GrowingProps[propType].item or Config.CraftingProps[propType].item
    if not exports.ox_inventory:RemoveItem(source, itemName, 1) then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Failed to place prop'
        })
        return
    end
    
    -- Add to placed props
    placedProps[id] = propData
    
    -- Sync to all clients
    TriggerClientEvent('nd_drugs:client:syncProps', -1, placedProps)
    
    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Prop placed successfully'
    })
end)

-- Pickup prop
RegisterNetEvent('nd_drugs:server:pickupProp', function(id)
    local source = source
    
    if not placedProps[id] then
        return
    end
    
    local prop = placedProps[id]
    
    -- Check if owner or has permission
    if prop.owner ~= source and not IsPlayerAdmin(source) then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You do not own this prop'
        })
        return
    end
    
    -- Give item back
    local itemName = prop.type == 'growing' and Config.GrowingProps[prop.propType].item or Config.CraftingProps[prop.propType].item
    
    if exports.ox_inventory:CanCarryItem(source, itemName, 1) then
        exports.ox_inventory:AddItem(source, itemName, 1)
        
        -- Remove from placed props
        placedProps[id] = nil
        
        -- Stop growing timer if exists
        if growingTimers[id] then
            growingTimers[id] = nil
        end
        
        -- Remove from clients
        TriggerClientEvent('nd_drugs:client:removeProp', -1, id)
        
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = 'Prop picked up'
        })
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Inventory full'
        })
    end
end)

-- Start growing timer
function StartGrowingTimer(id, propType)
    local config = Config.GrowingProps[propType]
    
    CreateThread(function()
        growingTimers[id] = true
        
        for stage, stageData in ipairs(config.stages) do
            Wait(stageData.time)
            
            if not growingTimers[id] or not placedProps[id] then
                break
            end
            
            placedProps[id].currentStage = stage
            TriggerClientEvent('nd_drugs:client:updateGrowingStage', -1, id, stage)
            
            if stage == #config.stages then
                placedProps[id].ready = true
            end
        end
    end)
end

-- Harvest prop
RegisterNetEvent('nd_drugs:server:harvestProp', function(id)
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
    local amount = math.random(config.reward.min, config.reward.max)
    
    if exports.ox_inventory:CanCarryItem(source, config.reward.item, amount) then
        exports.ox_inventory:AddItem(source, config.reward.item, amount)
        
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'success',
            description = 'Harvested ' .. amount .. 'x ' .. config.reward.item
        })
        
        -- Reset growing cycle
        prop.currentStage = 1
        prop.ready = false
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

-- Craft item
RegisterNetEvent('nd_drugs:server:craftItem', function(id, recipeIndex)
    local source = source
    
    if not placedProps[id] or placedProps[id].type ~= 'crafting' then
        return
    end
    
    local prop = placedProps[id]
    local config = Config.CraftingProps[prop.propType]
    local recipe = config.recipes[recipeIndex]
    
    if not recipe then
        return
    end
    
    -- Check requirements
    for _, req in ipairs(recipe.requirements) do
        local hasItem = exports.ox_inventory:GetItem(source, req.item, nil, true)
        -- Explicitly check for nil/false and type before numeric comparison
        if not hasItem or type(hasItem) ~= 'number' or hasItem < req.amount then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'Missing required items'
            })
            return
        end
    end
    
    -- Start crafting progress
    local progressCompleted = lib.callback.await('ox_lib:progressCircle', source, {
        duration = recipe.craftTime,
        label = 'Crafting ' .. recipe.name,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true
        }
    })
    
    if not progressCompleted then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Crafting cancelled'
        })
        return
    end
    
    -- Remove requirements
    for _, req in ipairs(recipe.requirements) do
        local removed = exports.ox_inventory:RemoveItem(source, req.item, req.amount)
        if not removed then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'Failed to remove required items'
            })
            -- Attempt to return already removed items
            for i = 1, _ - 1 do
                local prevReq = recipe.requirements[i]
                exports.ox_inventory:AddItem(source, prevReq.item, prevReq.amount)
            end
            return
        end
    end
        -- Give output
        if exports.ox_inventory:CanCarryItem(source, recipe.output.item, recipe.output.amount) then
            exports.ox_inventory:AddItem(source, recipe.output.item, recipe.output.amount)
            
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'success',
                description = 'Crafted ' .. recipe.name
            })
            
            -- Trigger md-drugs export if enabled
            if Config.UseMDDrugs then
                TriggerEvent('md-drugs:server:itemCrafted', source, recipe.output.item, recipe.output.amount)
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'Inventory full'
            })
            
            -- Give back items
            for _, req in ipairs(recipe.requirements) do
                exports.ox_inventory:AddItem(source, req.item, req.amount)
            end
        end
end)

-- Helper function to check if player is admin
function IsPlayerAdmin(source)
    if not Config.UsePermissions then
        return true
    end
    
    local player = QBX:GetPlayer(source)
    if not player then
        return false
    end
    
    -- Check for PlayerData and job existence
    if not player.PlayerData or not player.PlayerData.job or not player.PlayerData.job.name then
        return false
    end
    
    -- Check job
    for _, job in ipairs(Config.AllowedJobs) do
        if player.PlayerData.job.name == job then
            return true
        end
    end
    
    return false
end

-- Export functions for other resources
exports('getPlacedProps', function()
    return placedProps
end)

exports('removeProp', function(id)
    if placedProps[id] then
        placedProps[id] = nil
        TriggerClientEvent('nd_drugs:client:removeProp', -1, id)
        return true
    end
    return false
end)
