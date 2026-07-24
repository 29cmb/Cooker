--!strict
--[[
    _________                __                 
    \_   ___ \  ____   ____ |  | __ ___________ 
    /    \  \/ /  _ \ /  _ \|  |/ // __ \_  __ \
    \     \___(  <_> |  <_> )    <\  ___/|  | \/
     \______  /\____/ \____/|__|_ \\___  >__|   
            \/                   \/    \/       
    
    A roblox module for making game frameworks with ease.
    Made by DevCmb (@29ce)

    Created: 3/14/25
    Last updated: 7/24/26

    https://github.com/29cmb/Cooker
]]

-- local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- if not ReplicatedStorage:FindFirstChild("CookerSharedEventBus") then
--     local remote = Instance.new("RemoteEvent")
--     remote.Name = "CookerSharedEventBus"
--     remote.Parent = ReplicatedStorage
-- end

return {
    ServerModule = require(script.Modules.ServerModule),
    ClientModule = require(script.Modules.ClientModule),
    Registry = require(script.Registry),
    Remotes = require(script.Util.Remotes),

    EventEnvironments = require(script.Events.Environments)
}
