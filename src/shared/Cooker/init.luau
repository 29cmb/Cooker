--!strict
local Cooker = {}
Cooker.ServerModule = require(script.Modules.ServerModule)
Cooker.Registry = require(script.Registry)
Cooker.Remotes = require(script.Util.Remotes)
Cooker.Types = require(script.Types)

function Cooker:Initialize()
    local getServerModules: RemoteFunction = Cooker.Remotes:NewRemote("Cooker.GetServerModuleRemotes[RemoteFunction]")
    getServerModules.OnServerInvoke = function(player, moduleName)
        local remotes = Cooker.Registry:GetServerRemotes(moduleName)
        return remotes :: {
            [string]: RemoteEvent | RemoteFunction | BindableEvent | BindableFunction
        }?
    end
end

return Cooker