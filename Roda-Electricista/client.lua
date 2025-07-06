-- File: client.lua

QBCore = exports['qb-core']:GetCoreObject()

local trabalhando = false
local escadaNaMao = false
local escadaNoCarro = true
local escadaNoPoste = false

local executandoServico = false
local servicoConcluido = false
local segundos = 0
local tempoConserto = Config.TiempoParaArreglar

local spawnedLadder = nil
local attachedToIndex = nil
local repairBlips = {}

-- Reset job state and create blips
function StartJob()
    trabalhando = true
    for i = 1, #Config.TargetPoints do
        if Config.TargetPoints[i].isRepaired then
            Config.TargetPoints[i].isRepaired = false
        end
    end

    for _, blip in pairs(repairBlips) do if DoesBlipExist(blip) then RemoveBlip(blip) end end
    repairBlips = {}
    for i, data in ipairs(Config.TargetPoints) do
        local loc = data.location
        local blip = AddBlipForCoord(loc.x, loc.y, loc.z)
        SetBlipSprite(blip, 1); SetBlipScale(blip, 0.7); SetBlipColour(blip, 5); SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING"); AddTextComponentString("Điểm sửa chữa"); EndTextCommandSetBlipName(blip)
        repairBlips[i] = blip
    end

    Notificacion(Config.Locales["jobiniciado"])
    ChangeClothes()
    spawnCarJob(Config.Car)
end

function EndJob()
    trabalhando = false
    GetClothes()
    Notificacion(Config.Locales["jobterminado"])
    for _, blip in pairs(repairBlips) do if DoesBlipExist(blip) then RemoveBlip(blip) end end
    repairBlips = {}
    if escadaNaMao then DeleteObject(entity); escadaNaMao = false; end
    if spawnedLadder then DeleteObject(spawnedLadder); spawnedLadder = nil; end
    escadaNoPoste = false
end

-- Main logic thread
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        if trabalhando then
            sleep = 5
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local currentTargetIndex = nil

            if escadaNaMao and not escadaNoPoste then
                local closestTarget, closestDist = nil, Config.distance
                
                for i, data in ipairs(Config.TargetPoints) do
                    if not data.isRepaired then
                        local targetCoords = vector3(data.location.x, data.location.y, data.location.z)
                        local dist = #(playerCoords - targetCoords)
                        if dist < closestDist then
                            closestTarget, closestDist, currentTargetIndex = targetCoords, dist, i
                        end
                    end
                end

                if currentTargetIndex then
                    DrawText3D(closestTarget + vector3(0,0,1.5), Config.Locales["ponerescalera"])
                    if IsControlJustPressed(0, 38) then -- E key
                        local targetCoords = closestTarget
                        local dir, normalizedDir = (playerCoords - targetCoords), (playerCoords - targetCoords):normalized()
                        local ladderPos = targetCoords + (normalizedDir * Config.LadderOffset)
                        local heading = GetHeadingFromVector_2d(targetCoords.x - ladderPos.x, targetCoords.y - ladderPos.y)

                        escadaNoPoste, escadaNaMao, attachedToIndex = true, false, currentTargetIndex
                        StartAnim('mini@repair', 'fixing_a_ped'); Wait(1000); ClearPedTasks(playerPed)
                        DeleteObject(entity)
                        
                        spawnedLadder = CreateObject(GetHashKey("hw1_06_ldr_"), ladderPos, true, true, true)
                        PlaceObjectOnGroundProperly(spawnedLadder)
                        SetEntityRotation(spawnedLadder, 0.0, 0.0, heading, 2, true)
                        FreezeEntityPosition(spawnedLadder, true)
                    end
                end
            elseif escadaNoPoste then
                if servicoConcluido then
                    DrawText3D(GetEntityCoords(spawnedLadder) + vector3(0,0,1.5), Config.Locales["sacarescalera"])
                    if IsControlJustPressed(0, 38) then -- E key
                        servicoConcluido, executandoServico, escadaNoPoste, escadaNaMao = false, false, false, true
                        Config.TargetPoints[attachedToIndex].isRepaired = true
                        if repairBlips[attachedToIndex] and DoesBlipExist(repairBlips[attachedToIndex]) then RemoveBlip(repairBlips[attachedToIndex]) end
                        attachedToIndex = nil
                        DeleteObject(spawnedLadder); spawnedLadder = nil
                        
                        entity = CreateObject(GetHashKey("prop_byard_ladder01"), 0,0,0, true,true,true)
                        AttachEntityToEntity(entity, playerPed, GetPedBoneIndex(playerPed, 28422), 0.05, 0.1, -0.3, 300.0, 100.0, 20.0, true, true, false, true, 1, true)
                        StartAnim('amb@world_human_muscle_free_weights@male@barbell@idle_a', 'idle_a')
                    end
                elseif not executandoServico and #(playerCoords - GetEntityCoords(spawnedLadder)) < 2.0 and playerCoords.z > GetEntityCoords(spawnedLadder).z + 1.0 then
                     DrawText3D(playerCoords + vector3(0,0,0.5), Config.Locales["iniciarrepa"])
                     if IsControlJustPressed(0, 246) then executandoServico, segundos = true, tempoConserto end
                end
            end
        end
        if segundos > 0 then sleep = 0; drawTxt(Config.Locales["espera"]..segundos.. Config.Locales["tofinish"], 4, 0.5, 0.9, 0.50, 255, 255, 255, 180) end
        Citizen.Wait(sleep)
    end
end)

-- Job Start/End interaction thread
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local distance = #(GetEntityCoords(playerPed) - vector3(-825.55, -731.86, 27.07))
        if distance < 5.0 then
            sleep = 5
            local markerPos = vector3(-825.55, -731.86, 27.07)
            DrawMarker(23, markerPos.x, markerPos.y, markerPos.z, 0,0,0,0,0,0,1.0,1.0,0.5,240,200,80,80,0,0,0,0)
            if distance < 1.5 then
                if not trabalhando then
                    DrawText3D(markerPos.x, markerPos.y, markerPos.z + 1.0, Config.Locales["startjob"])
                    if IsControlJustPressed(0, 38) then StartJob() end
                else
                    DrawText3D(markerPos.x, markerPos.y, markerPos.z + 1.0, Config.Locales["endjob"])
                    if IsControlJustPressed(0, 38) then EndJob() end
                end
            end
        end
        
        -- **FIXED**: This block is now controlled by the corrected Perto() function below
        if trabalhando and GetVehiclePedIsIn(playerPed, false) == 0 and Perto() then
            sleep = 5
            if IsControlJustPressed(0, 38) then
                if not escadaNaMao and escadaNoCarro then
                    escadaNoCarro, escadaNaMao = false, true
                    StartAnim('mini@repair', 'fixing_a_ped'); Wait(1000); ClearPedTasks(playerPed)
                    entity = CreateObject(GetHashKey("prop_byard_ladder01"), 0,0,0,true,true,true)
                    AttachEntityToEntity(entity, playerPed, GetPedBoneIndex(playerPed, 28422), 0.05, 0.1, -0.3, 300.0, 100.0, 20.0, true, true, false, true, 1, true)
                    StartAnim('amb@world_human_muscle_free_weights@male@barbell@idle_a', 'idle_a')
                elseif escadaNaMao and not escadaNoCarro then
                    escadaNoCarro, escadaNaMao = true, false
                    StartAnim('mini@repair', 'fixing_a_ped'); Wait(1000); ClearPedTasks(playerPed); DeleteObject(entity)
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

-- Repair timer thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if segundos > 0 then
            segundos = segundos - 1
            StartAnim('amb@world_human_hammering@male@base', 'base')
            if segundos == 0 then
                ClearPedTasks(PlayerPedId())
                servicoConcluido, executandoServico = true, false
                PayForJob(Config.Pay)
            end
        end
    end
end)

function PayForJob(money) TriggerServerEvent('Roda-Electricista:PayJob', money, 'sdafghjrehrw2345dfe') end

-- ===================================
--  CÁC HÀM TIỆN ÍCH
-- ===================================

-- **FIXED**: This function is now more reliable
function Perto()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicle = QBCore.Functions.GetClosestVehicle()

    -- Check if a vehicle exists and if it's the correct model using its hash
    if vehicle and DoesEntityExist(vehicle) and (GetEntityModel(vehicle) == GetHashKey(Config.Car)) and #(playerCoords - GetEntityCoords(vehicle)) < 2.5 then
        DrawText3D(GetEntityCoords(vehicle) + vector3(0.0, 0.0, 1.0), not escadaNaMao and Config.Locales["cogerescala"] or Config.Locales["saveescalera"])
        return true
    end
    
    return false
end

function ChangeClothes() local gender = QBCore.Functions.GetPlayerData().charinfo.gender; TriggerEvent('qb-clothing:client:loadOutfit', gender == 0 and Config.Uniforms.male or Config.Uniforms.female) end
function GetClothes() TriggerServerEvent('qb-clothes:loadPlayerSkin') end
function Notificacion(text) QBCore.Functions.Notify(text, 'primary', 5000) end
DrawText3D = function(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35); SetTextFont(4); SetTextProportional(1); SetTextColour(255, 255, 255, 215); SetTextEntry("STRING"); SetTextCentre(1); AddTextComponentString(text); DrawText(_x, _y)
        local factor = (string.len(text)) / 370; DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 41, 41, 150)
    end
end
function drawTxt(text, font, x, y, scale, r, g, b, a) SetTextFont(font); SetTextScale(scale, scale); SetTextColour(r, g, b, a); SetTextOutline(); SetTextCentre(1); SetTextEntry("STRING"); AddTextComponentString(text); DrawText(x, y) end
function spawnCarJob(car) QBCore.Functions.SpawnVehicle(Config.Car, function(veh) SetVehicleNumberPlateText(veh, Config.Plate); TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh)); SetEntityHeading(veh, 79.89); TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1) end, vector3(-820.5, -748.1, 23.2), true) end
Citizen.CreateThread(function() local blip = AddBlipForCoord(-826.2,-739.9, 28.1); SetBlipSprite(blip, 459); SetBlipDisplay(blip, 4); SetBlipScale(blip, 0.9); SetBlipColour(blip, 59); SetBlipAsShortRange(blip, true); BeginTextCommandSetBlipName("STRING"); AddTextComponentString("Edelnor"); EndTextCommandSetBlipName(blip) end)