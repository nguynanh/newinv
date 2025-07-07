-- =================================================================
-- Roda-Electricista | client.lua | Thêm hiệu ứng điện giật
-- =================================================================

QBCore = exports['qb-core']:GetCoreObject()

-- Khai báo biến
local jobLocation = vector4(738.86, 136.4, 80.73, 245.51)
local vehicleSpawn = vector4(747.28, 130.02, 79.33, 232.34)

local trabalhando = false
local jobStarting = false
local escadaNaMao = false
local escadaNoCarro = true
local escadaNoPoste = false
local servicoConcluido = false

local escadaNoPoste = false -- <<<< 

local jobVehicle = nil
local AttachedLadder = nil
local SpawnedLadder = nil
local pontosDaSua = {}
local currentRepairPoint = nil

local isDoingGroundRepair = false
local pontosGroundFeitos = {}
local pontosAltosDaSua = {}

-- =================================================================
-- HÀM TIỆN ÍCH
-- =================================================================
function StartAnim(lib, anim)
    RequestAnimDict(lib)
    while not HasAnimDictLoaded(lib) do Wait(1) end
    TaskPlayAnim(PlayerPedId(), lib, anim, 8.0, -8.0, -1, 1, 0, false, false, false)
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35); SetTextFont(4); SetTextProportional(1)
        SetTextColour(255, 255, 255, 255); SetTextOutline()
        SetTextEntry("STRING"); SetTextCentre(1)
        AddTextComponentString(text); DrawText(_x, _y)
    end
end

function Notificacion(text)
    QBCore.Functions.Notify(text, 'primary')
end

function ChangeClothes()
    local gender = QBCore.Functions.GetPlayerData().charinfo.gender
    if gender == 0 then
        TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.male)
    else
        TriggerEvent('qb-clothing:client:loadOutfit', Config.Uniforms.female)
    end
end

function GetClothes()
    TriggerServerEvent('qb-clothes:loadPlayerSkin')
end

function spawnCarJob(car, cb)
    local plateNumber = math.random(100, 999)
    local newPlate = Config.PlatePrefix .. plateNumber
    QBCore.Functions.SpawnVehicle(Config.Car, function(veh)
        jobVehicle = veh
        SetVehicleNumberPlateText(veh, newPlate)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetEntityHeading(veh, vehicleSpawn.w)
        if cb then cb() end
    end, vehicleSpawn.xyz, true)
end

function Perto()
    if not jobVehicle or not DoesEntityExist(jobVehicle) then return false end
    local playerCoords = GetEntityCoords(PlayerPedId())
    local vehicleCoords = GetEntityCoords(jobVehicle)
    local distance = #(playerCoords - vehicleCoords)

    if distance < 2.5 then
        if not escadaNaMao then
            DrawText3D(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.5, Config.Locales["cogerescala"])
        else
            DrawText3D(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z + 1.5, Config.Locales["saveescalera"])
        end
        return true
    end
    return false
end

function PlaceLadderOnPole(pointData)
    currentRepairPoint = pointData
    escadaNoPoste = true; escadaNaMao = false; servicoConcluido = false
    ClearPedTasks(PlayerPedId())
    if AttachedLadder and DoesEntityExist(AttachedLadder) then DeleteEntity(AttachedLadder) end
    AttachedLadder = nil

    local ladderModel
    if pointData.type == 'high' then
        ladderModel = Config.TallLadderModel or "hw1_06_ldr_04"
    else
        ladderModel = Config.NormalLadderModel or "hw1_06_ldr_"
    end
    local ladderHash = GetHashKey(ladderModel)
    RequestModel(ladderHash)
    while not HasModelLoaded(ladderHash) do Wait(10) end
    SpawnedLadder = CreateObject(ladderHash, pointData.location.x, pointData.location.y, pointData.location.z, true, true, true)
    PlaceObjectOnGroundProperly(SpawnedLadder)
    SetEntityHeading(SpawnedLadder, (pointData.location.w + 180.0) % 360.0)
    FreezeEntityPosition(SpawnedLadder, true)
end

function TakeLadderFromPole()
    if not currentRepairPoint then return end
    if currentRepairPoint.type == 'high' then
        pontosAltosDaSua[currentRepairPoint.index] = true
    else
        pontosDaSua[currentRepairPoint.index] = true
    end
    currentRepairPoint = nil
    escadaNoPoste = false; escadaNaMao = true; servicoConcluido = false
    if SpawnedLadder and DoesEntityExist(SpawnedLadder) then DeleteEntity(SpawnedLadder) end
    SpawnedLadder = nil
    AttachedLadder = CreateObject(GetHashKey("prop_byard_ladder01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(AttachedLadder, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.05, 0.1, -0.3, 300.0, 100.0, 20.0, true, true, false, true, 1, true)
end

function PayForJob(money)
    TriggerServerEvent('Roda-Electricista:PayJob', money, 'sdafghjrehrw2345dfe')
end

function StartRepairMinigame()
    return exports['minigame']:startDistributor(true)
end

-- [[THÊM MỚI]] Hàm tạo hiệu ứng điện giật
function ApplyShockEffect()
    local playerPed = PlayerPedId()

    -- Ngừng mọi hoạt ảnh đang chạy để đảm bảo ragdoll có thể áp dụng
    ClearPedTasksImmediately(playerPed)
    ClearPedTasks(playerPed)

    -- Trừ một chút máu (15 máu)
    SetEntityHealth(playerPed, GetEntityHealth(playerPed) - 15)

    -- Tạo hiệu ứng tia lửa điện trên người
    local ptfxDict = "core"
    local ptfxName = "ent_sht_elec_box"
    RequestNamedPtfxAsset(ptfxDict)
    while not HasNamedPtfxAssetLoaded(ptfxDict) do Wait(50) end

    SetPtfxAssetNextCall(ptfxDict)
    StartNetworkedParticleFxNonLoopedOnEntity(ptfxName, playerPed,
                                               0.0, 0.0, 0.0,
                                               0.0, 0.0, 0.0,
                                               1.5,
                                               true, true, true)

    local convulsionDuration = 10000 -- Thời gian hiệu ứng ragdoll (10 giây)

    if escadaNoPoste then -- Nếu nhân vật đang ở trên thang đã đặt
        SetPedToRagdoll(playerPed, convulsionDuration, convulsionDuration, 5, false, false, false) 
    else
        SetPedToRagdoll(playerPed, convulsionDuration, convulsionDuration, 0, true, true, true)
       
    end
    -- >>>>>> KẾT THÚC LOGIC MỚI <<<<<<

    -- Chờ đợi hết thời gian nhân vật ragdoll
    Citizen.Wait(convulsionDuration)

end
-- =================================================================
-- LUỒNG XỬ LÝ CHÍNH
-- =================================================================

-- Luồng 1: Xử lý tương tác với các điểm sửa chữa
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        if trabalhando then
            if escadaNoPoste then
                sleep = 5
                local ladderCoords = GetEntityCoords(SpawnedLadder)
                if ladderCoords then
                    if not servicoConcluido then
                        local distance2D = #(vector2(playerCoords.x, playerCoords.y) - vector2(ladderCoords.x, ladderCoords.y))
                        if distance2D < 2.0 and playerCoords.z > ladderCoords.z + Config.RepairHeight then
                            DrawText3D(playerCoords.x, playerCoords.y, playerCoords.z + 0.5, "Nhan ~b~Y~w~ de sua chua")
                            if IsControlJustPressed(0, 246) then
                                local success = StartRepairMinigame()
                                if success then
                                    servicoConcluido = true
                                    Notificacion("Sửa chữa thành công!")
                                    local paymentInfo
                                    if currentRepairPoint.type == 'high' then
                                        paymentInfo = Config.Payments.ladder_high
                                    else
                                        paymentInfo = Config.Payments.ladder_normal
                                    end
                                    local paymentAmount = math.random(paymentInfo.min, paymentInfo.max)
                                    PayForJob(paymentAmount)
                                else
                                    Notificacion("Sửa chữa thất bại! Bạn đã bị điện giật!")
                                    ApplyShockEffect() -- Gọi hiệu ứng điện giật
                                end
                            end
                        end
                    end
                end
                if servicoConcluido then
                    if currentRepairPoint and currentRepairPoint.location then
                        local placementCoords = currentRepairPoint.location
                        if #(playerCoords - placementCoords.xyz) < 2.0 then
                            DrawText3D(placementCoords.x, placementCoords.y, placementCoords.z + 1.0, Config.Locales["sacarescalera"])
                            if IsControlJustPressed(0, 246) then
                                -- [[THAY ĐỔI]] Thêm animation khi gỡ thang
                                Notificacion("Đang thu dọn thang...")
                                FreezeEntityPosition(playerPed, true)
                                StartAnim("amb@world_human_hammering@male@base", "base")
                                Wait(3000)
                                FreezeEntityPosition(playerPed, false)
                                ClearPedTasks(playerPed)
                                TakeLadderFromPole()
                            end
                        end
                    end
                end
            elseif escadaNaMao then
                sleep = 5
                local closestDist = -1; local closestPoint = nil
                for i, location in ipairs(Config.RepairLocations) do
                    if not pontosDaSua[i] then
                        local dist = #(playerCoords - location.xyz)
                        if closestDist == -1 or dist < closestDist then
                            closestDist = dist
                            closestPoint = { location = location, index = i, type = 'normal' }
                        end
                    end
                end
                if Config.HighRepairLocations then
                    for i, location in ipairs(Config.HighRepairLocations) do
                        if not pontosAltosDaSua[i] then
                            local dist = #(playerCoords - location.xyz)
                            if closestDist == -1 or dist < closestDist then
                                closestDist = dist
                                closestPoint = { location = location, index = i, type = 'high' }
                            end
                        end
                    end
                end
                if closestPoint and closestDist < Config.distance then
                    DrawText3D(closestPoint.location.x, closestPoint.location.y, closestPoint.location.z + 1.0, Config.Locales["ponerescalera"])
                    if IsControlJustPressed(0, 246) then
                        if AttachedLadder and DoesEntityExist(AttachedLadder) then DeleteEntity(AttachedLadder); AttachedLadder = nil end
                        Notificacion("Đang chuẩn bị thang...")
                        FreezeEntityPosition(playerPed, true)
                        StartAnim("amb@world_human_hammering@male@base", "base")
                        Wait(3000)
                        FreezeEntityPosition(playerPed, false)
                        ClearPedTasks(playerPed)
                        PlaceLadderOnPole(closestPoint)
                    end
                end
            elseif not isDoingGroundRepair and Config.EnableGroundRepairs then
                local closestDist = -1; local closestPoint = nil
                for i, location in ipairs(Config.GroundRepairLocations) do
                    if not pontosGroundFeitos[i] then
                        local dist = #(playerCoords - location)
                        if dist < 10.0 and (closestDist == -1 or dist < closestDist) then
                            closestDist = dist
                            closestPoint = { location = location, index = i }
                        end
                    end
                end
                if closestPoint then
                    sleep = 5
                    if closestDist < 2.5 then
                        DrawText3D(closestPoint.location.x, closestPoint.location.y, closestPoint.location.z, "Nhan ~b~E~w~ de sua chua")
                    end
                    if closestDist < Config.distance then
                        if IsControlJustPressed(0, 38) then
                            local success = StartRepairMinigame()
                            if success then
                                Notificacion("Dang sua chua...")
                                local animDict = "amb@world_human_welding@male@base"
                                local animName = "base"
                                FreezeEntityPosition(playerPed, true)
                                StartAnim(animDict, animName)
                                Wait(7000)
                                FreezeEntityPosition(playerPed, false)
                                ClearPedTasks(playerPed)
                                pontosGroundFeitos[closestPoint.index] = true
                                Notificacion("Sửa chữa thành công!")
                                local paymentInfo = Config.Payments.ground
                                local paymentAmount = math.random(paymentInfo.min, paymentInfo.max)
                                PayForJob(paymentAmount)
                            else
                                Notificacion("Sửa chữa thất bại! Bạn đã bị điện giật!")
                                ApplyShockEffect() -- Gọi hiệu ứng điện giật
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)


-- Luồng 2: Xử lý nhận/trả việc và lấy/cất thang từ xe
Citizen.CreateThread(function()
    while true do
        local sleep = 500
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - jobLocation.xyz)
        if distance <= 5.0 then
            sleep = 5
            DrawMarker(23, jobLocation.x, jobLocation.y, jobLocation.z - 1.0, 0,0,0,0,0,0, 1.0,1.0,0.5, 240,200,80,80,0,0,0,0)
            if distance <= 1.5 then
                if not trabalhando then
                    DrawText3D(jobLocation.x, jobLocation.y, jobLocation.z + 0.5, Config.Locales["startjob"])
                    if IsControlJustPressed(0, 38) and not jobStarting then
                        local playerData = QBCore.Functions.GetPlayerData()
                        local playerMoney = playerData.money[Config.Account] or 0
                        if playerMoney >= Config.RentalCost then
                            jobStarting = true; trabalhando = true
                            pontosDaSua = {}; pontosGroundFeitos = {}; pontosAltosDaSua = {}
                            TriggerServerEvent('Roda-Electricista:DeductRentalCost')
                            Notificacion(Config.Locales["jobiniciado"])
                            ChangeClothes()
                            spawnCarJob(Config.Car, function() jobStarting = false end)
                        else
                            Notificacion("Bạn không đủ tiền để thuê xe.")
                        end
                    end
                else
                    DrawText3D(jobLocation.x, jobLocation.y, jobLocation.z + 0.5, Config.Locales["endjob"])
                    if IsControlJustPressed(0, 38) and not jobStarting then
                        local vehicleReturned = false
                        if jobVehicle and DoesEntityExist(jobVehicle) then
                            if #(jobLocation.xyz - GetEntityCoords(jobVehicle)) < Config.ReturnVehicleMaxDistance then
                                vehicleReturned = true
                            end
                        end
                        if vehicleReturned then
                            TriggerServerEvent('Roda-Electricista:ReturnVehicle')
                            DeleteEntity(jobVehicle)
                        else
                            Notificacion("Không tìm thấy xe làm việc gần đây. Tiền cọc không được hoàn lại.")
                            if jobVehicle and DoesEntityExist(jobVehicle) then DeleteEntity(jobVehicle) end
                        end
                        jobVehicle = nil; trabalhando = false
                        Notificacion(Config.Locales["jobterminado"]); GetClothes()
                    end
                end
            end
        end
        if trabalhando and not jobStarting and not IsPedInAnyVehicle(playerPed, false) and Perto() then
            sleep = 0
            if IsControlJustPressed(0, 38) then
                if not escadaNaMao and escadaNoCarro then
                    escadaNoCarro = false; escadaNaMao = true
                    StartAnim('mini@repair', 'fixing_a_ped')
                    Wait(1000)
                    ClearPedTasks(playerPed)
                    AttachedLadder = CreateObject(GetHashKey("prop_byard_ladder01"), 0,0,0, true,true,true)
                    AttachEntityToEntity(AttachedLadder, playerPed, GetPedBoneIndex(playerPed, 28422), 0.05, 0.1, -0.3, 300.0, 100.0, 20.0, true, true, false, true, 1, true)
                elseif escadaNaMao and not escadaNoCarro then
                    escadaNoCarro = true; escadaNaMao = false
                    StartAnim('mini@repair', 'fixing_a_ped')
                    Wait(1000)
                    ClearPedTasks(playerPed)
                    if AttachedLadder and DoesEntityExist(AttachedLadder) then DeleteEntity(AttachedLadder) end
                    AttachedLadder = nil
                end
            end
        end
        Wait(sleep)
    end
end)

-- Luồng 4: Tạo Blip và NPC (Giữ nguyên)
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(jobLocation.x, jobLocation.y, jobLocation.z)
    SetBlipSprite(blip, 354); SetBlipDisplay(blip, 4); SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 59); SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString("Edelnor")
    EndTextCommandSetBlipName(blip)

    if not Config.EnableJobGiverNpc then return end
    local npcModel = GetHashKey(Config.JobGiverNpcModel)
    RequestModel(npcModel)
    while not HasModelLoaded(npcModel) do Wait(100) end
    local npc = CreatePed(4, npcModel, jobLocation.x, jobLocation.y, jobLocation.z - 1.0, jobLocation.w, false, true)
    FreezeEntityPosition(npc, true); SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true); TaskStandStill(npc, -1)
end)

-- Lệnh Debug (Giữ nguyên)
local adminSpawnedLadder = nil
RegisterCommand('datthang', function(source, args, rawCommand)
    if not Config.AdminDebug then return end
    if adminSpawnedLadder and DoesEntityExist(adminSpawnedLadder) then DeleteEntity(adminSpawnedLadder) end
    local playerPed = PlayerPedId()
    local ladderCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 0.8, 0.0)
    local playerHeading = GetEntityHeading(playerPed)
    local ladderVisualHeading = (playerHeading + 180.0) % 360.0
    local ladderHash = GetHashKey("hw1_06_ldr_04")
    RequestModel(ladderHash)
    while not HasModelLoaded(ladderHash) do Wait(10) end
    adminSpawnedLadder = CreateObject(ladderHash, ladderCoords.x, ladderCoords.y, ladderCoords.z, true, true, true)
    PlaceObjectOnGroundProperly(adminSpawnedLadder)
    SetEntityHeading(adminSpawnedLadder, ladderVisualHeading)
    FreezeEntityPosition(adminSpawnedLadder, true)
    local vectorString = string.format("vector4(%.2f, %.2f, %.2f, %.2f),", ladderCoords.x, ladderCoords.y, ladderCoords.z, playerHeading)
    Notificacion("Đã đặt thang. Tọa độ đã được in ra console (F8).")
    print("================ TỌA ĐỘ ĐIỂM SỬA MỚI ================\n" .. vectorString .. "\n======================================================")
end, false)

RegisterCommand('xoathang', function(source, args, rawCommand)
    if not Config.AdminDebug then return end
    if adminSpawnedLadder and DoesEntityExist(adminSpawnedLadder) then
        DeleteEntity(adminSpawnedLadder)
        adminSpawnedLadder = nil
        Notificacion("Đã xóa thang debug.")
    else
        Notificacion("Không có thang debug nào để xóa.")
    end
end, false)