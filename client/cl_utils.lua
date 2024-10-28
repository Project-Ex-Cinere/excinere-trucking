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

    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
end

function SpawnTrailerWithCars(trailerType)
    local playerPed = PlayerPedId()
    local pickupLocation = CargoManager.cargoMarkerLocation
    
    local trailerModelHash = GetHashKey(trailerType.Trailers[1])
    RequestModel(trailerModelHash)
    while not HasModelLoaded(trailerModelHash) do
        Citizen.Wait(0)
    end

    if not CargoManager.cargoTrailer then
        CargoManager.cargoTrailer = CreateVehicle(trailerModelHash, pickupLocation.x, pickupLocation.y, pickupLocation.z, 0.0, true, false)
        print("Automotive trailer spawned.")
    else
        print("Automotive trailer already exists; skipping duplicate spawn.")
        return
    end

    local carOffsets = {
        { localX = 0.0, localY = 4.9, localZ = -1.4 },
        { localX = 0.0, localY = 0.15, localZ = -1.2 },
        { localX = 0.0, localY = -4.7, localZ = -1.2 },
        { localX = 0.0, localY = 4.9, localZ = -3.1 },
        { localX = 0.0, localY = 0.15, localZ = -3.1 },
        { localX = 0.0, localY = -4.7, localZ = -3.0 }
    }

    local spawnedVehicleCount = 0

    for i = 1, trailerType.MaxVehicles do
        if spawnedVehicleCount >= #carOffsets then
            break
        end
        
        local vehicleConfig = trailerType.Vehicles[i]
        local vehicleModelHash = GetHashKey(vehicleConfig.model)
        RequestModel(vehicleModelHash)
        while not HasModelLoaded(vehicleModelHash) do
            Citizen.Wait(0)
        end

        local offset = carOffsets[spawnedVehicleCount + 1]
        local car = CreateVehicle(vehicleModelHash, pickupLocation.x + 10, pickupLocation.y, pickupLocation.z, 0.0, true, false)

        AttachVehicleOnToTrailer(
            car, CargoManager.cargoTrailer,
            offset.localX, offset.localY, offset.localZ,
            0, 0, 0,
            0, 0, 0,
            false
        )

        spawnedVehicleCount = spawnedVehicleCount + 1
        print(string.format("Spawned vehicle: %s on trailer with offset X: %.2f, Y: %.2f, Z: %.2f",
            vehicleConfig.model, offset.localX, offset.localY, offset.localZ))
    end
    ShowHelpNotification("Automotive trailer and max vehicles spawned.")
end

function SpawnTrailerWithLargeMilitaryVehicle(trailerType)
    local playerPed = PlayerPedId()
    local pickupLocation = CargoManager.cargoMarkerLocation

    local trailerModelHash = GetHashKey(trailerType.Trailers[1])
    RequestModel(trailerModelHash)
    while not HasModelLoaded(trailerModelHash) do
        Citizen.Wait(0)
    end


    if not CargoManager.cargoTrailer then
        CargoManager.cargoTrailer = CreateVehicle(trailerModelHash, pickupLocation.x, pickupLocation.y, pickupLocation.z + 1.0, 0.0, true, false)
        print("Military trailer spawned.")
    else
        print("Military trailer already exists; skipping duplicate spawn.")
        return
    end

    local militaryOffsets = {
        { localX = 0.0, localY = 0.0, localZ = 0.0 },
    }

    local spawnedVehicleCount = 0

    for i = 1, trailerType.MaxVehicles do
        if spawnedVehicleCount >= #militaryOffsets then
            break
        end
        
        local vehicleConfig = trailerType.Vehicles[i]
        local vehicleModelHash = GetHashKey(vehicleConfig.model)
        RequestModel(vehicleModelHash)
        while not HasModelLoaded(vehicleModelHash) do
            Citizen.Wait(0)
        end

        local offset = militaryOffsets[spawnedVehicleCount + 1]
        local vehicle = CreateVehicle(vehicleModelHash, pickupLocation.x + 10, pickupLocation.y, pickupLocation.z, 0.0, true, false)

        AttachVehicleOnToTrailer(
            vehicle, CargoManager.cargoTrailer,
            offset.localX, offset.localY, offset.localZ,
            0, 0, 0,
            0, 0, 0,
            false
        )

        spawnedVehicleCount = spawnedVehicleCount + 1
        print(string.format("Spawned military vehicle: %s on trailer with offset X: %.2f, Y: %.2f, Z: %.2f",
            vehicleConfig.model, offset.localX, offset.localY, offset.localZ))
    end
    ShowHelpNotification("Military trailer and max vehicles spawned.")
end

function SetCargoPickupMarker()
    if not CargoManager.cargoMarkerLocation then
        print("Error: cargoMarkerLocation is not set before calling SetCargoPickupMarker.")
        return
    end

    CargoManager.cargoBlip = AddBlipForCoord(CargoManager.cargoMarkerLocation.x, CargoManager.cargoMarkerLocation.y, CargoManager.cargoMarkerLocation.z)
    SetBlipSprite(CargoManager.cargoBlip, 479)
    SetBlipColour(CargoManager.cargoBlip, 5)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cargo Pickup Point")
    EndTextCommandSetBlipName(CargoManager.cargoBlip)

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


function SpawnCargoForPickup(trailerType)
    local trailerModel = trailerType.Trailers[math.random(#trailerType.Trailers)]
    local trailerModelHash = GetHashKey(trailerModel)

    RequestModel(trailerModelHash)
    while not HasModelLoaded(trailerModelHash) do
        Citizen.Wait(0)
    end

    -- Spawn the trailer at the cargo pickup location
    local trailer = CreateVehicle(trailerModelHash, CargoManager.cargoMarkerLocation.x + 5, CargoManager.cargoMarkerLocation.y, CargoManager.cargoMarkerLocation.z, 0.0, true, false)
    print("Spawned trailer model:", trailerModel, "at", CargoManager.cargoMarkerLocation)

    -- Return the trailer so it can be assigned to CargoManager.cargoTrailer
    return trailer
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

    -- Request NPC model
    local npcModel = GetHashKey("s_m_m_trucker_01")
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do
        Citizen.Wait(0)
    end

    -- Spawn NPC on the ground
    local playerCoords = GetEntityCoords(playerPed)
    local npcCoords = vector3(playerCoords.x + 5.0, playerCoords.y + 5.0, playerCoords.z)
    local _, groundZ = GetGroundZFor_3dCoord(npcCoords.x, npcCoords.y, npcCoords.z)
    local npc = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, groundZ, 0.0, true, true)
    local npcHeading = GetEntityHeading(npc)

    -- Set up camera in front of NPC while they smoke
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cam, npcCoords.x + math.cos(math.rad(npcHeading)) * -1.5, npcCoords.y + math.sin(math.rad(npcHeading)) * -1.5, groundZ + 1.8)
    PointCamAtEntity(cam, npc, 0, 0, 0, true)
    SetCamActive(cam, true)
    RenderScriptCams(true, false, 0, true, true)

    -- Start player smoking and facing away initially
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING", 0, true)

    -- NPC smokes for 10 seconds
    TaskStartScenarioInPlace(npc, "WORLD_HUMAN_SMOKING", 0, true)
    Wait(10000)
    ClearPedTasksImmediately(npc)

    -- Load the animation dictionary for the whistle
    RequestAnimDict("rcmnigel1c")
    while not HasAnimDictLoaded("rcmnigel1c") do
        Citizen.Wait(0)
    end

    -- Move camera behind NPC as they start walking toward the player
    SetCamCoord(cam, npcCoords.x + math.cos(math.rad(npcHeading)) * 2.5, npcCoords.y + math.sin(math.rad(npcHeading)) * 2.5, groundZ + 1.8)
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 1.0)

    -- NPC starts walking towards the player
    TaskGoToEntity(npc, playerPed, -1, 1.5, 1.0, 1073741824, 0)

    Citizen.CreateThread(function()
        local whistleDone = false

        while not IsEntityAtEntity(npc, playerPed, 1.5, 1.5, 1.5, false, true, 0) do
            Citizen.Wait(0)
            local npcPosition = GetEntityCoords(npc)

            -- Keep camera behind NPC’s shoulder
            SetCamCoord(cam, npcPosition.x + math.cos(math.rad(GetEntityHeading(npc))) * -2.5, npcPosition.y + math.sin(math.rad(GetEntityHeading(npc))) * -2.5, npcPosition.z + 1.8)
            PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 1.0)

            -- Whistle once after 2 seconds of walking
            if not whistleDone and GetEntitySpeed(npc) > 0 then
                Wait(2000)
                TaskPlayAnim(npc, "rcmnigel1c", "hailing_whistle_waive_a", 8.0, 8.0, 1000, 49, 0, 0, 0, 0)
                TaskTurnPedToFaceEntity(playerPed, npc, -1)
                PlayAmbientSpeech1(npc, "GENERIC_WHISTLE", "SPEECH_PARAMS_FORCE_NORMAL")
                whistleDone = true
            end
        end

        -- Final camera adjustment: Slightly offset to the side as NPC reaches player
        local npcPosition = GetEntityCoords(npc)
        SetCamCoord(cam, npcPosition.x + math.cos(math.rad(GetEntityHeading(npc))) * -1.5, npcPosition.y + math.sin(math.rad(GetEntityHeading(npc))) * -0.5, npcPosition.z + 1.6)

        -- NPC does clipboard task for 10 seconds
        TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)
        Wait(10000)

        -- Clean up tasks and remove camera
        ClearPedTasksImmediately(playerPed)
        ClearPedTasksImmediately(npc)
        DeleteEntity(npc)
        RenderScriptCams(false, false, 0, true, true)
        DestroyCam(cam, false)

        -- Complete job and show notification
        JobManager:CompleteJob()
        ShowHelpNotification("Delivery complete! You have been paid.")
    end)
end


RegisterCommand("testdeliveryscene", function()
    StartDeliveryScene()
end, false)