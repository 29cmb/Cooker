--!strict
local RunService = game:GetService("RunService")
local Types = require(script.Parent.Parent.Types)
local Remotes = {}

function Remotes:NewRemote(creationString, scope: any?, callback: ((scope: any, ...any) -> any)?): (Types.AllRemotes?, RBXScriptConnection?)
    if not RunService:IsServer() then return end

    local validTypes = {
        ["RemoteEvent"] = function(remote: RemoteEvent)
            return remote.OnServerEvent:Connect(function(...)
                if callback then
                    if scope then
                        callback(scope, ...)
                    else
                        callback(...)
                    end
                end
            end)
        end,
        ["RemoteFunction"] = function(remote: RemoteFunction)
            -- if you're looking for a way to disconnect these (doubt you'd need to), just assign the OnInvoke to nil on the same event
            -- (or set it to an empty function if you want it to be a little less destructive)

            remote.OnServerInvoke = function(...) 
                if callback then
                    if scope then
                        callback(scope, ...)
                    else
                        callback(...)
                    end
                end
            end

            return {
                Disconnect = function()
                    remote.OnServerInvoke = function()end
                end,
            }
        end,
        ["BindableEvent"] = function(remote: BindableEvent)
            return remote.Event:Connect(function(...)
                if callback then
                    if scope then
                        callback(scope, ...)
                    else
                        callback(...)
                    end
                end
            end) 
        end,
        ["BindableFunction"] = function(remote: BindableFunction)
            -- if you're looking for a way to disconnect these (doubt you'd need to), just assign the OnInvoke to nil on the same event
            -- (or set it to an empty function if you want it to be a little less destructive)

            remote.OnInvoke = function(...)
                if callback then
                    if scope then
                        callback(scope, ...)
                    else
                        callback(...)
                    end
                end
            end

            return {
                Disconnect = function()
                    remote.OnInvoke = function()end
                end,
            }
        end,
        ["UnreliableRemoteEvent"] = function(remote: UnreliableRemoteEvent)
            return remote.OnServerEvent:Connect(function(...)
                if callback then
                    if scope then
                        callback(scope, ...)
                    else
                        callback(...)
                    end
                end
            end)
        end
    }

    local remotes = game.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then 
        remotes = Instance.new("Folder")
        remotes.Name = "Remotes"
        remotes.Parent = game.ReplicatedStorage
    end

    local finalRemote: Types.AllRemotes = nil

    if string.find(creationString, "%.") then
        local structure = string.split(creationString, ".")
        local remoteType = string.match(structure[#structure], "%[(.-)%]") or "RemoteEvent"
        structure[#structure] = string.gsub(structure[#structure], "%[.-%]", "")

        if not validTypes[remoteType] then
            warn("⚠️ | " .. remoteType .. " is not a valid remote type!")
            return
        end

        local parent = remotes
        for i, name in ipairs(structure) do
            local existing = parent:FindFirstChild(name)
            if not existing then
                if i == #structure then
                    existing = Instance.new(remoteType)
                    existing.Parent = parent
                    finalRemote = existing
                else
                    existing = Instance.new("Folder")
                    existing.Parent = parent
                end
                existing.Name = name
            end
            parent = existing
        end
    else
        local remoteType = string.match(creationString, "%[(.-)%]") or "RemoteEvent"
        local remote = Instance.new(remoteType) :: Instance & Types.AllRemotes
        remote.Name = string.gsub(creationString, "%[.-%]", "")
        remote.Parent = remotes

        finalRemote = remote
    end

    if callback then
        local connection = validTypes[finalRemote.ClassName](finalRemote)
        return finalRemote, connection
    end

    return finalRemote
end

return Remotes