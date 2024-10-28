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

    StartJobTruck(jobType)

    self.currentCargo = ExCinere.Config.CargoTypes[math.random(#ExCinere.Config.CargoTypes)]

    SetCargoPickupMarker()
end

function JobManager:CompleteJob()
    self.isDoingJob = false
    JobManager.alreadyOnJobNotified = false
    RemoveDeliveryBlip()
    ShowHelpNotification("Job completed! You can start a new one.")
end