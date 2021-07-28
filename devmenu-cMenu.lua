vehicleDevMode = false

local menu = MenuV:CreateMenu(false, 'Developer Menu', 'topright', 155, 0, 0, 'size-125', 'none', 'menuv', 'test')

local coords_button = menu:AddButton({
    icon = '🔎',
    label = 'Copy Coords to Clipboard',
    value = 'coords',
    description = 'vector3() CTRL+V 😸'
})

local heading_button = menu:AddButton({
    icon = '🧭',
    label = 'Copy Heading to Clipboard',
    value = 'heading',
    description = 'int CTRL+V 🐵'
})

local vehicledev_button = menu:AddButton({
    icon = '🚘',
    label = 'Vehicle Dev Mode',
    value = 'WHAT',
    description = 'see vehicle specific information'
})

coords_button:On("select", function()
    CopyToClipboard('coords')
end)

heading_button:On("select", function()
    CopyToClipboard('heading')
end)

vehicledev_button:On("select", function()
    vehicleDevMode = not vehicleDevMode
    ToggleVehicleDeveloperMode()
end)

RegisterNetEvent('qb-devmenu:OpenMenu')
AddEventHandler('qb-devmenu:OpenMenu', function()
    MenuV:OpenMenu(menu)
end)