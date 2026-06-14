local RMMZ = require('./rmmz')
local O = require('./objects')

local Globals = {}

export type Data = {
	Actors: {RMMZ.Actor};
	Classes: {RMMZ.Class};
	Skills: {RMMZ.Skill};
	Items: {RMMZ.Item};
	Weapons: {RMMZ.Weapon};
	Armors: {RMMZ.Armor};
	Enemies: {RMMZ.Enemy};
	Troops: {RMMZ.Troop};
	States: {RMMZ.State};
	Animations: {RMMZ.Animation};
	Tilesets: {RMMZ.Tileset};
	CommonEvents: {RMMZ.CommonEvent};
	System: {RMMZ.System};
	MapInfos: {RMMZ.MapInfo};
	Map: RMMZ.Map;
}

export type Game = {
	Temp: O.Temp;
	System: O.System;
	Screen: O.Screen;
	Timer: O.Timer;
	Message: O.Message;
	Switches: O.Switches;
	Variables: O.Variables;
	SelfSwitches: O.SelfSwitches;
	Actors: O.Actors;
	Party: O.Party;
	Troop: O.Troop;
	Map: O.Map;
	Player: O.Player;
}

export type TestEvent = {RMMZ.EventCommand};

return Globals