local ESX = exports['es_extended']:getSharedObject()

ESX = {
	GetPlayers = ESX.GetExtendedPlayers or ESX.GetPlayers,
	GetPlayerFromId = ESX.GetPlayerFromId
}

local function getUniquePhoneNumber(xPlayer)
	while true do
		local phoneNumber = ('%s-%s-%s'):format(math.random(100,999), math.random(100,999), math.random(1000,9999))
		local exists = exports.oxmysql:scalarSync('SELECT 1 FROM users WHERE phone_number = ?', { phoneNumber })

		if not exists then
			exports.oxmysql:update('UPDATE users SET phone_number = ? WHERE identifier = ?', { phoneNumber, xPlayer.identifier })
			xPlayer.set('phoneNumber', phoneNumber)
			return phoneNumber
		end
	end
end

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	print(playerId, xPlayer.variables.phoneNumber)
	local phoneNumber = xPlayer.variables.phoneNumber or getUniquePhoneNumber(xPlayer)
	print(phoneNumber)

	TriggerEvent('npwd:newPlayer', {
		source = playerId,
		identifier = xPlayer.identifier,
		phoneNumber = phoneNumber,
		firstname = xPlayer.variables.firstName,
		lastname = xPlayer.variables.lastName
	})
end)

AddEventHandler('esx:playerDropped', function(playerId)
	TriggerEvent('npwd:unloadPlayer', playerId)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == 'npwd' then
		local xPlayers = ESX.GetPlayers()
		if next(xPlayers) then
			local legacy = type(xPlayers[1]) == 'table'
			for i=1, #xPlayers do
				local xPlayer = legacy and xPlayers[i] or ESX.GetPlayerFromId(xPlayers[i])
				print(xPlayer.source, xPlayer.variables.firstName, xPlayer.variables.phoneNumber)

				TriggerEvent('npwd:newPlayer', {
					source = xPlayer.source,
					identifier = xPlayer.identifier,
					phoneNumber = xPlayer.variables.phoneNumber,
					firstname = xPlayer.variables.firstName,
					lastname = xPlayer.variables.lastName
				})
			end
		end
	end
end)