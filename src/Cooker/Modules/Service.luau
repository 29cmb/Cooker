local Service = {}
Service.__index = Service
Service.prototype = {
    Name = "Service",
    ClientAccessible = true,
    ServerAccessible = true,
}
Service.values = {
    Remotes = {}
}
Service.Registry = require(script.Parent.Parent.Registry)

local util = require(script.Parent.Parent.Util.Misc)

function Service.new(data: any)
    data = util:Default(data, Service.prototype)
    for i,v in pairs(Service.values) do 
        data[i] = v
    end

    setmetatable(data, Service)

    return data
end

function Service:InitializeServer()
    warn("⚠ | Service:InitializeServer() is not implemented for service " .. self.Name)
end

function Service:InitializeClient()
    warn("⚠ | Service:InitializeClient() is not implemented for service " .. self.Name)
end

return Service