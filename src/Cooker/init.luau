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
    Last updated: 8/30/25

    https://github.com/29cmb/Cooker
]]

local Cooker = {}
Cooker.ServerModule = require(script.Modules.ServerModule)
Cooker.ClientModule = require(script.Modules.ClientModule)
Cooker.Registry = require(script.Registry)
Cooker.Remotes = require(script.Util.Remotes)
Cooker.Types = require(script.Types)

return Cooker
