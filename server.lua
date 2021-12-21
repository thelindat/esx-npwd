local ESX = exports['es_extended']:getSharedObject()

ESX = {
	GetPlayers = ESX.GetExtendedPlayers or ESX.GetPlayers,
	GetPlayerFromId = ESX.GetPlayerFromId
}

local function getUniquePhoneNumber(identifier)
	local phoneNumber = exports.npwd:generatePhoneNumber()
	MySQL.Async.execute('UPDATE users SET phone_number = ? WHERE identifier = ?', { phoneNumber, identifier })
	return phoneNumber
end

local rawget = rawget
local variable_mt = {
	__index = function(self, key)
		return rawget(self, get) and self.get(key)
	end
}

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
	local variables = xPlayer.variables or setmetatable(xPlayer, variable_mt)

	local phoneNumber = variables.phoneNumber or getUniquePhoneNumber(xPlayer.identifier)

	exports.npwd:newPlayer({
		source = playerId,
		identifier = xPlayer.identifier,
		phoneNumber = phoneNumber,
		firstname = variables.firstName,
		lastname = variables.lastName
	})
end)

AddEventHandler('esx:playerLogout', function(playerId)
	exports.npwd:unloadPlayer, playerId)
end)

local legacy

AddEventHandler('onServerResourceStart', function(resource)
	if resource == 'npwd' then
		Wait(100)
		local xPlayers = ESX.GetPlayers()
		if next(xPlayers) then
			-- Check for ESX Legacy
			if not legacy then legacy = type(xPlayers[1]) == 'table' end

			for i=1, #xPlayers do
				-- Fallback to `GetPlayerFromId` if playerdata was not already returned
				local xPlayer = legacy and xPlayers[i] or ESX.GetPlayerFromId(xPlayers[i])
				local variables = xPlayer.variables or setmetatable(xPlayer, variable_mt)

				exports.npwd:newPlayer({
					source = xPlayer.source,
					identifier = xPlayer.identifier,
					phoneNumber = variables.phoneNumber,
					firstname = variables.firstName,
					lastname = variables.lastName
				})
			end
		end
	end
end)
