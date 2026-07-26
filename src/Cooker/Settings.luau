--!strict
local Types = require(script.Parent.Types)
local Settings = {
	LOG_REGISTRY_CHANGES = false,
	MODULE_AWAIT_TIMEOUT = 10,
	REMOTE_AWAIT_TIMEOUT = 10,
}

function Settings.OverrideSettings(self: Types.Settings, newSettings: Types.SettingsValues)
	for k,v in newSettings do
		self[k] = v
	end
end

return Settings :: Types.Settings