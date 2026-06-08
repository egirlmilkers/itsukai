local Scene_Base = require('Scene_Base')

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

--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

function Scene_Boot:Create()
	Scene_Base.Create(self)
end

function Scene_Boot:IsActive(): boolean
	return self._active
end

function Scene_Boot:Start()
	self._started = true
	self._active = true
end

function Scene_Boot:Update()
	self:UpdateFade()
	-- TODO: UpdateColorFilter()
	self:UpdateChildren()
end


return Scene_Boot