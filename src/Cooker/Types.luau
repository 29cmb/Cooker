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
    NewRemote: (self: ServerModule, path: string, scope: any?, callback: ((scope: any, ...any) -> any)?) -> (BaseRemoteEvent, RBXScriptConnection | {Disconnect: () -> nil}),
    GetModuleRemotes: (self: ServerModule, name: string) -> RemoteReturn?,
    Registry: Registry,
}

export type ReturnedClientModule = ClientModule & ClientModuleData

export type ClientModuleData = {
    Name: string,
    Accessible: boolean
}

export type ClientModule = {
    new: (any) -> ReturnedClientModule,
    Initialize: (self: ClientModule) -> any,
    GetModuleRemotes: (self: ClientModule, name: string) -> RemoteReturn?,
    Registry: Registry
}

export type Service = {
    new: (any) -> any,
    InitializeServer: (self: Service) -> any,
    InitializeClient: (self: Service) -> any,
    Registry: Registry
}

export type ServiceData = {
    Name: string,
    ServerAccessible: boolean,
    ClientAccessible: boolean
}

export type ReturnedService = Service & ServiceData

export type Registry = {
    RegisterServerModule: (self: Registry, module: ReturnedServerModule) -> any,
    RegisterClientModule: (self: Registry, module: any) -> any,
    GetServerModule: (self: Registry, name: string) -> ReturnedServerModule,
    GetClientModule: (self: Registry, name: string) -> ReturnedClientModule,
    GetServerRemotes: (self: Registry, moduleName: string) -> RemoteReturn?,
    GetClientRemotes: (self: Registry, moduleName: string) -> RemoteReturn?,
    AwaitServerLoad: (self: Registry, moduleName: string) -> ReturnedServerModule?,
    AwaitClientLoad: (self: Registry, moduleName: string) -> ReturnedClientModule?,
    AwaitServerLoadAsync: (self: Registry, moduleName: string, callback: (module: ReturnedServerModule?) -> any) -> nil,
    AwaitClientLoadAsync: (self: Registry, moduleName: string, callback: (module: ReturnedClientModule?) -> any) -> nil,
    RegisterServiceServer: (self: Registry, service: ReturnedService) -> any,
    RegisterServiceClient: (self: Registry, service: ReturnedService) -> any,
    GetService: (self: Registry, name: string) -> ReturnedService,
}

export type AllRemotes = RemoteEvent | RemoteFunction | BindableEvent | BindableFunction | UnreliableRemoteEvent

export type RemoteReturn = {
    [string]: AllRemotes
}

return {}