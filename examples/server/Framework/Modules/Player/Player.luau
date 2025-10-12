local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cooker = require(ReplicatedStorage.Cooker)

local module = Cooker.ServerModule.new({
    Name = "Player", -- An internal name for referencing this module using Cooker.Registry#AwaitServerLoad
    Accessible = false -- Can this module be accessed through the registry?
})

function module:Initialize()
    -- Create a remote to spawn a part at a certain position
    -- (this is insecure don't do this in production :P)

    self:NewRemote(
        "Player.CreatePart[RemoteEvent]", -- The path of the remote. This one will be placed in ReplicatedStorage.Remotes.Player.CreatePart
        self, -- The scope of the callback function (for the ability to use self calls in :Function notation)
        self.CreatePart -- The method to call (passes in the scope as the first argument)
    )

    return true -- Return true to make the server loader recognize a successful initialization
end

function module:CreatePart(player, position, size)
    local part = Instance.new("Part")
    part.Parent = workspace
    part.Position = position
    part.Name = player.Name .. "'s Part"
    part.Size = size
end

return module