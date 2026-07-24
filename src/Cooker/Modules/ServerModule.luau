--!strict
--[[
	The base class for all server modules.
]]
local ServerModule = {
	Name = "ServerModule",
	Accessible = true,
	Remotes = {},
}
ServerModule.__index = ServerModule
ServerModule.Registry = require(script.Parent.Parent.Registry)

local remotes = require(script.Parent.Parent.Util.Remotes)
local Types = require(script.Parent.Parent.Types)
local runService = game:GetService("RunService")

function ServerModule.new(data: Types.ServerModuleData)
	if runService:IsClient() then
		error("❌ | Attempted to create a server module on the client")
	end

	data = setmetatable(data, ServerModule)
	return data
end

function ServerModule.NewRemote(self: Types.ServerModule, path: string, scope: any?, callback: ((scope: any, ...any) -> any)?)
	local pattern = "^%w+[%.%w]*%[%w+%]$"
	local valid = path:match(pattern) ~= nil

	if not valid then error(`❌ | Invalid remote path: {path}; Please read the documentation for how remotes should be formatted.`) end

	local remote, connection = remotes:NewRemote(path, scope, callback)
	if not remote then error("❌ | Failed to create remote: " .. path) end

	self.Remotes[remote.Name] = remote
	return remote, connection
end

function ServerModule.GetModuleRemotes(self: Types.ServerModule, name: string)
	return self.Registry:GetServerRemotes(name)
end

function ServerModule.Initialize(self: Types.ServerModule)
	warn("⚠ | ServerModule:Initialize() is not implemented for module " .. self.Name)
end

return ServerModule :: Types.ServerModule
