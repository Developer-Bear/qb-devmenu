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
                local eHealth = GetVehicleEngineHealth(vehicle)
                local bHealth = GetVehicleBodyHealth(vehicle)
                Draw2DText('Vehicle Developer Data:', 4, {66, 182, 245}, 0.4, x + 0.0, y + 0.0)
                Draw2DText(string.format('Entity ID: ~b~%s~s~ | Net ID: ~b~%s~s~', vehicle, netID), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.025)
                Draw2DText(string.format('Model: ~b~%s~s~ | Hash: ~b~%s~s~', modelName, hash), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.050)
                Draw2DText(string.format('Engine Health: ~b~%s~s~ | Body Health: ~b~%s~s~', math.round(eHealth, 2), math.round(bHealth, 2)), 4, {255, 255, 255}, 0.4, x + 0.0, y + 0.075)
            end
        end
    end)
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