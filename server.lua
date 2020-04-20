local Tunnel = module('vrp', 'lib/Tunnel')
local Proxy = module('vrp', 'lib/Proxy')
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "vRP_admin")



RegisterServerEvent('TBRP:GetPlayerInformation')
AddEventHandler('TBRP:GetPlayerInformation', function() 
    local source = source
    user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id, cfg.perm}) then
    players = GetPlayers()
    players_table = {}
    for i, p in pairs(players) do 
        name = GetPlayerName(p)
        user_id = vRP.getUserId({p})
        players_table[p] = {name, p, user_id}
        
    end
    TriggerClientEvent("TBRP:SendPlayersInfo", source, players_table)
end
    
end)

RegisterServerEvent('TBRP:KickPlayer')
AddEventHandler('TBRP:KickPlayer', function(id, message) 
    vRP.kick({id, message or "None Given"})
end)
RegisterServerEvent('TBRP:BanPlayer')
AddEventHandler('TBRP:BanPlayer', function(id, message) 
    if cfg.admins_cant_ban_admins then 
        user_id = vRP.getUserId({id})
        if vRP.hasPermission({user_id, cfg.perm}) then 
            vRPclient.notify(source, {"~r~You can't ban them."})
        else 
            vRP.ban({id, message or "None Given"})
        end
    else 
        vRP.ban({id, message or "None Given"})

    end
    
end)
RegisterServerEvent('TBRP:TP2PLAYER')
AddEventHandler('TBRP:TP2PLAYER', function(id) 
    local source = source
    local user_id = vRP.getUserId({source})
    local src = vRP.getUserSource({user_id})
    vRPclient.getPosition(id,{}, function(x,y,z)
        vRPclient.teleport(src,{x,y,z})
    end)
    
end)

RegisterServerEvent('TBRP:TP2ME')
AddEventHandler('TBRP:TP2ME', function(id, coords) 
    source = source
    local x,y,z = table.unpack(coords)
    vRPclient.teleport(id,{x,y,z})
    
end)
RegisterServerEvent('TBRP:FREEZEPLAYER')
AddEventHandler('TBRP:FREEZEPLAYER', function(id) 
    TriggerClientEvent('TBRP:FREEZE', id)
    
end)
RegisterServerEvent('TBRP:REVIVE')
AddEventHandler('TBRP:REVIVE', function(id) 
    vRPclient.varyHealth(id, {200})
end)
