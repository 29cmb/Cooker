--!strict
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