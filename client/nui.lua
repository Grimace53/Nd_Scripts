-- NUI Client for Plant Health System

local isNuiOpen = false
local currentPropId = nil

-- Open plant health NUI
function OpenPlantHealthUI(propId, propData)
    if not propData or propData.type ~= 'growing' then
        return
    end
    
    currentPropId = propId
    isNuiOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        type = 'toggle',
        show = true,
        data = {
            health = propData.plantHealth or 100,
            light = propData.lightLevel or 75,
            water = propData.waterLevel or 50,
            fertilizer = propData.fertilizerLevel or 0
        }
    })
end

-- Close NUI
local function CloseNUI()
    isNuiOpen = false
    currentPropId = nil
    SetNuiFocus(false, false)
    
    SendNUIMessage({
        type = 'toggle',
        show = false
    })
end

-- NUI Callbacks
RegisterNUICallback('close', function(data, cb)
    CloseNUI()
    cb('ok')
end)

-- Update levels (for demonstration/testing only - sliders are read-only in production)
RegisterNUICallback('updateLevels', function(data, cb)
    -- In production, this would just return current data
    -- Players can't manually adjust levels via sliders
    if currentPropId and growingProps[currentPropId] then
        local propData = growingProps[currentPropId].data
        
        cb({
            health = propData.plantHealth or 100,
            light = propData.lightLevel or 75,
            water = propData.waterLevel or 50,
            fertilizer = propData.fertilizerLevel or 0
        })
    else
        cb({})
    end
end)

-- Update NUI when prop data changes
RegisterNetEvent('nd_drugs:client:updatePropData', function(propId, propData)
    if growingProps[propId] then
        growingProps[propId].data = propData
        
        -- Update NUI if this prop is currently open
        if isNuiOpen and currentPropId == propId then
            SendNUIMessage({
                type = 'update',
                data = {
                    health = propData.plantHealth or 100,
                    light = propData.lightLevel or 75,
                    water = propData.waterLevel or 50,
                    fertilizer = propData.fertilizerLevel or 0
                }
            })
        end
    end
end)

-- Export function
exports('openPlantHealthUI', OpenPlantHealthUI)
