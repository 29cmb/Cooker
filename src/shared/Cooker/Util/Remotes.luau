--!strict
local Remotes = {}

function Remotes:NewRemote(creationString)
    local remotes = game.ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then 
        remotes = Instance.new("Folder", game.ReplicatedStorage)
        remotes.Name = "Remotes"
    end

    local finalRemote = nil

    if string.find(creationString, "%.") then
        local structure = string.split(creationString, ".")
        local remoteType = string.match(structure[#structure], "%[(.-)%]") or "RemoteEvent"
        structure[#structure] = string.gsub(structure[#structure], "%[.-%]", "")

        local parent = remotes
        for i, name in ipairs(structure) do
            local existing = parent:FindFirstChild(name)
            if not existing then
                if i == #structure then
                    existing = Instance.new(remoteType, parent)
                    finalRemote = existing
                else
                    existing = Instance.new("Folder", parent)
                end
                existing.Name = name
            end
            parent = existing
        end
    else
        local remoteType = string.match(creationString, "%[(.-)%]") or "RemoteEvent"
        local remote = Instance.new(remoteType, remotes)
        remote.Name = string.gsub(creationString, "%[.-%]", "")
        finalRemote = remote
    end

    return finalRemote
end

return Remotes