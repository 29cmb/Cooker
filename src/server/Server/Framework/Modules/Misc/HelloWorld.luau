--!strict
local Cooker = require(game.ReplicatedStorage.Cooker)
local Module = Cooker.ServerModule.new({
    Name = "HelloWorld",
    Accessible = true
})

function Module:Initialize()
    print("Hello, world!")
    
    return true
end

return Module