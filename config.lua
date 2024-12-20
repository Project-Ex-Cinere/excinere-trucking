ExCinere = {}
ExCinere.Config = {

    BasePay = 1000,
    ExperienceMultiplier = 1.5,

    -- Test Mock Data for now
    Jobs = {
        quick = {
            title = "Quick Job",
            description = "Deliver a trailer to a nearby location",
            reward = "$1000",
            distance = "1 mile"
        },
        freight = {
            title = "Freight Job",
            description = "Deliver a trailer to a distant location",
            reward = "2000",
            distance = "5 miles"
        }
    },

    TruckModels = {
        quick = "packer",  
        freight = "phantom3"  
    },

    TrailerTypes = {
        Regular = {
            Trailers = { "trailers4", "trailers"},
            SpawnVehicles = false  -- No vehicles for Regular type
        },
        Industrial = {
            Trailers = { "tanker", "trailerlogs" },
            SpawnVehicles = false  -- No vehicles for Industrial type
        },
        Military = {
            Trailers = { "armytrailer", "armytanker", "armytrailer2" },
            SpawnVehicles = true,
            MaxVehicles = 1,
            Vehicles = {
                { model = "rhino", chance = 0.2 },
                { model = "lazer", chance = 0.1 },
                { model = "crusader", chance = 0.7 },
                { model = "barracks", chance = 0.6 },
                { model = "apc", chance = 0.4 }
            }
        },
        -- Props = {
        --     Trailers = { "prop_trailer" },
        --     SpawnVehicles = false  -- No vehicles for Props type
        -- },
        -- Special = {
        --     Trailers = { "special_trailer" },
        --     SpawnVehicles = false  -- No vehicles for Special type
        -- },
        Automotive = {  -- New Automotive trailer type
            Trailers = { "tr2" },
            SpawnVehicles = true,  -- This type spawns vehicles
            MaxVehicles = 6,       -- Maximum of 6 vehicles
            Vehicles = {
                { model = "comet2", chance = 0.5 },
                { model = "banshee", chance = 0.5 },
                { model = "buffalo", chance = 0.5 },
                { model = "infernus", chance = 0.5 },
                { model = "adder", chance = 0.5 },
                { model = "sultanrs", chance = 0.5 },
            }
        }
    },

    TruckImages = {
        ["default"] = "assets/images/default_truck.png"
    },

    Economy = {
        RepairCostMultiplier = 0.05,
        LoanInterestRate = 0.02
    },

    JobStartLocations = {
        vector3(1789.22, 3873.07, 34.27),
    },

    CargoPickupLocations = { 
        vector3(1670.63, 3828.6, 34.91),
    },

    DeliveryLocations = {  -- New field for delivery locations
        vector3(1981.55, 3781.15, 32.18),
    }
}
