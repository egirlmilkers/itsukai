local DataManager = require("../managers/DataManager")
local Scene_Base = require('./Scene_Base')

local Scn = require("../types/scenes")


local Scene_Boot = setmetatable({}, Scene_Base)

Scene_Boot.__index = Scene_Boot
Scene_Boot.Super = Scene_Base


Scene_Boot.ClassName = 'Scene_Boot'

function Scene_Boot.new()
	local sceneBase = Scene_Base.new()
	local self = setmetatable(sceneBase, Scene_Boot)
	
	self._databaseLoaded = false

	return self
end


function Scene_Boot.StartNormalGame(self: Scn.Boot)
	self.checkPlayerLocation()
	DataManager.setupNewGame()
	
end

--[[=======================
--- OVERRIDDEN FUNCTIONS --
=======================]]--

function Scene_Boot.Create(self: Scn.Boot)
	Scene_Base.Create(self)
	DataManager:LoadDatabase()
end

-- function Scene_Boot.IsActive(self: Scn.Boot): boolean

function Scene_Boot.Start(self: Scn.Boot)
	Scene_Base.Start(self)
	if DataManager.isBattleTest() then
		-- todo
	elseif DataManager.isEventTest() then
		-- todo
	elseif DataManager.isTitleSkip() then
		-- todo
	else
		
	end
end

function Scene_Boot.Update(self: Scn.Boot)
	self:UpdateFade()
	-- TODO: UpdateColorFilter()
	self:UpdateChildren()
end

-- function Scene_Boot.Stop(self: Scn.Boot)

-- function Scene_Boot.Terminate(self: Scn.Boot)

function Scene_Boot.IsReady(self: Scn.Boot): boolean
	if not self._databaseLoaded then
		if DataManager.isDatabaseLoaded() then
			self._databaseLoaded = true
		end
		return false
	end
	return Scene_Base.IsReady(self)
end

-- function Scene_Boot.IsStarted(self: Scn.Boot): boolean

-- function Scene_Boot.IsBusy(self: Scn.Boot): boolean

-- function Scene_Boot.IsFading(self: Scn.Boot): boolean

-- function Scene_Boot.UpdateFade(self: Scn.Boot)

-- function Scene_Boot.UpdateChildren(self: Scn.Boot)


return Scene_Boot