--!strict
local Cooker = require(game.ReplicatedStorage.Cooker)
local Module = Cooker.ClientModule.new({
    Name = "HelloWorld",
    Accessible = true
})

function Module:Initialize()
    print("Hello, world!")
    return nil
end

return Module