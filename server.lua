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
	local variables = xPlayer.variables
	local phoneNumber = (variables and variables.phoneNumber or xPlayer.get('phoneNumber')) or getUniquePhoneNumber(xPlayer)

	TriggerEvent('npwd:newPlayer', {
		source = playerId,
		identifier = xPlayer.identifier,
		phoneNumber = phoneNumber,
		firstname = variables and variables.firstName or xPlayer.get('firstName'),
		lastname = variables and variables.lastName or xPlayer.get('lastName')
	})
end)

AddEventHandler('esx:playerDropped', function(playerId)
	TriggerEvent('npwd:unloadPlayer', playerId)
end)

AddEventHandler('onResourceStart', function(resource)
	if resource == 'npwd' then
		local xPlayers = ESX.GetPlayers()
		if next(xPlayers) then
			-- Check for ESX Legacy
			local legacy = type(xPlayers[1]) == 'table'

			for i=1, #xPlayers do
				-- Fallback to `GetPlayerFromId` if playerdata was not already returned
				local xPlayer = legacy and xPlayers[i] or ESX.GetPlayerFromId(xPlayers[i])
				local variables = xPlayer.variables

				if variables then
					-- Support for ESX 1.2+
					TriggerEvent('npwd:newPlayer', {
						source = xPlayer.source,
						identifier = xPlayer.identifier,
						phoneNumber = variables.phoneNumber,
						firstname = variables.firstName,
						lastname = variables.lastName
					})
				else
					-- Support for ESX 1.1 with essentialmode
					TriggerEvent('npwd:newPlayer', {
						source = xPlayer.source,
						identifier = xPlayer.identifier,
						phoneNumber = xPlayer.get('phoneNumber'),
						firstname = xPlayer.get('firstName'),
						lastname = xPlayer.get('lastName')
					})
				end
			end
		end
	end
end)