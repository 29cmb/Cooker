local RunService = game:GetService("RunService")
local EventEnvironment = require(script.Parent.EventEnvironment)

return {
    ServerEvents = EventEnvironment.new({ 
        environment = "server",
        check = function() return RunService:IsServer() end 
    }),
    ClientEvents = EventEnvironment.new({ 
        environment = "client",
        check = function() return RunService:IsClient() end 
    }),
    -- SharedEvents = SharedEventsEnvironment
}