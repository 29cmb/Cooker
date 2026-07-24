--!strict
--[[
    The base class for all client modules.
    Clients cannot create remotes, but they can request remotes from the server modules, the server will then send the remotes back to the client through the method.
    Everything else is functionally the same as a server module.
]]

local ClientModule = {
	Name = "ClientModule",
	Accessible = true,
}
ClientModule.__index = ClientModule
ClientModule.Registry = require(script.Parent.Parent.Registry)

local Types = require(script.Parent.Parent.Types)
local runService = game:GetService("RunService")

function ClientModule.new(data: Types.ClientModuleData)
	if not runService:IsClient() then
		error("❌ | Attempted to create a client module on the server")
	end

	data = setmetatable(data, ClientModule)

	return data
end

function ClientModule.Initialize(self: Types.ClientModule)
	warn("⚠ | ClientModule:Initialize() is not implemented for module " .. self.Name)
end

return ClientModule :: Types.ClientModule