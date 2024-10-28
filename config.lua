ExCinere = {}
ExCinere.Config = {

    BasePay = 1000,
    ExperienceMultiplier = 1.5,

    JobNames = {
        quick = "Quick Job",
        freight = "Freight Job"
    },

    TruckModels = {
        quick = "phantom",  
        freight = "packer"  
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
            Trailers = { "armytrailer" },
            SpawnVehicles = true,
            MaxVehicles = 1, -- Only one large vehicle
            Vehicles = {
                { model = "rhino", chance = 0.7 },  -- Tank
                { model = "lazer", chance = 0.3 }   -- Fighter jet
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
