local Ext = require('../core/Ext')
local LoveAudio = require('../core/LoveAudio')

local RMMZ = require('../types/rmmz')

type Audio = RMMZ.Audio
type LoveAudio = LoveAudio.LoveAudio

local AudioManager = {}

local _createSource
local _updateSourceParameters
local _updateBgmParameters
local _updateBgsParameters
local _updateMeParameters
local _updateSeParameters
local _cleanupSe

local _bgmVolume = 100
local _bgsVolume = 100
local _meVolume = 100
local _seVolume = 100

local _currentBgm: Audio? = nil :: Audio?
local _currentBgs: Audio? = nil :: Audio?
local _currentMe: Audio? = nil :: Audio? -- never used in original code

local _bgmSource = nil :: LoveAudio?
local _bgsSource = nil :: LoveAudio?
local _meSource = nil :: LoveAudio?
local _seSources = {} :: {LoveAudio}
local _staticSources= {} :: {LoveAudio}

AudioManager.ReplayFadeTime = 0.5
AudioManager.Path = "assets/audio/"

--[[=======================
-------- Properties -------
=======================]]--

Ext.DefineProperty(AudioManager, "BgmVolume", {
	get = function(self)
		return _bgmVolume
	end,
	set = function(self, value)
		_bgmVolume = value
		_updateBgmParameters(_currentBgm)
	end,
})

Ext.DefineProperty(AudioManager, "BgsVolume", {
	get = function(self)
		return _bgsVolume
	end,
	set = function(self, value)
		_bgsVolume = value
		_updateBgsParameters(_currentBgs)
	end,
})

Ext.DefineProperty(AudioManager, "MeVolume", {
	get = function(self)
		return _meVolume
	end,
	set = function(self, value)
		_meVolume = value
		_updateMeParameters(_currentMe)
	end,
})

Ext.DefineProperty(AudioManager, "SeVolume", {
	get = function(self)
		return _seVolume
	end,
	set = function(self, value)
		_seVolume = value
	end,
})


--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

--- BGM (BackGround Music)

function AudioManager:PlayBgm(bgm: Audio, pos: number?)
	if self.IsCurrentBgm(bgm) then
		_updateBgmParameters(bgm)
	else
		self.StopBgm()
		if bgm.name and bgm.name ~= "" then
			_bgmSource = _createSource("bgm/", bgm.name, true)
			_updateBgmParameters(bgm)
			if not _meSource then
				_bgmSource:Play(true, pos or 0)
			end
		end
	end

	_currentBgm = {
		name = bgm.name,
		volume = bgm.volume,
		pitch = bgm.pitch,
		pan = bgm.pan,
		pos = pos,
	}
end

function AudioManager:ReplayBgm(bgm: Audio)
	if self.IsCurrentBgm(bgm) then
		_updateBgmParameters(bgm);
	else
		self:PlayBgm(bgm, bgm.pos)
		if _bgmSource then
			_bgmSource:FadeIn(self.ReplayFadeTime)
		end
	end
end

function AudioManager.IsCurrentBgm(bgm: Audio): boolean
	return _currentBgm ~= nil
		and _bgmSource ~= nil
		and _currentBgm.name == bgm.name
end

function AudioManager.StopBgm()
	if not _bgmSource then return end
	
	_bgmSource:Destroy()
	_bgmSource = nil
	_currentBgm = nil
end

function AudioManager.FadeOutBgm(duration: number)
	if not _bgmSource or not _currentBgm then return end
	
	_bgmSource:FadeOut(duration)
	_currentBgm = nil
end

function AudioManager.FadeInBgm(duration: number)
	if not _bgmSource or not _currentBgm then return end
	
	_bgmSource:FadeIn(duration)
end

function AudioManager:SaveBgm(): Audio
	if _currentBgm then
		local bgm = _currentBgm
		return {
			name = bgm.name,
			volume = bgm.volume,
			pitch = bgm.pitch,
			pan = bgm.pan,
			pos = if _bgmSource then _bgmSource:Seek() else 0,
		}
	else
		return self.MakeEmptyAudioObject()
	end
end

-- BGS (BackGround Sound / ambient loop)

function AudioManager:PlayBgs(bgs: Audio, pos: number?)
	if self.IsCurrentBgs(bgs) then
		_updateBgsParameters(bgs)
	else
		self.StopBgs()
		if bgs.name and bgs.name ~= "" then
			_bgsSource = _createSource("bgs/", bgs.name, true)
			_updateBgsParameters(bgs)
			_bgsSource:Play(true, pos or 0)
		end
	end

	_currentBgs = {
		name   = bgs.name,
		volume = bgs.volume,
		pitch  = bgs.pitch,
		pan    = bgs.pan,
		pos    = pos,
	}
end

function AudioManager:ReplayBgs(bgs: Audio)
	if self.IsCurrentBgs(bgs) then
		_updateBgsParameters(bgs)
	else
		self:PlayBgs(bgs, bgs.pos)
		if _bgsSource then
			_bgsSource:FadeIn(self.ReplayFadeTime)
		end
	end
end

function AudioManager.IsCurrentBgs(bgs: Audio): boolean
	return _currentBgs ~= nil
		and _bgsSource ~= nil
		and _currentBgs.name == bgs.name
end

function AudioManager.StopBgs()
	if not _bgsSource then return end

	_bgsSource:Destroy()
	_bgsSource = nil
	_currentBgs = nil
end

function AudioManager.FadeOutBgs(duration: number)
	if not _bgsSource or not _currentBgs then return end
	
	_bgsSource:FadeOut(duration)
	_currentBgs = nil
end

function AudioManager.FadeInBgs(duration: number)
	if not _bgsSource or not _currentBgs then return end
	
	_bgsSource:FadeIn(duration)
end

function AudioManager:SaveBgs(): Audio
	if _currentBgs then
		local bgs = _currentBgs
		return {
			name   = bgs.name,
			volume = bgs.volume,
			pitch  = bgs.pitch,
			pan    = bgs.pan,
			pos    = _bgsSource and _bgsSource:Seek() or 0,
		}
	else
		return self.MakeEmptyAudioObject()
	end
end

-- ME (Music Effect - plays once, then BGM resumes)

function AudioManager:PlayMe(me: Audio)
	self:StopMe()

	if not me.name or me.name == "" then return end

	-- Pause BGM while ME plays but remember its position
	if _bgmSource and _currentBgm then
		_currentBgm.pos = _bgmSource:Seek()
		_bgmSource:Stop()
	end
	_meSource = _createSource("me/", me.name, false)
	_updateMeParameters(me)
	_meSource:Play(false)
	_meSource:AddStopListener(self.StopMe)
end

function AudioManager.FadeOutMe(duration: number)
	if not _meSource then return end
	
	_meSource:FadeOut(duration)
end

function AudioManager:StopMe()
	if not _meSource then return end

	_meSource:Destroy()
	_meSource = nil
	-- Resume BGM from where it was paused
	if _bgmSource and _currentBgm
		and not _bgmSource:IsPlaying()
	then
		_bgmSource:Play(true, _currentBgm.pos or 0)
		_bgmSource:FadeIn(self.ReplayFadeTime)
	end
end

-- SE (Sound Effects - self explanatory)

--- Plays a sound effect.
function AudioManager:PlaySe(se: Audio)
	if se.name and se.name == "" then return end

	-- Don't replay the same sound twice in one frame
	local latestSources = Ext.Filter(self._seSources, function(src)
		return src.frameCount == Graphics.frameCount
	end)

	if table.find(latestSources, function(src)
		return src.name == se.name
	end) then
		return
	end

	local src = _createSource("se/", se.name, false)
	_updateSeParameters(src, se)
	src:Play(false)
	table.insert(_seSources, src)
	_cleanupSe()
end

function AudioManager.StopSe()
	for _, src in _seSources do
		src:Destroy()
	end
	_seSources = {}
end

--- Preloads an SE so the first play has no latency.
function AudioManager:LoadStaticSe(se: Audio)
	if se.name == "" or self.IsStaticSe(se) then return end
	
	local src = _createSource("se/", se.name, false)
	table.insert(_staticSources, src)
end

--- Plays a preloaded static SE (restarts from the beginning each call).
function AudioManager:PlayStaticSe(se: Audio)
	if not se.name or se.name == "" then return end

	self:LoadStaticSe(se)
	for _, src in _staticSources do
		if src.name == se.name then
			src:Stop()
			_updateSeParameters(src, se)
			src:Play(false)
			break
		end
	end
end

function AudioManager.IsStaticSe(se: Audio): boolean
	for _, src in _staticSources do
		if src.name == se.name then
			return true
		end
	end
	return false
end

-- Global Controls

function AudioManager:StopAll()
	self:StopMe()
	self.StopBgm()
	self.StopBgs()
	self.StopSe()
end

function AudioManager.MakeEmptyAudioObject(): Audio
	return { name = "", volume = 0, pitch = 0 }
end

--- Call in love.update(dt) to handle fades.
function AudioManager.Update(dt: number)
	if _bgmSource then _bgmSource:Update(dt) end
	if _bgsSource then _bgsSource:Update(dt) end
	if _meSource  then _meSource:Update(dt)  end
	for _, src in _seSources do
		src:Update(dt)
	end
end

--- Checks all active sources for load errors and throws them.
function AudioManager.CheckErrors()
	local sources = {_bgmSource, _bgsSource, _meSource}
	for _, b in _seSources do table.insert(sources, b) end
	for _, b in _staticSources do table.insert(sources, b) end

	for _, src in sources do
		if src and src:IsError() then
			error({ "LoadError", src.Path })
		end
	end
end


--[[=======================
---- PRIVATE FUNCTIONS ----
=======================]]--

--- Creates a new audio source from a given file path.
function _createSource(folder: string, name: string, stream: boolean): LoveAudio
	-- LÖVE supports .wav, .mp3, .ogg, .oga, .flac, and all tracker formats
	-- natively — no extension remapping needed.
	local url = AudioManager.Path .. folder .. name
	return LoveAudio.new(url, stream)
end

--- Applies volume, pitch, and pan from an Audio type.
function _updateSourceParameters(
	src: LoveAudio?,
	configVolume: number,
	audio: Audio?
)
	if not src or not audio then return end

	src.Volume = (configVolume * (audio.volume or 0)) / 10000
	src.Pitch = (audio.pitch or 0) / 100
	src.Pan = (audio.pan or 0) / 100
end

function _updateBgmParameters(bgm: Audio)
	_updateSourceParameters(_bgmSource, _bgmVolume, bgm)
end

function _updateBgsParameters(bgs: Audio)
	_updateSourceParameters(_bgsSource, _bgsVolume, bgs)
end

function _updateMeParameters(me: Audio)
	_updateSourceParameters(_meSource, _meVolume, me)
end

function _updateSeParameters(src: LoveAudio, se: Audio)
	_updateSourceParameters(src, _seVolume, se)
end

--- Destroys finished SE sources and removes them from the active list
function _cleanupSe()
	Ext.Filter(_seSources, function(src): boolean
		if src:IsPlaying() then
			return true
		end
		src:Destroy()
		return false
	end)
end


return AudioManager