local JsonSerializer =  require('../core/JsonSerializer')
local Util = require('../core/Util')
local Data, Game, TestEvent = require('../globals')()

local RMMZ = require('../types/rmmz')
local M = require('../types/managers')
type DM = M.DataManager


local DataManager = {} :: DM

local _globalInfo: {RMMZ.Global}
local _errors: {string} = {}

local _databaseFiles = {
	'Actors',
	'Classes',
	'Skills',
	'Items',
	'Weapons',
	'Armors',
	'Enemies',
	'Troops',
	'States',
	'Animations',
	'Tilesets',
	'CommonEvents',
	'System',
	'MapInfos'
}

function DataManager.LoadDatabase(self: DM)
	print('Loading database...')
	local test = self.isBattleTest() or self.isEventTest()
	local prefix = if test then 'Test_' else ''
	for _, file in _databaseFiles do
		Data[file] = self.loadDataFile(`{prefix}{file}`)
	end
	if self.isEventTest() then
		local tE: typeof(TestEvent) = self.loadDataFile(`{prefix}Event`)
		table.clear(TestEvent)
		for i, e in tE do
			TestEvent[i] = e
		end
	end
end

function DataManager.loadDataFile<T>(fileName: string): T
	print(`Loading {fileName}.json...`)
	
	local file = love.filesystem.read(`assets/data/{fileName}.json`)

	if not file then
		error(`LoadError: Failed to load {fileName}.`)
	end
	
	local data = JsonSerializer.parse(file) :: T
	-- If it's an array and index 1 is empty, but index 2 has data (The RMMZ offset)
	if type(data) == "table" and data[1] == nil and data[2] ~= nil then
		local shifted = {}
		-- Find the true maximum key using pairs since #data is untrustworthy here
		local maxKey = 0
		for k in pairs(data) do
			if type(k) == "number" and k > maxKey then maxKey = k end
		end
		
		-- Shift everything down by 1
		for i = 2, maxKey do
			shifted[i - 1] = data[i]
		end
		data = shifted
	end

	return data
end

function DataManager.isDatabaseLoaded(): boolean
	for _, file in _databaseFiles do
		if Data[file] == nil then
			return false
		end
	end
	return true
end

function DataManager.LoadGlobalInfo(self: DM)

end

function DataManager.isBattleTest(): boolean
	return Util.isOptionValid('btest')
end

function DataManager.isEventTest(): boolean
	return Util.isOptionValid('etest')
end

function DataManager.isTitleSkip(): boolean
	return Util.isOptionValid('tskip')
end


return DataManager