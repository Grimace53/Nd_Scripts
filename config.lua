Config = {}

-- General Settings
Config.Debug = false
Config.UseTarget = true -- Use ox_target for interactions

-- Growing System
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
    }
}

-- Crafting System
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
            }
        }
    }
}

-- Placement Settings
Config.MaxPlacementDistance = 5.0
Config.MinDistanceBetweenProps = 2.0
Config.PlacementHeight = 0.0 -- Ground level offset

-- Permissions (if using permissions)
Config.UsePermissions = false
Config.AllowedJobs = {
    'police',
    'admin'
}

-- Integration with md-drugs
Config.UseMDDrugs = true

return Config
