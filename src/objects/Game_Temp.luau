local Data, Game = require('../globals')()

local Util = require('../core/Util')
local Object = require('../core/Object')

local Game_Temp = setmetatable({}, Object)
Game_Temp.__index = Game_Temp

Game_Temp.ClassName = 'Game_Temp'
Game_Temp.Super = Object


function Game_Temp.new()
	-- create the parent class
	local object = Object.new()
	-- now we combine
	local self = setmetatable(object, Game_Temp)

	self._isPlaytest = Util.IsOptionValid("test")
	self._destinationX = nil :: number?
	self._destinationY = nil :: number?
	self._touchTarget = nil
	self._touchState = ""
	self._needsBattleRefresh = false
	self._commonEventQueue = {} :: {number}
	self._animationQueue = {} :: {{targets: any, animationId: number, mirror: boolean}}
	self._balloonQueue = {} :: {{target: any, balloonId: number}}
	self._lastActionData = {0, 0, 0, 0, 0, 0}

	return self
end

function Game_Temp:IsPlaytest(): boolean
	return self._isPlaytest
end

function Game_Temp:SetDestination(x, y)
	self._destinationX = x
	self._destinationY = y
end

function Game_Temp:ClearDestination()
	self._destinationX = nil
	self._destinationY = nil
end

function Game_Temp:IsDestinationValid(): boolean
	return self._destinationX ~= nil
end

function Game_Temp:DestinationX(): number
	return self._destinationX
end

function Game_Temp:DestinationY(): number
	return self._destinationY
end

function Game_Temp:SetTouchState(target, state: string)
	self._touchTarget = target
	self._touchState = state
end

function Game_Temp:ClearTouchState()
	self._touchTarget = nil
	self._touchState = ""
end

function Game_Temp:TouchTarget()
	return self._touchTarget
end

function Game_Temp:TouchState()
	return self._touchState
end

function Game_Temp:RequestBattleRefresh()
	if Game.Party.InBattle() then
		self._needsBattleRefresh = true
	end
end

function Game_Temp:ClearBattleRefreshRequest()
	self._needsBattleRefresh = false
end

function Game_Temp:IsBattleRefreshRequested(): boolean
	return self._needsBattleRefresh
end

function Game_Temp:ReserveCommonEvent(commonEventId: number)
	table.insert(self._commonEventQueue, commonEventId)
end

function Game_Temp:RetrieveCommonEvent()
	return Data.CommonEvents[table.remove(self._commonEventQueue, 1)]
end

function Game_Temp:ClearCommonEventReservation()
	self._commonEventQueue = {}
end

function Game_Temp:IsCommonEventReserved(): boolean
	return #self._commonEventQueue > 0
end

function Game_Temp:RequestAnimation(targets, animationId: number, mirror: boolean?)
	if mirror == nil then mirror = false end

	if Data.Animations[animationId] then
		local request = {
			targets = targets,
			animationId = animationId,
			mirror = mirror
		}

		table.insert(self._animationQueue, request)

		for target in targets do
			if target.StartAnimation then
				target:StartAnimation()
			end
		end
	end
end

function Game_Temp:RetrieveAnimation()
	return table.remove(self._animationQueue, 1)
end

function Game_Temp:RequestBalloon(target, balloonId: number)
	local request = {
		target = target,
		balloonId = balloonId
	}

	table.insert(self._balloonQueue, request)

	if target.StartBalloon then
		target.StartBalloon()
	end
end

function Game_Temp:RetrieveBalloon()
	return table.remove(self._balloonQueue, 1)
end

function Game_Temp:LastActionData(type: number): number
	return self._lastActionData[type] or 0
end

function Game_Temp:SetLastActionData(type: number, value: number)
	self._lastActionData[type] = value
end

function Game_Temp:SetLastUsedSkillId(skillID: number)
	self:SetLastActionData(0, skillID)
end

function Game_Temp:SetLastUsedItemId(itemID: number)
	self:SetLastActionData(1, itemID)
end

function Game_Temp:SetLastSubjectActorId(actorID: number)
	self:SetLastActionData(2, actorID)
end

function Game_Temp:SetLastSubjectEnemyIndex(enemyIndex: number)
	self:SetLastActionData(3, enemyIndex)
end

function Game_Temp:SetLastTargetActorId(actorID: number)
	self:SetLastActionData(4, actorID)
end

function Game_Temp:SetLastTargetEnemyIndex(enemyIndex: number)
	self:SetLastActionData(5, enemyIndex)
end