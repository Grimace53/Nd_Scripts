-- Shared utility functions

Utils = {}

-- Generate unique ID for props
-- Uses a combination of timestamp, random number, and counter for uniqueness
local idCounter = 0
function Utils.GenerateId()
    idCounter = idCounter + 1
    local timestamp = os.time()
    local random = math.random(1000, 9999)
    return string.format('prop_%d_%d_%d', timestamp, random, idCounter)
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
