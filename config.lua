Config = {}

-- Drug Types Configuration
-- Each drug type will have its own database table
Config.Drugs = {
    -- Growable Drugs (can be planted in pots)
    weed = {
        label = "Weed",
        growable = true,
        growTime = 600000, -- 10 minutes in milliseconds
        harvestAmount = {min = 3, max = 7},
        requiredItem = "weed_seed",
        harvestedItem = "weed_bud",
        potModel = "bkr_prop_weed_01_small_01c",
        -- Database table will be created as 'drug_weed'
    },
    cocaine = {
        label = "Cocaine",
        growable = true,
        growTime = 900000, -- 15 minutes
        harvestAmount = {min = 2, max = 5},
        requiredItem = "coca_seed",
        harvestedItem = "coca_leaf",
        potModel = "bkr_prop_weed_01_small_01c",
        -- Database table will be created as 'drug_cocaine'
    },
    
    -- Non-Growable Drugs (obtained through AI interaction)
    meth = {
        label = "Meth",
        growable = false,
        -- AI interaction locations (vec4: x, y, z, heading)
        locations = {
            {x = 1391.74, y = 3605.87, z = 38.94, heading = 200.0}, -- Sandy Shores
            {x = 2434.14, y = 4968.74, z = 42.35, heading = 45.0},  -- Grapeseed
        },
        pedModel = "a_m_m_hillbilly_02",
        -- Items that can be obtained from this AI
        items = {
            {item = "meth_ingredient", amount = {min = 1, max = 3}, chance = 70}, -- 70% chance
            {item = "meth_chemical", amount = {min = 1, max = 2}, chance = 50},   -- 50% chance
        },
        minigameType = "lockpick", -- Type of minigame to trigger
        -- Database table will be created as 'drug_meth'
    },
    heroin = {
        label = "Heroin",
        growable = false,
        locations = {
            {x = 2220.39, y = 5577.17, z = 53.81, heading = 90.0},  -- Paleto Bay
            {x = -1149.23, y = -1521.12, z = 4.37, heading = 180.0}, -- Beach
        },
        pedModel = "a_m_m_beach_02",
        items = {
            {item = "heroin_ingredient", amount = {min = 1, max = 3}, chance = 60},
            {item = "heroin_powder", amount = {min = 1, max = 2}, chance = 40},
        },
        minigameType = "hacking",
        -- Database table will be created as 'drug_heroin'
    },
    lsd = {
        label = "LSD",
        growable = false,
        locations = {
            {x = 717.23, y = -975.61, z = 24.88, heading = 270.0}, -- Downtown
        },
        pedModel = "a_m_y_hipster_02",
        items = {
            {item = "lsd_paper", amount = {min = 2, max = 5}, chance = 80},
            {item = "lsd_liquid", amount = {min = 1, max = 2}, chance = 40},
        },
        minigameType = "skillcheck",
        -- Database table will be created as 'drug_lsd'
    },
}

-- Pot Configuration for Growable Drugs
Config.PotSettings = {
    maxDistance = 2.0, -- Max distance to interact with pot
    wateringRequired = true,
    wateringInterval = 300000, -- 5 minutes
}

-- AI Interaction Settings
Config.AISettings = {
    interactionDistance = 2.5,
    cooldownTime = 300000, -- 5 minutes cooldown per location
    pedInvincible = true,
    pedFrozen = true,
}

-- Minigame Settings
Config.Minigames = {
    lockpick = {
        difficulty = "medium",
        duration = 10000, -- 10 seconds
    },
    hacking = {
        difficulty = "hard",
        duration = 15000,
    },
    skillcheck = {
        difficulty = "easy",
        duration = 8000,
    },
}
