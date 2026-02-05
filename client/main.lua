local QBX = exports.qbx_core
local placedProps = {}
local growingProps = {}

-- Initialize
CreateThread(function()
    Utils.Debug('Client initialized')
    
    -- Load placed props from server
    TriggerServerEvent('nd_drugs:server:loadProps')
end)

-- Register net events
RegisterNetEvent('nd_drugs:client:syncProps', function(props)
    placedProps = props
    for id, prop in pairs(props) do
        if prop.type == 'growing' then
            SpawnGrowingProp(id, prop)
        elseif prop.type == 'crafting' then
            SpawnCraftingProp(id, prop)
        end
    end
end)

-- Spawn growing prop
function SpawnGrowingProp(id, propData)
    local model = propData.currentStage and Config.GrowingProps[propData.propType].stages[propData.currentStage].model or propData.model
    
    lib.requestModel(model, 10000)
    
    local obj = CreateObject(model, propData.coords.x, propData.coords.y, propData.coords.z, false, false, false)
    SetEntityHeading(obj, propData.coords.w or 0.0)
    FreezeEntityPosition(obj, true)
    
    growingProps[id] = {
        object = obj,
        data = propData
    }
    
    -- Add ox_target interaction
    exports.ox_target:addLocalEntity(obj, {
        {
            name = 'pickup_growing_prop',
            label = 'Pick Up Growing Pot',
            icon = 'fas fa-hand-paper',
            onSelect = function()
                TriggerServerEvent('nd_drugs:server:pickupProp', id)
            end
        },
        {
            name = 'harvest_growing_prop',
            label = 'Harvest',
            icon = 'fas fa-seedling',
            canInteract = function()
                return propData.ready
            end,
            onSelect = function()
                TriggerServerEvent('nd_drugs:server:harvestProp', id)
            end
        }
    })
end

-- Spawn crafting prop
function SpawnCraftingProp(id, propData)
    lib.requestModel(propData.model, 10000)
    
    local obj = CreateObject(propData.model, propData.coords.x, propData.coords.y, propData.coords.z, false, false, false)
    SetEntityHeading(obj, propData.coords.w or 0.0)
    FreezeEntityPosition(obj, true)
    
    growingProps[id] = {
        object = obj,
        data = propData
    }
    
    -- Add ox_target interaction
    local options = {
        {
            name = 'pickup_crafting_prop',
            label = 'Pick Up Crafting Table',
            icon = 'fas fa-hand-paper',
            onSelect = function()
                TriggerServerEvent('nd_drugs:server:pickupProp', id)
            end
        }
    }
    
    -- Add crafting recipes
    if propData.propType and Config.CraftingProps[propData.propType] then
        for idx, recipe in ipairs(Config.CraftingProps[propData.propType].recipes) do
            table.insert(options, {
                name = 'craft_' .. recipe.item,
                label = 'Craft ' .. recipe.name,
                icon = 'fas fa-flask',
                onSelect = function()
                    TriggerServerEvent('nd_drugs:server:craftItem', id, idx)
                end
            })
        end
    end
    
    exports.ox_target:addLocalEntity(obj, options)
end

-- Remove prop
RegisterNetEvent('nd_drugs:client:removeProp', function(id)
    if growingProps[id] then
        if DoesEntityExist(growingProps[id].object) then
            DeleteEntity(growingProps[id].object)
        end
        growingProps[id] = nil
    end
end)

-- Update growing stage
RegisterNetEvent('nd_drugs:client:updateGrowingStage', function(id, stage)
    if growingProps[id] and growingProps[id].data.type == 'growing' then
        local propData = growingProps[id].data
        local config = Config.GrowingProps[propData.propType]
        
        if config.stages[stage] then
            -- Delete old object
            if DoesEntityExist(growingProps[id].object) then
                DeleteEntity(growingProps[id].object)
            end
            
            -- Spawn new stage
            propData.currentStage = stage
            SpawnGrowingProp(id, propData)
        end
    end
end)

-- Place prop from inventory
function PlaceProp(propType, isGrowing)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    -- Get placement position in front of player
    local forwardVector = GetEntityForwardVector(playerPed)
    local placementCoords = coords + forwardVector * 2.0
    
    -- Raycast to ground
    local rayHandle = StartShapeTestRay(placementCoords.x, placementCoords.y, placementCoords.z + 2.0,
        placementCoords.x, placementCoords.y, placementCoords.z - 2.0,
        1, playerPed, 0)
    local _, hit, endCoords = GetShapeTestResult(rayHandle)
    
    if hit then
        placementCoords = endCoords + vector3(0, 0, Config.PlacementHeight)
    end
    
    -- Send to server
    TriggerServerEvent('nd_drugs:server:placeProp', {
        x = placementCoords.x,
        y = placementCoords.y,
        z = placementCoords.z,
        w = heading
    }, propType, isGrowing)
end

-- Register usable items with ox_inventory
exports.ox_inventory:registerHook('createItem', function(payload)
    if payload.metadata.propType then
        local isGrowing = payload.metadata.isGrowing or false
        PlaceProp(payload.metadata.propType, isGrowing)
    end
end, {
    print = true,
    itemFilter = {
        drug_pot = true,
        craft_table = true
    }
})

-- Export functions
exports('placeProp', PlaceProp)
