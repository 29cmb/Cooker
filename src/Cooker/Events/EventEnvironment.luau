--!strict
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local EventEnvironment = {
    environment = "shared",
    check = function() return false end,
    handlers = {}
}
EventEnvironment.__index = EventEnvironment

local Types = require(script.Parent.Parent.Types)

function EventEnvironment.new(data: Types.EventEnvironmentData)
	local envData = setmetatable(data, EventEnvironment)
    return envData
end

function EventEnvironment.RegisterListener(self: Types.EventEnvironment, event: string, onEvent: (...any) -> any, source: string): Types.EventListener
    if not self.check() then error("❌ | Attempted to register an event listener in an incorrect environment") end
    if not self.handlers[event] then self.handlers[event] = {} end

    local environment: "client" | "server" = if self.environment == "shared" then 
        if RunService:IsClient() then "client" else "server"
    else self.environment

    local listener: Types.EventListener = {
        id = HttpService:GenerateGUID(false),
        event = event,
        onEvent = onEvent,
        source = source,
        environment = environment
    }

    table.insert(self.handlers[event], listener)
    return listener
end

function EventEnvironment.UnregisterListener(self: Types.EventEnvironment, listener: Types.EventListener)
    local item = table.find(self.handlers[listener.event], listener)
    if not item then return warn("⚠️ | Attempted to unregister a listener that is not currently registered") end

    table.remove(self.handlers[listener.event], item)
end

function EventEnvironment.Call(self: Types.EventEnvironment, event: string, ...: any)
    if self.handlers[event] then
        for _, handler in self.handlers[event] do
            handler.onEvent(...)
        end
    end
end

return EventEnvironment :: Types.EventEnvironmentClass