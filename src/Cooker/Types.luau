export type ServerModuleSettings = {
	ReadOnly: boolean,
}

export type Settings = {
	LOG_REGISTRY_CHANGES: boolean,
	MODULE_AWAIT_TIMEOUT: number,
	REMOTE_AWAIT_TIMEOUT: number
}

export type ServerModuleData = {
	Name: string,
	Accessible: boolean,
	Remotes: RemoteReturn,
}

export type ServerModule = ServerModuleData & ServerModuleClass

export type ServerModuleClass = {
	__index: ServerModuleClass,
	Registry: Registry,

	new: (data: ServerModuleData) -> 
		typeof(setmetatable({} :: ServerModuleData, {} :: ServerModule)),
	Initialize: (self: ServerModule) -> any,

	NewRemote: (
		self: ServerModule,
		path: string,
		scope: any?,
		callback: ((scope: any, ...any) -> any)?
	) -> (AllRemotes, (RBXScriptConnection | { Disconnect: () -> nil })?),
	GetModuleRemotes: (self: ServerModule, name: string) -> RemoteReturn?,
}

export type ClientModuleData = {
	Name: string,
	Accessible: boolean,
}

export type ClientModule = ClientModuleData & ClientModuleClass

export type ClientModuleClass = {
	__index: ClientModuleClass,
	Registry: Registry,
	new: (data: ClientModuleData) -> typeof(setmetatable({} :: ClientModuleData, {} :: ClientModule)),
	Initialize: (self: ClientModule) -> any,
}

export type Registry = {
	ServerModules: {[string]: ServerModule},
	ClientModules: {[string]: ClientModule},

	RegisterServerModule: (self: Registry, module: ServerModule) -> any,
	RegisterClientModule: (self: Registry, module: ClientModule) -> any,
	
	GetServerModule: (self: Registry, name: string) -> ServerModule?,
	GetClientModule: (self: Registry, name: string) -> ClientModule?,

	GetServerRemotes: (self: Registry, moduleName: string) -> RemoteReturn?,
	AwaitServerLoad: (self: Registry, moduleName: string) -> ServerModule?,
	AwaitClientLoad: (self: Registry, moduleName: string) -> ClientModule?,
	AwaitServerLoadAsync: (self: Registry, moduleName: string, callback: (module: ServerModule?) -> any) -> nil,
	AwaitClientLoadAsync: (self: Registry, moduleName: string, callback: (module: ClientModule?) -> any) -> nil,
}

export type AllRemotes = RemoteEvent | RemoteFunction | BindableEvent | BindableFunction | UnreliableRemoteEvent

export type RemoteReturn = {
	[string]: AllRemotes,
}

return {}
