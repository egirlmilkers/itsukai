local Objects = {}

export type Temp = {
	new: () -> Temp
}

export type System = {
	new: () -> System
}

export type Screen = {
	new: () -> Screen
}

export type Timer = {
	new: () -> Timer
}

export type Message = {
	new: () -> Message
}

export type Switches = {
	new: () -> Switches
}

export type Variables = {
	new: () -> Variables
}

export type SelfSwitches = {
	new: () -> SelfSwitches
}

export type Actors = {
	new: () -> Actors
}

export type Party = {
	new: () -> Party
}

export type Troop = {
	new: () -> Troop
}

export type Map = {
	new: () -> Map
}

export type Player = {
	new: () -> Player
}

return Objects