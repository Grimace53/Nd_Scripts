local isNuiOpen = false
local currentPlant = nil
local plants = {} -- Store all plant entities

-- Plant data structure
local function createPlantData()
    return {
        health = 100,
        light = 75,
        water = 50,
        fertilizer = 0,
        entity = nil,
        coords = nil
    }
end

-- Function to open NUI with plant data
local function openPlantUI(plantEntity)
    if not plants[plantEntity] then
        plants[plantEntity] = createPlantData()
        plants[plantEntity].entity = plantEntity
        plants[plantEntity].coords = GetEntityCoords(plantEntity)
    end
    
    currentPlant = plantEntity
    isNuiOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = 'toggle',
        show = true,
        data = plants[plantEntity]
    })
end

-- Function to close NUI
local function closeNUI()
    isNuiOpen = false
    currentPlant = nil
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = 'toggle',
        show = false
    })
end

-- Close NUI from JavaScript
RegisterNUICallback('close', function(data, cb)
    closeNUI()
    cb('ok')
end)

-- Update plant levels from NUI sliders (for viewing/debugging only)
RegisterNUICallback('updateLevels', function(data, cb)
    if currentPlant and plants[currentPlant] then
        local plantData = plants[currentPlant]
        
        if data.light then
            plantData.light = math.max(0, math.min(100, data.light))
        end
        if data.water then
            plantData.water = math.max(0, math.min(100, data.water))
        end
        if data.fertilizer then
            plantData.fertilizer = math.max(0, math.min(100, data.fertilizer))
        end
        
        -- Calculate plant health
        local healthScore = (plantData.light * 0.4) + (plantData.water * 0.4) + (plantData.fertilizer * 0.2)
        plantData.health = math.floor(healthScore)
        
        cb({
            health = plantData.health,
            light = plantData.light,
            water = plantData.water,
            fertilizer = plantData.fertilizer
        })
    else
        cb({})
    end
end)

-- Water the plant (ox_target action)
local function waterPlant(plantEntity)
    if plants[plantEntity] then
        -- Add water (increase by 30, max 100)
        plants[plantEntity].water = math.min(100, plants[plantEntity].water + 30)
        
        -- Recalculate health
        local healthScore = (plants[plantEntity].light * 0.4) + (plants[plantEntity].water * 0.4) + (plants[plantEntity].fertilizer * 0.2)
        plants[plantEntity].health = math.floor(healthScore)
        
        lib.notify({
            title = 'Plant Watered',
            description = 'Water level increased to ' .. plants[plantEntity].water .. '%',
            type = 'success'
        })
        
        -- Update NUI if open
        if isNuiOpen and currentPlant == plantEntity then
            SendNUIMessage({
                type = 'update',
                data = plants[plantEntity]
            })
        end
    end
end

-- Fertilize the plant (ox_target action)
local function fertilizePlant(plantEntity)
    if plants[plantEntity] then
        -- Add fertilizer (increase by 50, max 100)
        plants[plantEntity].fertilizer = math.min(100, plants[plantEntity].fertilizer + 50)
        
        -- Recalculate health
        local healthScore = (plants[plantEntity].light * 0.4) + (plants[plantEntity].water * 0.4) + (plants[plantEntity].fertilizer * 0.2)
        plants[plantEntity].health = math.floor(healthScore)
        
        lib.notify({
            title = 'Plant Fertilized',
            description = 'Fertilizer level increased to ' .. plants[plantEntity].fertilizer .. '%',
            type = 'success'
        })
        
        -- Update NUI if open
        if isNuiOpen and currentPlant == plantEntity then
            SendNUIMessage({
                type = 'update',
                data = plants[plantEntity]
            })
        end
    end
end

-- Move the plant (ox_target action)
local function movePlant(plantEntity)
    if plants[plantEntity] then
        lib.notify({
            title = 'Move Plant',
            description = 'Plant movement feature - coming soon!',
            type = 'info'
        })
        -- TODO: Implement plant movement logic
    end
end

-- Pickup/destroy the plant (ox_target action)
local function pickupPlant(plantEntity)
    if plants[plantEntity] then
        local alert = lib.alertDialog({
            header = 'Pick Up Plant',
            content = 'Are you sure you want to pick up this plant? This will destroy it.',
            centered = true,
            cancel = true
        })
        
        if alert == 'confirm' then
            -- Remove plant data
            plants[plantEntity] = nil
            
            -- Close NUI if this plant is open
            if currentPlant == plantEntity then
                closeNUI()
            end
            
            -- Delete the entity (if you have permission)
            if DoesEntityExist(plantEntity) then
                DeleteEntity(plantEntity)
            end
            
            lib.notify({
                title = 'Plant Removed',
                description = 'Plant picked up successfully',
                type = 'success'
            })
        end
    end
end

-- Create a test plant for demonstration
CreateThread(function()
    -- Wait for game to load
    Wait(1000)
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local forwardVector = GetEntityForwardVector(playerPed)
    local plantCoords = coords + (forwardVector * 2.0)
    
    -- Create a plant prop (using a potted plant model)
    local plantModel = GetHashKey('prop_plant_01a')
    RequestModel(plantModel)
    while not HasModelLoaded(plantModel) do
        Wait(100)
    end
    
    local plant = CreateObject(plantModel, plantCoords.x, plantCoords.y, plantCoords.z - 1.0, false, false, false)
    FreezeEntityPosition(plant, true)
    
    -- Initialize plant data
    plants[plant] = createPlantData()
    plants[plant].entity = plant
    plants[plant].coords = GetEntityCoords(plant)
    
    -- Add ox_target options to the plant
    exports.ox_target:addLocalEntity(plant, {
        {
            name = 'view_plant',
            icon = 'fas fa-seedling',
            label = 'View Plant Health',
            onSelect = function(data)
                openPlantUI(data.entity)
            end
        },
        {
            name = 'water_plant',
            icon = 'fas fa-tint',
            label = 'Water Plant',
            onSelect = function(data)
                waterPlant(data.entity)
            end
        },
        {
            name = 'fertilize_plant',
            icon = 'fas fa-leaf',
            label = 'Fertilize Plant',
            onSelect = function(data)
                fertilizePlant(data.entity)
            end
        },
        {
            name = 'move_plant',
            icon = 'fas fa-arrows-alt',
            label = 'Move Plant',
            onSelect = function(data)
                movePlant(data.entity)
            end
        },
        {
            name = 'pickup_plant',
            icon = 'fas fa-hand-holding',
            label = 'Pick Up Plant',
            onSelect = function(data)
                pickupPlant(data.entity)
            end
        }
    })
    
    print('Plant created at ' .. plantCoords.x .. ', ' .. plantCoords.y .. ', ' .. plantCoords.z)
end)

-- Simulate natural degradation over time
CreateThread(function()
    while true do
        Wait(10000) -- Every 10 seconds
        
        -- Update all plants
        for entity, plantData in pairs(plants) do
            if DoesEntityExist(entity) then
                -- Light decreases slowly (clouds, time of day)
                plantData.light = math.max(0, plantData.light - 1)
                
                -- Water decreases faster
                plantData.water = math.max(0, plantData.water - 2)
                
                -- Fertilizer depletes slowly
                if plantData.fertilizer > 0 then
                    plantData.fertilizer = math.max(0, plantData.fertilizer - 0.5)
                end
                
                -- Recalculate health
                local healthScore = (plantData.light * 0.4) + (plantData.water * 0.4) + (plantData.fertilizer * 0.2)
                plantData.health = math.floor(healthScore)
                
                -- If NUI is open for this plant, update it
                if isNuiOpen and currentPlant == entity then
                    SendNUIMessage({
                        type = 'update',
                        data = plantData
                    })
                end
            else
                -- Entity doesn't exist anymore, remove from table
                plants[entity] = nil
            end
        end
    end
end)
