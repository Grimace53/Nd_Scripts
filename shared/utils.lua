-- Shared utility functions

Utils = {}

-- Generate unique ID for props
function Utils.GenerateId()
    return 'prop_' .. math.random(10000, 99999) .. '_' .. os.time()
end

-- Check if player has required items
function Utils.HasRequiredItems(source, requirements)
    for _, req in ipairs(requirements) do
        local hasItem = exports.ox_inventory:GetItem(source, req.item, nil, true)
        if not hasItem or hasItem < req.amount then
            return false, req.item
        end
    end
    return true
end

-- Calculate distance between two points
function Utils.GetDistance(coords1, coords2)
    return #(vector3(coords1.x, coords1.y, coords1.z) - vector3(coords2.x, coords2.y, coords2.z))
end

-- Debug print
function Utils.Debug(...)
    if Config.Debug then
        print('[ND_DRUGS]', ...)
    end
end

return Utils
