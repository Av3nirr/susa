Framework = {}
Players = {}


local connectingPlayers = {}
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local sourceTempId = source
    if connectingPlayers[sourceTempId] or not sourceTempId then return end
    connectingPlayers[sourceTempId] = true
    
    deferrals.defer()
    logger(('Player %s is connecting to the server'):format(name), 'info')
    local identifier = Framework.GetPlayerIdentifiers(sourceTempId)['license']
    deferrals.update(('Checking identifiers for %s'):format(name))
    Wait(1000)
    if not identifier then
        deferrals.done('Aucun identifier trouvé')
        return
    else
        deferrals.update(('Loading player %s'):format(name))
        Wait(1000)
        local result = ConnectPlayer(sourceTempId)
        if result then
            deferrals.done('Une erreur est survenue lors de la connexion: ' .. result)
            return
        end
        deferrals.update(('Welcome %s, enjoy your stay!'):format(name))
        Wait(1000)
        deferrals.done()
    end
end)

AddEventHandler('playerJoining', function()
    local playerId = source
    if not playerId or playerId == 0 then return end
    local player = Framework.GetPlayerIdentifiers(playerId)
    if not player then
        TriggerEvent('susa:playerConnected', playerId)
    end
end)

function ConnectPlayer(playerId)
    local _src = playerId
    if Players[_src] then
        logger(('Player %s is already connected'):format(_src), 'error')
        return "CNNCT1"
    end
    local identifier = Framework.GetPlayerIdentifiers(_src)['license']
    if not identifier then
        logger(('No identifier found for player %s'):format(_src), 'error')
        return "CNNCT2"
    end
    local result = MySQL.scalar.await("SELECT 1 FROM users WHERE identifier = ?", { identifier })
    if result then
        Framework.LoadPlayer(_src, result)
    else
        Framework.CreatePlayer(_src, identifier)
    end
end


AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    -- Reload all the connected players (in case of a resource restart)
    local players = GetPlayers()
    for _, playerId in pairs(players) do
        ConnectPlayer(playerId)
    end
end)