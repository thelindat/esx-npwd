local ESX = exports['es_extended']:getSharedObject()

ESX = {
	GetPlayers = ESX.GetExtendedPlayers or ESX.GetPlayers,
	GetPlayerFromId = ESX.GetPlayerFromId
}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	if not xPlayer then
		xPlayer = ESX.GetPlayerFromId(playerId)
	end

	exports.npwd:newPlayer({
		source = playerId,
		identifier = xPlayer.identifier,
		firstname = xPlayer.firstName or xPlayer.variables?.firstName or xPlayer.get('firstName'),
		lastname = xPlayer.lastName or xPlayer.variables?.lastName or xPlayer.get('lastName')
	})
end)

AddEventHandler('esx:playerLogout', function(playerId)
	exports.npwd:unloadPlayer(playerId)
end)

AddEventHandler('onServerResourceStart', function(resource)
	if resource == 'npwd' then
		local xPlayers = ESX.GetPlayers()

		if next(xPlayers) then
			Wait(100)
			local isTable = type(xPlayers[1]) == 'table'

			for i=1, #xPlayers do
				-- Fallback to `GetPlayerFromId` if playerdata was not already returned
				local xPlayer = isTable and xPlayers[i] or ESX.GetPlayerFromId(xPlayers[i])

				exports.npwd:newPlayer({
					source = xPlayer.source,
					identifier = xPlayer.identifier,
					firstname = xPlayer.firstName or xPlayer.variables?.firstName or xPlayer.get('firstName'),
					lastname = xPlayer.lastName or xPlayer.variables?.lastName or xPlayer.get('lastName')
				})
			end
		end
	end
end)
