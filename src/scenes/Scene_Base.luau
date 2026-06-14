local Stage = require("../core/Stage")

local C = require('../types/core')
local Scn = require("../types/scenes")


local Scene_Base = setmetatable({}, Stage)

Scene_Base.__index = Scene_Base
Scene_Base.Super = Stage

Scene_Base.ClassName = 'Scene_Base'

function Scene_Base.new(): Scn.Base
	local stage: C.Stage = Stage.new()
	local self = setmetatable(stage, Scene_Base)

	self._started = false
	self._active = false
	self._fadeSign = 0
	self._fadeDuration = 0
	self._fadeWhite = 0
	self._fadeOpacity = 0
	-- TODO: CreateColorFilter()

	return self
end

--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

function Scene_Base.Create(self: Scn.Base)
	--
end

function Scene_Base.IsActive(self: Scn.Base): boolean
	return self._active
end

function Scene_Base.Start(self: Scn.Base)
	self._started = true
	self._active = true
end

function Scene_Base.Update(self: Scn.Base)
	self:UpdateFade()
	-- TODO: UpdateColorFilter()
	self:UpdateChildren()
end

function Scene_Base.Stop(self: Scn.Base)
	self._active = false
end

function Scene_Base.Terminate(self: Scn.Base)
	--
end

function Scene_Base.IsReady(self: Scn.Base): boolean
	return true
end

function Scene_Base.IsStarted(self: Scn.Base): boolean
	return self._started
end

--- Simply returns if the scene is fading.
function Scene_Base.IsBusy(self: Scn.Base): boolean
	return self:IsFading()
end

--- Returns true if the fade duration time isn't up yet.
function Scene_Base.IsFading(self: Scn.Base): boolean
	return self._fadeDuration > 0
end

function Scene_Base.UpdateFade(self: Scn.Base)
	if self._fadeDuration <= 0 then return end

	local d = self._fadeDuration
	if self._fadeSign > 0 then
		self._fadeOpacity -= self._fadeOpacity / d
	else
		self._fadeOpacity += (1.0 - self._fadeOpacity) / d
	end
	self._fadeDuration -= 1
end

function Scene_Base.UpdateChildren(self: Scn.Base)
	for _, child in self.Children do
		if child.Update then
			child:Update()
		end
	end
end


return Scene_Base