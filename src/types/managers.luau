local RMMZ = require('./rmmz')

local Managers = {}

export type DataManager = {
	_globalInfo: {RMMZ.Global};

	LoadDatabase: (DataManager) -> ();
	loadDataFile: <T>(string) -> T;
	isDatabaseLoaded: () -> boolean;
	isBattleTest: () -> boolean;
	isEventTest: () -> boolean;
	isTitleSkip: () -> boolean;
}

return Managers