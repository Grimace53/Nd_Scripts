-- Client-side notification handler
-- Adapt this to work with your notification system

RegisterNetEvent('nd_drugs:client:notify', function(message, type)
    -- Example implementations for different frameworks:
    
    -- QBCore:
    -- if GetResourceState('qb-core') == 'started' then
    --     QBCore.Functions.Notify(message, type)
    -- end
    
    -- ESX:
    -- if GetResourceState('es_extended') == 'started' then
    --     ESX.ShowNotification(message)
    -- end
    
    -- ox_lib:
    -- if GetResourceState('ox_lib') == 'started' then
    --     lib.notify({
    --         title = 'Drug System',
    --         description = message,
    --         type = type
    --     })
    -- end
    
    -- Standalone/Default: Simple chat message
    TriggerEvent('chat:addMessage', {
        color = type == 'error' and {255, 0, 0} or type == 'success' and {0, 255, 0} or {255, 255, 255},
        multiline = true,
        args = {"[Drugs]", message}
    })
end)
