local isControllingCamera = false
local camera

function CopyToClipboard(dataType)
    local ped = PlayerPedId()
    if dataType == 'coords' then
        local coords = GetEntityCoords(ped)
        local x = math.round(coords.x, 2)
        local y = math.round(coords.y, 2)
        local z = math.round(coords.z, 2)
        SendNUIMessage({
            string = string.format('vector3(%s, %s, %s)', x, y, z)
        })
        QBCore.Functions.Notify("Coordinates copied to clipboard!", "success")
    elseif dataType == 'heading' then
        local heading = GetEntityHeading(ped)
        local h = math.round(heading, 2)
        SendNUIMessage({
            string = h
        })
        QBCore.Functions.Notify("Heading copied to clipboard!", "success")
    elseif dataType == 'camCoords' then
        local coords = GetCamCoord(camera)
        local x = math.round(coords.x, 2)
        local y = math.round(coords.y, 2)
        local z = math.round(coords.z, 2)
        SendNUIMessage({
            string = string.format('vector3(%s, %s, %s)', x, y, z)
        })
        QBCore.Functions.Notify("Camera coordinates copied to clipboard!", "success")
    elseif dataType == 'camRot' then
        local rot = GetCamRot(camera, 2)
        print(rot)
        local x = math.round(rot.x, 2)
        local y = math.round(rot.y, 2)
        local z = math.round(rot.z, 2)
        SendNUIMessage({
            string = string.format('vector3(%s, %s, %s)', x, y, z)
        })
        QBCore.Functions.Notify("Camera rotation copied to clipboard!", "success")
    end
end

function ToggleVehicleDeveloperMode()
    local x = 0.325
    local y = 0.888
    if vehicleDevMode then
        QBCore.Functions.Notify("Vehicle dev mode ACTIVATED!", "success")
    else
        QBCore.Functions.Notify("Vehicle dev mode DEACTIVATED!", "success")
    end
    Citizen.CreateThread(function()
        while vehicleDevMode do
            local ped = PlayerPedId()
            Citizen.Wait(0)
            if IsPedInAnyVehicle(ped, false) then
                local vehicle = GetVehiclePedIsIn(ped, false)
                local netID = VehToNet(vehicle)
                local hash = GetEntityModel(vehicle)
                local modelName = GetLabelText(GetDisplayNameFromVehicleModel(hash))
                local makeName = GetLabelText(GetMakeNameFromVehicleModel(hash))
                local eHealth = GetVehicleEngineHealth(vehicle)
                local bHealth = GetVehicleBodyHealth(vehicle)
                Draw2DText('Vehicle Developer Data:', 4, {66, 182, 245}, 0.4, x + 0.0, y + 0.0)
                Draw2DText(string.format('Entity ID: ~b~%s~s~ | Net ID: ~b~%s~s~', vehicle, netID), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.025)
                Draw2DText(string.format('Make: ~b~%s~s~ | Model: ~b~%s~s~ | Hash: ~b~%s~s~', makeName, modelName, hash), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.050)
                Draw2DText(string.format('Engine Health: ~b~%s~s~ | Body Health: ~b~%s~s~', math.round(eHealth, 2), math.round(bHealth, 2)), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.075)
            end
        end
    end)
end

--------------------------------------------------------------------------------------------
-- CAMERAS 
--------------------------------------------------------------------------------------------
function CreateCamera()
    if not camera then
        camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        SetCamCoord(camera, GetEntityCoords(PlayerPedId()))
        SetCamRot(camera, 0.0, 2)
        SetCamFov(camera, 40.0)
        SetCamActive(camera, true)
        RenderScriptCams(true, false, 1, true, true)
        isControllingCamera = true
        FreezeEntityPosition(PlayerPedId(), true)
        while isControllingCamera do
            local cameraCoords = GetCamCoord(camera)
            local cameraRotation = GetCamRot(camera, 2)
            Citizen.Wait(0)
            if IsControlPressed(0, Config.CameraDev.Controls.Up) then
                SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z + Config.CameraDev.MovementSensitivity)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.Down) then
                SetCamCoord(camera, cameraCoords.x, cameraCoords.y, cameraCoords.z - Config.CameraDev.MovementSensitivity)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.Forward) then
                SetCamCoord(camera, cameraCoords.x, cameraCoords.y + Config.CameraDev.MovementSensitivity, cameraCoords.z)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.Backward) then
                SetCamCoord(camera, cameraCoords.x, cameraCoords.y - Config.CameraDev.MovementSensitivity, cameraCoords.z)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.Left) then
                SetCamCoord(camera, cameraCoords.x - Config.CameraDev.MovementSensitivity, cameraCoords.y, cameraCoords.z)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.Right) then
                SetCamCoord(camera, cameraCoords.x + Config.CameraDev.MovementSensitivity, cameraCoords.y, cameraCoords.z)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.TiltForward) and IsControlPressed(0, 21) then
                SetCamRot(camera, cameraRotation.x + Config.CameraDev.MovementSensitivity, cameraRotation.y, cameraRotation.z, 2)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.TiltBackward) and IsControlPressed(0, 21) then
                SetCamRot(camera, cameraRotation.x - Config.CameraDev.MovementSensitivity, cameraRotation.y, cameraRotation.z, 2)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.RotateLeft) and IsControlPressed(0, 21) then
                SetCamRot(camera, cameraRotation.x, cameraRotation.y, cameraRotation.z + (Config.CameraDev.MovementSensitivity * 4), 2)
            end
            if IsControlPressed(0, Config.CameraDev.Controls.RotateRight) and IsControlPressed(0, 21) then
                SetCamRot(camera, cameraRotation.x, cameraRotation.y, cameraRotation.z - (Config.CameraDev.MovementSensitivity * 4), 2)
            end
        end
    else
        QBCore.Functions.Notify("There is already an active camera, destroy it to create a new one", "error")
    end
end

function UpdateFov(value)
    SetCamFov(camera, value + 0.0)
end

function DestroyCamera()
    if camera then
        DestroyCam(camera)
        camera = nil
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
    else
        QBCore.Functions.Notify("No active camera detected", "error")
    end
end


--------------------------------------------------------------------------------------------
-- UTILITY 
--------------------------------------------------------------------------------------------

function Draw2DText(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end

function math.round(input, decimalPlaces)
    return tonumber(string.format("%." .. (decimalPlaces or 0) .. "f", input))
end