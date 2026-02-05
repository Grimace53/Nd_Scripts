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
            name = 'view_plant_health',
            label = 'View Plant Health',
            icon = 'fas fa-heart',
            onSelect = function()
                exports['nd_drugs']:openPlantHealthUI(id, growingProps[id].data)
            end
        },
        {
            name = 'water_plant',
            label = 'Water Plant',
            icon = 'fas fa-tint',
            onSelect = function()
                TriggerServerEvent('nd_drugs:server:waterPlant', id)
            end
        },
        {
            name = 'apply_fertilizer',
            label = 'Apply Fertilizer',
            icon = 'fas fa-leaf',
            canInteract = function()
                return growingProps[id] and not growingProps[id].data.fertilizerType
            end,
            onSelect = function()
                -- Show fertilizer selection menu
                local options = {}
                for fertType, fertConfig in pairs(Fertilizers) do
                    table.insert(options, {
                        title = fertConfig.label,
                        description = fertConfig.description,
                        icon = 'leaf',
                        onSelect = function()
                            TriggerServerEvent('nd_drugs:server:applyFertilizerToPot', id, fertType)
                        end
                    })
                end
                
                lib.registerContext({
                    id = 'fertilizer_menu',
                    title = 'Select Fertilizer',
                    options = options
                })
                lib.showContext('fertilizer_menu')
            end
        },
        {
            name = 'harvest_growing_prop',
            label = 'Harvest',
            icon = 'fas fa-seedling',
            canInteract = function()
                return growingProps[id] and growingProps[id].data.ready
            end,
            onSelect = function()
                TriggerServerEvent('nd_drugs:server:harvestPropWithFertilizer', id)
            end
        },
        {
            name = 'pickup_growing_prop',
            label = 'Pick Up Pot',
            icon = 'fas fa-hand-paper',
            onSelect = function()
                TriggerServerEvent('nd_drugs:server:pickupProp', id)
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
function PlaceProp(data, slot)
    local propType
    local isGrowing = false
    
    -- Determine prop type based on item name
    if data.name == 'drug_pot' then
        propType = 'pot'
        isGrowing = true
    elseif data.name == 'craft_table' then
        propType = 'crafting_table'
        isGrowing = false
    else
        return
    end
    
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

-- Export functions
exports('placeProp', PlaceProp)
