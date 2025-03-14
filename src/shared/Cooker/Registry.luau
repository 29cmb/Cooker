--[[
    Registry
    The registry is used to keep track of all the modules that have been registered.
    It also provides functions to get the modules and their remotes.
]]

local Types = require(script.Parent.Types)
local Registry = {}
local ServerModules: {[string]: Types.ReturnedServerModule} = {}
local ClientModules: {[string]: Types.ReturnedClientModule} = {}

local runService = game:GetService("RunService")
local cookerSettings = require(script.Parent.Settings)
local settings = require(script.Parent.Settings)

function Registry:RegisterServerModule(module: Types.ReturnedServerModule)
    if runService:IsClient() then 
        warn("⚠ | Attempted to register a server module on the client")
        return
    end

    if not module.Name then
        warn("⚠ | Attempted to register a server module without a name")
        return
    end

    local startTime = time()
    module:Initialize()

    if cookerSettings.LOG_REGISTRY_CHANGES then 
        print("✅ | Registered server module '" .. module.Name .. "' in " .. math.round((time() - startTime) * 1000) .. "ms")
    end

    ServerModules[module.Name] = module
end

function Registry:RegisterClientModule(module: Types.ReturnedClientModule)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to register a client module on the server")
        return
    end

    if not module.Name then
        warn("⚠ | Attempted to register a client module without a name")
        return
    end

    local startTime = time()
    module:Initialize()

    if cookerSettings.LOG_REGISTRY_CHANGES then 
        print("✅ | Registered client module '" .. module.Name .. "' in " .. math.round((time() - startTime) * 1000) .. "ms")
    end

    ClientModules[module.Name] = module
end

function Registry:GetServerModule(name: string): Types.ReturnedServerModule?
    if runService:IsClient() then 
        warn("⚠ | Attempted to get a server module on the client")
        return nil
    end

    local m = ServerModules[name]
    if m == nil then 
        return nil
    end

    if m.Accessible == false then 
        warn("⚠ | Attempted to get a server module '" .. name .. "' that is not accessible")
        return nil
    end

    return m
end

function Registry:GetClientModule(name: string): Types.ReturnedClientModule?
    if not runService:IsClient() then 
        warn("⚠ | Attempted to get a client module on the server")
        return nil
    end

    local m = ClientModules[name]
    if m == nil then 
        return nil
    end

    if m.Accessible == false then 
        warn("⚠ | Attempted to get a client module '" .. name .. "' that is not accessible")
        return nil
    end

    return m
end

function Registry:GetServerRemotes(moduleName: string): Types.RemoteReturn?
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

function Registry:GetClientRemotes(moduleName: string): Types.RemoteReturn?
    if not runService:IsClient() then 
        warn("⚠ | Attempted to get client remotes on the server")
        return nil
    end

    local remote: RemoteFunction = game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Cooker"):WaitForChild("GetServerModuleRemotes")
    return remote:InvokeServer(moduleName)
end

function Registry:AwaitServerLoad(moduleName: string)
    if runService:IsClient() then 
        warn("⚠ | Attempted to await server load on the client")
        return
    end

    local timeout = false
    local completed = false

    task.spawn(function()
        wait(settings.MODULE_AWAIT_TIMEOUT)
        if not completed then timeout = true end
    end)

    repeat task.wait() until ServerModules[moduleName] ~= nil or timeout == true
    if ServerModules[moduleName] ~= nil then 
        completed = true
    else
        warn("⚠ | Timed out waiting for server module '" .. moduleName .. "' to load")
    end
end

function Registry:AwaitClientLoad(moduleName: string)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to await client load on the server")
        return
    end

    local timeout = false
    local completed = false

    task.spawn(function()
        wait(settings.MODULE_AWAIT_TIMEOUT)
        if not completed then timeout = true end
    end)

    repeat task.wait() until ClientModules[moduleName] ~= nil or timeout == true
    if ClientModules[moduleName] ~= nil then 
        completed = true
    else
        warn("⚠ | Timed out waiting for client module '" .. moduleName .. "' to load")
    end
end

return Registry :: Types.Registry