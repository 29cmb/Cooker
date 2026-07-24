--!strict
--[[
    The base class for all client modules.
    Clients cannot create remotes.
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
local Environments = require(script.Parent.Parent.Events.Environments)

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

function ClientModule.RegisterEventListener(self: Types.ClientModule, event: string, onEvent: (...any) -> nil)
	return Environments.ClientEvents:RegisterListener(event, onEvent, self.Name)
end

function ClientModule.UnregisterEventListener(_: Types.ClientModule, listener: Types.EventListener)
	Environments.ClientEvents:UnregisterListener(listener)
end

function ClientModule.CallEvent(_: Types.ClientModule, event: string, ...: any)
	Environments.ClientEvents:Call(event, ...)
end

return ClientModule :: Types.ClientModuleClass