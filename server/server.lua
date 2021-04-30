ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

RegisterServerEvent("guille_dispatch:server:sendAlert")
AddEventHandler("guille_dispatch:server:sendAlert", function(type, text, coords, id)
    if type == "alert" then
        TriggerClientEvent("guille_dispatch:alertToClient", -1, text, coords, id)
    elseif type == "ambulance" then
        TriggerClientEvent("guille_dispatch:auxToClient", -1, text, coords, id)
    elseif type == "mechanic" then
        TriggerClientEvent("guille_dispatch:mecaToClient", -1, text, coords, id)
    elseif type == "taxi" then
        TriggerClientEvent("guille_dispatch:taxiToClient", -1, text, coords, id)
    end
end)

RegisterServerEvent("guille_dispatch:sendVehRob")
AddEventHandler("guille_dispatch:sendVehRob", function(coords, model, color, id)
    TriggerClientEvent("guille_dispatch:vehToClient", -1, coords, model, color, id)
end)

RegisterServerEvent("guille_dispatch:sendRobaAlert")
AddEventHandler("guille_dispatch:sendRobaAlert", function(type, coords, id)
    TriggerClientEvent("guille_dispatch:robberyToClient", -1, type, coords, id)
end)
