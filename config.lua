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

    CargoTypes = {
        "trailers4",
        "trailers",
        "trailerlogs",
        -- Add more as needed
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
