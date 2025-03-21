--[[
    Registry
    The registry is used to keep track of all the modules that have been registered.
    It also provides functions to get the modules and their remotes.

    For registering a module, you should loop through a list of modules and register them through a seperate thread.
    This is because if you're doing everything one after the other, some modules that reference others might never return a valid module, because it hasn't been loaded.
]]

local Types = require(script.Parent.Types)
local Registry = {}
local ServerModules: {[string]: Types.ReturnedServerModule} = {}
local ClientModules: {[string]: Types.ReturnedClientModule} = {}
local Services = {}

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
    local output
    xpcall(function()
        output = module:Initialize()
        if cookerSettings.LOG_REGISTRY_CHANGES then 
            print("✅ | Registered server module '" .. module.Name .. "' in " .. math.round((time() - startTime) * 1000) .. "ms")
        end
    end, function(err)
        warn(debug.traceback("⚠ | Failed to register server module '" .. module.Name .. "': " .. err))
    end)

    ServerModules[module.Name] = module
    return output
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
    local output
    xpcall(function()
        output = module:Initialize()
        if cookerSettings.LOG_REGISTRY_CHANGES then 
            print("✅ | Registered client module '" .. module.Name .. "' in " .. math.round((time() - startTime) * 1000) .. "ms")
        end
    end, function(err)
        warn(debug.traceback("⚠ | Failed to register server module '" .. module.Name .. "': " .. err))
    end)

    ClientModules[module.Name] = module
    return output
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
    if ServerModules[moduleName] == nil then 
        warn("⚠ | Timed out waiting for server module '" .. moduleName .. "' to load")
        return
    end

    completed = true
    return ServerModules[moduleName]
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
    if ClientModules[moduleName] == nil then 
        warn("⚠ | Timed out waiting for client module '" .. moduleName .. "' to load")
        return
    end

    completed = true
    return ClientModules[moduleName]
end

function Registry:AwaitServerLoadAsync(moduleName, callback)
    if runService:IsClient() then 
        warn("⚠ | Attempted to await server load on the client")
        return
    end
    
    task.spawn(function()
        local module = self:AwaitServerLoad(moduleName)
        if not module then return end
        callback(module)
    end)
end

function Registry:AwaitClientLoadAsync(moduleName, callback)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to await client load on the server")
        return
    end

    task.spawn(function()
        local module = self:AwaitClientLoad(moduleName)
        if not module then return end
        callback(module)
    end)
end

function Registry:RegisterServiceServer(service)
    if runService:IsClient() then 
        warn("⚠ | Attempted to call a service server initialize on the client")
        return
    end

    if not service.Name then
        warn("⚠ | Attempted to register a service without a name")
        return
    end

    local startTime = time()
    local output
    xpcall(function()
        output = service:ServerInitialize()
        if cookerSettings.LOG_REGISTRY_CHANGES then 
            print("✅ | Registered service (server) '" .. service.Name .. "' in " .. math.round((time() - startTime) * 1000) .. "ms")
        end
    end, function(err)
        warn(debug.traceback("⚠ | Failed to register service '" .. service.Name .. "': " .. err))
    end)

    Services[service.Name] = service
    return output
end

function Registry:RegisterServiceClient(service)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to call a service client initialize on the server")
        return
    end

    if not service.Name then
        warn("⚠ | Attempted to register a service without a name")
        return
    end

    local startTime = time()
    local output
    xpcall(function()
        output = service:ClientInitialize()
        if cookerSettings.LOG_REGISTRY_CHANGES then 
            print("✅ | Registered service (client) '" .. service.Name .. "' in " .. math.round((time() - startTime) * 1000) .. "ms")
        end
    end, function(err)
        warn(debug.traceback("⚠ | Failed to register service '" .. service.Name .. "': " .. err))
    end)

    Services[service.Name] = service
    return output
end

function Registry:GetService(name)
    local client = runService:IsClient()

    if client then
        if Services[name] == nil then 
            warn("⚠ | Attempted to get a service that does not exist: " .. name)
            return nil
        end

        if Services[name].ClientAccessible == false then 
            warn("⚠ | Attempted to get a service that is not accessible by the client. " .. name)
            return nil
        end

        return Services[name]
    else
        if Services[name] == nil then 
            warn("⚠ | Attempted to get a service that does not exist: " .. name)
            return nil
        end

        if Services[name].ServerAccessible == false then 
            warn("⚠ | Attempted to get a service that is not accessible by the server. " .. name)
            return nil
        end

        return Services[name]
    end
end

return Registry :: Types.Registry