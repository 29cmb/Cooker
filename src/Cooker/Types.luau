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
}

export type ServerModule = typeof(setmetatable({} :: ServerModuleData, {} :: ServerModuleClass ))

export type ServerModuleClass = {
	__index: ServerModuleClass,
	Registry: Registry,
	Remotes: RemoteReturn,

	new: (data: ServerModuleData) -> 
		ServerModule,
	Initialize: (self: ServerModule) -> any,

	NewRemote: (
		self: ServerModule,
		path: string,
		scope: any?,
		callback: ((scope: any, ...any) -> any)?
	) -> (AllRemotes, (RBXScriptConnection | { Disconnect: () -> nil })?),
	GetModuleRemotes: (self: ServerModule, name: string) -> RemoteReturn?,

	RegisterEventListener: (self: ServerModule, event: string, onEvent: (...any) -> nil) -> EventListener,
	UnregisterEventListener: (self: ServerModule, listener: EventListener) -> nil,
	CallEvent: (self: ServerModule, event: string, ...any) -> nil
}

export type ClientModuleData = {
	Name: string,
	Accessible: boolean,
}

export type ClientModule = typeof(setmetatable({} :: ClientModuleData, {} :: ClientModuleClass ))

export type ClientModuleClass = {
	__index: ClientModuleClass,
	Registry: Registry,
	new: (data: ClientModuleData) -> ClientModule,
	Initialize: (self: ClientModule) -> any,
	
	RegisterEventListener: (self: ClientModule, event: string, onEvent: (...any) -> nil) -> EventListener,
	UnregisterEventListener: (self: ClientModule, listener: EventListener) -> nil,
	CallEvent: (self: ClientModule, event: string, ...any) -> nil
}

export type Registry = {
	ServerModules: {[string]: ServerModule?},
	ClientModules: {[string]: ClientModule?},

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

export type EventEnvironmentData = {
	environment: "server" | "client" | "shared",
	check: () -> boolean
}

export type EventEnvironment = typeof(setmetatable({} :: EventEnvironmentData, {} :: EventEnvironmentClass))

export type EventEnvironmentClass = {
	__index: EventEnvironmentClass,
	handlers: {[string]: {EventListener}},

	new: (data: EventEnvironmentData) -> EventEnvironment,
	RegisterListener: (self: EventEnvironment, event: string, onEvent: (...any) -> any, source: string) -> EventListener,
	UnregisterListener: (self: EventEnvironment, listener: EventListener) -> nil,
	Call: (self: EventEnvironment, event: string, ...any) -> nil
}

export type EventListener = {
	id: string,
	event: string,
	environment: "server" | "client",
	onEvent: (...any) -> any,
	source: string
}

return {}
