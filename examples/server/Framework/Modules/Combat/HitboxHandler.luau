local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cooker = require(ReplicatedStorage.Cooker)

local module = Cooker.ServerModule.new({
    Name = "HitboxHandler", -- An internal name for referencing this module using Cooker.Registry#AwaitServerLoad
    Accessible = true -- Allow this module to be accessed so we can reference it in the WeaponsHandler
})

local function CreateHitbox(position: Vector3, size: Vector3)
    local hitbox = Instance.new("Part")
    hitbox.Position = position
    hitbox.Size = size
    hitbox.Anchored = true
    hitbox.Transparency = 0.8
    hitbox.Color = Color3.fromRGB(255, 0, 0)
    hitbox.CanCollide = false
    hitbox.Parent = workspace
end

function module:Initialize()
    self:RegisterEventListener("create_hitbox", function(position: Vector3, size: Vector3)
        CreateHitbox(position, size)
    end)

    return true -- This module on its own doesn't have any functionality, so we can simply return true
end

return module