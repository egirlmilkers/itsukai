local Ext = require('../core/Ext')

local RMMZ = require('../types/rmmz')


AudioManager = {}


AudioManager._bgmVolume = 100
AudioManager._bgsVolume = 100
AudioManager._meVolume = 100
AudioManager._seVolume = 100

AudioManager._currentBgm = nil :: RMMZ.Audio?
AudioManager._currentBgs = nil :: RMMZ.Audio?
AudioManager._currentMe = nil :: RMMZ.Audio?

AudioManager._bgmBuffer = nil :: RMMZ.Audio?
AudioManager._bgsBuffer = nil :: RMMZ.Audio?
AudioManager._meBuffer = nil :: RMMZ.Audio?
AudioManager._seBuffers = {}
AudioManager._staticBuffers = {}

AudioManager._replayFadeTime = 0.5
AudioManager._path = "assets/audio/"

Ext.DefineProperty(AudioManager, "bgmVolume", {
	get = function(self)
		return self._bgmVolume
	end,
	set = function(self, value)
		self._bgmVolume = value
		self:UpdateAudioParameters('bgm', self._currentBgm)
	end
})

Ext.DefineProperty(AudioManager, "bgsVolume", {
	get = function(self)
		return self._bgsVolume
	end,
	set = function(self, value)
		self._bgsVolume = value
		self:UpdateAudioParameters('bgs', self._currentBgs)
	end
})

Ext.DefineProperty(AudioManager, "meVolume", {
	get = function(self)
		return self._meVolume
	end,
	set = function(self, value)
		self._meVolume = value
		self:UpdateAudioParameters('me', self._currentMe)
	end
})

Ext.DefineProperty(AudioManager, "seVolume", {
	get = function(self)
		return self._seVolume
	end,
	set = function(self, value)
		self._seVolume = value
	end
})

function AudioManager:Play(channel: 'bgm'|'bgs'|'me'|'se'|'static', audio: RMMZ.Audio, pos: number?)
	if channel == 'bgm' or channel == 'bgs' then
		if self:IsCurrent(channel, audio) then
			self:UpdateAudioParameters(channel, audio)
		else
			self:Stop(channel)
			if audio.name then
				self._bgmBuffer = self:CreateBuffer(`{channel}/`, audio.name)
				self:UpdateAudioParameters(channel, audio)
				if (channel == 'bgm' and not self._meBuffer) or channel == 'bgs' then
					self[`_{channel}Buffer`]:Play(true, pos or 0)
				end
			end
		end
		self.UpdateCurrent(channel, audio, pos)
	elseif channel == 'me' or channel == 'se' or channel == 'static' then
		if channel == 'me' then self:Stop(channel) end
		if not audio.name then return end

		if channel == 'me' then
			if self._bgmBuffer and self._currentBgm then
				self._currentBgm.pos = self._bgmBuffer:Seek()
				self._bgmBuffer:Stop()
			end
			self._meBuffer = self:CreateBuffer("me/", audio.name)
			self:UpdateAudioParameters(channel, audio)
			self._meBuffer:Play(false)
			-- TODO: self._meBuffer:AddStopListener(self.Stop(_, _))
		elseif channel == 'se' then
			local latestBuffers = Ext.Filter(self._seBuffers, function(buffer)
				return buffer.frameCount == Graphics.frameCount
			end)
			if table.find(latestBuffers, function(buffer)
				return buffer.name == audio.name
			end) then
				return
			end
			local buffer = self:CreateBuffer(`se/`, audio)
			self:UpdateAudioParameters(channel, buffer, audio)
			buffer:Play(false)
			table.insert(self._seBuffers, buffer)
			self:CleanupAudio(channel)
		elseif channel == 'static' then
			self:LoadStaticSe(audio)
			for buffer in self._staticBuffers do
				if buffer.name == audio.name then
					buffer:Stop()
					self.UpdateAudioParameters('se', buffer, audio)
					buffer:Play(false)
					break
				end
			end
		end
	end
end


return AudioManager