local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cooker = require(ReplicatedStorage.Cooker)

local module = Cooker.ServerModule.new({
    Name = "WeaponsHandler", -- An internal name for referencing this module using Cooker.Registry#AwaitServerLoad
    Accessible = true -- Can this module be accessed through the registry?
})

local HITBOX_SIZE = Vector3.new(2, 5, 2)

function module:Initialize()
    -- Get the hitbox handler module from the registry
    local HitboxHandler = Cooker.Registry:AwaitServerLoad("HitboxHandler") -- Name here must match the Name field, not the script name!

    -- It is VERY IMPORTANT that a spawn is used here because otherwise, this module will never finish loading
    -- That means anything that wants to reference this module will not be able to unless the loop breaks
    task.spawn(function()
        -- Spawn a hitbox on every player every 3 seconds
        while task.wait(3) do
            for _,player in pairs(Players:GetPlayers()) do
                local char = player.Character
                if not char then continue end

                -- Get their root part
                local root = char:FindFirstChild("HumanoidRootPart")
                if not root then continue end
                
                -- Use a method from the other module to abstract the code a bit
                HitboxHandler:CreateHitbox(root.Position, HITBOX_SIZE)
            end
        end
    end)

    return true -- Return true to make the server loader recognize a successful initialization
end

return module