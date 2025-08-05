--[[
    The base class for all client modules.
    Clients cannot create remotes, but they can request remotes from the server modules, the server will then send the remotes back to the client through the method.
    Everything else is functionally the same as a server module.
]]

local ClientModule = {}
ClientModule.__index = ClientModule
ClientModule.prototype = {
    Name = "ClientModule",
    Accessible = true,
}
ClientModule.Registry = require(script.Parent.Parent.Registry)

local util = require(script.Parent.Parent.Util.Misc)
local Types = require(script.Parent.Parent.Types)
local runService = game:GetService("RunService")

function ClientModule.new(data: any)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to create a client module on the server")
        return nil
    end
    
    data = util:Default(data, ClientModule.prototype) :: Types.ClientModuleData
    setmetatable(data, ClientModule)

    return data
end

function ClientModule:Initialize()
    warn("⚠ | ClientModule:Initialize() is not implemented for module " .. self.Name)
end

return ClientModule :: Types.ClientModule