local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cooker = require(ReplicatedStorage.Cooker)

local module = Cooker.ServerModule.new({
    Name = "HitboxHandler", -- An internal name for referencing this module using Cooker.Registry#AwaitServerLoad
    Accessible = true -- Allow this module to be accessed so we can reference it in the WeaponsHandler
})

function module:Initialize()
    return true -- This module on its own doesn't have any functionality, so we can simply return true
end

function module:CreateHitbox(position: Vector3, size: Vector3)
    local hitbox = Instance.new("Part")
    hitbox.Position = position
    hitbox.Size = size
    hitbox.Anchored = true
    hitbox.Transparency = 0.8
    hitbox.Color = Color3.fromRGB(255, 0, 0)
    hitbox.CanCollide = false
    hitbox.Parent = workspace
end

return module