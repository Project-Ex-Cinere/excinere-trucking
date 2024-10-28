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

    print("Selected trailer type:", trailerTypeKey)
    
    SetCargoPickupMarker(trailerType)

    if trailerType.SpawnVehicles then
        if trailerTypeKey == "Automotive" then
            print("Automotive job selected, spawning vehicles on trailer.")
            SpawnTrailerWithCars(trailerType)
        elseif trailerTypeKey == "Military" then
            print("Military job selected, spawning single large vehicle on trailer.")
            SpawnTrailerWithLargeMilitaryVehicle(trailerType)
        end
    end
end


function JobManager:CompleteJob()
    self.isDoingJob = false
    JobManager.alreadyOnJobNotified = false
    RemoveDeliveryBlip()
    ShowHelpNotification("Job completed! You can start a new one.")
end