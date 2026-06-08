local Util = require('../core/Util')
local Object = require('../engine/Object')

local Game_Message = setmetatable({}, Object)
Game_Message.__index = Game_Message

Game_Message.ClassName = 'Game_Message'
Game_Message.Super = Object


function Game_Message.new()
	-- create the parent class
	local object = Object.new()
	-- now we combine
	local self = setmetatable(object, Game_Message)

	self:Clear()

	return self
end

function Game_Message:Clear()
	self._texts = {} :: {string}
	self._choices = {} :: {string}
	self._speakerName = ""
	self._faceName = ""
	self._faceIndex = 0
	self._background = 0
	self._positionType = 2
	self._choiceDefaultType = 0
	self._choiceCancelType = 0
	self._choiceBackground = 0
	self._choicePositionType = 2
	self._numInputVariableId = 0
	self._numInputMaxDigits = 0
	self._itemChoiceVariableId = 0
	self._itemChoiceItypeId = 0
	self._scrollMode = false
	self._scrollSpeed = 2
	self._scrollNoFast = false
	self._choiceCallback = nil
end

function Game_Message:Choices()
	return self._choices
end

function Game_Message:SpeakerName()
	return self._speakerName
end

function Game_Message:FaceName()
	return self._faceName
end

function Game_Message:FaceIndex()
	return self._faceIndex
end

function Game_Message:Background()
	return self._background
end

function Game_Message:PositionType()
	return self._positionType
end

function Game_Message:ChoiceDefaultType()
	return self._choiceDefaultType
end

function Game_Message:ChoiceCancelType()
	return self._choiceCancelType
end

function Game_Message:ChoiceBackground()
	return self._choiceBackground
end

function Game_Message:ChoicePositionType()
	return self._choicePositionType
end

function Game_Message:NumInputVariableId()
	return self._numInputVariableId
end

function Game_Message:NumInputMaxDigits()
	return self._numInputMaxDigits
end

function Game_Message:ItemChoiceVariableId()
	return self._itemChoiceVariableId
end

function Game_Message:ItemChoiceItypeId()
	return self._itemChoiceItypeId
end

function Game_Message:ScrollMode()
	return self._scrollMode
end

function Game_Message:ScrollSpeed()
	return self._scrollSpeed
end

function Game_Message:ScrollNoFast()
	return self._scrollNoFast
end

function Game_Message:Add(text: string)
	table.insert(self._texts, text)
end

function Game_Message:SetSpeakerName(speakerName: string)
	self._speakerName = if speakerName then speakerName else ""
end

function Game_Message:SetFaceImage(faceName: string, faceIndex: number)
	self._faceName = faceName
	self._faceIndex = faceIndex
end

function Game_Message:SetBackground(background)
	self._background = background
end

function Game_Message:SetPositionType(positionType)
	self._positionType = positionType
end

function Game_Message:SetChoices(choices, defaultType, cancelType)
	self._choices = choices
	self._choiceDefaultType = defaultType
	self._choiceCancelType = cancelType
end

function Game_Message:SetChoiceBackground(background)
	self._choiceBackground = background
end

function Game_Message:SetChoicePositionType(positionType)
	self._choicePositionType = positionType
end

function Game_Message:SetNumberInput(variableId, maxDigits)
	self._numInputVariableId = variableId
	self._numInputMaxDigits = maxDigits
end

function Game_Message:SetItemChoice(variableId, itemType)
	self._itemChoiceVariableId = variableId
	self._itemChoiceItypeId = itemType
end

function Game_Message:SetScroll(speed, noFast)
	self._scrollMode = true
	self._scrollSpeed = speed
	self._scrollNoFast = noFast
end

function Game_Message:SetChoiceCallback(callback)
	self._choiceCallback = callback
end

function Game_Message:OnChoice(n)
	if self._choiceCallback then
		self._choiceCallback(n)
		self._choiceCallback = nil
	end
end

function Game_Message:HasText()
	return #self._texts > 0
end

function Game_Message:IsChoice()
	return #self._choices > 0
end

function Game_Message:IsNumberInput()
	return self._numInputVariableId > 0
end

function Game_Message:IsItemChoice()
	return self._itemChoiceVariableId > 0
end

function Game_Message:IsBusy()
	return self:HasText() or self:IsChoice() or self:IsNumberInput() or self:IsItemChoice()
end

function Game_Message:NewPage()
	if #self._texts > 0 then
		self._texts[#self._texts] ..= "\f"
	end
end

function Game_Message:AllText()
	return table.concat(self._texts, "\n")
end

function Game_Message:IsRTL()
	return Util.containsArabic(self:AllText())
end


return Game_Message