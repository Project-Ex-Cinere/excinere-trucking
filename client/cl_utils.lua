function DrawMarkersAtJobStartLocations()
    local playerCoords = GetEntityCoords(PlayerPedId())

    for _, location in pairs(ExCinere.Config.JobStartLocations) do
        local distance = #(playerCoords - location)

        if distance < 50.0 then
            DrawMarker(
                1, 
                location.x,
                location.y,
                location.z - 1.0,
                0, 0, 0,
                0, 0, 0,
                2.0, 2.0, 2.0,
                255, 0, 0, 150,
                false, false, 2, nil, nil, false
            )
        end
    end
end

function ShowHelpNotification(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

function OpenJobStartUI()
    if JobManager.isDoingJob then
        ShowHelpNotification("You are already on a job!")
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({ action = "showUI" })
end

-- Function to close the job UI
RegisterNUICallback('closeUI', function(_, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

-- Callback for starting a quick job
RegisterNUICallback('startQuickJob', function(_, cb)
    JobManager:StartJob("quick")
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('startFreightJob', function(_, cb)
    JobManager:StartJob("freight")
    SetNuiFocus(false, false)
    cb('ok')
end)

function StartJobTruck(jobType)
    local truckModel = ExCinere.Config.TruckModels[jobType]
    if truckModel then
        SpawnTruck(truckModel)
    end
end

function SpawnTruck(model)
    local modelHash = GetHashKey(model)

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(0)
    end

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    local vehicle = CreateVehicle(modelHash, playerCoords.x + 5, playerCoords.y, playerCoords.z, heading, true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1) 
end

function SpawnCargoForPickup(cargoModel)
    local modelHash = GetHashKey(cargoModel)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(0)
    end

    local vehicleCoords = vector3(CargoManager.cargoMarkerLocation.x + 5, CargoManager.cargoMarkerLocation.y, CargoManager.cargoMarkerLocation.z)
    CargoManager.cargoTrailer = CreateVehicle(modelHash, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 0.0, true, false)
end

function SetCargoPickupMarker()
    CargoManager.cargoMarkerLocation = CargoManager.cargoMarkerLocations[math.random(#CargoManager.cargoMarkerLocations)]

    CargoManager.cargoBlip = AddBlipForCoord(CargoManager.cargoMarkerLocation.x, CargoManager.cargoMarkerLocation.y, CargoManager.cargoMarkerLocation.z)
    SetBlipSprite(CargoManager.cargoBlip, 479)
    SetBlipColour(CargoManager.cargoBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cargo Pickup Point")
    EndTextCommandSetBlipName(CargoManager.cargoBlip)

    SpawnCargoForPickup(JobManager.currentCargo)

    Citizen.CreateThread(function()
        while JobManager.isDoingJob do
            Citizen.Wait(0)

            local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if playerVehicle ~= 0 and CargoManager.cargoTrailer then
                local success, attachedTrailer = GetVehicleTrailerVehicle(playerVehicle)
                if success and attachedTrailer == CargoManager.cargoTrailer then
                    ShowHelpNotification("Cargo picked up! Head to the delivery point.")
                    RemoveBlip(CargoManager.cargoBlip)
                    SetDeliveryMarker()
                    break
                end
            end
        end
    end)
end

function SetDeliveryMarker()
    local deliveryLocations = ExCinere.Config.DeliveryLocations
    JobManager.currentDeliveryLocation = deliveryLocations[math.random(#deliveryLocations)]

    JobManager.deliveryBlip = AddBlipForCoord(JobManager.currentDeliveryLocation.x, JobManager.currentDeliveryLocation.y, JobManager.currentDeliveryLocation.z)
    SetBlipRoute(JobManager.deliveryBlip, true)
    SetBlipSprite(JobManager.deliveryBlip, 280)
    SetBlipColour(JobManager.deliveryBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Delivery Point")
    EndTextCommandSetBlipName(JobManager.deliveryBlip)

    Citizen.CreateThread(function()
        while JobManager.isDoingJob do
            Citizen.Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - JobManager.currentDeliveryLocation)

            if distance < 50.0 then
                DrawMarker(30, JobManager.currentDeliveryLocation.x, JobManager.currentDeliveryLocation.y, JobManager.currentDeliveryLocation.z - 1.0, 0.0, 0.0, 0.0, 90.0, 0.0, 0.0, 4.0, 4.0, 1.0, 0, 255, 0, 150, true, false, 2, nil, nil, false)

                if distance < 5.0 then
                    if not IsVehicleAttachedToTrailer(GetVehiclePedIsIn(PlayerPedId(), false)) then
                        RemoveBlip(JobManager.deliveryBlip)
                        StartDeliveryScene()
                        break
                    end
                end
            end
        end
    end)
end

function CheckParkingAccuracy()
    local playerVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if playerVehicle ~= 0 then
        local vehicleCoords = GetEntityCoords(playerVehicle)
        local headingDiff = math.abs(GetEntityHeading(playerVehicle) - GetEntityHeading(PlayerPedId()))

        if #(vehicleCoords - JobManager.currentDeliveryLocation) < 3.0 and headingDiff < 10 then
            ShowHelpNotification("Perfect parking! Job complete.")
            JobManager:CompleteJob()
        else
            ShowHelpNotification("Try to park more accurately.")
        end
    end
end

function RemoveDeliveryBlip()
    if JobManager.deliveryBlip then
        RemoveBlip(JobManager.deliveryBlip)
        JobManager.deliveryBlip = nil
    end
end

function StartDeliveryScene()
    local playerPed = PlayerPedId()
    local deliveryLocation = JobManager.currentDeliveryLocation

    TaskLeaveVehicle(playerPed, GetVehiclePedIsIn(playerPed, false), 0)
    Wait(1000)

    -- Adjust the camera to a higher angle offset to the side of the player
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local playerCoords = GetEntityCoords(playerPed)
    SetCamCoord(cam, playerCoords.x + 2.5, playerCoords.y + 2.5, playerCoords.z + 2.5)  -- Position to the side and above
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)  -- Aim slightly above the player's position
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    local npcModel = GetHashKey("s_m_m_trucker_01")
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Citizen.Wait(0)
    end

    local npcCoords = vector3(playerCoords.x + 5.0, playerCoords.y + 5.0, playerCoords.z)
    local npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z, 0.0, true, true)

    TaskGoToEntity(npc, playerPed, -1, 1.5, 1.0, 1073741824, 0)
    Wait(3000)

    -- Test
    TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)  -- NPC with clipboard
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_ATM", 0, true)    -- Player receives money

    Citizen.Wait(3000)

    ClearPedTasksImmediately(playerPed)
    ClearPedTasksImmediately(npc)
    DeleteEntity(npc)

    RenderScriptCams(false, false, 0, true, true)
    DestroyCam(cam, false)

    JobManager:CompleteJob()
    ShowHelpNotification("Delivery complete! You have been paid.")
end


RegisterCommand("testdeliveryscene", function()
    StartDeliveryScene()
end, false)
