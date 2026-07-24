--!strict
--[[
    Registry
    The registry is used to keep track of all the modules that have been registered.
    It also provides functions to get the modules and their remotes.

    For registering a module, you should loop through a list of modules and register them through a seperate thread.
    This is because if you're doing everything one after the other, some modules that reference others might never return a valid module, because it hasn't been loaded.
]]

local Types = require(script.Parent.Types)
local Registry = {
	ServerModules = {},
	ClientModules = {}
}

local runService = game:GetService("RunService")
local cookerSettings = require(script.Parent.Settings)
local settings = require(script.Parent.Settings)

function Registry.RegisterServerModule(self: Types.Registry, module: Types.ServerModule): any
	if runService:IsClient() then
		warn("⚠ | Attempted to register a server module on the client")
		return
	end

	if not module.Name then
		warn("⚠ | Attempted to register a server module without a name")
		return
	end

	local startTime = time()
	local output
	xpcall(function()
		output = module:Initialize()
		if cookerSettings.LOG_REGISTRY_CHANGES then
			print(
				"✅ | Registered server module '"
					.. module.Name
					.. "' in "
					.. math.round((time() - startTime) * 1000)
					.. "ms"
			)
		end
	end, function(err)
		warn(debug.traceback("⚠ | Failed to register server module '" .. module.Name .. "': " .. err))
	end)

	self.ServerModules[module.Name] = module
	return output
end

function Registry.RegisterClientModule(self: Types.Registry, module: Types.ClientModule): any
	if not runService:IsClient() then
		warn("⚠ | Attempted to register a client module on the server")
		return
	end

	if not module.Name then
		warn("⚠ | Attempted to register a client module without a name")
		return
	end

	local startTime = time()
	local output
	xpcall(function()
		output = module:Initialize()
		if cookerSettings.LOG_REGISTRY_CHANGES then
			print(
				"✅ | Registered client module '"
					.. module.Name
					.. "' in "
					.. math.round((time() - startTime) * 1000)
					.. "ms"
			)
		end
	end, function(err)
		warn(debug.traceback("⚠ | Failed to register server module '" .. module.Name .. "': " .. err))
	end)

	self.ClientModules[module.Name] = module
	return output
end

function Registry.GetServerModule(self: Types.Registry, name: string): Types.ServerModule?
	if runService:IsClient() then
		warn("⚠ | Attempted to get a server module on the client")
		return nil
	end

	local m = self.ServerModules[name]
	if m == nil then
		return nil
	end

	if m.Accessible == false then
		warn("⚠ | Attempted to get a server module '" .. name .. "' that is not accessible")
		return nil
	end

	return m
end

function Registry.GetClientModule(self: Types.Registry, name: string): Types.ClientModule?
	if not runService:IsClient() then
		warn("⚠ | Attempted to get a client module on the server")
		return nil
	end

	local m = self.ClientModules[name]
	if m == nil then
		return nil
	end

	if m.Accessible == false then
		warn("⚠ | Attempted to get a client module '" .. name .. "' that is not accessible")
		return nil
	end

	return m
end

function Registry.GetServerRemotes(self: Types.Registry, moduleName: string): Types.RemoteReturn?
	if runService:IsClient() then
		warn("⚠ | Attempted to get server remotes on the client")
		return nil
	end

	local module = self:GetServerModule(moduleName)
	if not module then
		warn("⚠ | Attempted to get server remotes for a module that does not exist: " .. moduleName)
		return nil
	end

	if not module.Remotes or typeof(module.Remotes) ~= "table" then
		warn("⚠ | Attempted to get server remotes for a module that does not have remotes: " .. moduleName)
		return nil
	end

	return module.Remotes
end

function Registry.AwaitServerLoad(self: Types.Registry, moduleName: string)
	if runService:IsClient() then
		warn("⚠ | Attempted to await server load on the client")
		return
	end

	local timeout = false
	local completed = false

	task.spawn(function()
		task.wait(settings.MODULE_AWAIT_TIMEOUT)
		if not completed then
			timeout = true
		end
	end)

	repeat
		task.wait()
	until self.ServerModules[moduleName] ~= nil or timeout == true

	if self.ServerModules[moduleName] == nil then
		warn("⚠ | Timed out waiting for server module '" .. moduleName .. "' to load")
		return
	end

	if self.ServerModules[moduleName].Accessible == false then
		warn("⚠ | Attempted to await server module '" .. moduleName .. "' that is not accessible")
		return nil
	end

	completed = true
	return self.ServerModules[moduleName]
end

function Registry.AwaitClientLoad(self: Types.Registry, moduleName: string)
	if not runService:IsClient() then
		warn("⚠ | Attempted to await client load on the server")
		return
	end

	local timeout = false
	local completed = false

	task.spawn(function()
		task.wait(settings.MODULE_AWAIT_TIMEOUT)
		if not completed then
			timeout = true
		end
	end)

	repeat
		task.wait()
	until self.ClientModules[moduleName] ~= nil or timeout == true
	
	if self.ClientModules[moduleName] == nil then
		warn("⚠ | Timed out waiting for client module '" .. moduleName .. "' to load")
		return
	end

	if self.ClientModules[moduleName].Accessible == false then
		warn("⚠ | Attempted to await client module '" .. moduleName .. "' that is not accessible")
		return nil
	end

	completed = true
	return self.ClientModules[moduleName]
end

function Registry.AwaitServerLoadAsync(self: Types.Registry, moduleName, callback)
	if runService:IsClient() then
		warn("⚠ | Attempted to await server load on the client")
		return
	end

	task.spawn(function()
		local module = self:AwaitServerLoad(moduleName)
		if not module then
			return
		end
		callback(module)
	end)
end

function Registry.AwaitClientLoadAsync(self: Types.Registry, moduleName, callback)
	if not runService:IsClient() then
		warn("⚠ | Attempted to await client load on the server")
		return
	end

	task.spawn(function()
		local module = self:AwaitClientLoad(moduleName)
		if not module then
			return
		end
		callback(module)
	end)
end

return Registry :: Types.Registry