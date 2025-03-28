local ServerModule = {}
ServerModule.__index = ServerModule
ServerModule.prototype = {
    Name = "ServerModule",
    Accessible = true,
}
ServerModule.values = {
    Remotes = {}
}
ServerModule.Registry = require(script.Parent.Parent.Registry)

local util = require(script.Parent.Parent.Util.Misc)
local remotes = require(script.Parent.Parent.Util.Remotes)
local Types = require(script.Parent.Parent.Types)
local runService = game:GetService("RunService")

function ServerModule.new(data: any)
    if runService:IsClient() then 
        warn("⚠ | Attempted to create a server module on the client")
        return nil
    end

    data = util:Default(data, ServerModule.prototype) :: Types.ServerModuleData
    for i,v in pairs(ServerModule.values) do 
        data[i] = v
    end

    setmetatable(data, ServerModule)

    return data
end

function ServerModule:NewRemote(path)
    local pattern = "^%w+[%.%w]*%[%w+%]$"
    local valid = path:match(pattern) ~= nil

    if not valid then 
        warn("⚠ | Invalid remote path: " .. path .. ". Please read the documentation for how remotes should be formatted.")
        return nil
    end

    local remote = remotes:NewRemote(path)
    if remote then
        self.Remotes[remote.Name] = remote
        return remote
    else
        warn("⚠ | Failed to create remote: " .. path)
        return nil
    end
end

function ServerModule:GetModuleRemotes(name) : Types.RemoteReturn?
    return self.Registry:GetServerRemotes(name)
end

function ServerModule:Initialize()
    warn("⚠ | ServerModule:Initialize() is not implemented for module " .. self.Name)
end

return ServerModule :: Types.ServerModule