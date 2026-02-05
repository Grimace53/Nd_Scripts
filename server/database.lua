-- Database operations module
Database = {}

-- Initialize database tables
function Database.Init()
    Utils.Debug('Initializing database tables...')
    -- Tables will be created via schema.sql
end

-- Save placed prop to database
function Database.SaveProp(propData)
    local success = MySQL.insert.await(
        'INSERT INTO drug_placed_props (id, owner, coords, prop_type, type, model, placed, current_stage, ready, plant_health, water_level, light_level, fertilizer_level, fertilizer_type) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)',
        {
            propData.id,
            propData.owner,
            json.encode(propData.coords),
            propData.propType,
            propData.type,
            propData.model,
            propData.placed or os.time(),
            propData.currentStage or 1,
            propData.ready or false,
            propData.plantHealth or 100,
            propData.waterLevel or 50,
            propData.lightLevel or 75,
            propData.fertilizerLevel or 0,
            propData.fertilizerType or nil
        }
    )
    return success
end

-- Load all placed props
function Database.LoadAllProps()
    local result = MySQL.query.await('SELECT * FROM drug_placed_props', {})
    if result then
        local props = {}
        for _, row in ipairs(result) do
            props[row.id] = {
                id = row.id,
                owner = row.owner,
                coords = json.decode(row.coords),
                propType = row.prop_type,
                type = row.type,
                model = row.model,
                placed = row.placed,
                currentStage = row.current_stage,
                ready = row.ready == 1,
                plantHealth = row.plant_health,
                waterLevel = row.water_level,
                lightLevel = row.light_level,
                fertilizerLevel = row.fertilizer_level,
                fertilizerType = row.fertilizer_type
            }
        end
        return props
    end
    return {}
end

-- Update prop data
function Database.UpdateProp(id, data)
    local updates = {}
    local values = {}
    
    if data.currentStage then
        table.insert(updates, 'current_stage = ?')
        table.insert(values, data.currentStage)
    end
    if data.ready ~= nil then
        table.insert(updates, 'ready = ?')
        table.insert(values, data.ready)
    end
    if data.plantHealth then
        table.insert(updates, 'plant_health = ?')
        table.insert(values, data.plantHealth)
    end
    if data.waterLevel then
        table.insert(updates, 'water_level = ?')
        table.insert(values, data.waterLevel)
    end
    if data.lightLevel then
        table.insert(updates, 'light_level = ?')
        table.insert(values, data.lightLevel)
    end
    if data.fertilizerLevel then
        table.insert(updates, 'fertilizer_level = ?')
        table.insert(values, data.fertilizerLevel)
    end
    if data.fertilizerType then
        table.insert(updates, 'fertilizer_type = ?')
        table.insert(values, data.fertilizerType)
    end
    
    if #updates > 0 then
        table.insert(values, id)
        local query = 'UPDATE drug_placed_props SET ' .. table.concat(updates, ', ') .. ' WHERE id = ?'
        return MySQL.update.await(query, values)
    end
    return false
end

-- Delete prop from database
function Database.DeleteProp(id)
    return MySQL.query.await('DELETE FROM drug_placed_props WHERE id = ?', {id})
end

-- Growable drug operations
function Database.PlantDrug(drugType, identifier, position)
    local insertId = MySQL.insert.await(
        'INSERT INTO drug_'..drugType..' (identifier, position, growth_stage, harvestable) VALUES (?, ?, ?, ?)',
        {identifier, json.encode(position), 0, false}
    )
    return insertId
end

function Database.GetPlant(drugType, plantId)
    return MySQL.single.await('SELECT * FROM drug_'..drugType..' WHERE id = ?', {plantId})
end

function Database.UpdatePlantStage(drugType, plantId, stage, harvestable)
    return MySQL.update.await(
        'UPDATE drug_'..drugType..' SET growth_stage = ?, harvestable = ? WHERE id = ?',
        {stage, harvestable, plantId}
    )
end

function Database.DeletePlant(drugType, plantId)
    return MySQL.query.await('DELETE FROM drug_'..drugType..' WHERE id = ?', {plantId})
end

function Database.GetAllPlants(drugType)
    return MySQL.query.await('SELECT * FROM drug_'..drugType, {})
end

function Database.ApplyFertilizer(drugType, plantId, fertilizerType, growthMult, yieldMult)
    return MySQL.update.await(
        'UPDATE drug_'..drugType..' SET fertilizer_type = ?, fertilizer_applied_at = NOW(), growth_multiplier = ?, yield_multiplier = ? WHERE id = ?',
        {fertilizerType, growthMult, yieldMult, plantId}
    )
end

-- Cooldown operations
function Database.IsOnCooldown(identifier, drugType, locationIndex)
    local result = MySQL.single.await(
        'SELECT cooldown_until FROM drug_cooldowns WHERE identifier = ? AND drug_type = ? AND location_index = ? AND cooldown_until > NOW()',
        {identifier, drugType, locationIndex}
    )
    return result ~= nil
end

function Database.SetCooldown(identifier, drugType, locationIndex, cooldownSeconds)
    return MySQL.insert.await(
        'INSERT INTO drug_cooldowns (identifier, drug_type, location_index, cooldown_until) VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? SECOND)) ON DUPLICATE KEY UPDATE cooldown_until = DATE_ADD(NOW(), INTERVAL ? SECOND)',
        {identifier, drugType, locationIndex, cooldownSeconds, cooldownSeconds}
    )
end

-- Non-growable drug interaction logging
function Database.LogDrugInteraction(drugType, identifier, locationIndex, itemsReceived)
    return MySQL.insert.await(
        'INSERT INTO drug_'..drugType..' (identifier, location_index, items_received) VALUES (?, ?, ?)',
        {identifier, locationIndex, json.encode(itemsReceived)}
    )
end

return Database
