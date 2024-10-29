JobManager = {
    isDoingJob = false,
    currentDeliveryLocation = nil,
    deliveryBlip = nil,
    alreadyOnJobNotified = false
}

CargoManager = {
    cargoBlip = nil,
    cargoMarkerLocations = ExCinere.Config.CargoPickupLocations
}

CreateThread(function()
    while true do
        Wait(0)

        DrawMarkersAtJobStartLocations()

        local playerCoords = GetEntityCoords(PlayerPedId())
        
        if JobManager.isDoingJob then
            if not JobManager.alreadyOnJobNotified then
                ShowHelpNotification("You are already on a job!")
                JobManager.alreadyOnJobNotified = true
            end
        else
            JobManager.alreadyOnJobNotified = false

            for _, location in pairs(ExCinere.Config.JobStartLocations) do
                local distance = #(playerCoords - location)

                if distance < 3.0 then
                    ShowHelpNotification("Press ~INPUT_CONTEXT~ to start a job")

                    if IsControlJustReleased(1, 51) then
                        OpenJobStartUI()
                    end
                end
            end
        end
    end
end)

function JobManager:StartJob(jobType)
    if self.isDoingJob then
        ShowHelpNotification("You are already on a job!")
        return
    end

    self.isDoingJob = true
    print("Starting job for truck type:", jobType)

    CargoManager:ClearExistingTrailer()

    StartJobTruck(jobType)

    local trailerTypeKey
    if jobType == "freight" then
        trailerTypeKey = (math.random() < 0.5) and "Automotive" or "Military"
    elseif jobType == "quick" then
        trailerTypeKey = (math.random() < 0.5) and "Regular" or "Industrial"
    else
        local trailerTypeKeys = {}
        for key in pairs(ExCinere.Config.TrailerTypes) do
            table.insert(trailerTypeKeys, key)
        end
        trailerTypeKey = trailerTypeKeys[math.random(#trailerTypeKeys)]
    end

    print("Selected trailer type key:", trailerTypeKey)
    local trailerType = ExCinere.Config.TrailerTypes[trailerTypeKey]
    if not trailerType then
        print("Error: Trailer type configuration not found for key:", trailerTypeKey)
        ShowHelpNotification("Could not start job. Trailer type configuration missing.")
        return
    end

    CargoManager.cargoMarkerLocation = CargoManager.cargoMarkerLocations[math.random(#CargoManager.cargoMarkerLocations)]
    
    local selectedTrailer = trailerType.Trailers[math.random(#trailerType.Trailers)]
    if trailerTypeKey == "Military" then
        if selectedTrailer == "armytrailer" then
            print("Military job selected with armytrailer, spawning single large vehicle on trailer.")
            SpawnTrailerWithLargeMilitaryVehicle(trailerType)
        else
            print("Military job selected with " .. selectedTrailer .. " trailer. No vehicles will be spawned.")
            CargoManager.cargoTrailer = SpawnCargoForPickup(selectedTrailer)
        end
    elseif trailerType.SpawnVehicles then
        if trailerTypeKey == "Automotive" then
            print("Automotive job selected, spawning vehicles on trailer.")
            SpawnTrailerWithCars(trailerType)
        end
    else
        CargoManager.cargoTrailer = SpawnCargoForPickup(selectedTrailer)
    end

    SetCargoPickupMarker()
end

function JobManager:CompleteJob()
    self.isDoingJob = false
    JobManager.alreadyOnJobNotified = false
    RemoveDeliveryBlip()
    ShowHelpNotification("Job completed! You can start a new one.")
end

function CargoManager:ClearExistingTrailer()
    if self.cargoTrailer then
        DeleteEntity(self.cargoTrailer)
        self.cargoTrailer = nil
        print("Previous trailer deleted.")
    end
end
