-- Server-side initialization and database setup

local function InitializeTables()
    -- Create tables for each drug type on resource start
    for drugType, drugData in pairs(Config.Drugs) do
        if drugData.growable then
            -- Growable drug table
            MySQL.query([[
                CREATE TABLE IF NOT EXISTS `drug_]]..drugType..[[` (
                    `id` INT AUTO_INCREMENT PRIMARY KEY,
                    `identifier` VARCHAR(50) NOT NULL,
                    `planted_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    `position` TEXT NOT NULL,
                    `growth_stage` INT DEFAULT 0,
                    `last_watered` TIMESTAMP NULL,
                    `harvestable` BOOLEAN DEFAULT FALSE,
                    INDEX `idx_identifier` (`identifier`),
                    INDEX `idx_harvestable` (`harvestable`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ]])
        else
            -- Non-growable drug table (AI interaction)
            MySQL.query([[
                CREATE TABLE IF NOT EXISTS `drug_]]..drugType..[[` (
                    `id` INT AUTO_INCREMENT PRIMARY KEY,
                    `identifier` VARCHAR(50) NOT NULL,
                    `location_index` INT NOT NULL,
                    `last_interaction` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    `items_received` TEXT NOT NULL,
                    INDEX `idx_identifier` (`identifier`),
                    INDEX `idx_location` (`location_index`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
            ]])
        end
    end
    
    -- Create cooldowns table
    MySQL.query([[
        CREATE TABLE IF NOT EXISTS `drug_cooldowns` (
            `id` INT AUTO_INCREMENT PRIMARY KEY,
            `identifier` VARCHAR(50) NOT NULL,
            `drug_type` VARCHAR(50) NOT NULL,
            `location_index` INT NOT NULL,
            `cooldown_until` TIMESTAMP NOT NULL,
            UNIQUE KEY `unique_cooldown` (`identifier`, `drug_type`, `location_index`),
            INDEX `idx_cooldown_check` (`identifier`, `drug_type`, `location_index`, `cooldown_until`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
    ]])
    
    print("^2[Nd_Scripts]^7 Drug system tables initialized")
end

-- Helper function to get player identifier
local function GetPlayerIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, id in pairs(identifiers) do
        if string.match(id, "license:") then
            return id
        end
    end
    return nil
end

-- Initialize on resource start
CreateThread(function()
    InitializeTables()
end)

-- Export helper function
exports('GetPlayerIdentifier', GetPlayerIdentifier)
