export type ServerModuleSettings = {
    ReadOnly: boolean
}

export type Settings = {
    LOG_REGISTRY_CHANGES: boolean,
    MODULE_AWAIT_TIMEOUT: number
}

export type ReturnedServerModule = ServerModule & ServerModuleData

export type ServerModuleData = {
    Name: string,
    Accessible: boolean,
    Remotes: RemoteReturn,
}

export type ServerModule = {
    new: (any) -> ReturnedServerModule,
    Initialize: (self: ServerModule) -> any?,
    NewRemote: (self: ServerModule, path: string) -> BaseRemoteEvent,
    GetModuleRemotes: (self: ServerModule, name: string) -> RemoteReturn?
}

export type ReturnedClientModule = ClientModule & ClientModuleData

export type ClientModuleData = {
    Name: string,
    Accessible: boolean
}

export type ClientModule = {
    new: (any) -> ReturnedClientModule,
    Initialize: (self: ClientModule) -> any,
    GetModuleRemotes: (self: ClientModule, name: string) -> RemoteReturn?
}

export type Registry = {
    RegisterServerModule: (self: Registry, module: ReturnedServerModule) -> nil,
    RegisterClientModule: (self: Registry, module: any) -> nil,
    GetServerModule: (self: Registry, name: string) -> ReturnedServerModule,
    GetClientModule: (self: Registry, name: string) -> ReturnedClientModule,
    GetServerRemotes: (self: Registry, moduleName: string) -> RemoteReturn?,
    GetClientRemotes: (self: Registry, moduleName: string) -> RemoteReturn?,
    AwaitServerLoad: (self: Registry, moduleName: string) -> nil,
    AwaitClientLoad: (self: Registry, moduleName: string) -> nil,
}

export type RemoteReturn = {
    [string]: RemoteEvent | RemoteFunction | BindableEvent | BindableFunction
}

return {}