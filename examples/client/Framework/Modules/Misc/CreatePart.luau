local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Cooker = require(ReplicatedStorage.Cooker)

local module = Cooker.ClientModule.new({
    Name = "CreatePart", -- An internal name for referencing this module using Cooker.Registry#AwaitClientLoad
    Accessible = false -- Can this module be accessed through the registry?
})

-- Wait for the server to create the remote (timeout in settings, default 10)
local remote: RemoteEvent = Cooker.Remotes:AwaitRemote("Player.CreatePart[RemoteEvent]")

function module:Initialize()
    -- Detect user input
    UserInputService.InputBegan:Connect(function(object)
        -- Make sure its a mouse press
        if object.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouse = Players.LocalPlayer:GetMouse()

            -- Send the remote over to the server
            remote:FireServer(mouse.Hit.Position, Vector3.new(3,3,3))
        end
    end)

    return true
end

return module