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
    Last updated: 3/21/25

    https://github.com/29cmb/Cooker
]]

local Cooker = {}
Cooker.ServerModule = require(script.Modules.ServerModule)
Cooker.ClientModule = require(script.Modules.ClientModule)
Cooker.Registry = require(script.Registry)
Cooker.Remotes = require(script.Util.Remotes)
Cooker.Types = require(script.Types)

function Cooker:Initialize()
    local getServerModules: RemoteFunction = self.Remotes:NewRemote("Cooker.GetServerModuleRemotes[RemoteFunction]")
    getServerModules.OnServerInvoke = function(player, moduleName)
        local remotes = self.Registry:GetServerRemotes(moduleName)
        return remotes :: {
            [string]: RemoteEvent | RemoteFunction | BindableEvent | BindableFunction
        }?
    end
end

return Cooker