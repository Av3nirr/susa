local Player = {}
Player.__index = Player

function Player.new(playerData)
    local self = setmetatable({}, Player)
    
    self.id = playerData.id
    self.source = playerData.source
    self.name = playerData.name
    self.identifier = playerData.identifier
    self.steam = playerData.steam
    self.discord = playerData.discord
    self.money = playerData.money or 0
    self.level = playerData.level or 1
    self.job = playerData.job or "unemployed"
    self.position = playerData.position or {x = 0, y = 0, z = 0}
    

    ---Get the player identifier
    ---@return string string Player identifier
    function self.getIdentifier()
        return self.identifier
    end


    return self
end
return Player