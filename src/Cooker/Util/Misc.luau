--!strict
local Util = {}

function Util:Default(data, prototype): any
	if typeof(prototype) ~= "table" then
		warn("⚠ | Prototype is not a valid table")
		return data or {}
	end

	if typeof(data) ~= "table" then
		data = {}
	end

	local newTable = {}
	local prototypes = (typeof(prototype[1]) == "table") and prototype or { prototype }

	for _, proto in ipairs(prototypes) do
		for key, value in pairs(proto) do
			if typeof(value) == "table" then
				if data[key] == nil then
					data[key] = table.clone(value)
				else
					data[key] = self:Default(data[key], value)
				end
			else
				data[key] = data[key] or value
			end
		end
	end

	newTable = table.clone(data)
	return newTable
end

return Util
