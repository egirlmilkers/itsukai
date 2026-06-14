local G = require('types/globals')

local Data: G.Data = {
	Actors = nil;
	Classes = nil;
	Skills = nil;
	Items = nil;
	Weapons = nil;
	Armors = nil;
	Enemies = nil;
	Troops = nil;
	States = nil;
	Animations = nil;
	Tilesets = nil;
	CommonEvents = nil;
	System = nil;
	MapInfos = nil;
	Map = nil;
}

local Game: G.Game = {
	Temp = nil;
	System = nil;
	Screen = nil;
	Timer = nil;
	Message = nil;
	Switches = nil;
	Variables = nil;
	SelfSwitches = nil;
	Actors = nil;
	Party = nil;
	Troop = nil;
	Map = nil;
	Player = nil;
}

local TestEvent: G.TestEvent = nil

return function()
	return Data, Game, TestEvent
end