local Graphics = {}

local _width = 0
local _height = 0
local _scale = 1
local _canvas = nil

Graphics.Width = _width
Graphics.Height = _height
Graphics.FrameCount = 0
Graphics.Stage = nil
Graphics.Loading = false

--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

function Graphics:Init()
	_width = 0
	_height = 0
	_scale = 1
	_canvas = nil

	self.FrameCount = 0
	self.Width = _width
	self.Height = _height

	local mode = love.window.getMode()
	mode.resizable = false
	mode.vsync = 1
	love.window.setMode(
		Graphics.Width  * _scale,
		Graphics.Height * _scale,
		mode
	)
end

function Graphics:Update(dt: number)
	if self.Loading then
		love.graphics.print('Loading...')
	end
end


return Graphics