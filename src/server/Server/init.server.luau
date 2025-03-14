--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Cooker.Types)
local Cooker = require(game.ReplicatedStorage.Cooker)
Cooker:Initialize()

local Framework = script.Framework
local Modules = Framework.Modules

local successful = 0
local failed = 0

local requiredLoads = 0
local loaded = 0

for _, modules in pairs(Modules:GetChildren()) do
	if not modules:IsA("ModuleScript") then continue end
    requiredLoads += 1
end


local gameStartTime = time()
for _, module in pairs(Modules:GetChildren()) do
	if not module:IsA("ModuleScript") then continue end
    module = require(module) :: Types.ServerModule

    task.spawn(function()
        xpcall(function()
            local startTime = time()	
            Cooker.Registry:RegisterServerModule(module)

            print(`✅ | {module.Name} finished initializing in {math.round((time() - startTime) * 1000)}ms`)
            successful += 1
        end, function(err)
            warn(debug.traceback(`❌ | {module.Name} failed to initialize: {err}`))
            failed += 1
        end)
        
        loaded += 1
    end)
end

repeat task.wait() until loaded >= requiredLoads
print(`🍳 | All server modules finished initializing in {math.round((time() - gameStartTime) * 1000)}ms (✅{successful}, ❌{failed})`)