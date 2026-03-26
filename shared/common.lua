

---This function return the framework object for client/server
---@return table|nil Framework object 
function GetFramework()
    return Framework and Framework or nil
end


---Easy log function
---@param message string message to log
---@param logType string|nil Default info
function Logger(message, logType)
    if not logType then logType = "info"
        if logType == "info" then
            
        end
    end
end

exports("GetFramework", GetFramework)
