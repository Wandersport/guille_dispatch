local calls = {}
local callnum = 0
local totalcalls = 0
local config = false
local showed = false
local PlayerData = {}
local bigrambo = {}
local nofilterquick = {}
local wackytequiero = {}
local activated = true

ESX = nil 

Citizen.CreateThread(function() 
    while ESX == nil do 
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 
        Citizen.Wait(0) 
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
    calls = {}
    callnum = 0
    totalcalls = 0
    SendNUIMessage({
        show = false;
        content = "No alerts";
        callnum = 0;
        totalcalls = 0;
        closeConfigMenu = true;
        newalert = false;
    })
    SetNuiFocus(false, false)
    showed = false
end)

RegisterCommand("showalerts", function()
    if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'mechanic' or PlayerData.job.name == 'taxi' then
        if not showed then
            if checkTable(calls) then
                    SendNUIMessage({
                        show = true;
                    })
                    showed = true
                end
            else
                SendNUIMessage({
                    show = true;
                })
                showed = true
            end
        else
            SendNUIMessage({
                show = false;
            })
            showed = false
        end
    else
        ESX.ShowNotification('Your job does not require alerts')
    end
end, false)

AddEventHandler("onResourceStart", function(resource)
    if resource == GetCurrentResourceName() then
        Citizen.Wait(2000)
        SendNUIMessage({
            callnum = 0;
        })
    end
end)

RegisterNetEvent("guille_dispatch:alertToClient")
AddEventHandler("guille_dispatch:alertToClient", function(text, coords, id)
    if PlayerData.job and PlayerData.job.name == 'police' and activated then
        callnum = callnum + 1
        totalcalls = totalcalls + 1
        SendNUIMessage({
            content = text;
            callnum = callnum;
            totalcalls = totalcalls;
            newalert = true;
            id = id;
            
        })
        table.insert(calls, {text = text, coords = coords})
    end
end)

RegisterNetEvent("guille_dispatch:vehToClient")
AddEventHandler("guille_dispatch:vehToClient", function(coords, model, color, id)
    if PlayerData.job and PlayerData.job.name == 'police' and activated then
        callnum = callnum + 1
        totalcalls = totalcalls + 1
        local distanceToAlert = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords)
        local finalDistanceTo = ESX.Math.Round(ESX.Math.Round(distanceToAlert, 1) * 0.001, 1)
        if Config.enableVehiclePics then
            SendNUIMessage({
                content = "A man has stolen a vehicle model " ..model.. ",color "..color..", I got a photo of the vehicle. You meet " ..finalDistanceTo .. " km away";
                callnum = callnum;
                totalcalls = totalcalls;
                pic = true;
                model = model;
                newalert = true;
                id = id;
            })
            table.insert(calls, {text = "A man has stolen a vehicle model " ..model.. " de color "..color..", I got a photo of the vehicle. You meet " ..finalDistanceTo .. " km away", coords = coords, model = model})
        else
            SendNUIMessage({
                content = "A man has stolen a vehicle model " ..model.. " de color "..color..", I got a photo of the vehicle. You meet " ..finalDistanceTo .. " km away";
                callnum = callnum;
                totalcalls = totalcalls;
                newalert = true;
                id = id;
            })
            table.insert(calls, {text = "A man has stolen a vehicle model " ..model.. " de color "..color..", I got a photo of the vehicle. You meet " ..finalDistanceTo .. " km away", coords = coords})
        end
    end
end)

RegisterCommand("sos", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent("guille_dispatch:sendAmbuAlert", text, coords, id)
end, false)

RegisterCommand("meca", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent("guille_dispatch:sendMecaAlert", text, coords, id)
end, false)

RegisterCommand("taxi", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent("guille_dispatch:sendTaxiaAlert", text, coords, id)
end, false)

RegisterNetEvent("guille_dispatch:auxToClient")
AddEventHandler("guille_dispatch:auxToClient", function(text, coords, id)
    if PlayerData.job and PlayerData.job.name == 'ambulance' and activated then
        callnum = callnum + 1
        totalcalls = totalcalls + 1
        SendNUIMessage({
            content = text;
            callnum = callnum;
            totalcalls = totalcalls;
            newambualert = true;
            newalert = true;
            id = id;
        })
        table.insert(calls, {text = text, coords = coords})
    end
    
end)
RegisterNetEvent("guille_dispatch:taxiToClient")
AddEventHandler("guille_dispatch:taxiToClient", function(text, coords, id)
    if PlayerData.job and PlayerData.job.name == 'taxi' and activated then
        callnum = callnum + 1
        totalcalls = totalcalls + 1
        SendNUIMessage({
            content = text;
            callnum = callnum;
            totalcalls = totalcalls;
            newtaxialert = true;
            newalert = true;
            id = id;
        })
        table.insert(calls, {text = text, coords = coords})
    end
    
end)


RegisterNetEvent("guille_dispatch:mecaToClient")
AddEventHandler("guille_dispatch:mecaToClient", function(text, coords, id)
    if PlayerData.job and PlayerData.job.name == 'mechanic' and activated then
        callnum = callnum + 1
        totalcalls = totalcalls + 1
        SendNUIMessage({
            content = text;
            callnum = callnum;
            totalcalls = totalcalls;
            newmecaalert = true;
            newalert = true;
            id = id;
        })
        table.insert(calls, {text = text, coords = coords})
    end
    
end)


RegisterNetEvent("guille_dispatch:robberyToClient")
AddEventHandler("guille_dispatch:robberyToClient", function(type, coords, id)
    if PlayerData.job and PlayerData.job.name == 'police' and activated then
        callnum = callnum + 1
        totalcalls = totalcalls + 1
        if Config.enableRobberyPics then
            if type == "247" then
                SendNUIMessage({
                    content = "An alarm has been triggered in a 24/7, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    pic = true;
                    model = 247;
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has been triggered in a 24/7, please come!", coords = coords, model = 247})
            elseif type == "vangelico" then
                SendNUIMessage({
                    content = "An alarm has gone off in the jewelry store, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    pic = true;
                    model = "vangelico";
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has gone off in the jewelry store, please come!", coords = coords, model = "vangelico"})
            elseif type == "ammunation" then
                SendNUIMessage({
                    content = "An alarm has gone off in an AmmuNation, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    pic = true;
                    model = "ammunation";
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has gone off in an AmmuNation, please come!", coords = coords, model = "ammunation"})
            elseif type == "fleeca" then
                SendNUIMessage({
                    content = "An alarm has gone off on a Fleeca, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    pic = true;
                    model = "fleeca";
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has gone off on a Fleeca, please come!", coords = coords, model = "fleeca"})
            elseif type == "humane" then
                SendNUIMessage({
                    content = "An alarm has gone off at Humane Labs, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    pic = true;
                    model = "humane";
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has gone off at Humane Labs, please come!", coords = coords, model = "humane"})
            elseif type == "pacific" then
                SendNUIMessage({
                    content = "An alarm has gone off in the Pacific Standard, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    pic = true;
                    model = "pacific";
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has gone off in the Pacific Standard, please come!", coords = coords, model = "pacific"})
            end
        else
            if type == "247" then
                SendNUIMessage({
                    content = "An alarm has been triggered in a 24/7, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    newalert = true;
                    id = id;

                })
                table.insert(calls, {text = "An alarm has been triggered in a 24/7, please come!", coords = coords})
            elseif type == "vangelico" then
                SendNUIMessage({
                    content = "An alarm has gone off in the jewelry store, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    newalert = true;
                    id = id;
                })
                table.insert(calls, {text = "An alarm has gone off in the jewelry store, please come!", coords = coords})
            elseif type == "ammunation" then
                SendNUIMessage({
                    content = "An alarm has gone off in an AmmuNation, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    newalert = true;
                    id = id;
                })
                table.insert(calls, {text = "An alarm has gone off in an AmmuNation, please come!", coords = coords})
            elseif type == "fleeca" then
                SendNUIMessage({
                    content = "An alarm has gone off on a Fleeca, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    newalert = true;
                    id = id;
                })
                table.insert(calls, {text = "An alarm has gone off on a Fleeca, please come!", coords = coords})
            elseif type == "humane" then
                SendNUIMessage({
                    content = "An alarm has gone off at Humane Labs, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    newalert = true;
                    id = id;
                })
                table.insert(calls, {text = "An alarm has gone off at Humane Labs, please come!", coords = coords})
            elseif type == "pacific" then
                SendNUIMessage({
                    content = "An alarm has gone off in the Pacific Standard, please come!";
                    callnum = callnum;
                    totalcalls = totalcalls;
                    newalert = true;
                    id = id;
                })
                table.insert(calls, {text = "An alarm has gone off in the Pacific Standard, please come!", coords = coords})
            end
        end
    end
end)

RegisterCommand("rob", function()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        local model = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))
        local coords = GetEntityCoords(PlayerPedId())
        local id = GetPlayerServerId(PlayerId())
        local color = GetVehicleColor(vehicle)
        local klk = tostring(color)
        local finalColor = Config.Colors[klk]
        TriggerServerEvent("guille_dispatch:sendVehRob", coords, model, finalColor, id)
    end
end, false)

RegisterCommand("911", function(source, args)
    local text = table.concat(args, " ")
    local coords = GetEntityCoords(PlayerPedId())
    local id = GetPlayerServerId(PlayerId())
    TriggerServerEvent("guille_dispatch:sendAlert", text, coords, id)
end, false)


RegisterCommand("right", function()
    if calls[callnum + 1] ~= nil then
        local num = callnum + 1
        if calls[callnum + 1]['model'] ~= nil then
            SendNUIMessage({
                content = calls[callnum + 1]['text'];
                callnum = num;
                right = true;
                pic = true;
                model = calls[callnum + 1]['model'];
            })
        else
            SendNUIMessage({
                content = calls[callnum + 1]['text'];
                callnum = num;
                right = true;
            })
        end
        callnum = callnum + 1 
    end
end, false)

RegisterCommand("left", function()
    if calls[callnum - 1] ~= nil then
        local num = callnum - 1
        if calls[callnum - 1]['model'] ~= nil then
            SendNUIMessage({
                content = calls[callnum - 1]['text'];
                callnum = num;
                left = true;
                pic = true;
                model = calls[callnum - 1]['model'];
            })
        else
            SendNUIMessage({
                content = calls[callnum - 1]['text'];
                callnum = num;
                left = true;
            })
        end
        callnum = callnum - 1 
    end
end, false)

RegisterCommand("mover", function(source, args)
    if showed then 
        SetNuiFocus(true, true)
        SendNUIMessage({
            inConfig = true;
        })
    end
end, false)

RegisterCommand("acceptentorno", function(source, args)
    if callnum ~= 0 then
        SetNewWaypoint(calls[callnum]['coords'])
        ESX.ShowNotification('The coords have been marked in your ~r~GPS')
        SendNUIMessage({
            avkey = true;
        })
    end
end, false)

RegisterKeyMapping("mover", ("Config"), 'keyboard', 'i')

RegisterKeyMapping("right", ("Move to right alert"), 'keyboard', 'right')

RegisterKeyMapping("left", ("Move to left alert"), 'keyboard', 'left')

RegisterKeyMapping("showalerts", ("Open dispatch"), 'keyboard', 'f4')

RegisterKeyMapping("acceptentorno", ("Got to the marker"), 'keyboard', 'o')

RegisterNUICallback("exit", function()
    SetNuiFocus(false, false)
    if checkTable(calls) then
        if calls[callnum]['model'] == nil then
            SendNUIMessage({
                content = calls[callnum]['text'];
                callnum = num;
            })
        else

            SendNUIMessage({
                content = calls[callnum]['text'];
                callnum = num;
                pic = true;
                model = calls[callnum]['model'];
            })
        end
    else
        if checkTable(calls) then
            SendNUIMessage({
                content = calls[callnum]['text'];
                callnum = num;
            })
        else
            SendNUIMessage({
                content = "No alerts received";
                callnum = num;
            })
        end
    end
end)

RegisterNUICallback("tooglepic", function()
    if Config.enableVehiclePics then
        Config.enableVehiclePics = false
        ESX.ShowNotification('Images have been disabled')
    else
        Config.enableVehiclePics = true
        ESX.ShowNotification('Images have been enabled')
    end
end)

RegisterNUICallback("deletealerts", function()
    callnum = 0
    totalcalls = 0
    calls = {}
    SendNUIMessage({
        content = "No alerts received";
        restart = true;
        newalert = false;
        
    })
    ESX.ShowNotification('All alerts deleted')
end)

RegisterNUICallback("togglealerts", function()
    if activated then
        activated = false
        ESX.ShowNotification('Alerts have been disabled')
    else
        activated = true
        ESX.ShowNotification('Alerts have been enabled')
    end
end)

RegisterNUICallback("deletealert", function(cb)
    totalcalls = totalcalls - 1
    
    if (cb.selectedId + 1) == callnum then
        if checkTable(calls) then
                if calls[callnum + 1] ~= nil then
                    SendNUIMessage({
                        content = calls[callnum + 1]['text'];
                        callnum = num;
                        totalcalls = totalcalls;
                    })
                    callnum = callnum + 1
                elseif calls[callnum - 1] ~= nil then
                    local num = callnum - 1
                    SendNUIMessage({
                        content = calls[callnum - 1]['text'];
                        callnum = num;
                        totalcalls = totalcalls;
                    })
                    callnum = callnum - 1
                else

                    callnum = 0
                    totalcalls = 0
                    calls = {}
                    SendNUIMessage({
                        content = "No alerts received";
                        restart = true;
                        newalert = false;
                        
                    })
                end
            end
        end
    else
        callnum = callnum - 1
        SendNUIMessage({
            callnum = callnum;
            totalcalls = totalcalls;
        })
    end
    table.remove(calls, cb.selectedId + 1)
    
end)

function checkTable(table)
    local init = false
    for k,v in pairs(table) do
        inIt = true
    end
    if inIt then
        return true
    else
        return false
    end
end
