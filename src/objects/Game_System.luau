local Data, _, _ = require('../globals')()

local Ext = require('../core/Ext')
local Object = require('../core/Object')

local RMMZ = require('../types/rmmz')


local Game_System = setmetatable({}, Object)

Game_System.__index = Game_System
Game_System.Super = Object


Game_System.ClassName = 'Game_System'

function Game_System.new()
	-- create the parent class
	local object = Object.new()
	-- now we combine
	local self = setmetatable(object, Game_System)

	self:Initialize()

	return self
end

function Game_System:Initialize()
	self._saveEnabled = true
	self._menuEnabled = true
	self._encounterEnabled = true
	self._formationEnabled = true
	self._battleCount = 0
	self._winCount = 0
	self._escapeCount = 0
	self._saveCount = 0
	self._versionId = 0
	self._savefileId = 0
	self._framesOnSave = 0
	self._bgmOnSave = nil :: RMMZ.Audio?
	self._bgsOnSave = nil :: RMMZ.Audio?
	self._windowTone = nil :: {number}?
	self._battleBgm = nil :: RMMZ.Audio?
	self._victoryMe = nil :: RMMZ.Audio?
	self._defeatMe = nil :: RMMZ.Audio?
	self._savedBgm = nil :: RMMZ.Audio?
	self._walkingBgm = nil :: RMMZ.Audio?
end

function Game_System.IsJapanese(): boolean
    return string.match(Data.System.locale, "^ja") ~= nil
end

function Game_System.IsChinese(): boolean
    return string.match(Data.System.locale, "^zh") ~= nil
end

function Game_System.IsKorean(): boolean
    return string.match(Data.System.locale, "^ko") ~= nil
end

function Game_System:IsCJK(): boolean
    -- Since Luau patterns don't support (ja|zh|ko), we just use the other functions
    return self.IsJapanese() or self.IsChinese() or self.IsKorean()
end

function Game_System.IsRussian(): boolean
    return string.match(Data.System.locale, "^ru") ~= nil
end

function Game_System.IsSideView(): boolean
	return Data.System.optSideView
end

function Game_System.IsAutosaveEnabled(): boolean
	return Data.System.optAutosave
end

function Game_System.IsMessageSkipEnabled(): boolean
	return Data.System.optMessageSkip
end

function Game_System:IsSaveEnabled(): boolean
	return self._saveEnabled
end

function Game_System:DisableSave()
	self._saveEnabled = false
end

function Game_System:EnableSave()
	self._saveEnabled = true
end

function Game_System:IsMenuEnabled(): boolean
	return self._menuEnabled
end

function Game_System:DisableMenu()
	self._menuEnabled = false
end

function Game_System:EnableMenu()
	self._menuEnabled = true
end

function Game_System:IsEncounterEnabled(): boolean
	return self._encounterEnabled
end

function Game_System:DisableEncounter()
	self._encounterEnabled = false
end

function Game_System:EnableEncounter()
	self._encounterEnabled = true
end

function Game_System:IsFormationEnabled(): boolean
	return self._formationEnabled
end

function Game_System:DisableFormation()
	self._formationEnabled = false
end

function Game_System:EnableFormation()
	self._formationEnabled = true
end

function Game_System:BattleCount(): number
	return self._battleCount
end

function Game_System:WinCount(): number
	return self._winCount
end

function Game_System:EscapeCount(): number
	return self._escapeCount
end

function Game_System:SaveCount(): number
	return self._saveCount
end

function Game_System:VersionId(): number
	return self._versionId
end

function Game_System:SavefileId(): number
	return self._savefileId or 0
end

function Game_System:SetSavefileId(savefileId)
	self._savefileId = savefileId
end

function Game_System:WindowTone(): {number}
	return self._windowTone or Data.System.windowTone
end

function Game_System:SetWindowTone(value)
	self._windowTone = value
end

function Game_System:BattleBgm(): RMMZ.Audio
	return self._battleBgm or Data.System.battleBgm
end

function Game_System:SetBattleBgm(value)
	self._battleBgm = value
end

function Game_System:VictoryMe(): RMMZ.Audio
	return self._victoryMe or Data.System.victoryMe
end

function Game_System:SetVictoryMe(value)
	self._victoryMe = value
end

function Game_System:DefeatMe(): RMMZ.Audio
	return self._defeatMe or Data.System.defeatMe
end

function Game_System:SetDefeatMe(value)
	self._defeatMe = value
end

function Game_System:OnBattleStart()
	self._battleCount += 1
end

function Game_System:OnBattleWin()
	self._winCount += 1
end

function Game_System:OnBattleEscape()
	self._escapeCount += 1
end

function Game_System:OnBeforeSave()
	self._saveCount += 1
	self._versionId = Data.System.versionId
	self._framesOnSave = Graphics.frameCount
	self._bgmOnSave = AudioManager.SaveBgm()
	self._bgsOnSave = AudioManager.SaveBgs()
end

function Game_System:OnAfterLoad()
	Graphics.frameCount = self._framesOnSave
	AudioManager.PlayBgm(self._bgmOnSave)
	AudioManager.PlayBgs(self._bgsOnSave)
end

function Game_System.Playtime(): number
	return math.floor(Graphics.frameCount / 60)
end

function Game_System:PlaytimeText(): string
	local hour = math.floor(self.Playtime() / 60 / 60)
	local min = math.floor(self.Playtime() / 60) % 60
	local sec = self.Playtime() % 60
	return `{Ext.PadZeroes(hour, 2)}:{Ext.PadZeroes(min, 2)}:{Ext.PadZeroes(sec, 2)}`
end

function Game_System:SaveBgm()
	self._savedBgm = AudioManager.SaveBgm()
end

function Game_System:ReplayBgm()
	if self._savedBgm ~= nil then
		AudioManager.ReplayBgm(self._savedBgm)
	end
end

function Game_System:SaveWalkingBgm()
	self._walkingBgm = AudioManager.SaveBgm()
end

function Game_System:ReplayWalkingBgm()
	if self._walkingBgm then
		AudioManager.PlayBgm(self._walkingBgm)
	end
end

function Game_System:SaveWalkingBgm2()
	self._walkingBgm = Data.Map.bgm
end

function Game_System.MainFontFace(): string
	return `rmmz-mainfont, {Data.System.advanced.fallbackFonts}`
end

function Game_System:NumberFontFace(): string
	return `rmmz-numberfont, {self.MainFontFace()}`
end

function Game_System.MainFontSize(): number
	return Data.System.advanced.fontSize
end

function Game_System.WindowPadding(): number
	return 12
end

function Game_System.WindowOpacity(): number
	return Data.System.advanced.windowOpacity
end


return Game_System