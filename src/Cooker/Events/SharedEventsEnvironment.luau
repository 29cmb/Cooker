local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Types = require(ReplicatedStorage.Cooker.Types)
local EventEnvironment = require(script.Parent.EventEnvironment)

local SharedEventsEnvironment = EventEnvironment.new({
    environment = "shared",
    check = function() return true end,
})

local eventBus: RemoteEvent = ReplicatedStorage:FindFirstChild("CookerSharedEventBus")
local currentEnvironment = if RunService:IsClient() then "client" else "server"

if currentEnvironment == "client" then
    eventBus.OnClientEvent:Connect(function(event, ...)
        local handlers = SharedEventsEnvironment.handlers[event]
        if handlers == nil then return end

        for _, handler in handlers do
            handler.onEvent(...)
        end
    end)
else
    eventBus.OnServerEvent:Connect(function(player, event, ...)
        local handlers = SharedEventsEnvironment.handlers[event]
        if handlers == nil then return end

        for _, handler in handlers do
            handler.onEvent(player, ...)
        end
    end)
end

function SharedEventsEnvironment.Call(self: Types.EventEnvironment, event: string, ...: any)
    EventEnvironment.Call(self, event, ...)

    if not eventBus then error("CookerSharedEventBus not found in ReplicatedStorage") end

    if currentEnvironment == "client" then
        eventBus:FireServer(event, ...)
    else
        eventBus:FireAllClients(event, ...)
    end
end

return SharedEventsEnvironment