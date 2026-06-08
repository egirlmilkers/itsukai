local Graphics = require('../core/Graphics')

local S = require('../types/scenes')


local SceneManager = {}

local _scene: S.Base? = nil
local _nextScene: S.Base? = nil
local _exiting = false
local _previousScene: S.Base? = nil
local _previousConstructor: () -> S.Base = nil

local _TICK_RATE = 1 / 60
local _accumulator = 0

--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

function SceneManager:Run(sceneClass)
	local success, error = pcall(function(...)
		self:Init()
		self.GoTo(sceneClass)
	end)

	-- true/false depending on if this protected call ran without error
	if not success then
		print(error)
	end
end

function SceneManager:Init(sceneClass)
	Graphics:Init()
	-- TODO: Input:Init()
end

function SceneManager:GoTo(scene: S.Base)
	if not scene:IsA('Scene_Base') or not nil then
		error('Error in SceneManager:GoTo(). Provided object is not a scene.')
	end

	if scene then
		_nextScene = scene.new()
	end

	if _scene then
		_scene:Stop()
	end
end

function SceneManager:Update(dt: number)
	-- Bank the time that has passed since the last frame
    _accumulator = _accumulator + dt
    
    -- Consume the banked time in discrete ticks
    while _accumulator >= _TICK_RATE do
        self:UpdateMain(dt)
        _accumulator = _accumulator - _TICK_RATE
    end
end

function SceneManager:UpdateMain(dt: number)
	Graphics.FrameCount += 1
	-- TODO: Input Update
	self:ChangeScene()
	self:UpdateScene(dt)
end

function SceneManager:ChangeScene()
	if not self.isSceneChanging() or self.isCurrentSceneBusy() then return end

	if _scene then
		_scene:Terminate()
		self.onSceneTerminate()
	end
	_scene = _nextScene
	_nextScene = nil
	if _scene then
		_scene:Create()
		self.onSceneCreate()
	end
	if _exiting then
		self.terminate()
	end
end

function SceneManager:UpdateScene(dt: number)
	if not _scene then return end

	if _scene:IsStarted() then
		if self.isGameActive() then
			_scene:Update(dt)
		end
	else
		self.onBeforeSceneStart()
		_scene:Start()
		self.onSceneStart()
	end
end

function SceneManager.isGameActive(): boolean
	return love.window.hasFocus()
end

--- Returns true if the game is exiting or if there is a scene in queue.
function SceneManager.isSceneChanging(): boolean
	return _exiting or not not _nextScene
end

--- Returns true if the current scene is reporting that it is busy.
function SceneManager.isCurrentSceneBusy(): boolean
	return _scene and _scene:IsBusy()
end

function SceneManager.onSceneTerminate()
	if not _scene then return end

	_previousScene = _scene
	_previousConstructor = _scene.new
	Graphics.Stage = nil
end

function SceneManager.onSceneCreate()
	Graphics.Loading = true
end

function SceneManager.onBeforeSceneStart()
	if not _previousScene then return end

	_previousScene:Destroy()
	_previousScene = nil
end

function SceneManager.onStageStart()
	Graphics.Loading = false
	Graphics.Stage = _scene
end

function SceneManager.terminate()
	love.event.quit()
end


--[[=======================
---- PRIVATE FUNCTIONS ----
=======================]]--

function _tbd()

end


return SceneManager