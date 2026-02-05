Config = {}

-- General Settings
Config.Debug = false
Config.UseTarget = true -- Use ox_target for interactions

-- Growing System (PR #4 Foundation)
Config.GrowingProps = {
    pot = {
        model = 'bkr_prop_weed_01_small_01c',
        label = 'Drug Growing Pot',
        item = 'drug_pot',
        growTime = 300000, -- 5 minutes in milliseconds
        stages = {
            {model = 'bkr_prop_weed_01_small_01a', stage = 1, time = 100000},
            {model = 'bkr_prop_weed_01_small_01b', stage = 2, time = 200000},
            {model = 'bkr_prop_weed_01_small_01c', stage = 3, time = 300000}
        },
        reward = {
            item = 'weed_leaf',
            min = 1,
            max = 3
        }
    },
    coca_pot = {
        model = 'bkr_prop_weed_01_small_01c',
        label = 'Coca Growing Pot',
        item = 'coca_pot',
        growTime = 450000, -- 7.5 minutes
        stages = {
            {model = 'bkr_prop_weed_01_small_01a', stage = 1, time = 150000},
            {model = 'bkr_prop_weed_01_small_01b', stage = 2, time = 300000},
            {model = 'bkr_prop_weed_01_small_01c', stage = 3, time = 450000}
        },
        reward = {
            item = 'coca_leaf',
            min = 1,
            max = 2
        }
    }
}

-- Crafting System (PR #4 Foundation)
Config.CraftingProps = {
    crafting_table = {
        model = 'bkr_prop_meth_table01a',
        label = 'Drug Crafting Table',
        item = 'craft_table',
        recipes = {
            {
                name = 'Processed Weed',
                item = 'weed',
                requirements = {
                    {item = 'weed_leaf', amount = 3},
                    {item = 'rolling_paper', amount = 1}
                },
                craftTime = 10000, -- 10 seconds
                output = {item = 'weed', amount = 1}
            },
            {
                name = 'Cocaine',
                item = 'coke',
                requirements = {
                    {item = 'coca_leaf', amount = 3},
                    {item = 'chemicals', amount = 1}
                },
                craftTime = 15000,
                output = {item = 'coke', amount = 1}
            },
            {
                name = 'Meth',
                item = 'meth',
                requirements = {
                    {item = 'meth_ingredient', amount = 2},
                    {item = 'meth_chemical', amount = 1}
                },
                craftTime = 20000,
                output = {item = 'meth', amount = 1}
            }
        }
    }
}

-- Non-Growable Drugs (PR #2 - NPC/AI Interactions)
Config.NonGrowableDrugs = {
    meth = {
        label = 'Meth',
        pedModel = 'a_m_m_hillbilly_02',
        locations = {
            {x = 1391.74, y = 3605.87, z = 38.94, heading = 200.0}, -- Sandy Shores
            {x = 2434.14, y = 4968.74, z = 42.35, heading = 45.0}   -- Grapeseed
        },
        items = {
            {item = 'meth_ingredient', amount = {min = 1, max = 3}, chance = 70},
            {item = 'meth_chemical', amount = {min = 1, max = 2}, chance = 50}
        },
        minigameType = 'lockpick'
    },
    heroin = {
        label = 'Heroin',
        pedModel = 'a_m_m_beach_02',
        locations = {
            {x = 2220.39, y = 5577.17, z = 53.81, heading = 90.0},    -- Paleto Bay
            {x = -1149.23, y = -1521.12, z = 4.37, heading = 180.0}   -- Beach
        },
        items = {
            {item = 'heroin_ingredient', amount = {min = 1, max = 3}, chance = 60},
            {item = 'heroin_powder', amount = {min = 1, max = 2}, chance = 40}
        },
        minigameType = 'hacking'
    },
    lsd = {
        label = 'LSD',
        pedModel = 'a_m_y_hipster_02',
        locations = {
            {x = 717.23, y = -975.61, z = 24.88, heading = 270.0}  -- Downtown
        },
        items = {
            {item = 'lsd_paper', amount = {min = 2, max = 5}, chance = 80},
            {item = 'lsd_liquid', amount = {min = 1, max = 2}, chance = 40}
        },
        minigameType = 'skillcheck'
    }
}

-- Non-Growable Settings (PR #2)
Config.NonGrowableSettings = {
    interactionDistance = 2.5,
    cooldownTime = 300000, -- 5 minutes
    pedInvincible = true,
    pedFrozen = true
}

-- Placement Settings
Config.MaxPlacementDistance = 5.0
Config.MinDistanceBetweenProps = 2.0
Config.PlacementHeight = 0.0

-- Plant Health Settings (PR #5)
Config.PlantHealth = {
    enabled = true,
    degradationRate = 60000, -- Check every minute
    waterDegradation = 2,    -- Water decreases by 2% per check
    fertilizerDegradation = 1 -- Fertilizer decreases by 1% per check
}

-- Permissions
Config.UsePermissions = false
Config.AllowedJobs = {
    'police',
    'admin'
}

-- Integration
Config.UseMDDrugs = true

return Config
