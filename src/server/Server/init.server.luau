local Framework = script.Framework
local Modules = Framework.Modules
local Cooker = require(game.ReplicatedStorage.Cooker)
Cooker:Initialize()

local successful = 0
local warning = 0
local failed = 0

local requiredLoads = 0
local loaded = 0

for _, category in pairs(Modules:GetChildren()) do
	if not category:IsA("Folder") then continue end

	for _, m in pairs(category:GetChildren()) do
		if not m:IsA("ModuleScript") then continue end
		requiredLoads += 1
	end
end


local gameStartTime = time()
for _, category in pairs(Modules:GetChildren()) do
	if not category:IsA("Folder") then continue end
	
	for _, m in pairs(category:GetChildren()) do
		if not m:IsA("ModuleScript") then continue end
		task.spawn(function()
			local module = require(m)
			
			xpcall(function()
				local startTime = time()	
				local response = Cooker.Registry:RegisterServerModule(module)
				
				if response == true then
					print(`✅ | {module.Name} finished initializing in {math.round((time() - startTime) * 1000)}ms`)
					successful += 1
				else
					warn(`⚠️ | {module.Name} finished initializing with warnings in {math.round((time() - startTime) * 1000)}ms\n{response}`)
					warning += 1
				end
			end, function(err)
				warn(debug.traceback(`❌ | {module.Name} failed to initialize: {err}`))
				failed += 1
			end)
			
			loaded += 1
		end)
	end
end

repeat task.wait() until loaded >= requiredLoads
print(`🍳 | All server modules finished initializing in {math.round((time() - gameStartTime) * 1000)}ms (✅{successful}, ⚠{warning}, ❌{failed})`)