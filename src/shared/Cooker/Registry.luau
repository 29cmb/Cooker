local Registry = {}
Registry.ServerModules = {}
Registry.ClientModules = {}
local runService = game:GetService("RunService")
local cookerSettings = require(script.Parent.Settings)

function Registry:RegisterServerModule(module)
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

    table.insert(self.ServerModules, module)
end

function Registry:RegisterClientModule(module)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to register a client module on the server")
        return
    end

    if not module.Name then
        warn("⚠ | Attempted to register a client module without a name")
        return
    end

    table.insert(self.ClientModules, module)
end

function Registry:GetServerModule(name)
    if runService:IsClient() then 
        warn("⚠ | Attempted to get a server module on the client")
        return nil
    end

    local m = nil
    for _, module in ipairs(self.ServerModules) do
        if module.Name == name then
            m = module
        end
    end

    if m == nil then 
        return nil
    end

    if m.Accessible == false then 
        warn("⚠ | Attempted to get a server module '" .. name .. "' that is not accessible")
        return nil
    end

    return nil
end

function Registry:GetClientModule(name)
    if not runService:IsClient() then 
        warn("⚠ | Attempted to get a client module on the server")
        return nil
    end

    local m = nil
    for _, module in ipairs(self.ClientModules) do
        if module.Name == name then
            m = module
        end
    end

    if m == nil then 
        return nil
    end

    if m.Accessible == false then 
        warn("⚠ | Attempted to get a client module '" .. name .. "' that is not accessible")
        return nil
    end

    return nil
end

return Registry