local Framework = script.Framework
local Modules = Framework.Modules
local Cooker = require(script.Parent.Cooker)

-- Module loading
local successful = 0
local warning = 0
local failed = 0

local requiredLoads = 0
local loaded = 0
local modules = {}

-- Add all the subcategories to a modules list
for _, category in pairs(Modules:GetChildren()) do
	if not category:IsA("Folder") then continue end

	for _, m in pairs(category:GetChildren()) do
		if not m:IsA("ModuleScript") then continue end
		requiredLoads += 1
		table.insert(modules, m)
	end
end

local gameStartTime = time()
for _, m in pairs(modules) do
	if not m:IsA("ModuleScript") then continue end
	task.spawn(function()
		local module = require(m)
        
		xpcall(function()
            -- Record the starting time of the load
			local startTime = time()

            -- Register the module into the cooker registry
			local response = Cooker.Registry:RegisterClientModule(module)
            
			if response == true then
                -- Success! Increase successful loads to display when all of them finish
				print(`✅ | {module.Name} finished initializing in {math.round((time() - startTime) * 1000)}ms`)
				successful += 1
			else
                -- If the module doesn't error, but also doesn't return true, it sends what it did return as a warning
                -- A common mistake is not returning anything which will also trigger this message with the warning `nil`
				warn(`⚠️ | {module.Name} ({m.Name}) finished initializing with warnings in {math.round((time() - startTime) * 1000)}ms\n{response}`)
				warning += 1
			end
		end, function(err)
            -- Sends the error as well as the stack trace
			warn(debug.traceback(`❌ | {module.Name} failed to initialize: {err}`))
			failed += 1
		end)
        
		loaded += 1
	end)
end

-- Wait for all the spawned tasks to start their modules
repeat
	task.wait()
until loaded >= requiredLoads

-- Record how long it took to initialize all the modules
print(`🍳 | All client modules finished initializing in {math.round((time() - gameStartTime) * 1000)}ms (✅{successful}, ⚠{warning}, ❌{failed})`)
