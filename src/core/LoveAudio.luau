local Object = require('Object')
local Ext = require('Ext')

local LoveAudio = setmetatable({}, Object)

LoveAudio.__index = LoveAudio
LoveAudio.Super = Object

export type LoveAudio = {
	_path: string;
	Path: string;
	_volume: number;
	Volume: number;
	_pitch: number;
	Pitch: number;
	_pan: number;
	Pan: number;

	_source: Source;
	_stopListeners: {() -> ()};
	_isError: boolean;
	_fadeTarget: number;
	_fadeFrom: number;
	_fadeDuration: number;
	_fadeElapsed: number;

	new: (string, boolean?) -> LoveAudio;
	IsReady: (LoveAudio) -> boolean;
	IsError: (LoveAudio) -> boolean;
	IsPlaying: (LoveAudio) -> boolean;
	Play: (LoveAudio, boolean?, number?) -> ();
	Stop: (LoveAudio) -> ();
	Pause: (LoveAudio) -> ();
	Destroy: (LoveAudio) -> ();
	FadeIn: (LoveAudio, number) -> ();
	FadeOut: (LoveAudio, number) -> ();
	Clear: (LoveAudio) -> ();
	Update: (LoveAudio, number) -> ();
	Seek: (LoveAudio) -> number;
	AddStopListener: (LoveAudio, ()->()) -> ();

	_load: (LoveAudio, boolean?) -> ()
}

function LoveAudio.new(path: string, stream: boolean?): LoveAudio
	local object = Object.new()
	local self = setmetatable(object, LoveAudio)

	self:Clear()
	self._path = path
	self:_load(stream)

	return self
end


--[[=======================
-------- Properties -------
=======================]]--

Ext.DefineProperty(LoveAudio, "Path", {
	--- The path of the audio file.
	get = function(self)
		return self._path
	end,
})

Ext.DefineProperty(LoveAudio, "Volume", {
	--- The volume of the audio.
	get = function(self)
		return self._volume
	end,
	--- The volume of the audio.
	set = function(self, value)
		self._volume = value
		if self._source then
			self._source:setVolume(value)
		end
	end,
})

Ext.DefineProperty(LoveAudio, "Pitch", {
	--- The pitch of the audio.
	get = function(self)
		return self._pitch
	end,
	--- The pitch of the audio.
	set = function(self, value)
		self._pitch = value
		if self._source then
			self._source:setPitch(value)
		end
	end,
})

Ext.DefineProperty(LoveAudio, "Pan", {
	--- The pan of the audio.
	get = function(self)
		return self._pan
	end,
	--- The pan of the audio.
	set = function(self, value)
		self._pan = value
		if self._source then
			-- Place the source left/right while keeping it close to the listener
			self._source:setPosition(value, 0, -1)
			self._source:setRelative(true)
		end
	end,
})


--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

--- Returns true if the source is ready.
function LoveAudio:IsReady(): boolean
	return self._source ~= nil and not self._isError
end

--- Returns true if the source errored.
function LoveAudio:IsError(): boolean
	return self._isError
end

--- Returns true if the source is currently playing.
function LoveAudio:IsPlaying(): boolean
	return self._source ~= nil and self._source:isPlaying()
end

--- Plays the source.
--- @param loop  Whether to loop. Defaults to false.
--- @param offset  Start position in seconds. Defaults to 0.
function LoveAudio:Play(loop: boolean?, offset: number?)
	local source = self._source
	if not source then return end

	source:setLooping(loop or false)
	if offset and offset > 0 then
		-- love.Source:tell / seek uses seconds with the "seconds" time unit
		source:seek(offset, "seconds")
	end

	source:play()
end

--- Stops the source and fires any registered stop listeners.
function LoveAudio:Stop()
	if self._source then
		self._source:stop()
	end
	local listeners: {() -> ()} = self._stopListeners
	self._stopListeners = {}
	for _, fn in listeners do
		fn()
	end
end

--- Pauses the source without resetting its position.
function LoveAudio:Pause()
	if self._source then
		self._source:pause()
	end
end

--- Releases the underlying LÖVE source. Call when the audio is no longer needed.
function LoveAudio:Destroy()
	self:Stop()
	if self._source then
		self._source:release()
		self._source = nil
	end
end

--- Fades the volume in over `duration` seconds using a coroutine-style update.
--- AudioManager drives this via LoveAudio:Update(dt) each frame.
function LoveAudio:FadeIn(duration: number)
	if not self._source then return end

	self._fadeTarget = self._volume
	self._fadeFrom = 0
	self._fadeDuration = duration
	self._fadeElapsed = 0
	self._source:setVolume(0)
end

--- Fades the volume out over `duration` seconds. Stops the source when done.
function LoveAudio:FadeOut(duration: number)
	if not self._source then return end

	self._fadeTarget = 0
	self._fadeFrom = self._volume
	self._fadeDuration = duration
	self._fadeElapsed  = 0
end

function LoveAudio:Clear()
	self:Stop()
	self._volume = 1
	self._pitch = 1
	self._pan = 0
	self._stopListeners = {} :: {() -> ()}
	self._isError = false
end

--- Must be called each frame from love.update(dt) for fades to work.
function LoveAudio:Update(dt: number)
	if self._fadeDuration and self._fadeDuration > 0 then
		self._fadeElapsed = (self._fadeElapsed or 0) + dt
		local t = math.min(self._fadeElapsed / self._fadeDuration, 1)
		local current = self._fadeFrom + (self._fadeTarget - self._fadeFrom) * t
		if self._source then
			self._source:setVolume(current)
		end
		if t >= 1 then
			self._fadeDuration = 0
			if self._fadeTarget == 0 then
				self:Stop()
			end
		end
	end
end

--- Returns the current playback position in seconds.
function LoveAudio:Seek(): number
	if self._source then
		return self._source:tell("seconds")
	end
	return 0
end

--- Registers a callback to be called once when the source stops.
function LoveAudio:AddStopListener(fn: () -> ())
	table.insert(self._stopListeners, fn)
end


--[[=======================
---- PRIVATE FUNCTIONS ----
=======================]]--

function LoveAudio:_load(stream: boolean?)
	local ok, result = pcall(function()
		local sourceType = stream and "stream" or "static"
		return love.audio.newSource(self._path, sourceType)
	end)

	if ok then
		self._source = result
	else
		self._isError = true
		error(`[LoveAudio] Failed to load '{self._path}': {tostring(result)}`)
	end
end



return LoveAudio