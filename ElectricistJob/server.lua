local QBCore = exports['qb-core']:GetCoreObject()

-- [[SỬA LỖI]] Thay thế callback bằng một sự kiện đơn giản để trừ tiền
RegisterServerEvent('Roda-Electricista:DeductRentalCost')
AddEventHandler('Roda-Electricista:DeductRentalCost', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        Player.Functions.RemoveMoney(Config.Account, Config.RentalCost, 'electrician_vehicle_rental')
        TriggerClientEvent('QBCore:Notify', source, "Bạn đã trả $" .. Config.RentalCost .. " để thuê xe.", "primary")
    end
end)

-- Sự kiện để hoàn lại tiền cọc khi trả xe (Giữ nguyên)
RegisterServerEvent('Roda-Electricista:ReturnVehicle')
AddEventHandler('Roda-Electricista:ReturnVehicle', function()
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player then return end

    Player.Functions.AddMoney(Config.Account, Config.RefundAmount, 'electrician_vehicle_refund')
    TriggerClientEvent('QBCore:Notify', source, "Bạn đã nhận lại $" .. Config.RefundAmount .. " tiền cọc.", "success")
end)


-- Sự kiện thanh toán tiền công việc (Giữ nguyên)
RegisterServerEvent('Roda-Electricista:PayJob')
AddEventHandler('Roda-Electricista:PayJob', function(money, can)
    local src = source
    if can == 'sdafghjrehrw2345dfe' then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            local payment = tonumber(money)
            if payment and payment > 0 then
                Player.Functions.AddMoney(Config.Account, payment, 'electrician_job_payment')
                TriggerClientEvent('QBCore:Notify', src, "Bạn đã nhận được $" .. payment .. " tiền công vào tài khoản " .. Config.Account, "success")
            end
        end
    else
        DropPlayer(src, 'Bye, Bye Cheater')
    end
end)