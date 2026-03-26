
---comment
---@param source number Player source id
---@return table Identifiers of the player
function Framework.GetPlayerIdentifiers(source)
    local identifiers = GetPlayerIdentifiers(source)
    local result = {}

    for _, v in pairs(identifiers) do
        local split = string.split(v, ':')
        local type = split[1]
        local id = split[2]

        result[type] = id
    end

    return result
end



function Framework.LoadPlayer(source, id)
    local playerData = MySQL.single.await("SELECT * FROM users WHERE id = ?", { id })
    if playerData then
        Players[source] = {
            id = playerData.id,
            identifier = playerData.identifier,
            money = playerData.money,
            bank = playerData.bank,
            job = playerData.job,
            grade = playerData.grade,
        }
        logger(('Player %s loaded with identifier %s'):format(source, playerData.identifier), 'info')
        return true
    else
        logger(('Failed to load player %s with id %s'):format(source, id), 'error')
        return "LOAD1"
    end
end

---This function create the player id the db and laod the player data
---@param source number Player source id
---@param identifier string Identifier to get
function Framework.CreatePlayer(source, identifier)
    local id = MySQL.insert.await("INSERT INTO users (identifier) VALUES (?)", { identifier })
    if id then
        return Framework.LoadPlayer(source, id)
    else
        logger(('Failed to create player with identifier %s'):format(identifier), 'error')
        return "CRTE1"
    end
end