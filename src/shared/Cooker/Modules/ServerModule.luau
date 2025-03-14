local ServerModule = {}
ServerModule.__index = ServerModule
ServerModule.prototype = {
    Name = "ServerModule",
    Accessible = true,
}

local util = require(script.Parent.Parent.Util.Misc)
local remotes = require(script.Parent.Parent.Util.Remotes)

function ServerModule.new(data)
    data = util:Default(data, ServerModule.prototype)
    setmetatable(data, ServerModule)

    return data
end

function ServerModule:NewRemote(path)
    local pattern = "^(%w+%.?)*%w+%[%w+%]$"
    local valid = path:match(pattern) ~= nil

    if not valid then 
        warn("⚠ | Invalid remote path: " .. path .. ". Please read the documentation for how remotes should be formatted.")
        return nil
    end

    local remote = remotes:NewRemote(path)
    if remote then
        return remote
    else
        warn("⚠ | Failed to create remote: " .. path)
        return nil
    end
end

return ServerModule