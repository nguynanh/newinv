local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('Roda-Electricista:PayJob')
AddEventHandler('Roda-Electricista:PayJob', function(money, can)
    local src = source
    if can == 'sdafghjrehrw2345dfe' then 
        local xPlayer = QBCore.Functions.GetPlayer(src)
        xPlayer.Functions.AddMoney('cash', money, 'Pay Job')
    else
        DropPlayer(src, 'Bye, Bye Cheater')
    end
end)