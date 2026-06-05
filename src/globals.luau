local RMMZ = require('types/rmmz')

local Data = {
	Actors = nil :: {RMMZ.Actor}?;
	Classes = nil :: {RMMZ.Class}?;
	Skills = nil :: {RMMZ.Skill}?;
	Items = nil :: {RMMZ.Item}?;
	Weapons = nil :: {RMMZ.Weapon}?;
	Armors = nil :: {RMMZ.Armor}?;
	Enemies = nil :: {RMMZ.Enemy}?;
	Troops = nil :: {RMMZ.Troop}?;
	States = nil :: {RMMZ.State}?;
	Animations = nil :: {RMMZ.Animation}?;
	Tilesets = nil :: {RMMZ.Tileset}?;
	CommonEvents = nil :: {RMMZ.CommonEvent}?;
	System = nil :: RMMZ.System?;
	MapInfos = nil :: {RMMZ.MapInfo}?;
	Map = nil :: RMMZ.Map?;
}

local Game = {
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

local TestEvent = nil

return function()
	return Data, Game, TestEvent
end