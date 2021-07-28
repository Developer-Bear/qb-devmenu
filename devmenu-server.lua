QBCore.Commands.Add(Config.OpenCommand, "Open Developer Menu (Admin Only)", {}, false, function(source, args)
    TriggerClientEvent('crp-devmenu:OpenMenu', source)
end, "admin")