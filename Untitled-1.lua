-------------------------------------------------------------------------------
-- Game_Timer
--
-- The game object class for the timer.

function Game_Timer.new()
	self:Initialize(...arguments)
end

function Game_Timer:Initialize()
	self._frames = 0
	self._working = false
end

function Game_Timer:Update(sceneActive)
	if sceneActive and self._working and self._frames > 0 then
		self._frames--
		if self._frames === 0 then
			self:OnExpire()
		end
	end
end

function Game_Timer:Start(count)
	self._frames = count
	self._working = true
end

function Game_Timer:Stop()
	self._working = false
end

function Game_Timer:IsWorking()
	return self._working
end

function Game_Timer:Seconds()
	return Math.floor(self._frames / 60)
end

function Game_Timer:Frames()
	return self._frames
end

function Game_Timer:OnExpire()
	BattleManager.abort()
end

-------------------------------------------------------------------------------
-- Game_Switches
--
-- The game object class for switches.

function Game_Switches.new()
	self:Initialize(...arguments)
end

function Game_Switches:Initialize()
	self:Clear()
end

function Game_Switches:Clear()
	self._data = []
end

function Game_Switches:Value(switchId)
	return !!self._data[switchId]
end

function Game_Switches:SetValue(switchId, value)
	if switchId > 0 and switchId < Data.System.switches.length then
		self._data[switchId] = value
		self:OnChange()
	end
end

function Game_Switches:OnChange()
	Game.Map.requestRefresh()
end

-------------------------------------------------------------------------------
-- Game_Variables
--
-- The game object class for variables.

function Game_Variables.new()
	self:Initialize(...arguments)
end

function Game_Variables:Initialize()
	self:Clear()
end

function Game_Variables:Clear()
	self._data = []
end

function Game_Variables:Value(variableId)
	return self._data[variableId] or 0
end

function Game_Variables:SetValue(variableId, value)
	if variableId > 0 and variableId < Data.System.variables.length then
		if typeof value === "number" then
			value = Math.floor(value)
		end
		self._data[variableId] = value
		self:OnChange()
	end
end

function Game_Variables:OnChange()
	Game.Map.requestRefresh()
end

-------------------------------------------------------------------------------
-- Game_SelfSwitches
--
-- The game object class for self switches.

function Game_SelfSwitches.new()
	self:Initialize(...arguments)
end

function Game_SelfSwitches:Initialize()
	self:Clear()
end

function Game_SelfSwitches:Clear()
	self._data = {end
end

function Game_SelfSwitches:Value(key)
	return !!self._data[key]
end

function Game_SelfSwitches:SetValue(key, value)
	if value then
		self._data[key] = true
	end else {
		delete self._data[key]
	end
	self:OnChange()
end

function Game_SelfSwitches:OnChange()
	Game.Map.requestRefresh()
end

-------------------------------------------------------------------------------
-- Game_Screen
--
-- The game object class for screen effect data, such as changes in color tone
-- and flashes.

function Game_Screen.new()
	self:Initialize(...arguments)
end

function Game_Screen:Initialize()
	self:Clear()
end

function Game_Screen:Clear()
	self:ClearFade()
	self:ClearTone()
	self:ClearFlash()
	self:ClearShake()
	self:ClearZoom()
	self:ClearWeather()
	self:ClearPictures()
end

function Game_Screen:OnBattleStart()
	self:ClearFade()
	self:ClearFlash()
	self:ClearShake()
	self:ClearZoom()
	self:EraseBattlePictures()
end

function Game_Screen:Brightness()
	return self._brightness
end

function Game_Screen:Tone()
	return self._tone
end

function Game_Screen:FlashColor()
	return self._flashColor
end

function Game_Screen:Shake()
	return self._shake
end

function Game_Screen:ZoomX()
	return self._zoomX
end

function Game_Screen:ZoomY()
	return self._zoomY
end

function Game_Screen:ZoomScale()
	return self._zoomScale
end

function Game_Screen:WeatherType()
	return self._weatherType
end

function Game_Screen:WeatherPower()
	return self._weatherPower
end

function Game_Screen:Picture(pictureId)
	local realPictureId = self:RealPictureId(pictureId)
	return self._pictures[realPictureId]
end

function Game_Screen:RealPictureId(pictureId)
	if Game.Party.inBattle() then
		return pictureId + self:MaxPictures()
	end else {
		return pictureId
	end
end

function Game_Screen:ClearFade()
	self._brightness = 255
	self._fadeOutDuration = 0
	self._fadeInDuration = 0
end

function Game_Screen:ClearTone()
	self._tone = [0, 0, 0, 0]
	self._toneTarget = [0, 0, 0, 0]
	self._toneDuration = 0
end

function Game_Screen:ClearFlash()
	self._flashColor = [0, 0, 0, 0]
	self._flashDuration = 0
end

function Game_Screen:ClearShake()
	self._shakePower = 0
	self._shakeSpeed = 0
	self._shakeDuration = 0
	self._shakeDirection = 1
	self._shake = 0
end

function Game_Screen:ClearZoom()
	self._zoomX = 0
	self._zoomY = 0
	self._zoomScale = 1
	self._zoomScaleTarget = 1
	self._zoomDuration = 0
end

function Game_Screen:ClearWeather()
	self._weatherType = "none"
	self._weatherPower = 0
	self._weatherPowerTarget = 0
	self._weatherDuration = 0
end

function Game_Screen:ClearPictures()
	self._pictures = []
end

function Game_Screen:EraseBattlePictures()
	self._pictures = self._pictures.slice(0, self:MaxPictures() + 1)
end

function Game_Screen:MaxPictures()
	if "picturesUpperLimit" in Data.System.advanced then
		return Data.System.advanced.picturesUpperLimit
	end else {
		return 100
	end
end

function Game_Screen:StartFadeOut(duration)
	self._fadeOutDuration = duration
	self._fadeInDuration = 0
end

function Game_Screen:StartFadeIn(duration)
	self._fadeInDuration = duration
	self._fadeOutDuration = 0
end

function Game_Screen:StartTint(tone, duration)
	self._toneTarget = tone.clone()
	self._toneDuration = duration
	if self._toneDuration === 0 then
		self._tone = self._toneTarget.clone()
	end
end

function Game_Screen:StartFlash(color, duration)
	self._flashColor = color.clone()
	self._flashDuration = duration
end

function Game_Screen:StartShake(power, speed, duration)
	self._shakePower = power
	self._shakeSpeed = speed
	self._shakeDuration = duration
end

function Game_Screen:StartZoom(x, y, scale, duration)
	self._zoomX = x
	self._zoomY = y
	self._zoomScaleTarget = scale
	self._zoomDuration = duration
end

function Game_Screen:SetZoom(x, y, scale)
	self._zoomX = x
	self._zoomY = y
	self._zoomScale = scale
end

function Game_Screen:ChangeWeather(type, power, duration)
	if type ~= "none" or duration === 0 then
		self._weatherType = type
	end
	self._weatherPowerTarget = type === "none" ? 0 : power
	self._weatherDuration = duration
	if duration === 0 then
		self._weatherPower = self._weatherPowerTarget
	end
end

function Game_Screen:Update()
	self:UpdateFadeOut()
	self:UpdateFadeIn()
	self:UpdateTone()
	self:UpdateFlash()
	self:UpdateShake()
	self:UpdateZoom()
	self:UpdateWeather()
	self:UpdatePictures()
end

function Game_Screen:UpdateFadeOut()
	if self._fadeOutDuration > 0 then
		local d = self._fadeOutDuration
		self._brightness = (self._brightness * (d - 1)) / d
		self._fadeOutDuration--
	end
end

function Game_Screen:UpdateFadeIn()
	if self._fadeInDuration > 0 then
		local d = self._fadeInDuration
		self._brightness = (self._brightness * (d - 1) + 255) / d
		self._fadeInDuration--
	end
end

function Game_Screen:UpdateTone()
	if self._toneDuration > 0 then
		local d = self._toneDuration
		for (local i = 0 i < 4 i++) {
			self._tone[i] = (self._tone[i] * (d - 1) + self._toneTarget[i]) / d
		end
		self._toneDuration--
	end
end

function Game_Screen:UpdateFlash()
	if self._flashDuration > 0 then
		local d = self._flashDuration
		self._flashColor[3] *= (d - 1) / d
		self._flashDuration--
	end
end

function Game_Screen:UpdateShake()
	if self._shakeDuration > 0 or self._shake ~= 0 then
		local delta = (self._shakePower * self._shakeSpeed * self._shakeDirection) / 10
		if self._shakeDuration <= 1 and self._shake * (self._shake + delta) < 0 then
			self._shake = 0
		end else {
			self._shake += delta
		end
		if self._shake > self._shakePower * 2 then
			self._shakeDirection = -1
		end
		if self._shake < -self._shakePower * 2 then
			self._shakeDirection = 1
		end
		self._shakeDuration--
	end
end

function Game_Screen:UpdateZoom()
	if self._zoomDuration > 0 then
		local d = self._zoomDuration
		local t = self._zoomScaleTarget
		self._zoomScale = (self._zoomScale * (d - 1) + t) / d
		self._zoomDuration--
	end
end

function Game_Screen:UpdateWeather()
	if self._weatherDuration > 0 then
		local d = self._weatherDuration
		local t = self._weatherPowerTarget
		self._weatherPower = (self._weatherPower * (d - 1) + t) / d
		self._weatherDuration--
		if self._weatherDuration === 0 and self._weatherPowerTarget === 0 then
			self._weatherType = "none"
		end
	end
end

function Game_Screen:UpdatePictures()
	for (local picture of self._pictures) {
		if picture then
			picture.update()
		end
	end
end

function Game_Screen:StartFlashForDamage()
	self:StartFlash([255, 0, 0, 128], 8)
end

-- prettier-ignore
Game_Screen.prototype.showPicture = function(
	pictureId, name, origin, x, y, scaleX, scaleY, opacity, blendMode
) {
	local realPictureId = self:RealPictureId(pictureId)
	local picture = new Game_Picture()
	picture.show(name, origin, x, y, scaleX, scaleY, opacity, blendMode)
	self._pictures[realPictureId] = picture
end

-- prettier-ignore
Game_Screen.prototype.movePicture = function(
	pictureId, origin, x, y, scaleX, scaleY, opacity, blendMode, duration,
	easingType
) {
	local picture = self:Picture(pictureId)
	if picture then
		-- prettier-ignore
		picture.move(origin, x, y, scaleX, scaleY, opacity, blendMode,
					 duration, easingType)
	end
end

function Game_Screen:RotatePicture(pictureId, speed)
	local picture = self:Picture(pictureId)
	if picture then
		picture.rotate(speed)
	end
end

function Game_Screen:TintPicture(pictureId, tone, duration)
	local picture = self:Picture(pictureId)
	if picture then
		picture.tint(tone, duration)
	end
end

function Game_Screen:ErasePicture(pictureId)
	local realPictureId = self:RealPictureId(pictureId)
	self._pictures[realPictureId] = nil
end

-------------------------------------------------------------------------------
-- Game_Picture
--
-- The game object class for a picture.

function Game_Picture.new()
	self:Initialize(...arguments)
end

function Game_Picture:Initialize()
	self:InitBasic()
	self:InitTarget()
	self:InitTone()
	self:InitRotation()
end

function Game_Picture:Name()
	return self._name
end

function Game_Picture:Origin()
	return self._origin
end

function Game_Picture:X()
	return self._x
end

function Game_Picture:Y()
	return self._y
end

function Game_Picture:ScaleX()
	return self._scaleX
end

function Game_Picture:ScaleY()
	return self._scaleY
end

function Game_Picture:Opacity()
	return self._opacity
end

function Game_Picture:BlendMode()
	return self._blendMode
end

function Game_Picture:Tone()
	return self._tone
end

function Game_Picture:Angle()
	return self._angle
end

function Game_Picture:InitBasic()
	self._name = ""
	self._origin = 0
	self._x = 0
	self._y = 0
	self._scaleX = 100
	self._scaleY = 100
	self._opacity = 255
	self._blendMode = 0
end

function Game_Picture:InitTarget()
	self._targetX = self._x
	self._targetY = self._y
	self._targetScaleX = self._scaleX
	self._targetScaleY = self._scaleY
	self._targetOpacity = self._opacity
	self._duration = 0
	self._wholeDuration = 0
	self._easingType = 0
	self._easingExponent = 0
end

function Game_Picture:InitTone()
	self._tone = nil
	self._toneTarget = nil
	self._toneDuration = 0
end

function Game_Picture:InitRotation()
	self._angle = 0
	self._rotationSpeed = 0
end

-- prettier-ignore
Game_Picture.prototype.show = function(
	name, origin, x, y, scaleX, scaleY, opacity, blendMode
) {
	self._name = name
	self._origin = origin
	self._x = x
	self._y = y
	self._scaleX = scaleX
	self._scaleY = scaleY
	self._opacity = opacity
	self._blendMode = blendMode
	self:InitTarget()
	self:InitTone()
	self:InitRotation()
end

-- prettier-ignore
Game_Picture.prototype.move = function(
	origin, x, y, scaleX, scaleY, opacity, blendMode, duration, easingType
) {
	self._origin = origin
	self._targetX = x
	self._targetY = y
	self._targetScaleX = scaleX
	self._targetScaleY = scaleY
	self._targetOpacity = opacity
	self._blendMode = blendMode
	self._duration = duration
	self._wholeDuration = duration
	self._easingType = easingType
	self._easingExponent = 2
end

function Game_Picture:Rotate(speed)
	self._rotationSpeed = speed
end

function Game_Picture:Tint(tone, duration)
	if !self._tone then
		self._tone = [0, 0, 0, 0]
	end
	self._toneTarget = tone.clone()
	self._toneDuration = duration
	if self._toneDuration === 0 then
		self._tone = self._toneTarget.clone()
	end
end

function Game_Picture:Update()
	self:UpdateMove()
	self:UpdateTone()
	self:UpdateRotation()
end

function Game_Picture:UpdateMove()
	if self._duration > 0 then
		self._x = self:ApplyEasing(self._x, self._targetX)
		self._y = self:ApplyEasing(self._y, self._targetY)
		self._scaleX = self:ApplyEasing(self._scaleX, self._targetScaleX)
		self._scaleY = self:ApplyEasing(self._scaleY, self._targetScaleY)
		self._opacity = self:ApplyEasing(self._opacity, self._targetOpacity)
		self._duration--
	end
end

function Game_Picture:UpdateTone()
	if self._toneDuration > 0 then
		local d = self._toneDuration
		for (local i = 0 i < 4 i++) {
			self._tone[i] = (self._tone[i] * (d - 1) + self._toneTarget[i]) / d
		end
		self._toneDuration--
	end
end

function Game_Picture:UpdateRotation()
	if self._rotationSpeed ~= 0 then
		self._angle += self._rotationSpeed / 2
	end
end

function Game_Picture:ApplyEasing(current, target)
	local d = self._duration
	local wd = self._wholeDuration
	local lt = self:CalcEasing((wd - d) / wd)
	local t = self:CalcEasing((wd - d + 1) / wd)
	local start = (current - target * lt) / (1 - lt)
	return start + (target - start) * t
end

function Game_Picture:CalcEasing(t)
	local exponent = self._easingExponent
	switch (self._easingType) {
		case 1: -- Slow start
			return self:EaseIn(t, exponent)
		case 2: -- Slow end
			return self:EaseOut(t, exponent)
		case 3: -- Slow start and end
			return self:EaseInOut(t, exponent)
		default:
			return t
	end
end

function Game_Picture:EaseIn(t, exponent)
	return Math.pow(t, exponent)
end

function Game_Picture:EaseOut(t, exponent)
	return 1 - Math.pow(1 - t, exponent)
end

function Game_Picture:EaseInOut(t, exponent)
	if t < 0.5 then
		return self:EaseIn(t * 2, exponent) / 2
	end else {
		return self:EaseOut(t * 2 - 1, exponent) / 2 + 0.5
	end
end

-------------------------------------------------------------------------------
-- Game_Item
--
-- The game object class for handling skills, items, weapons, and armor. It is
-- required because save data should not include the database object itself.

function Game_Item.new()
	self:Initialize(...arguments)
end

function Game_Item:Initialize(item)
	self._dataClass = ""
	self._itemId = 0
	if item then
		self:SetObject(item)
	end
end

function Game_Item:IsSkill()
	return self._dataClass === "skill"
end

function Game_Item:IsItem()
	return self._dataClass === "item"
end

function Game_Item:IsUsableItem()
	return self:IsSkill() or self:IsItem()
end

function Game_Item:IsWeapon()
	return self._dataClass === "weapon"
end

function Game_Item:IsArmor()
	return self._dataClass === "armor"
end

function Game_Item:IsEquipItem()
	return self:IsWeapon() or self:IsArmor()
end

function Game_Item:IsNull()
	return self._dataClass === ""
end

function Game_Item:ItemId()
	return self._itemId
end

function Game_Item:Object()
	if self:IsSkill() then
		return Data.Skills[self._itemId]
	end else if self:IsItem() then
		return Data.Items[self._itemId]
	end else if self:IsWeapon() then
		return Data.Weapons[self._itemId]
	end else if self:IsArmor() then
		return Data.Armors[self._itemId]
	end else {
		return nil
	end
end

function Game_Item:SetObject(item)
	if DataManager.isSkill(item) then
		self._dataClass = "skill"
	end else if DataManager.isItem(item) then
		self._dataClass = "item"
	end else if DataManager.isWeapon(item) then
		self._dataClass = "weapon"
	end else if DataManager.isArmor(item) then
		self._dataClass = "armor"
	end else {
		self._dataClass = ""
	end
	self._itemId = item ? item.id : 0
end

function Game_Item:SetEquip(isWeapon, itemId)
	self._dataClass = isWeapon ? "weapon" : "armor"
	self._itemId = itemId
end

-------------------------------------------------------------------------------
-- Game_Action
--
-- The game object class for a battle action.

function Game_Action.new()
	self:Initialize(...arguments)
end

Game_Action.EFFECT_RECOVER_HP = 11
Game_Action.EFFECT_RECOVER_MP = 12
Game_Action.EFFECT_GAIN_TP = 13
Game_Action.EFFECT_ADD_STATE = 21
Game_Action.EFFECT_REMOVE_STATE = 22
Game_Action.EFFECT_ADD_BUFF = 31
Game_Action.EFFECT_ADD_DEBUFF = 32
Game_Action.EFFECT_REMOVE_BUFF = 33
Game_Action.EFFECT_REMOVE_DEBUFF = 34
Game_Action.EFFECT_SPECIAL = 41
Game_Action.EFFECT_GROW = 42
Game_Action.EFFECT_LEARN_SKILL = 43
Game_Action.EFFECT_COMMON_EVENT = 44
Game_Action.SPECIAL_EFFECT_ESCAPE = 0
Game_Action.HITTYPE_CERTAIN = 0
Game_Action.HITTYPE_PHYSICAL = 1
Game_Action.HITTYPE_MAGICAL = 2

function Game_Action:Initialize(subject, forcing)
	self._subjectActorId = 0
	self._subjectEnemyIndex = -1
	self._forcing = forcing or false
	self:SetSubject(subject)
	self:Clear()
end

function Game_Action:Clear()
	self._item = new Game_Item()
	self._targetIndex = -1
end

function Game_Action:SetSubject(subject)
	if subject.isActor() then
		self._subjectActorId = subject.actorId()
		self._subjectEnemyIndex = -1
	end else {
		self._subjectEnemyIndex = subject.index()
		self._subjectActorId = 0
	end
end

function Game_Action:Subject()
	if self._subjectActorId > 0 then
		return Game.Actors.actor(self._subjectActorId)
	end else {
		return Game.Troop.members()[self._subjectEnemyIndex]
	end
end

function Game_Action:FriendsUnit()
	return self:Subject().friendsUnit()
end

function Game_Action:OpponentsUnit()
	return self:Subject().opponentsUnit()
end

function Game_Action:SetEnemyAction(action)
	if action then
		self:SetSkill(action.skillId)
	end else {
		self:Clear()
	end
end

function Game_Action:SetAttack()
	self:SetSkill(self:Subject().attackSkillId())
end

function Game_Action:SetGuard()
	self:SetSkill(self:Subject().guardSkillId())
end

function Game_Action:SetSkill(skillId)
	self._item.setObject(Data.Skills[skillId])
end

function Game_Action:SetItem(itemId)
	self._item.setObject(Data.Items[itemId])
end

function Game_Action:SetItemObject(object)
	self._item.setObject(object)
end

function Game_Action:SetTarget(targetIndex)
	self._targetIndex = targetIndex
end

function Game_Action:Item()
	return self._item.object()
end

function Game_Action:IsSkill()
	return self._item.isSkill()
end

function Game_Action:IsItem()
	return self._item.isItem()
end

function Game_Action:NumRepeats()
	local repeats = self:Item().repeats
	if self:IsAttack() then
		repeats += self:Subject().attackTimesAdd()
	end
	return Math.floor(repeats)
end

function Game_Action:CheckItemScope(list)
	return list.includes(self:Item().scope)
end

function Game_Action:IsForOpponent()
	return self:CheckItemScope([1, 2, 3, 4, 5, 6, 14])
end

function Game_Action:IsForFriend()
	return self:CheckItemScope([7, 8, 9, 10, 11, 12, 13, 14])
end

function Game_Action:IsForEveryone()
	return self:CheckItemScope([14])
end

function Game_Action:IsForAliveFriend()
	return self:CheckItemScope([7, 8, 11, 14])
end

function Game_Action:IsForDeadFriend()
	return self:CheckItemScope([9, 10])
end

function Game_Action:IsForUser()
	return self:CheckItemScope([11])
end

function Game_Action:IsForOne()
	return self:CheckItemScope([1, 3, 7, 9, 11, 12])
end

function Game_Action:IsForRandom()
	return self:CheckItemScope([3, 4, 5, 6])
end

function Game_Action:IsForAll()
	return self:CheckItemScope([2, 8, 10, 13, 14])
end

function Game_Action:NeedsSelection()
	return self:CheckItemScope([1, 7, 9, 12])
end

function Game_Action:NumTargets()
	return self:IsForRandom() ? self:Item().scope - 2 : 0
end

function Game_Action:CheckDamageType(list)
	return list.includes(self:Item().damage.type)
end

function Game_Action:IsHpEffect()
	return self:CheckDamageType([1, 3, 5])
end

function Game_Action:IsMpEffect()
	return self:CheckDamageType([2, 4, 6])
end

function Game_Action:IsDamage()
	return self:CheckDamageType([1, 2])
end

function Game_Action:IsRecover()
	return self:CheckDamageType([3, 4])
end

function Game_Action:IsDrain()
	return self:CheckDamageType([5, 6])
end

function Game_Action:IsHpRecover()
	return self:CheckDamageType([3])
end

function Game_Action:IsMpRecover()
	return self:CheckDamageType([4])
end

function Game_Action:IsCertainHit()
	return self:Item().hitType === Game_Action.HITTYPE_CERTAIN
end

function Game_Action:IsPhysical()
	return self:Item().hitType === Game_Action.HITTYPE_PHYSICAL
end

function Game_Action:IsMagical()
	return self:Item().hitType === Game_Action.HITTYPE_MAGICAL
end

function Game_Action:IsAttack()
	return self:Item() === Data.Skills[self:Subject().attackSkillId()]
end

function Game_Action:IsGuard()
	return self:Item() === Data.Skills[self:Subject().guardSkillId()]
end

function Game_Action:IsMagicSkill()
	if self:IsSkill() then
		return Data.System.magicSkills.includes(self:Item().stypeId)
	end else {
		return false
	end
end

function Game_Action:DecideRandomTarget()
	local target
	if self:IsForDeadFriend() then
		target = self:FriendsUnit().randomDeadTarget()
	end else if self:IsForFriend() then
		target = self:FriendsUnit().randomTarget()
	end else {
		target = self:OpponentsUnit().randomTarget()
	end
	if target then
		self._targetIndex = target.index()
	end else {
		self:Clear()
	end
end

function Game_Action:SetConfusion()
	self:SetAttack()
end

function Game_Action:Prepare()
	if self:Subject().isConfused() and !self._forcing then
		self:SetConfusion()
	end
end

function Game_Action:IsValid()
	return (self._forcing and self:Item()) or self:Subject().canUse(self:Item())
end

function Game_Action:Speed()
	local agi = self:Subject().agi
	local speed = agi + Math.randomInt(Math.floor(5 + agi / 4))
	if self:Item() then
		speed += self:Item().speed
	end
	if self:IsAttack() then
		speed += self:Subject().attackSpeed()
	end
	return speed
end

function Game_Action:MakeTargets()
	local targets = []
	if !self._forcing and self:Subject().isConfused() then
		targets.push(self:ConfusionTarget())
	end else if self:IsForEveryone() then
		targets.push(...self:TargetsForEveryone())
	end else if self:IsForOpponent() then
		targets.push(...self:TargetsForOpponents())
	end else if self:IsForFriend() then
		targets.push(...self:TargetsForFriends())
	end
	return self:RepeatTargets(targets)
end

function Game_Action:RepeatTargets(targets)
	local repeatedTargets = []
	local repeats = self:NumRepeats()
	for (local target of targets) {
		if target then
			for (local i = 0 i < repeats i++) {
				repeatedTargets.push(target)
			end
		end
	end
	return repeatedTargets
end

function Game_Action:ConfusionTarget()
	switch (self:Subject().confusionLevel()) {
		case 1:
			return self:OpponentsUnit().randomTarget()
		case 2:
			if Math.randomInt(2) === 0 then
				return self:OpponentsUnit().randomTarget()
			end
			return self:FriendsUnit().randomTarget()
		default:
			return self:FriendsUnit().randomTarget()
	end
end

function Game_Action:TargetsForEveryone()
	local opponentMembers = self:OpponentsUnit().aliveMembers()
	local friendMembers = self:FriendsUnit().aliveMembers()
	return opponentMembers.concat(friendMembers)
end

function Game_Action:TargetsForOpponents()
	local unit = self:OpponentsUnit()
	if self:IsForRandom() then
		return self:RandomTargets(unit)
	end else {
		return self:TargetsForAlive(unit)
	end
end

function Game_Action:TargetsForFriends()
	local unit = self:FriendsUnit()
	if self:IsForUser() then
		return [self:Subject()]
	end else if self:IsForDeadFriend() then
		return self:TargetsForDead(unit)
	end else if self:IsForAliveFriend() then
		return self:TargetsForAlive(unit)
	end else {
		return self:TargetsForDeadAndAlive(unit)
	end
end

function Game_Action:RandomTargets(unit)
	local targets = []
	for (local i = 0 i < self:NumTargets() i++) {
		targets.push(unit.randomTarget())
	end
	return targets
end

function Game_Action:TargetsForDead(unit)
	if self:IsForOne() then
		return [unit.smoothDeadTarget(self._targetIndex)]
	end else {
		return unit.deadMembers()
	end
end

function Game_Action:TargetsForAlive(unit)
	if self:IsForOne() then
		if self._targetIndex < 0 then
			return [unit.randomTarget()]
		end else {
			return [unit.smoothTarget(self._targetIndex)]
		end
	end else {
		return unit.aliveMembers()
	end
end

function Game_Action:TargetsForDeadAndAlive(unit)
	if self:IsForOne() then
		return [unit.members()[self._targetIndex]]
	end else {
		return unit.members()
	end
end

function Game_Action:Evaluate()
	local value = 0
	for (local target of self:ItemTargetCandidates()) {
		local targetValue = self:EvaluateWithTarget(target)
		if self:IsForAll() then
			value += targetValue
		end else if targetValue > value then
			value = targetValue
			self._targetIndex = target.index()
		end
	end
	value *= self:NumRepeats()
	if value > 0 then
		value += Math.random()
	end
	return value
end

function Game_Action:ItemTargetCandidates()
	if !self:IsValid() then
		return []
	end else if self:IsForOpponent() then
		return self:OpponentsUnit().aliveMembers()
	end else if self:IsForUser() then
		return [self:Subject()]
	end else if self:IsForDeadFriend() then
		return self:FriendsUnit().deadMembers()
	end else {
		return self:FriendsUnit().aliveMembers()
	end
end

function Game_Action:EvaluateWithTarget(target)
	if self:IsHpEffect() then
		local value = self:MakeDamageValue(target, false)
		if self:IsForOpponent() then
			return value / Math.max(target.hp, 1)
		end else {
			local recovery = Math.min(-value, target.mhp - target.hp)
			return recovery / target.mhp
		end
	end
end

function Game_Action:TestApply(target)
	return self:TestLifeAndDeath(target) and (Game.Party.inBattle() or (self:IsHpRecover() and target.hp < target.mhp) or (self:IsMpRecover() and target.mp < target.mmp) or self:HasItemAnyValidEffects(target))
end

function Game_Action:TestLifeAndDeath(target)
	if self:IsForOpponent() or self:IsForAliveFriend() then
		return target.isAlive()
	end else if self:IsForDeadFriend() then
		return target.isDead()
	end else {
		return true
	end
end

function Game_Action:HasItemAnyValidEffects(target)
	return self:Item().effects.some((effect) => self:TestItemEffect(target, effect))
end

function Game_Action:TestItemEffect(target, effect)
	switch (effect.code) {
		case Game_Action.EFFECT_RECOVER_HP:
			return target.hp < target.mhp or effect.value1 < 0 or effect.value2 < 0
		case Game_Action.EFFECT_RECOVER_MP:
			return target.mp < target.mmp or effect.value1 < 0 or effect.value2 < 0
		case Game_Action.EFFECT_ADD_STATE:
			return !target.isStateAffected(effect.dataId)
		case Game_Action.EFFECT_REMOVE_STATE:
			return target.isStateAffected(effect.dataId)
		case Game_Action.EFFECT_ADD_BUFF:
			return !target.isMaxBuffAffected(effect.dataId)
		case Game_Action.EFFECT_ADD_DEBUFF:
			return !target.isMaxDebuffAffected(effect.dataId)
		case Game_Action.EFFECT_REMOVE_BUFF:
			return target.isBuffAffected(effect.dataId)
		case Game_Action.EFFECT_REMOVE_DEBUFF:
			return target.isDebuffAffected(effect.dataId)
		case Game_Action.EFFECT_LEARN_SKILL:
			return target.isActor() and !target.isLearnedSkill(effect.dataId)
		default:
			return true
	end
end

function Game_Action:ItemCnt(target)
	if self:IsPhysical() and target.canMove() then
		return target.cnt
	end else {
		return 0
	end
end

function Game_Action:ItemMrf(target)
	if self:IsMagical() then
		return target.mrf
	end else {
		return 0
	end
end

function Game_Action:ItemHit(/*target*/)
	local successRate = self:Item().successRate
	if self:IsPhysical() then
		return successRate * 0.01 * self:Subject().hit
	end else {
		return successRate * 0.01
	end
end

function Game_Action:ItemEva(target)
	if self:IsPhysical() then
		return target.eva
	end else if self:IsMagical() then
		return target.mev
	end else {
		return 0
	end
end

function Game_Action:ItemCri(target)
	return self:Item().damage.critical ? self:Subject().cri * (1 - target.cev) : 0
end

function Game_Action:Apply(target)
	local result = target.result()
	self:Subject().clearResult()
	result.clear()
	result.used = self:TestApply(target)
	result.missed = result.used and Math.random() >= self:ItemHit(target)
	result.evaded = !result.missed and Math.random() < self:ItemEva(target)
	result.physical = self:IsPhysical()
	result.drain = self:IsDrain()
	if result.isHit() then
		if self:Item().damage.type > 0 then
			result.critical = Math.random() < self:ItemCri(target)
			local value = self:MakeDamageValue(target, result.critical)
			self:ExecuteDamage(target, value)
		end
		for (local effect of self:Item().effects) {
			self:ApplyItemEffect(target, effect)
		end
		self:ApplyItemUserEffect(target)
	end
	self:UpdateLastTarget(target)
end

function Game_Action:MakeDamageValue(target, critical)
	local item = self:Item()
	local baseValue = self:EvalDamageFormula(target)
	local value = baseValue * self:CalcElementRate(target)
	if self:IsPhysical() then
		value *= target.pdr
	end
	if self:IsMagical() then
		value *= target.mdr
	end
	if baseValue < 0 then
		value *= target.rec
	end
	if critical then
		value = self:ApplyCritical(value)
	end
	value = self:ApplyVariance(value, item.damage.variance)
	value = self:ApplyGuard(value, target)
	value = Math.round(value)
	return value
end

function Game_Action:EvalDamageFormula(target)
	try {
		local item = self:Item()
		local a = self:Subject() -- eslint-disable-line no-unused-vars
		local b = target -- eslint-disable-line no-unused-vars
		local v = Game.Variables._data -- eslint-disable-line no-unused-vars
		local sign = [3, 4].includes(item.damage.type) ? -1 : 1
		local value = Math.max(eval(item.damage.formula), 0) * sign
		return isNaN(value) ? 0 : value
	end catch (e) {
		return 0
	end
end

function Game_Action:CalcElementRate(target)
	if self:Item().damage.elementId < 0 then
		return self:ElementsMaxRate(target, self:Subject().attackElements())
	end else {
		return target.elementRate(self:Item().damage.elementId)
	end
end

function Game_Action:ElementsMaxRate(target, elements)
	if elements.length > 0 then
		local rates = elements.map((elementId) => target.elementRate(elementId))
		return Math.max(...rates)
	end else {
		return 1
	end
end

function Game_Action:ApplyCritical(damage)
	return damage * 3
end

function Game_Action:ApplyVariance(damage, variance)
	local amp = Math.floor(Math.max((Math.abs(damage) * variance) / 100, 0))
	local v = Math.randomInt(amp + 1) + Math.randomInt(amp + 1) - amp
	return damage >= 0 ? damage + v : damage - v
end

function Game_Action:ApplyGuard(damage, target)
	return damage / (damage > 0 and target.isGuard() ? 2 * target.grd : 1)
end

function Game_Action:ExecuteDamage(target, value)
	local result = target.result()
	if value === 0 then
		result.critical = false
	end
	if self:IsHpEffect() then
		self:ExecuteHpDamage(target, value)
	end
	if self:IsMpEffect() then
		self:ExecuteMpDamage(target, value)
	end
end

function Game_Action:ExecuteHpDamage(target, value)
	if self:IsDrain() then
		value = Math.min(target.hp, value)
	end
	self:MakeSuccess(target)
	target.gainHp(-value)
	if value > 0 then
		target.onDamage(value)
	end
	self:GainDrainedHp(value)
end

function Game_Action:ExecuteMpDamage(target, value)
	if !self:IsMpRecover() then
		value = Math.min(target.mp, value)
	end
	if value ~= 0 then
		self:MakeSuccess(target)
	end
	target.gainMp(-value)
	self:GainDrainedMp(value)
end

function Game_Action:GainDrainedHp(value)
	if self:IsDrain() then
		local gainTarget = self:Subject()
		if self._reflectionTarget then
			gainTarget = self._reflectionTarget
		end
		gainTarget.gainHp(value)
	end
end

function Game_Action:GainDrainedMp(value)
	if self:IsDrain() then
		local gainTarget = self:Subject()
		if self._reflectionTarget then
			gainTarget = self._reflectionTarget
		end
		gainTarget.gainMp(value)
	end
end

function Game_Action:ApplyItemEffect(target, effect)
	switch (effect.code) {
		case Game_Action.EFFECT_RECOVER_HP:
			self:ItemEffectRecoverHp(target, effect)
			break
		case Game_Action.EFFECT_RECOVER_MP:
			self:ItemEffectRecoverMp(target, effect)
			break
		case Game_Action.EFFECT_GAIN_TP:
			self:ItemEffectGainTp(target, effect)
			break
		case Game_Action.EFFECT_ADD_STATE:
			self:ItemEffectAddState(target, effect)
			break
		case Game_Action.EFFECT_REMOVE_STATE:
			self:ItemEffectRemoveState(target, effect)
			break
		case Game_Action.EFFECT_ADD_BUFF:
			self:ItemEffectAddBuff(target, effect)
			break
		case Game_Action.EFFECT_ADD_DEBUFF:
			self:ItemEffectAddDebuff(target, effect)
			break
		case Game_Action.EFFECT_REMOVE_BUFF:
			self:ItemEffectRemoveBuff(target, effect)
			break
		case Game_Action.EFFECT_REMOVE_DEBUFF:
			self:ItemEffectRemoveDebuff(target, effect)
			break
		case Game_Action.EFFECT_SPECIAL:
			self:ItemEffectSpecial(target, effect)
			break
		case Game_Action.EFFECT_GROW:
			self:ItemEffectGrow(target, effect)
			break
		case Game_Action.EFFECT_LEARN_SKILL:
			self:ItemEffectLearnSkill(target, effect)
			break
		case Game_Action.EFFECT_COMMON_EVENT:
			self:ItemEffectCommonEvent(target, effect)
			break
	end
end

function Game_Action:ItemEffectRecoverHp(target, effect)
	local value = (target.mhp * effect.value1 + effect.value2) * target.rec
	if self:IsItem() then
		value *= self:Subject().pha
	end
	value = Math.floor(value)
	if value ~= 0 then
		target.gainHp(value)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectRecoverMp(target, effect)
	local value = (target.mmp * effect.value1 + effect.value2) * target.rec
	if self:IsItem() then
		value *= self:Subject().pha
	end
	value = Math.floor(value)
	if value ~= 0 then
		target.gainMp(value)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectGainTp(target, effect)
	local value = Math.floor(effect.value1)
	if value ~= 0 then
		target.gainTp(value)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectAddState(target, effect)
	if effect.dataId === 0 then
		self:ItemEffectAddAttackState(target, effect)
	end else {
		self:ItemEffectAddNormalState(target, effect)
	end
end

function Game_Action:ItemEffectAddAttackState(target, effect)
	for (local stateId of self:Subject().attackStates()) {
		local chance = effect.value1
		chance *= target.stateRate(stateId)
		chance *= self:Subject().attackStatesRate(stateId)
		chance *= self:LukEffectRate(target)
		if Math.random() < chance then
			target.addState(stateId)
			self:MakeSuccess(target)
		end
	end
end

function Game_Action:ItemEffectAddNormalState(target, effect)
	local chance = effect.value1
	if !self:IsCertainHit() then
		chance *= target.stateRate(effect.dataId)
		chance *= self:LukEffectRate(target)
	end
	if Math.random() < chance then
		target.addState(effect.dataId)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectRemoveState(target, effect)
	local chance = effect.value1
	if Math.random() < chance then
		target.removeState(effect.dataId)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectAddBuff(target, effect)
	target.addBuff(effect.dataId, effect.value1)
	self:MakeSuccess(target)
end

function Game_Action:ItemEffectAddDebuff(target, effect)
	local chance = target.debuffRate(effect.dataId) * self:LukEffectRate(target)
	if Math.random() < chance then
		target.addDebuff(effect.dataId, effect.value1)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectRemoveBuff(target, effect)
	if target.isBuffAffected(effect.dataId) then
		target.removeBuff(effect.dataId)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectRemoveDebuff(target, effect)
	if target.isDebuffAffected(effect.dataId) then
		target.removeBuff(effect.dataId)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectSpecial(target, effect)
	if effect.dataId === Game_Action.SPECIAL_EFFECT_ESCAPE then
		target.escape()
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectGrow(target, effect)
	target.addParam(effect.dataId, Math.floor(effect.value1))
	self:MakeSuccess(target)
end

function Game_Action:ItemEffectLearnSkill(target, effect)
	if target.isActor() then
		target.learnSkill(effect.dataId)
		self:MakeSuccess(target)
	end
end

function Game_Action:ItemEffectCommonEvent(/*target, effect*/)
	--
end

function Game_Action:MakeSuccess(target)
	target.result().success = true
end

function Game_Action:ApplyItemUserEffect(/*target*/)
	local value = Math.floor(self:Item().tpGain * self:Subject().tcr)
	self:Subject().gainSilentTp(value)
end

function Game_Action:LukEffectRate(target)
	return Math.max(1.0 + (self:Subject().luk - target.luk) * 0.001, 0.0)
end

function Game_Action:ApplyGlobal()
	for (local effect of self:Item().effects) {
		if effect.code === Game_Action.EFFECT_COMMON_EVENT then
			Game.Temp.reserveCommonEvent(effect.dataId)
		end
	end
	self:UpdateLastUsed()
	self:UpdateLastSubject()
end

function Game_Action:UpdateLastUsed()
	local item = self:Item()
	if DataManager.isSkill(item) then
		Game.Temp.setLastUsedSkillId(item.id)
	end else if DataManager.isItem(item) then
		Game.Temp.setLastUsedItemId(item.id)
	end
end

function Game_Action:UpdateLastSubject()
	local subject = self:Subject()
	if subject.isActor() then
		Game.Temp.setLastSubjectActorId(subject.actorId())
	end else {
		Game.Temp.setLastSubjectEnemyIndex(subject.index() + 1)
	end
end

function Game_Action:UpdateLastTarget(target)
	if target.isActor() then
		Game.Temp.setLastTargetActorId(target.actorId())
	end else {
		Game.Temp.setLastTargetEnemyIndex(target.index() + 1)
	end
end

-------------------------------------------------------------------------------
-- Game_ActionResult
--
-- The game object class for a result of a battle action. For convinience, all
-- member variables in this class are public.

function Game_ActionResult.new()
	self:Initialize(...arguments)
end

function Game_ActionResult:Initialize()
	self:Clear()
end

function Game_ActionResult:Clear()
	self:Used = false
	self:Missed = false
	self:Evaded = false
	self:Physical = false
	self:Drain = false
	self:Critical = false
	self:Success = false
	self:HpAffected = false
	self:HpDamage = 0
	self:MpDamage = 0
	self:TpDamage = 0
	self:AddedStates = []
	self:RemovedStates = []
	self:AddedBuffs = []
	self:AddedDebuffs = []
	self:RemovedBuffs = []
end

function Game_ActionResult:AddedStateObjects()
	return self:AddedStates.map((id) => Data.States[id])
end

function Game_ActionResult:RemovedStateObjects()
	return self:RemovedStates.map((id) => Data.States[id])
end

function Game_ActionResult:IsStatusAffected()
	return self:AddedStates.length > 0 or self:RemovedStates.length > 0 or self:AddedBuffs.length > 0 or self:AddedDebuffs.length > 0 or self:RemovedBuffs.length > 0
end

function Game_ActionResult:IsHit()
	return self:Used and !self:Missed and !self:Evaded
end

function Game_ActionResult:IsStateAdded(stateId)
	return self:AddedStates.includes(stateId)
end

function Game_ActionResult:PushAddedState(stateId)
	if !self:IsStateAdded(stateId) then
		self:AddedStates.push(stateId)
	end
end

function Game_ActionResult:IsStateRemoved(stateId)
	return self:RemovedStates.includes(stateId)
end

function Game_ActionResult:PushRemovedState(stateId)
	if !self:IsStateRemoved(stateId) then
		self:RemovedStates.push(stateId)
	end
end

function Game_ActionResult:IsBuffAdded(paramId)
	return self:AddedBuffs.includes(paramId)
end

function Game_ActionResult:PushAddedBuff(paramId)
	if !self:IsBuffAdded(paramId) then
		self:AddedBuffs.push(paramId)
	end
end

function Game_ActionResult:IsDebuffAdded(paramId)
	return self:AddedDebuffs.includes(paramId)
end

function Game_ActionResult:PushAddedDebuff(paramId)
	if !self:IsDebuffAdded(paramId) then
		self:AddedDebuffs.push(paramId)
	end
end

function Game_ActionResult:IsBuffRemoved(paramId)
	return self:RemovedBuffs.includes(paramId)
end

function Game_ActionResult:PushRemovedBuff(paramId)
	if !self:IsBuffRemoved(paramId) then
		self:RemovedBuffs.push(paramId)
	end
end

-------------------------------------------------------------------------------
-- Game_BattlerBase
--
-- The superclass of Game_Battler. It mainly contains parameters calculation.

function Game_BattlerBase.new()
	self:Initialize(...arguments)
end

Game_BattlerBase.TRAIT_ELEMENT_RATE = 11
Game_BattlerBase.TRAIT_DEBUFF_RATE = 12
Game_BattlerBase.TRAIT_STATE_RATE = 13
Game_BattlerBase.TRAIT_STATE_RESIST = 14
Game_BattlerBase.TRAIT_PARAM = 21
Game_BattlerBase.TRAIT_XPARAM = 22
Game_BattlerBase.TRAIT_SPARAM = 23
Game_BattlerBase.TRAIT_ATTACK_ELEMENT = 31
Game_BattlerBase.TRAIT_ATTACK_STATE = 32
Game_BattlerBase.TRAIT_ATTACK_SPEED = 33
Game_BattlerBase.TRAIT_ATTACK_TIMES = 34
Game_BattlerBase.TRAIT_ATTACK_SKILL = 35
Game_BattlerBase.TRAIT_STYPE_ADD = 41
Game_BattlerBase.TRAIT_STYPE_SEAL = 42
Game_BattlerBase.TRAIT_SKILL_ADD = 43
Game_BattlerBase.TRAIT_SKILL_SEAL = 44
Game_BattlerBase.TRAIT_EQUIP_WTYPE = 51
Game_BattlerBase.TRAIT_EQUIP_ATYPE = 52
Game_BattlerBase.TRAIT_EQUIP_LOCK = 53
Game_BattlerBase.TRAIT_EQUIP_SEAL = 54
Game_BattlerBase.TRAIT_SLOT_TYPE = 55
Game_BattlerBase.TRAIT_ACTION_PLUS = 61
Game_BattlerBase.TRAIT_SPECIAL_FLAG = 62
Game_BattlerBase.TRAIT_COLLAPSE_TYPE = 63
Game_BattlerBase.TRAIT_PARTY_ABILITY = 64
Game_BattlerBase.FLAG_ID_AUTO_BATTLE = 0
Game_BattlerBase.FLAG_ID_GUARD = 1
Game_BattlerBase.FLAG_ID_SUBSTITUTE = 2
Game_BattlerBase.FLAG_ID_PRESERVE_TP = 3
Game_BattlerBase.ICON_BUFF_START = 32
Game_BattlerBase.ICON_DEBUFF_START = 48

Object.defineProperties(Game_BattlerBase.prototype, {
	-- Hit Points
	hp: {
		get: function .new()
			return self._hp
		end,
		configurable: true,
	end,
	-- Magic Points
	mp: {
		get: function .new()
			return self._mp
		end,
		configurable: true,
	end,
	-- Tactical Points
	tp: {
		get: function .new()
			return self._tp
		end,
		configurable: true,
	end,
	-- Maximum Hit Points
	mhp: {
		get: function .new()
			return self:Param(0)
		end,
		configurable: true,
	end,
	-- Maximum Magic Points
	mmp: {
		get: function .new()
			return self:Param(1)
		end,
		configurable: true,
	end,
	-- ATtacK power
	atk: {
		get: function .new()
			return self:Param(2)
		end,
		configurable: true,
	end,
	-- DEFense power
	def: {
		get: function .new()
			return self:Param(3)
		end,
		configurable: true,
	end,
	-- Magic ATtack power
	mat: {
		get: function .new()
			return self:Param(4)
		end,
		configurable: true,
	end,
	-- Magic DeFense power
	mdf: {
		get: function .new()
			return self:Param(5)
		end,
		configurable: true,
	end,
	-- AGIlity
	agi: {
		get: function .new()
			return self:Param(6)
		end,
		configurable: true,
	end,
	-- LUcK
	luk: {
		get: function .new()
			return self:Param(7)
		end,
		configurable: true,
	end,
	-- HIT rate
	hit: {
		get: function .new()
			return self:Xparam(0)
		end,
		configurable: true,
	end,
	-- EVAsion rate
	eva: {
		get: function .new()
			return self:Xparam(1)
		end,
		configurable: true,
	end,
	-- CRItical rate
	cri: {
		get: function .new()
			return self:Xparam(2)
		end,
		configurable: true,
	end,
	-- Critical EVasion rate
	cev: {
		get: function .new()
			return self:Xparam(3)
		end,
		configurable: true,
	end,
	-- Magic EVasion rate
	mev: {
		get: function .new()
			return self:Xparam(4)
		end,
		configurable: true,
	end,
	-- Magic ReFlection rate
	mrf: {
		get: function .new()
			return self:Xparam(5)
		end,
		configurable: true,
	end,
	-- CouNTer attack rate
	cnt: {
		get: function .new()
			return self:Xparam(6)
		end,
		configurable: true,
	end,
	-- Hp ReGeneration rate
	hrg: {
		get: function .new()
			return self:Xparam(7)
		end,
		configurable: true,
	end,
	-- Mp ReGeneration rate
	mrg: {
		get: function .new()
			return self:Xparam(8)
		end,
		configurable: true,
	end,
	-- Tp ReGeneration rate
	trg: {
		get: function .new()
			return self:Xparam(9)
		end,
		configurable: true,
	end,
	-- TarGet Rate
	tgr: {
		get: function .new()
			return self:Sparam(0)
		end,
		configurable: true,
	end,
	-- GuaRD effect rate
	grd: {
		get: function .new()
			return self:Sparam(1)
		end,
		configurable: true,
	end,
	-- RECovery effect rate
	rec: {
		get: function .new()
			return self:Sparam(2)
		end,
		configurable: true,
	end,
	-- PHArmacology
	pha: {
		get: function .new()
			return self:Sparam(3)
		end,
		configurable: true,
	end,
	-- Mp Cost Rate
	mcr: {
		get: function .new()
			return self:Sparam(4)
		end,
		configurable: true,
	end,
	-- Tp Charge Rate
	tcr: {
		get: function .new()
			return self:Sparam(5)
		end,
		configurable: true,
	end,
	-- Physical Damage Rate
	pdr: {
		get: function .new()
			return self:Sparam(6)
		end,
		configurable: true,
	end,
	-- Magic Damage Rate
	mdr: {
		get: function .new()
			return self:Sparam(7)
		end,
		configurable: true,
	end,
	-- Floor Damage Rate
	fdr: {
		get: function .new()
			return self:Sparam(8)
		end,
		configurable: true,
	end,
	-- EXperience Rate
	exr: {
		get: function .new()
			return self:Sparam(9)
		end,
		configurable: true,
	end,
end)

function Game_BattlerBase:Initialize()
	self:InitMembers()
end

function Game_BattlerBase:InitMembers()
	self._hp = 1
	self._mp = 0
	self._tp = 0
	self._hidden = false
	self:ClearParamPlus()
	self:ClearStates()
	self:ClearBuffs()
end

function Game_BattlerBase:ClearParamPlus()
	self._paramPlus = [0, 0, 0, 0, 0, 0, 0, 0]
end

function Game_BattlerBase:ClearStates()
	self._states = []
	self._stateTurns = {end
end

function Game_BattlerBase:EraseState(stateId)
	self._states.remove(stateId)
	delete self._stateTurns[stateId]
end

function Game_BattlerBase:IsStateAffected(stateId)
	return self._states.includes(stateId)
end

function Game_BattlerBase:IsDeathStateAffected()
	return self:IsStateAffected(self:DeathStateId())
end

function Game_BattlerBase:DeathStateId()
	return 1
end

function Game_BattlerBase:ResetStateCounts(stateId)
	local state = Data.States[stateId]
	local variance = 1 + Math.max(state.maxTurns - state.minTurns, 0)
	self._stateTurns[stateId] = state.minTurns + Math.randomInt(variance)
end

function Game_BattlerBase:IsStateExpired(stateId)
	return self._stateTurns[stateId] === 0
end

function Game_BattlerBase:UpdateStateTurns()
	for (local stateId of self._states) {
		if self._stateTurns[stateId] > 0 then
			self._stateTurns[stateId]--
		end
	end
end

function Game_BattlerBase:ClearBuffs()
	self._buffs = [0, 0, 0, 0, 0, 0, 0, 0]
	self._buffTurns = [0, 0, 0, 0, 0, 0, 0, 0]
end

function Game_BattlerBase:EraseBuff(paramId)
	self._buffs[paramId] = 0
	self._buffTurns[paramId] = 0
end

function Game_BattlerBase:BuffLength()
	return self._buffs.length
end

function Game_BattlerBase:Buff(paramId)
	return self._buffs[paramId]
end

function Game_BattlerBase:IsBuffAffected(paramId)
	return self._buffs[paramId] > 0
end

function Game_BattlerBase:IsDebuffAffected(paramId)
	return self._buffs[paramId] < 0
end

function Game_BattlerBase:IsBuffOrDebuffAffected(paramId)
	return self._buffs[paramId] ~= 0
end

function Game_BattlerBase:IsMaxBuffAffected(paramId)
	return self._buffs[paramId] === 2
end

function Game_BattlerBase:IsMaxDebuffAffected(paramId)
	return self._buffs[paramId] === -2
end

function Game_BattlerBase:IncreaseBuff(paramId)
	if !self:IsMaxBuffAffected(paramId) then
		self._buffs[paramId]++
	end
end

function Game_BattlerBase:DecreaseBuff(paramId)
	if !self:IsMaxDebuffAffected(paramId) then
		self._buffs[paramId]--
	end
end

function Game_BattlerBase:OverwriteBuffTurns(paramId, turns)
	if self._buffTurns[paramId] < turns then
		self._buffTurns[paramId] = turns
	end
end

function Game_BattlerBase:IsBuffExpired(paramId)
	return self._buffTurns[paramId] === 0
end

function Game_BattlerBase:UpdateBuffTurns()
	for (local i = 0 i < self._buffTurns.length i++) {
		if self._buffTurns[i] > 0 then
			self._buffTurns[i]--
		end
	end
end

function Game_BattlerBase:Die()
	self._hp = 0
	self:ClearStates()
	self:ClearBuffs()
end

function Game_BattlerBase:Revive()
	if self._hp === 0 then
		self._hp = 1
	end
end

function Game_BattlerBase:States()
	return self._states.map((id) => Data.States[id])
end

function Game_BattlerBase:StateIcons()
	return self:States()
		.map((state) => state.iconIndex)
		.filter((iconIndex) => iconIndex > 0)
end

function Game_BattlerBase:BuffIcons()
	local icons = []
	for (local i = 0 i < self._buffs.length i++) {
		if self._buffs[i] ~= 0 then
			icons.push(self:BuffIconIndex(self._buffs[i], i))
		end
	end
	return icons
end

function Game_BattlerBase:BuffIconIndex(buffLevel, paramId)
	if buffLevel > 0 then
		return Game_BattlerBase.ICON_BUFF_START + (buffLevel - 1) * 8 + paramId
	end else if buffLevel < 0 then
		return Game_BattlerBase.ICON_DEBUFF_START + (-buffLevel - 1) * 8 + paramId
	end else {
		return 0
	end
end

function Game_BattlerBase:AllIcons()
	return self:StateIcons().concat(self:BuffIcons())
end

function Game_BattlerBase:TraitObjects()
	-- Returns an array of the all objects having traits. States only here.
	return self:States()
end

function Game_BattlerBase:AllTraits()
	return self:TraitObjects().reduce((r, obj) => r.concat(obj.traits), [])
end

function Game_BattlerBase:Traits(code)
	return self:AllTraits().filter((trait) => trait.code === code)
end

function Game_BattlerBase:TraitsWithId(code, id)
	return self:AllTraits().filter((trait) => trait.code === code and trait.dataId === id)
end

function Game_BattlerBase:TraitsPi(code, id)
	return self:TraitsWithId(code, id).reduce((r, trait) => r * trait.value, 1)
end

function Game_BattlerBase:TraitsSum(code, id)
	return self:TraitsWithId(code, id).reduce((r, trait) => r + trait.value, 0)
end

function Game_BattlerBase:TraitsSumAll(code)
	return self:Traits(code).reduce((r, trait) => r + trait.value, 0)
end

function Game_BattlerBase:TraitsSet(code)
	return self:Traits(code).reduce((r, trait) => r.concat(trait.dataId), [])
end

function Game_BattlerBase:ParamBase(/*paramId*/)
	return 0
end

function Game_BattlerBase:ParamPlus(paramId)
	return self._paramPlus[paramId]
end

function Game_BattlerBase:ParamBasePlus(paramId)
	return Math.max(0, self:ParamBase(paramId) + self:ParamPlus(paramId))
end

function Game_BattlerBase:ParamMin(paramId)
	if paramId === 0 then
		return 1 -- MHP
	end else {
		return 0
	end
end

function Game_BattlerBase:ParamMax(/*paramId*/)
	return Infinity
end

function Game_BattlerBase:ParamRate(paramId)
	return self:TraitsPi(Game_BattlerBase.TRAIT_PARAM, paramId)
end

function Game_BattlerBase:ParamBuffRate(paramId)
	return self._buffs[paramId] * 0.25 + 1.0
end

function Game_BattlerBase:Param(paramId)
	local value = self:ParamBasePlus(paramId) * self:ParamRate(paramId) * self:ParamBuffRate(paramId)
	local maxValue = self:ParamMax(paramId)
	local minValue = self:ParamMin(paramId)
	return Math.round(value.clamp(minValue, maxValue))
end

function Game_BattlerBase:Xparam(xparamId)
	return self:TraitsSum(Game_BattlerBase.TRAIT_XPARAM, xparamId)
end

function Game_BattlerBase:Sparam(sparamId)
	return self:TraitsPi(Game_BattlerBase.TRAIT_SPARAM, sparamId)
end

function Game_BattlerBase:ElementRate(elementId)
	return self:TraitsPi(Game_BattlerBase.TRAIT_ELEMENT_RATE, elementId)
end

function Game_BattlerBase:DebuffRate(paramId)
	return self:TraitsPi(Game_BattlerBase.TRAIT_DEBUFF_RATE, paramId)
end

function Game_BattlerBase:StateRate(stateId)
	return self:TraitsPi(Game_BattlerBase.TRAIT_STATE_RATE, stateId)
end

function Game_BattlerBase:StateResistSet()
	return self:TraitsSet(Game_BattlerBase.TRAIT_STATE_RESIST)
end

function Game_BattlerBase:IsStateResist(stateId)
	return self:StateResistSet().includes(stateId)
end

function Game_BattlerBase:AttackElements()
	return self:TraitsSet(Game_BattlerBase.TRAIT_ATTACK_ELEMENT)
end

function Game_BattlerBase:AttackStates()
	return self:TraitsSet(Game_BattlerBase.TRAIT_ATTACK_STATE)
end

function Game_BattlerBase:AttackStatesRate(stateId)
	return self:TraitsSum(Game_BattlerBase.TRAIT_ATTACK_STATE, stateId)
end

function Game_BattlerBase:AttackSpeed()
	return self:TraitsSumAll(Game_BattlerBase.TRAIT_ATTACK_SPEED)
end

function Game_BattlerBase:AttackTimesAdd()
	return Math.max(self:TraitsSumAll(Game_BattlerBase.TRAIT_ATTACK_TIMES), 0)
end

function Game_BattlerBase:AttackSkillId()
	local set = self:TraitsSet(Game_BattlerBase.TRAIT_ATTACK_SKILL)
	return set.length > 0 ? Math.max(...set) : 1
end

function Game_BattlerBase:AddedSkillTypes()
	return self:TraitsSet(Game_BattlerBase.TRAIT_STYPE_ADD)
end

function Game_BattlerBase:IsSkillTypeSealed(stypeId)
	return self:TraitsSet(Game_BattlerBase.TRAIT_STYPE_SEAL).includes(stypeId)
end

function Game_BattlerBase:AddedSkills()
	return self:TraitsSet(Game_BattlerBase.TRAIT_SKILL_ADD)
end

function Game_BattlerBase:IsSkillSealed(skillId)
	return self:TraitsSet(Game_BattlerBase.TRAIT_SKILL_SEAL).includes(skillId)
end

function Game_BattlerBase:IsEquipWtypeOk(wtypeId)
	return self:TraitsSet(Game_BattlerBase.TRAIT_EQUIP_WTYPE).includes(wtypeId)
end

function Game_BattlerBase:IsEquipAtypeOk(atypeId)
	return self:TraitsSet(Game_BattlerBase.TRAIT_EQUIP_ATYPE).includes(atypeId)
end

function Game_BattlerBase:IsEquipTypeLocked(etypeId)
	return self:TraitsSet(Game_BattlerBase.TRAIT_EQUIP_LOCK).includes(etypeId)
end

function Game_BattlerBase:IsEquipTypeSealed(etypeId)
	return self:TraitsSet(Game_BattlerBase.TRAIT_EQUIP_SEAL).includes(etypeId)
end

function Game_BattlerBase:SlotType()
	local set = self:TraitsSet(Game_BattlerBase.TRAIT_SLOT_TYPE)
	return set.length > 0 ? Math.max(...set) : 0
end

function Game_BattlerBase:IsDualWield()
	return self:SlotType() === 1
end

function Game_BattlerBase:ActionPlusSet()
	return self:Traits(Game_BattlerBase.TRAIT_ACTION_PLUS).map((trait) => trait.value)
end

function Game_BattlerBase:SpecialFlag(flagId)
	return self:Traits(Game_BattlerBase.TRAIT_SPECIAL_FLAG).some((trait) => trait.dataId === flagId)
end

function Game_BattlerBase:CollapseType()
	local set = self:TraitsSet(Game_BattlerBase.TRAIT_COLLAPSE_TYPE)
	return set.length > 0 ? Math.max(...set) : 0
end

function Game_BattlerBase:PartyAbility(abilityId)
	return self:Traits(Game_BattlerBase.TRAIT_PARTY_ABILITY).some((trait) => trait.dataId === abilityId)
end

function Game_BattlerBase:IsAutoBattle()
	return self:SpecialFlag(Game_BattlerBase.FLAG_ID_AUTO_BATTLE)
end

function Game_BattlerBase:IsGuard()
	return self:SpecialFlag(Game_BattlerBase.FLAG_ID_GUARD) and self:CanMove()
end

function Game_BattlerBase:IsSubstitute()
	return self:SpecialFlag(Game_BattlerBase.FLAG_ID_SUBSTITUTE) and self:CanMove()
end

function Game_BattlerBase:IsPreserveTp()
	return self:SpecialFlag(Game_BattlerBase.FLAG_ID_PRESERVE_TP)
end

function Game_BattlerBase:AddParam(paramId, value)
	self._paramPlus[paramId] += value
	self:Refresh()
end

function Game_BattlerBase:SetHp(hp)
	self._hp = hp
	self:Refresh()
end

function Game_BattlerBase:SetMp(mp)
	self._mp = mp
	self:Refresh()
end

function Game_BattlerBase:SetTp(tp)
	self._tp = tp
	self:Refresh()
end

function Game_BattlerBase:MaxTp()
	return 100
end

function Game_BattlerBase:Refresh()
	for (local stateId of self:StateResistSet()) {
		self:EraseState(stateId)
	end
	self._hp = self._hp.clamp(0, self:Mhp)
	self._mp = self._mp.clamp(0, self:Mmp)
	self._tp = self._tp.clamp(0, self:MaxTp())
end

function Game_BattlerBase:RecoverAll()
	self:ClearStates()
	self._hp = self:Mhp
	self._mp = self:Mmp
end

function Game_BattlerBase:HpRate()
	return self:Hp / self:Mhp
end

function Game_BattlerBase:MpRate()
	return self:Mmp > 0 ? self:Mp / self:Mmp : 0
end

function Game_BattlerBase:TpRate()
	return self:Tp / self:MaxTp()
end

function Game_BattlerBase:Hide()
	self._hidden = true
end

function Game_BattlerBase:Appear()
	self._hidden = false
end

function Game_BattlerBase:IsHidden()
	return self._hidden
end

function Game_BattlerBase:IsAppeared()
	return !self:IsHidden()
end

function Game_BattlerBase:IsDead()
	return self:IsAppeared() and self:IsDeathStateAffected()
end

function Game_BattlerBase:IsAlive()
	return self:IsAppeared() and !self:IsDeathStateAffected()
end

function Game_BattlerBase:IsDying()
	return self:IsAlive() and self._hp < self:Mhp / 4
end

function Game_BattlerBase:IsRestricted()
	return self:IsAppeared() and self:Restriction() > 0
end

function Game_BattlerBase:CanInput()
	-- prettier-ignore
	return self:IsAppeared() and self:IsActor() &&
			!self:IsRestricted() and !self:IsAutoBattle()
end

function Game_BattlerBase:CanMove()
	return self:IsAppeared() and self:Restriction() < 4
end

function Game_BattlerBase:IsConfused()
	return self:IsAppeared() and self:Restriction() >= 1 and self:Restriction() <= 3
end

function Game_BattlerBase:ConfusionLevel()
	return self:IsConfused() ? self:Restriction() : 0
end

function Game_BattlerBase:IsActor()
	return false
end

function Game_BattlerBase:IsEnemy()
	return false
end

function Game_BattlerBase:SortStates()
	self._states.sort((a, b) => {
		local p1 = Data.States[a].priority
		local p2 = Data.States[b].priority
		if p1 ~= p2 then
			return p2 - p1
		end
		return a - b
	end)
end

function Game_BattlerBase:Restriction()
	local restrictions = self:States().map((state) => state.restriction)
	return Math.max(0, ...restrictions)
end

function Game_BattlerBase:AddNewState(stateId)
	if stateId === self:DeathStateId() then
		self:Die()
	end
	local restricted = self:IsRestricted()
	self._states.push(stateId)
	self:SortStates()
	if !restricted and self:IsRestricted() then
		self:OnRestrict()
	end
end

function Game_BattlerBase:OnRestrict()
	--
end

function Game_BattlerBase:MostImportantStateText()
	for (local state of self:States()) {
		if state.message3 then
			return state.message3
		end
	end
	return ""
end

function Game_BattlerBase:StateMotionIndex()
	local states = self:States()
	if states.length > 0 then
		return states[0].motion
	end else {
		return 0
	end
end

function Game_BattlerBase:StateOverlayIndex()
	local states = self:States()
	if states.length > 0 then
		return states[0].overlay
	end else {
		return 0
	end
end

function Game_BattlerBase:IsSkillWtypeOk(/*skill*/)
	return true
end

function Game_BattlerBase:SkillMpCost(skill)
	return Math.floor(skill.mpCost * self:Mcr)
end

function Game_BattlerBase:SkillTpCost(skill)
	return skill.tpCost
end

function Game_BattlerBase:CanPaySkillCost(skill)
	return self._tp >= self:SkillTpCost(skill) and self._mp >= self:SkillMpCost(skill)
end

function Game_BattlerBase:PaySkillCost(skill)
	self._mp -= self:SkillMpCost(skill)
	self._tp -= self:SkillTpCost(skill)
end

function Game_BattlerBase:IsOccasionOk(item)
	if Game.Party.inBattle() then
		return item.occasion === 0 or item.occasion === 1
	end else {
		return item.occasion === 0 or item.occasion === 2
	end
end

function Game_BattlerBase:MeetsUsableItemConditions(item)
	return self:CanMove() and self:IsOccasionOk(item)
end

function Game_BattlerBase:MeetsSkillConditions(skill)
	return self:MeetsUsableItemConditions(skill) and self:IsSkillWtypeOk(skill) and self:CanPaySkillCost(skill) and !self:IsSkillSealed(skill.id) and !self:IsSkillTypeSealed(skill.stypeId)
end

function Game_BattlerBase:MeetsItemConditions(item)
	return self:MeetsUsableItemConditions(item) and Game.Party.hasItem(item)
end

function Game_BattlerBase:CanUse(item)
	if !item then
		return false
	end else if DataManager.isSkill(item) then
		return self:MeetsSkillConditions(item)
	end else if DataManager.isItem(item) then
		return self:MeetsItemConditions(item)
	end else {
		return false
	end
end

function Game_BattlerBase:CanEquip(item)
	if !item then
		return false
	end else if DataManager.isWeapon(item) then
		return self:CanEquipWeapon(item)
	end else if DataManager.isArmor(item) then
		return self:CanEquipArmor(item)
	end else {
		return false
	end
end

function Game_BattlerBase:CanEquipWeapon(item)
	return self:IsEquipWtypeOk(item.wtypeId) and !self:IsEquipTypeSealed(item.etypeId)
end

function Game_BattlerBase:CanEquipArmor(item)
	return self:IsEquipAtypeOk(item.atypeId) and !self:IsEquipTypeSealed(item.etypeId)
end

function Game_BattlerBase:GuardSkillId()
	return 2
end

function Game_BattlerBase:CanAttack()
	return self:CanUse(Data.Skills[self:AttackSkillId()])
end

function Game_BattlerBase:CanGuard()
	return self:CanUse(Data.Skills[self:GuardSkillId()])
end

-------------------------------------------------------------------------------
-- Game_Battler
--
-- The superclass of Game_Actor and Game_Enemy. It contains methods for sprites
-- and actions.

function Game_Battler.new()
	self:Initialize(...arguments)
end

Game_Battler.prototype = Object.create(Game_BattlerBase.prototype)
Game_Battler.prototype.constructor = Game_Battler

function Game_Battler:Initialize()
	Game_BattlerBase.prototype.initialize.call(this)
end

function Game_Battler:InitMembers()
	Game_BattlerBase.prototype.initMembers.call(this)
	self._actions = []
	self._speed = 0
	self._result = new Game_ActionResult()
	self._actionState = ""
	self._lastTargetIndex = 0
	self._damagePopup = false
	self._effectType = nil
	self._motionType = nil
	self._weaponImageId = 0
	self._motionRefresh = false
	self._selected = false
	self._tpbState = ""
	self._tpbChargeTime = 0
	self._tpbCastTime = 0
	self._tpbIdleTime = 0
	self._tpbTurnCount = 0
	self._tpbTurnEnd = false
end

function Game_Battler:ClearDamagePopup()
	self._damagePopup = false
end

function Game_Battler:ClearWeaponAnimation()
	self._weaponImageId = 0
end

function Game_Battler:ClearEffect()
	self._effectType = nil
end

function Game_Battler:ClearMotion()
	self._motionType = nil
	self._motionRefresh = false
end

function Game_Battler:RequestEffect(effectType)
	self._effectType = effectType
end

function Game_Battler:RequestMotion(motionType)
	self._motionType = motionType
end

function Game_Battler:RequestMotionRefresh()
	self._motionRefresh = true
end

function Game_Battler:CancelMotionRefresh()
	self._motionRefresh = false
end

function Game_Battler:Select()
	self._selected = true
end

function Game_Battler:Deselect()
	self._selected = false
end

function Game_Battler:IsDamagePopupRequested()
	return self._damagePopup
end

function Game_Battler:IsEffectRequested()
	return !!self._effectType
end

function Game_Battler:IsMotionRequested()
	return !!self._motionType
end

function Game_Battler:IsWeaponAnimationRequested()
	return self._weaponImageId > 0
end

function Game_Battler:IsMotionRefreshRequested()
	return self._motionRefresh
end

function Game_Battler:IsSelected()
	return self._selected
end

function Game_Battler:EffectType()
	return self._effectType
end

function Game_Battler:MotionType()
	return self._motionType
end

function Game_Battler:WeaponImageId()
	return self._weaponImageId
end

function Game_Battler:StartDamagePopup()
	self._damagePopup = true
end

function Game_Battler:ShouldPopupDamage()
	local result = self._result
	return result.missed or result.evaded or result.hpAffected or result.mpDamage ~= 0
end

function Game_Battler:StartWeaponAnimation(weaponImageId)
	self._weaponImageId = weaponImageId
end

function Game_Battler:Action(index)
	return self._actions[index]
end

function Game_Battler:SetAction(index, action)
	self._actions[index] = action
end

function Game_Battler:NumActions()
	return self._actions.length
end

function Game_Battler:ClearActions()
	self._actions = []
end

function Game_Battler:Result()
	return self._result
end

function Game_Battler:ClearResult()
	self._result.clear()
end

function Game_Battler:ClearTpbChargeTime()
	self._tpbState = "charging"
	self._tpbChargeTime = 0
end

function Game_Battler:ApplyTpbPenalty()
	self._tpbState = "charging"
	self._tpbChargeTime -= 1
end

function Game_Battler:InitTpbChargeTime(advantageous)
	local speed = self:TpbRelativeSpeed()
	self._tpbState = "charging"
	self._tpbChargeTime = advantageous ? 1 : speed * Math.random() * 0.5
	if self:IsRestricted() then
		self._tpbChargeTime = 0
	end
end

function Game_Battler:TpbChargeTime()
	return self._tpbChargeTime
end

function Game_Battler:StartTpbCasting()
	self._tpbState = "casting"
	self._tpbCastTime = 0
end

function Game_Battler:StartTpbAction()
	self._tpbState = "acting"
end

function Game_Battler:IsTpbCharged()
	return self._tpbState === "charged"
end

function Game_Battler:IsTpbReady()
	return self._tpbState === "ready"
end

function Game_Battler:IsTpbTimeout()
	return self._tpbIdleTime >= 1
end

function Game_Battler:UpdateTpb()
	if self:CanMove() then
		self:UpdateTpbChargeTime()
		self:UpdateTpbCastTime()
		self:UpdateTpbAutoBattle()
	end
	if self:IsAlive() then
		self:UpdateTpbIdleTime()
	end
end

function Game_Battler:UpdateTpbChargeTime()
	if self._tpbState === "charging" then
		self._tpbChargeTime += self:TpbAcceleration()
		if self._tpbChargeTime >= 1 then
			self._tpbChargeTime = 1
			self:OnTpbCharged()
		end
	end
end

function Game_Battler:UpdateTpbCastTime()
	if self._tpbState === "casting" then
		self._tpbCastTime += self:TpbAcceleration()
		if self._tpbCastTime >= self:TpbRequiredCastTime() then
			self._tpbCastTime = self:TpbRequiredCastTime()
			self._tpbState = "ready"
		end
	end
end

function Game_Battler:UpdateTpbAutoBattle()
	if self:IsTpbCharged() and !self:IsTpbTurnEnd() and self:IsAutoBattle() then
		self:MakeTpbActions()
	end
end

function Game_Battler:UpdateTpbIdleTime()
	if !self:CanMove() or self:IsTpbCharged() then
		self._tpbIdleTime += self:TpbAcceleration()
	end
end

function Game_Battler:TpbAcceleration()
	local speed = self:TpbRelativeSpeed()
	local referenceTime = Game.Party.tpbReferenceTime()
	return speed / referenceTime
end

function Game_Battler:TpbRelativeSpeed()
	return self:TpbSpeed() / Game.Party.tpbBaseSpeed()
end

function Game_Battler:TpbSpeed()
	return Math.sqrt(self:Agi) + 1
end

function Game_Battler:TpbBaseSpeed()
	local baseAgility = self:ParamBasePlus(6)
	return Math.sqrt(baseAgility) + 1
end

function Game_Battler:TpbRequiredCastTime()
	local actions = self._actions.filter((action) => action.isValid())
	local items = actions.map((action) => action.item())
	local delay = items.reduce((r, item) => r + Math.max(0, -item.speed), 0)
	return Math.sqrt(delay) / self:TpbSpeed()
end

function Game_Battler:OnTpbCharged()
	if !self:ShouldDelayTpbCharge() then
		self:FinishTpbCharge()
	end
end

function Game_Battler:ShouldDelayTpbCharge()
	return !BattleManager.isActiveTpb() and Game.Party.canInput()
end

function Game_Battler:FinishTpbCharge()
	self._tpbState = "charged"
	self._tpbTurnEnd = true
	self._tpbIdleTime = 0
end

function Game_Battler:IsTpbTurnEnd()
	return self._tpbTurnEnd
end

function Game_Battler:InitTpbTurn()
	self._tpbTurnEnd = false
	self._tpbTurnCount = 0
	self._tpbIdleTime = 0
end

function Game_Battler:StartTpbTurn()
	self._tpbTurnEnd = false
	self._tpbTurnCount++
	self._tpbIdleTime = 0
	if self:NumActions() === 0 then
		self:MakeTpbActions()
	end
end

function Game_Battler:MakeTpbActions()
	self:MakeActions()
	if self:CanInput() then
		self:SetActionState("undecided")
	end else {
		self:StartTpbCasting()
		self:SetActionState("waiting")
	end
end

function Game_Battler:OnTpbTimeout()
	self:OnAllActionsEnd()
	self._tpbTurnEnd = true
	self._tpbIdleTime = 0
end

function Game_Battler:TurnCount()
	if BattleManager.isTpb() then
		return self._tpbTurnCount
	end else {
		return Game.Troop.turnCount() + 1
	end
end

function Game_Battler:CanInput()
	if BattleManager.isTpb() and !self:IsTpbCharged() then
		return false
	end
	return Game_BattlerBase.prototype.canInput.call(this)
end

function Game_Battler:Refresh()
	Game_BattlerBase.prototype.refresh.call(this)
	if self:Hp === 0 then
		self:AddState(self:DeathStateId())
	end else {
		self:RemoveState(self:DeathStateId())
	end
end

function Game_Battler:AddState(stateId)
	if self:IsStateAddable(stateId) then
		if !self:IsStateAffected(stateId) then
			self:AddNewState(stateId)
			self:Refresh()
		end
		self:ResetStateCounts(stateId)
		self._result.pushAddedState(stateId)
	end
end

function Game_Battler:IsStateAddable(stateId)
	return self:IsAlive() and Data.States[stateId] and !self:IsStateResist(stateId) and !self:IsStateRestrict(stateId)
end

function Game_Battler:IsStateRestrict(stateId)
	return Data.States[stateId].removeByRestriction and self:IsRestricted()
end

function Game_Battler:OnRestrict()
	Game_BattlerBase.prototype.onRestrict.call(this)
	self:ClearTpbChargeTime()
	self:ClearActions()
	for (local state of self:States()) {
		if state.removeByRestriction then
			self:RemoveState(state.id)
		end
	end
end

function Game_Battler:RemoveState(stateId)
	if self:IsStateAffected(stateId) then
		if stateId === self:DeathStateId() then
			self:Revive()
		end
		self:EraseState(stateId)
		self:Refresh()
		self._result.pushRemovedState(stateId)
	end
end

function Game_Battler:Escape()
	if Game.Party.inBattle() then
		self:Hide()
	end
	self:ClearActions()
	self:ClearStates()
	SoundManager.playEscape()
end

function Game_Battler:AddBuff(paramId, turns)
	if self:IsAlive() then
		self:IncreaseBuff(paramId)
		if self:IsBuffAffected(paramId) then
			self:OverwriteBuffTurns(paramId, turns)
		end
		self._result.pushAddedBuff(paramId)
		self:Refresh()
	end
end

function Game_Battler:AddDebuff(paramId, turns)
	if self:IsAlive() then
		self:DecreaseBuff(paramId)
		if self:IsDebuffAffected(paramId) then
			self:OverwriteBuffTurns(paramId, turns)
		end
		self._result.pushAddedDebuff(paramId)
		self:Refresh()
	end
end

function Game_Battler:RemoveBuff(paramId)
	if self:IsAlive() and self:IsBuffOrDebuffAffected(paramId) then
		self:EraseBuff(paramId)
		self._result.pushRemovedBuff(paramId)
		self:Refresh()
	end
end

function Game_Battler:RemoveBattleStates()
	for (local state of self:States()) {
		if state.removeAtBattleEnd then
			self:RemoveState(state.id)
		end
	end
end

function Game_Battler:RemoveAllBuffs()
	for (local i = 0 i < self:BuffLength() i++) {
		self:RemoveBuff(i)
	end
end

function Game_Battler:RemoveStatesAuto(timing)
	for (local state of self:States()) {
		if self:IsStateExpired(state.id) and state.autoRemovalTiming === timing then
			self:RemoveState(state.id)
		end
	end
end

function Game_Battler:RemoveBuffsAuto()
	for (local i = 0 i < self:BuffLength() i++) {
		if self:IsBuffExpired(i) then
			self:RemoveBuff(i)
		end
	end
end

function Game_Battler:RemoveStatesByDamage()
	for (local state of self:States()) {
		if state.removeByDamage and Math.randomInt(100) < state.chanceByDamage then
			self:RemoveState(state.id)
		end
	end
end

function Game_Battler:MakeActionTimes()
	local actionPlusSet = self:ActionPlusSet()
	return actionPlusSet.reduce((r, p) => (Math.random() < p ? r + 1 : r), 1)
end

function Game_Battler:MakeActions()
	self:ClearActions()
	if self:CanMove() then
		local actionTimes = self:MakeActionTimes()
		self._actions = []
		for (local i = 0 i < actionTimes i++) {
			self._actions.push(new Game_Action(this))
		end
	end
end

function Game_Battler:Speed()
	return self._speed
end

function Game_Battler:MakeSpeed()
	self._speed = Math.min(...self._actions.map((action) => action.speed())) or 0
end

function Game_Battler:CurrentAction()
	return self._actions[0]
end

function Game_Battler:RemoveCurrentAction()
	self._actions.shift()
end

function Game_Battler:SetLastTarget(target)
	self._lastTargetIndex = target ? target.index() : 0
end

function Game_Battler:ForceAction(skillId, targetIndex)
	self:ClearActions()
	local action = new Game_Action(this, true)
	action.setSkill(skillId)
	if targetIndex === -2 then
		action.setTarget(self._lastTargetIndex)
	end else if targetIndex === -1 then
		action.decideRandomTarget()
	end else {
		action.setTarget(targetIndex)
	end
	if action.item() then
		self._actions.push(action)
	end
end

function Game_Battler:UseItem(item)
	if DataManager.isSkill(item) then
		self:PaySkillCost(item)
	end else if DataManager.isItem(item) then
		self:ConsumeItem(item)
	end
end

function Game_Battler:ConsumeItem(item)
	Game.Party.consumeItem(item)
end

function Game_Battler:GainHp(value)
	self._result.hpDamage = -value
	self._result.hpAffected = true
	self:SetHp(self:Hp + value)
end

function Game_Battler:GainMp(value)
	self._result.mpDamage = -value
	self:SetMp(self:Mp + value)
end

function Game_Battler:GainTp(value)
	self._result.tpDamage = -value
	self:SetTp(self:Tp + value)
end

function Game_Battler:GainSilentTp(value)
	self:SetTp(self:Tp + value)
end

function Game_Battler:InitTp()
	self:SetTp(Math.randomInt(25))
end

function Game_Battler:ClearTp()
	self:SetTp(0)
end

function Game_Battler:ChargeTpByDamage(damageRate)
	local value = Math.floor(50 * damageRate * self:Tcr)
	self:GainSilentTp(value)
end

function Game_Battler:RegenerateHp()
	local minRecover = -self:MaxSlipDamage()
	local value = Math.max(Math.floor(self:Mhp * self:Hrg), minRecover)
	if value ~= 0 then
		self:GainHp(value)
	end
end

function Game_Battler:MaxSlipDamage()
	return Data.System.optSlipDeath ? self:Hp : Math.max(self:Hp - 1, 0)
end

function Game_Battler:RegenerateMp()
	local value = Math.floor(self:Mmp * self:Mrg)
	if value ~= 0 then
		self:GainMp(value)
	end
end

function Game_Battler:RegenerateTp()
	local value = Math.floor(100 * self:Trg)
	self:GainSilentTp(value)
end

function Game_Battler:RegenerateAll()
	if self:IsAlive() then
		self:RegenerateHp()
		self:RegenerateMp()
		self:RegenerateTp()
	end
end

function Game_Battler:OnBattleStart(advantageous)
	self:SetActionState("undecided")
	self:ClearMotion()
	self:InitTpbChargeTime(advantageous)
	self:InitTpbTurn()
	if !self:IsPreserveTp() then
		self:InitTp()
	end
end

function Game_Battler:OnAllActionsEnd()
	self:ClearResult()
	self:RemoveStatesAuto(1)
	self:RemoveBuffsAuto()
end

function Game_Battler:OnTurnEnd()
	self:ClearResult()
	self:RegenerateAll()
	self:UpdateStateTurns()
	self:UpdateBuffTurns()
	self:RemoveStatesAuto(2)
end

function Game_Battler:OnBattleEnd()
	self:ClearResult()
	self:RemoveBattleStates()
	self:RemoveAllBuffs()
	self:ClearActions()
	if !self:IsPreserveTp() then
		self:ClearTp()
	end
	self:Appear()
end

function Game_Battler:OnDamage(value)
	self:RemoveStatesByDamage()
	self:ChargeTpByDamage(value / self:Mhp)
end

function Game_Battler:SetActionState(actionState)
	self._actionState = actionState
	self:RequestMotionRefresh()
end

function Game_Battler:IsUndecided()
	return self._actionState === "undecided"
end

function Game_Battler:IsInputting()
	return self._actionState === "inputting"
end

function Game_Battler:IsWaiting()
	return self._actionState === "waiting"
end

function Game_Battler:IsActing()
	return self._actionState === "acting"
end

function Game_Battler:IsChanting()
	if self:IsWaiting() then
		return self._actions.some((action) => action.isMagicSkill())
	end
	return false
end

function Game_Battler:IsGuardWaiting()
	if self:IsWaiting() then
		return self._actions.some((action) => action.isGuard())
	end
	return false
end

function Game_Battler:PerformActionStart(action)
	if !action.isGuard() then
		self:SetActionState("acting")
	end
end

function Game_Battler:PerformAction(/*action*/)
	--
end

function Game_Battler:PerformActionEnd()
	--
end

function Game_Battler:PerformDamage()
	--
end

function Game_Battler:PerformMiss()
	SoundManager.playMiss()
end

function Game_Battler:PerformRecovery()
	SoundManager.playRecovery()
end

function Game_Battler:PerformEvasion()
	SoundManager.playEvasion()
end

function Game_Battler:PerformMagicEvasion()
	SoundManager.playMagicEvasion()
end

function Game_Battler:PerformCounter()
	SoundManager.playEvasion()
end

function Game_Battler:PerformReflection()
	SoundManager.playReflection()
end

function Game_Battler:PerformSubstitute(/*target*/)
	--
end

function Game_Battler:PerformCollapse()
	--
end

-------------------------------------------------------------------------------
-- Game_Actor
--
-- The game object class for an actor.

function Game_Actor.new()
	self:Initialize(...arguments)
end

Game_Actor.prototype = Object.create(Game_Battler.prototype)
Game_Actor.prototype.constructor = Game_Actor

Object.defineProperty(Game_Actor.prototype, "level", {
	get: function .new()
		return self._level
	end,
	configurable: true,
end)

function Game_Actor:Initialize(actorId)
	Game_Battler.prototype.initialize.call(this)
	self:Setup(actorId)
end

function Game_Actor:InitMembers()
	Game_Battler.prototype.initMembers.call(this)
	self._actorId = 0
	self._name = ""
	self._nickname = ""
	self._classId = 0
	self._level = 0
	self._characterName = ""
	self._characterIndex = 0
	self._faceName = ""
	self._faceIndex = 0
	self._battlerName = ""
	self._exp = {end
	self._skills = []
	self._equips = []
	self._actionInputIndex = 0
	self._lastMenuSkill = new Game_Item()
	self._lastBattleSkill = new Game_Item()
	self._lastCommandSymbol = ""
end

function Game_Actor:Setup(actorId)
	local actor = Data.Actors[actorId]
	self._actorId = actorId
	self._name = actor.name
	self._nickname = actor.nickname
	self._profile = actor.profile
	self._classId = actor.classId
	self._level = actor.initialLevel
	self:InitImages()
	self:InitExp()
	self:InitSkills()
	self:InitEquips(actor.equips)
	self:ClearParamPlus()
	self:RecoverAll()
end

function Game_Actor:ActorId()
	return self._actorId
end

function Game_Actor:Actor()
	return Data.Actors[self._actorId]
end

function Game_Actor:Name()
	return self._name
end

function Game_Actor:SetName(name)
	self._name = name
end

function Game_Actor:Nickname()
	return self._nickname
end

function Game_Actor:SetNickname(nickname)
	self._nickname = nickname
end

function Game_Actor:Profile()
	return self._profile
end

function Game_Actor:SetProfile(profile)
	self._profile = profile
end

function Game_Actor:CharacterName()
	return self._characterName
end

function Game_Actor:CharacterIndex()
	return self._characterIndex
end

function Game_Actor:FaceName()
	return self._faceName
end

function Game_Actor:FaceIndex()
	return self._faceIndex
end

function Game_Actor:BattlerName()
	return self._battlerName
end

function Game_Actor:ClearStates()
	Game_Battler.prototype.clearStates.call(this)
	self._stateSteps = {end
end

function Game_Actor:EraseState(stateId)
	Game_Battler.prototype.eraseState.call(this, stateId)
	delete self._stateSteps[stateId]
end

function Game_Actor:ResetStateCounts(stateId)
	Game_Battler.prototype.resetStateCounts.call(this, stateId)
	self._stateSteps[stateId] = Data.States[stateId].stepsToRemove
end

function Game_Actor:InitImages()
	local actor = self:Actor()
	self._characterName = actor.characterName
	self._characterIndex = actor.characterIndex
	self._faceName = actor.faceName
	self._faceIndex = actor.faceIndex
	self._battlerName = actor.battlerName
end

function Game_Actor:ExpForLevel(level)
	local c = self:CurrentClass()
	local basis = c.expParams[0]
	local extra = c.expParams[1]
	local acc_a = c.expParams[2]
	local acc_b = c.expParams[3]
	return Math.round((basis * Math.pow(level - 1, 0.9 + acc_a / 250) * level * (level + 1)) / (6 + Math.pow(level, 2) / 50 / acc_b) + (level - 1) * extra)
end

function Game_Actor:InitExp()
	self._exp[self._classId] = self:CurrentLevelExp()
end

function Game_Actor:CurrentExp()
	return self._exp[self._classId]
end

function Game_Actor:CurrentLevelExp()
	return self:ExpForLevel(self._level)
end

function Game_Actor:NextLevelExp()
	return self:ExpForLevel(self._level + 1)
end

function Game_Actor:NextRequiredExp()
	return self:NextLevelExp() - self:CurrentExp()
end

function Game_Actor:MaxLevel()
	return self:Actor().maxLevel
end

function Game_Actor:IsMaxLevel()
	return self._level >= self:MaxLevel()
end

function Game_Actor:InitSkills()
	self._skills = []
	for (local learning of self:CurrentClass().learnings) {
		if learning.level <= self._level then
			self:LearnSkill(learning.skillId)
		end
	end
end

function Game_Actor:InitEquips(equips)
	local slots = self:EquipSlots()
	local maxSlots = slots.length
	self._equips = []
	for (local i = 0 i < maxSlots i++) {
		self._equips[i] = new Game_Item()
	end
	for (local j = 0 j < equips.length j++) {
		if j < maxSlots then
			self._equips[j].setEquip(slots[j] === 1, equips[j])
		end
	end
	self:ReleaseUnequippableItems(true)
	self:Refresh()
end

function Game_Actor:EquipSlots()
	local slots = []
	for (local i = 1 i < Data.System.equipTypes.length i++) {
		slots.push(i)
	end
	if slots.length >= 2 and self:IsDualWield() then
		slots[1] = 1
	end
	return slots
end

function Game_Actor:Equips()
	return self._equips.map((item) => item.object())
end

function Game_Actor:Weapons()
	return self:Equips().filter((item) => item and DataManager.isWeapon(item))
end

function Game_Actor:Armors()
	return self:Equips().filter((item) => item and DataManager.isArmor(item))
end

function Game_Actor:HasWeapon(weapon)
	return self:Weapons().includes(weapon)
end

function Game_Actor:HasArmor(armor)
	return self:Armors().includes(armor)
end

function Game_Actor:IsEquipChangeOk(slotId)
	return !self:IsEquipTypeLocked(self:EquipSlots()[slotId]) and !self:IsEquipTypeSealed(self:EquipSlots()[slotId])
end

function Game_Actor:ChangeEquip(slotId, item)
	if self:TradeItemWithParty(item, self:Equips()[slotId]) and (!item or self:EquipSlots()[slotId] === item.etypeId) then
		self._equips[slotId].setObject(item)
		self:Refresh()
	end
end

function Game_Actor:ForceChangeEquip(slotId, item)
	self._equips[slotId].setObject(item)
	self:ReleaseUnequippableItems(true)
	self:Refresh()
end

function Game_Actor:TradeItemWithParty(newItem, oldItem)
	if newItem and !Game.Party.hasItem(newItem) then
		return false
	end else {
		Game.Party.gainItem(oldItem, 1)
		Game.Party.loseItem(newItem, 1)
		return true
	end
end

function Game_Actor:ChangeEquipById(etypeId, itemId)
	local slotId = etypeId - 1
	if self:EquipSlots()[slotId] === 1 then
		self:ChangeEquip(slotId, Data.Weapons[itemId])
	end else {
		self:ChangeEquip(slotId, Data.Armors[itemId])
	end
end

function Game_Actor:IsEquipped(item)
	return self:Equips().includes(item)
end

function Game_Actor:DiscardEquip(item)
	local slotId = self:Equips().indexOf(item)
	if slotId >= 0 then
		self._equips[slotId].setObject(nil)
	end
end

function Game_Actor:ReleaseUnequippableItems(forcing)
	for () {
		local slots = self:EquipSlots()
		local equips = self:Equips()
		local changed = false
		for (local i = 0 i < equips.length i++) {
			local item = equips[i]
			if item and (!self:CanEquip(item) or item.etypeId ~= slots[i]) then
				if !forcing then
					self:TradeItemWithParty(nil, item)
				end
				self._equips[i].setObject(nil)
				changed = true
			end
		end
		if !changed then
			break
		end
	end
end

function Game_Actor:ClearEquipments()
	local maxSlots = self:EquipSlots().length
	for (local i = 0 i < maxSlots i++) {
		if self:IsEquipChangeOk(i) then
			self:ChangeEquip(i, nil)
		end
	end
end

function Game_Actor:OptimizeEquipments()
	local maxSlots = self:EquipSlots().length
	self:ClearEquipments()
	for (local i = 0 i < maxSlots i++) {
		if self:IsEquipChangeOk(i) then
			self:ChangeEquip(i, self:BestEquipItem(i))
		end
	end
end

function Game_Actor:BestEquipItem(slotId)
	local etypeId = self:EquipSlots()[slotId]
	local items = Game.Party.equipItems().filter((item) => item.etypeId === etypeId and self:CanEquip(item))
	local bestItem = nil
	local bestPerformance = -1000
	for (local i = 0 i < items.length i++) {
		local performance = self:CalcEquipItemPerformance(items[i])
		if performance > bestPerformance then
			bestPerformance = performance
			bestItem = items[i]
		end
	end
	return bestItem
end

function Game_Actor:CalcEquipItemPerformance(item)
	return item.params.reduce((a, b) => a + b)
end

function Game_Actor:IsSkillWtypeOk(skill)
	local wtypeId1 = skill.requiredWtypeId1
	local wtypeId2 = skill.requiredWtypeId2
	if (wtypeId1 === 0 and wtypeId2 === 0) or (wtypeId1 > 0 and self:IsWtypeEquipped(wtypeId1)) or (wtypeId2 > 0 and self:IsWtypeEquipped(wtypeId2)) then
		return true
	end else {
		return false
	end
end

function Game_Actor:IsWtypeEquipped(wtypeId)
	return self:Weapons().some((weapon) => weapon.wtypeId === wtypeId)
end

function Game_Actor:Refresh()
	self:ReleaseUnequippableItems(false)
	Game_Battler.prototype.refresh.call(this)
end

function Game_Actor:Hide()
	Game_Battler.prototype.hide.call(this)
	Game.Temp.requestBattleRefresh()
end

function Game_Actor:IsActor()
	return true
end

function Game_Actor:FriendsUnit()
	return Game.Party
end

function Game_Actor:OpponentsUnit()
	return Game.Troop
end

function Game_Actor:Index()
	return Game.Party.members().indexOf(this)
end

function Game_Actor:IsBattleMember()
	return Game.Party.battleMembers().includes(this)
end

function Game_Actor:IsFormationChangeOk()
	return true
end

function Game_Actor:CurrentClass()
	return Data.Classes[self._classId]
end

function Game_Actor:IsClass(gameClass)
	return gameClass and self._classId === gameClass.id
end

function Game_Actor:SkillTypes()
	local skillTypes = self:AddedSkillTypes().sort((a, b) => a - b)
	return skillTypes.filter((x, i, self) => self:IndexOf(x) === i)
end

function Game_Actor:Skills()
	local list = []
	for (local id of self._skills.concat(self:AddedSkills())) {
		if !list.includes(Data.Skills[id]) then
			list.push(Data.Skills[id])
		end
	end
	return list
end

function Game_Actor:UsableSkills()
	return self:Skills().filter((skill) => self:CanUse(skill))
end

function Game_Actor:TraitObjects()
	local objects = Game_Battler.prototype.traitObjects.call(this)
	objects.push(self:Actor(), self:CurrentClass())
	for (local item of self:Equips()) {
		if item then
			objects.push(item)
		end
	end
	return objects
end

function Game_Actor:AttackElements()
	local set = Game_Battler.prototype.attackElements.call(this)
	if self:HasNoWeapons() and !set.includes(self:BareHandsElementId()) then
		set.push(self:BareHandsElementId())
	end
	return set
end

function Game_Actor:HasNoWeapons()
	return self:Weapons().length === 0
end

function Game_Actor:BareHandsElementId()
	return 1
end

function Game_Actor:ParamBase(paramId)
	return self:CurrentClass().params[paramId][self._level]
end

function Game_Actor:ParamPlus(paramId)
	local value = Game_Battler.prototype.paramPlus.call(this, paramId)
	for (local item of self:Equips()) {
		if item then
			value += item.params[paramId]
		end
	end
	return value
end

function Game_Actor:AttackAnimationId1()
	if self:HasNoWeapons() then
		return self:BareHandsAnimationId()
	end else {
		local weapons = self:Weapons()
		return weapons[0] ? weapons[0].animationId : 0
	end
end

function Game_Actor:AttackAnimationId2()
	local weapons = self:Weapons()
	return weapons[1] ? weapons[1].animationId : 0
end

function Game_Actor:BareHandsAnimationId()
	return 1
end

function Game_Actor:ChangeExp(exp, show)
	self._exp[self._classId] = Math.max(exp, 0)
	local lastLevel = self._level
	local lastSkills = self:Skills()
	while (!self:IsMaxLevel() and self:CurrentExp() >= self:NextLevelExp()) {
		self:LevelUp()
	end
	while (self:CurrentExp() < self:CurrentLevelExp()) {
		self:LevelDown()
	end
	if show and self._level > lastLevel then
		self:DisplayLevelUp(self:FindNewSkills(lastSkills))
	end
	self:Refresh()
end

function Game_Actor:LevelUp()
	self._level++
	for (local learning of self:CurrentClass().learnings) {
		if learning.level === self._level then
			self:LearnSkill(learning.skillId)
		end
	end
end

function Game_Actor:LevelDown()
	self._level--
end

function Game_Actor:FindNewSkills(lastSkills)
	local newSkills = self:Skills()
	for (local lastSkill of lastSkills) {
		newSkills.remove(lastSkill)
	end
	return newSkills
end

function Game_Actor:DisplayLevelUp(newSkills)
	local text = TextManager.levelUp.format(self._name, TextManager.level, self._level)
	Game.Message.newPage()
	Game.Message.add(text)
	for (local skill of newSkills) {
		Game.Message.add(TextManager.obtainSkill.format(skill.name))
	end
end

function Game_Actor:GainExp(exp)
	local newExp = self:CurrentExp() + Math.round(exp * self:FinalExpRate())
	self:ChangeExp(newExp, self:ShouldDisplayLevelUp())
end

function Game_Actor:FinalExpRate()
	return self:Exr * (self:IsBattleMember() ? 1 : self:BenchMembersExpRate())
end

function Game_Actor:BenchMembersExpRate()
	return Data.System.optExtraExp ? 1 : 0
end

function Game_Actor:ShouldDisplayLevelUp()
	return true
end

function Game_Actor:ChangeLevel(level, show)
	level = level.clamp(1, self:MaxLevel())
	self:ChangeExp(self:ExpForLevel(level), show)
end

function Game_Actor:LearnSkill(skillId)
	if !self:IsLearnedSkill(skillId) then
		self._skills.push(skillId)
		self._skills.sort((a, b) => a - b)
	end
end

function Game_Actor:ForgetSkill(skillId)
	self._skills.remove(skillId)
end

function Game_Actor:IsLearnedSkill(skillId)
	return self._skills.includes(skillId)
end

function Game_Actor:HasSkill(skillId)
	return self:Skills().includes(Data.Skills[skillId])
end

function Game_Actor:ChangeClass(classId, keepExp)
	if keepExp then
		self._exp[classId] = self:CurrentExp()
	end
	self._classId = classId
	self._level = 0
	self:ChangeExp(self._exp[self._classId] or 0, false)
	self:Refresh()
end

function Game_Actor:SetCharacterImage(characterName, characterIndex)
	self._characterName = characterName
	self._characterIndex = characterIndex
end

function Game_Actor:SetFaceImage(faceName, faceIndex)
	self._faceName = faceName
	self._faceIndex = faceIndex
	Game.Temp.requestBattleRefresh()
end

function Game_Actor:SetBattlerImage(battlerName)
	self._battlerName = battlerName
end

function Game_Actor:IsSpriteVisible()
	return Game.System.isSideView()
end

function Game_Actor:PerformActionStart(action)
	Game_Battler.prototype.performActionStart.call(this, action)
end

function Game_Actor:PerformAction(action)
	Game_Battler.prototype.performAction.call(this, action)
	if action.isAttack() then
		self:PerformAttack()
	end else if action.isGuard() then
		self:RequestMotion("guard")
	end else if action.isMagicSkill() then
		self:RequestMotion("spell")
	end else if action.isSkill() then
		self:RequestMotion("skill")
	end else if action.isItem() then
		self:RequestMotion("item")
	end
end

function Game_Actor:PerformActionEnd()
	Game_Battler.prototype.performActionEnd.call(this)
end

function Game_Actor:PerformAttack()
	local weapons = self:Weapons()
	local wtypeId = weapons[0] ? weapons[0].wtypeId : 0
	local attackMotion = Data.System.attackMotions[wtypeId]
	if attackMotion then
		if attackMotion.type === 0 then
			self:RequestMotion("thrust")
		end else if attackMotion.type === 1 then
			self:RequestMotion("swing")
		end else if attackMotion.type === 2 then
			self:RequestMotion("missile")
		end
		self:StartWeaponAnimation(attackMotion.weaponImageId)
	end
end

function Game_Actor:PerformDamage()
	Game_Battler.prototype.performDamage.call(this)
	if self:IsSpriteVisible() then
		self:RequestMotion("damage")
	end else {
		Game.Screen.startShake(5, 5, 10)
	end
	SoundManager.playActorDamage()
end

function Game_Actor:PerformEvasion()
	Game_Battler.prototype.performEvasion.call(this)
	self:RequestMotion("evade")
end

function Game_Actor:PerformMagicEvasion()
	Game_Battler.prototype.performMagicEvasion.call(this)
	self:RequestMotion("evade")
end

function Game_Actor:PerformCounter()
	Game_Battler.prototype.performCounter.call(this)
	self:PerformAttack()
end

function Game_Actor:PerformCollapse()
	Game_Battler.prototype.performCollapse.call(this)
	if Game.Party.inBattle() then
		SoundManager.playActorCollapse()
	end
end

function Game_Actor:PerformVictory()
	self:SetActionState("done")
	if self:CanMove() then
		self:RequestMotion("victory")
	end
end

function Game_Actor:PerformEscape()
	if self:CanMove() then
		self:RequestMotion("escape")
	end
end

function Game_Actor:MakeActionList()
	local list = []
	local attackAction = new Game_Action(this)
	attackAction.setAttack()
	list.push(attackAction)
	for (local skill of self:UsableSkills()) {
		local skillAction = new Game_Action(this)
		skillAction.setSkill(skill.id)
		list.push(skillAction)
	end
	return list
end

function Game_Actor:MakeAutoBattleActions()
	for (local i = 0 i < self:NumActions() i++) {
		local list = self:MakeActionList()
		local maxValue = -Number.MAX_VALUE
		for (local action of list) {
			local value = action.evaluate()
			if value > maxValue then
				maxValue = value
				self:SetAction(i, action)
			end
		end
	end
	self:SetActionState("waiting")
end

function Game_Actor:MakeConfusionActions()
	for (local i = 0 i < self:NumActions() i++) {
		self:Action(i).setConfusion()
	end
	self:SetActionState("waiting")
end

function Game_Actor:MakeActions()
	Game_Battler.prototype.makeActions.call(this)
	if self:NumActions() > 0 then
		self:SetActionState("undecided")
	end else {
		self:SetActionState("waiting")
	end
	if self:IsAutoBattle() then
		self:MakeAutoBattleActions()
	end else if self:IsConfused() then
		self:MakeConfusionActions()
	end
end

function Game_Actor:OnPlayerWalk()
	self:ClearResult()
	self:CheckFloorEffect()
	if Game.Player.isNormal() then
		self:TurnEndOnMap()
		for (local state of self:States()) {
			self:UpdateStateSteps(state)
		end
		self:ShowAddedStates()
		self:ShowRemovedStates()
	end
end

function Game_Actor:UpdateStateSteps(state)
	if state.removeByWalking then
		if self._stateSteps[state.id] > 0 then
			if --self._stateSteps[state.id] === 0 then
				self:RemoveState(state.id)
			end
		end
	end
end

function Game_Actor:ShowAddedStates()
	for (local state of self:Result().addedStateObjects()) {
		if state.message1 then
			Game.Message.add(state.message1.format(self._name))
		end
	end
end

function Game_Actor:ShowRemovedStates()
	for (local state of self:Result().removedStateObjects()) {
		if state.message4 then
			Game.Message.add(state.message4.format(self._name))
		end
	end
end

function Game_Actor:StepsForTurn()
	return 20
end

function Game_Actor:TurnEndOnMap()
	if Game.Party.steps() % self:StepsForTurn() === 0 then
		self:OnTurnEnd()
		if self:Result().hpDamage > 0 then
			self:PerformMapDamage()
		end
	end
end

function Game_Actor:CheckFloorEffect()
	if Game.Player.isOnDamageFloor() then
		self:ExecuteFloorDamage()
	end
end

function Game_Actor:ExecuteFloorDamage()
	local floorDamage = Math.floor(self:BasicFloorDamage() * self:Fdr)
	local realDamage = Math.min(floorDamage, self:MaxFloorDamage())
	self:GainHp(-realDamage)
	if realDamage > 0 then
		self:PerformMapDamage()
	end
end

function Game_Actor:BasicFloorDamage()
	return 10
end

function Game_Actor:MaxFloorDamage()
	return Data.System.optFloorDeath ? self:Hp : Math.max(self:Hp - 1, 0)
end

function Game_Actor:PerformMapDamage()
	if !Game.Party.inBattle() then
		Game.Screen.startFlashForDamage()
	end
end

function Game_Actor:ClearActions()
	Game_Battler.prototype.clearActions.call(this)
	self._actionInputIndex = 0
end

function Game_Actor:InputtingAction()
	return self:Action(self._actionInputIndex)
end

function Game_Actor:SelectNextCommand()
	if self._actionInputIndex < self:NumActions() - 1 then
		self._actionInputIndex++
		return true
	end else {
		return false
	end
end

function Game_Actor:SelectPreviousCommand()
	if self._actionInputIndex > 0 then
		self._actionInputIndex--
		return true
	end else {
		return false
	end
end

function Game_Actor:LastSkill()
	if Game.Party.inBattle() then
		return self:LastBattleSkill()
	end else {
		return self:LastMenuSkill()
	end
end

function Game_Actor:LastMenuSkill()
	return self._lastMenuSkill.object()
end

function Game_Actor:SetLastMenuSkill(skill)
	self._lastMenuSkill.setObject(skill)
end

function Game_Actor:LastBattleSkill()
	return self._lastBattleSkill.object()
end

function Game_Actor:SetLastBattleSkill(skill)
	self._lastBattleSkill.setObject(skill)
end

function Game_Actor:LastCommandSymbol()
	return self._lastCommandSymbol
end

function Game_Actor:SetLastCommandSymbol(symbol)
	self._lastCommandSymbol = symbol
end

function Game_Actor:TestEscape(item)
	return item.effects.some((effect) => effect and effect.code === Game_Action.EFFECT_SPECIAL)
end

function Game_Actor:MeetsUsableItemConditions(item)
	if Game.Party.inBattle() then
		if !BattleManager.canEscape() and self:TestEscape(item) then
			return false
		end
	end
	return Game_BattlerBase.prototype.meetsUsableItemConditions.call(this, item)
end

function Game_Actor:OnEscapeFailure()
	if BattleManager.isTpb() then
		self:ApplyTpbPenalty()
	end
	self:ClearActions()
	self:RequestMotionRefresh()
end

-------------------------------------------------------------------------------
-- Game_Enemy
--
-- The game object class for an enemy.

function Game_Enemy.new()
	self:Initialize(...arguments)
end

Game_Enemy.prototype = Object.create(Game_Battler.prototype)
Game_Enemy.prototype.constructor = Game_Enemy

function Game_Enemy:Initialize(enemyId, x, y)
	Game_Battler.prototype.initialize.call(this)
	self:Setup(enemyId, x, y)
end

function Game_Enemy:InitMembers()
	Game_Battler.prototype.initMembers.call(this)
	self._enemyId = 0
	self._letter = ""
	self._plural = false
	self._screenX = 0
	self._screenY = 0
end

function Game_Enemy:Setup(enemyId, x, y)
	self._enemyId = enemyId
	self._screenX = x
	self._screenY = y
	self:RecoverAll()
end

function Game_Enemy:IsEnemy()
	return true
end

function Game_Enemy:FriendsUnit()
	return Game.Troop
end

function Game_Enemy:OpponentsUnit()
	return Game.Party
end

function Game_Enemy:Index()
	return Game.Troop.members().indexOf(this)
end

function Game_Enemy:IsBattleMember()
	return self:Index() >= 0
end

function Game_Enemy:EnemyId()
	return self._enemyId
end

function Game_Enemy:Enemy()
	return Data.Enemies[self._enemyId]
end

function Game_Enemy:TraitObjects()
	return Game_Battler.prototype.traitObjects.call(this).concat(self:Enemy())
end

function Game_Enemy:ParamBase(paramId)
	return self:Enemy().params[paramId]
end

function Game_Enemy:Exp()
	return self:Enemy().exp
end

function Game_Enemy:Gold()
	return self:Enemy().gold
end

function Game_Enemy:MakeDropItems()
	local rate = self:DropItemRate()
	return self:Enemy().dropItems.reduce((r, di) => {
		if di.kind > 0 and Math.random() * di.denominator < rate then
			return r.concat(self:ItemObject(di.kind, di.dataId))
		end else {
			return r
		end
	end, [])
end

function Game_Enemy:DropItemRate()
	return Game.Party.hasDropItemDouble() ? 2 : 1
end

function Game_Enemy:ItemObject(kind, dataId)
	if kind === 1 then
		return Data.Items[dataId]
	end else if kind === 2 then
		return Data.Weapons[dataId]
	end else if kind === 3 then
		return Data.Armors[dataId]
	end else {
		return nil
	end
end

function Game_Enemy:IsSpriteVisible()
	return true
end

function Game_Enemy:ScreenX()
	return self._screenX
end

function Game_Enemy:ScreenY()
	return self._screenY
end

function Game_Enemy:BattlerName()
	return self:Enemy().battlerName
end

function Game_Enemy:BattlerHue()
	return self:Enemy().battlerHue
end

function Game_Enemy:OriginalName()
	return self:Enemy().name
end

function Game_Enemy:Name()
	return self:OriginalName() + (self._plural ? self._letter : "")
end

function Game_Enemy:IsLetterEmpty()
	return self._letter === ""
end

function Game_Enemy:SetLetter(letter)
	self._letter = letter
end

function Game_Enemy:SetPlural(plural)
	self._plural = plural
end

function Game_Enemy:PerformActionStart(action)
	Game_Battler.prototype.performActionStart.call(this, action)
	self:RequestEffect("whiten")
end

function Game_Enemy:PerformAction(action)
	Game_Battler.prototype.performAction.call(this, action)
end

function Game_Enemy:PerformActionEnd()
	Game_Battler.prototype.performActionEnd.call(this)
end

function Game_Enemy:PerformDamage()
	Game_Battler.prototype.performDamage.call(this)
	SoundManager.playEnemyDamage()
	self:RequestEffect("blink")
end

function Game_Enemy:PerformCollapse()
	Game_Battler.prototype.performCollapse.call(this)
	switch (self:CollapseType()) {
		case 0:
			self:RequestEffect("collapse")
			SoundManager.playEnemyCollapse()
			break
		case 1:
			self:RequestEffect("bossCollapse")
			SoundManager.playBossCollapse1()
			break
		case 2:
			self:RequestEffect("instantCollapse")
			break
	end
end

function Game_Enemy:Transform(enemyId)
	local name = self:OriginalName()
	self._enemyId = enemyId
	if self:OriginalName() ~= name then
		self._letter = ""
		self._plural = false
	end
	self:Refresh()
	if self:NumActions() > 0 then
		self:MakeActions()
	end
end

function Game_Enemy:MeetsCondition(action)
	local param1 = action.conditionParam1
	local param2 = action.conditionParam2
	switch (action.conditionType) {
		case 1:
			return self:MeetsTurnCondition(param1, param2)
		case 2:
			return self:MeetsHpCondition(param1, param2)
		case 3:
			return self:MeetsMpCondition(param1, param2)
		case 4:
			return self:MeetsStateCondition(param1)
		case 5:
			return self:MeetsPartyLevelCondition(param1)
		case 6:
			return self:MeetsSwitchCondition(param1)
		default:
			return true
	end
end

function Game_Enemy:MeetsTurnCondition(param1, param2)
	local n = self:TurnCount()
	if param2 === 0 then
		return n === param1
	end else {
		return n > 0 and n >= param1 and n % param2 === param1 % param2
	end
end

function Game_Enemy:MeetsHpCondition(param1, param2)
	return self:HpRate() >= param1 and self:HpRate() <= param2
end

function Game_Enemy:MeetsMpCondition(param1, param2)
	return self:MpRate() >= param1 and self:MpRate() <= param2
end

function Game_Enemy:MeetsStateCondition(param)
	return self:IsStateAffected(param)
end

function Game_Enemy:MeetsPartyLevelCondition(param)
	return Game.Party.highestLevel() >= param
end

function Game_Enemy:MeetsSwitchCondition(param)
	return Game.Switches.value(param)
end

function Game_Enemy:IsActionValid(action)
	return self:MeetsCondition(action) and self:CanUse(Data.Skills[action.skillId])
end

function Game_Enemy:SelectAction(actionList, ratingZero)
	local sum = actionList.reduce((r, a) => r + a.rating - ratingZero, 0)
	if sum > 0 then
		local value = Math.randomInt(sum)
		for (local action of actionList) {
			value -= action.rating - ratingZero
			if value < 0 then
				return action
			end
		end
	end else {
		return nil
	end
end

function Game_Enemy:SelectAllActions(actionList)
	local ratingMax = Math.max(...actionList.map((a) => a.rating))
	local ratingZero = ratingMax - 3
	actionList = actionList.filter((a) => a.rating > ratingZero)
	for (local i = 0 i < self:NumActions() i++) {
		self:Action(i).setEnemyAction(self:SelectAction(actionList, ratingZero))
	end
end

function Game_Enemy:MakeActions()
	Game_Battler.prototype.makeActions.call(this)
	if self:NumActions() > 0 then
		local actionList = self:Enemy().actions.filter((a) => self:IsActionValid(a))
		if actionList.length > 0 then
			self:SelectAllActions(actionList)
		end
	end
	self:SetActionState("waiting")
end

-------------------------------------------------------------------------------
-- Game_Actors
--
-- The wrapper class for an actor array.

function Game_Actors.new()
	self:Initialize(...arguments)
end

function Game_Actors:Initialize()
	self._data = []
end

function Game_Actors:Actor(actorId)
	if Data.Actors[actorId] then
		if !self._data[actorId] then
			self._data[actorId] = new Game_Actor(actorId)
		end
		return self._data[actorId]
	end
	return nil
end

-------------------------------------------------------------------------------
-- Game_Unit
--
-- The superclass of Game_Party and Game_Troop.

function Game_Unit.new()
	self:Initialize(...arguments)
end

function Game_Unit:Initialize()
	self._inBattle = false
end

function Game_Unit:InBattle()
	return self._inBattle
end

function Game_Unit:Members()
	return []
end

function Game_Unit:AliveMembers()
	return self:Members().filter((member) => member.isAlive())
end

function Game_Unit:DeadMembers()
	return self:Members().filter((member) => member.isDead())
end

function Game_Unit:MovableMembers()
	return self:Members().filter((member) => member.canMove())
end

function Game_Unit:ClearActions()
	for (local member of self:Members()) {
		member.clearActions()
	end
end

function Game_Unit:Agility()
	local members = self:Members()
	local sum = members.reduce((r, member) => r + member.agi, 0)
	return Math.max(1, sum / Math.max(1, members.length))
end

function Game_Unit:TgrSum()
	return self:AliveMembers().reduce((r, member) => r + member.tgr, 0)
end

function Game_Unit:RandomTarget()
	local tgrRand = Math.random() * self:TgrSum()
	local target = nil
	for (local member of self:AliveMembers()) {
		tgrRand -= member.tgr
		if tgrRand <= 0 and !target then
			target = member
		end
	end
	return target
end

function Game_Unit:RandomDeadTarget()
	local members = self:DeadMembers()
	return members.length ? members[Math.randomInt(members.length)] : nil
end

function Game_Unit:SmoothTarget(index)
	local member = self:Members()[Math.max(0, index)]
	return member and member.isAlive() ? member : self:AliveMembers()[0]
end

function Game_Unit:SmoothDeadTarget(index)
	local member = self:Members()[Math.max(0, index)]
	return member and member.isDead() ? member : self:DeadMembers()[0]
end

function Game_Unit:ClearResults()
	for (local member of self:Members()) {
		member.clearResult()
	end
end

function Game_Unit:OnBattleStart(advantageous)
	for (local member of self:Members()) {
		member.onBattleStart(advantageous)
	end
	self._inBattle = true
end

function Game_Unit:OnBattleEnd()
	self._inBattle = false
	for (local member of self:Members()) {
		member.onBattleEnd()
	end
end

function Game_Unit:MakeActions()
	for (local member of self:Members()) {
		member.makeActions()
	end
end

function Game_Unit:Select(activeMember)
	for (local member of self:Members()) {
		if member === activeMember then
			member.select()
		end else {
			member.deselect()
		end
	end
end

function Game_Unit:IsAllDead()
	return self:AliveMembers().length === 0
end

function Game_Unit:SubstituteBattler(target)
	for (local member of self:Members()) {
		if member.isSubstitute() and member ~= target then
			return member
		end
	end
	return nil
end

function Game_Unit:TpbBaseSpeed()
	local members = self:Members()
	return Math.max(...members.map((member) => member.tpbBaseSpeed()))
end

function Game_Unit:TpbReferenceTime()
	return BattleManager.isActiveTpb() ? 240 : 60
end

function Game_Unit:UpdateTpb()
	for (local member of self:Members()) {
		member.updateTpb()
	end
end

-------------------------------------------------------------------------------
-- Game_Party
--
-- The game object class for the party. Information such as gold and items is
-- included.

function Game_Party.new()
	self:Initialize(...arguments)
end

Game_Party.prototype = Object.create(Game_Unit.prototype)
Game_Party.prototype.constructor = Game_Party

Game_Party.ABILITY_ENCOUNTER_HALF = 0
Game_Party.ABILITY_ENCOUNTER_NONE = 1
Game_Party.ABILITY_CANCEL_SURPRISE = 2
Game_Party.ABILITY_RAISE_PREEMPTIVE = 3
Game_Party.ABILITY_GOLD_DOUBLE = 4
Game_Party.ABILITY_DROP_ITEM_DOUBLE = 5

function Game_Party:Initialize()
	Game_Unit.prototype.initialize.call(this)
	self._gold = 0
	self._steps = 0
	self._lastItem = new Game_Item()
	self._menuActorId = 0
	self._targetActorId = 0
	self._actors = []
	self:InitAllItems()
end

function Game_Party:InitAllItems()
	self._items = {end
	self._weapons = {end
	self._armors = {end
end

function Game_Party:Exists()
	return self._actors.length > 0
end

function Game_Party:Size()
	return self:Members().length
end

function Game_Party:IsEmpty()
	return self:Size() === 0
end

function Game_Party:Members()
	return self:InBattle() ? self:BattleMembers() : self:AllMembers()
end

function Game_Party:AllMembers()
	return self._actors.map((id) => Game.Actors.actor(id))
end

function Game_Party:BattleMembers()
	return self:AllBattleMembers().filter((actor) => actor.isAppeared())
end

function Game_Party:HiddenBattleMembers()
	return self:AllBattleMembers().filter((actor) => actor.isHidden())
end

function Game_Party:AllBattleMembers()
	return self:AllMembers().slice(0, self:MaxBattleMembers())
end

function Game_Party:MaxBattleMembers()
	return 4
end

function Game_Party:Leader()
	return self:BattleMembers()[0]
end

function Game_Party:RemoveInvalidMembers()
	for (local actorId of self._actors) {
		if !Data.Actors[actorId] then
			self._actors.remove(actorId)
		end
	end
end

function Game_Party:ReviveBattleMembers()
	for (local actor of self:BattleMembers()) {
		if actor.isDead() then
			actor.setHp(1)
		end
	end
end

function Game_Party:Items()
	return Object.keys(self._items).map((id) => Data.Items[id])
end

function Game_Party:Weapons()
	return Object.keys(self._weapons).map((id) => Data.Weapons[id])
end

function Game_Party:Armors()
	return Object.keys(self._armors).map((id) => Data.Armors[id])
end

function Game_Party:EquipItems()
	return self:Weapons().concat(self:Armors())
end

function Game_Party:AllItems()
	return self:Items().concat(self:EquipItems())
end

function Game_Party:ItemContainer(item)
	if !item then
		return nil
	end else if DataManager.isItem(item) then
		return self._items
	end else if DataManager.isWeapon(item) then
		return self._weapons
	end else if DataManager.isArmor(item) then
		return self._armors
	end else {
		return nil
	end
end

function Game_Party:SetupStartingMembers()
	self._actors = []
	for (local actorId of Data.System.partyMembers) {
		if Game.Actors.actor(actorId) then
			self._actors.push(actorId)
		end
	end
end

function Game_Party:Name()
	local numBattleMembers = self:BattleMembers().length
	if numBattleMembers === 0 then
		return ""
	end else if numBattleMembers === 1 then
		return self:Leader().name()
	end else {
		return TextManager.partyName.format(self:Leader().name())
	end
end

function Game_Party:SetupBattleTest()
	self:SetupBattleTestMembers()
	self:SetupBattleTestItems()
end

function Game_Party:SetupBattleTestMembers()
	for (local battler of Data.System.testBattlers) {
		local actor = Game.Actors.actor(battler.actorId)
		if actor then
			actor.changeLevel(battler.level, false)
			actor.initEquips(battler.equips)
			actor.recoverAll()
			self:AddActor(battler.actorId)
		end
	end
end

function Game_Party:SetupBattleTestItems()
	for (local item of Data.Items) {
		if item and item.name.length > 0 then
			self:GainItem(item, self:MaxItems(item))
		end
	end
end

function Game_Party:HighestLevel()
	return Math.max(...self:Members().map((actor) => actor.level))
end

function Game_Party:AddActor(actorId)
	if !self._actors.includes(actorId) then
		self._actors.push(actorId)
		Game.Player.refresh()
		Game.Map.requestRefresh()
		Game.Temp.requestBattleRefresh()
		if self:InBattle() then
			local actor = Game.Actors.actor(actorId)
			if self:BattleMembers().includes(actor) then
				actor.onBattleStart()
			end
		end
	end
end

function Game_Party:RemoveActor(actorId)
	if self._actors.includes(actorId) then
		local actor = Game.Actors.actor(actorId)
		local wasBattleMember = self:BattleMembers().includes(actor)
		self._actors.remove(actorId)
		Game.Player.refresh()
		Game.Map.requestRefresh()
		Game.Temp.requestBattleRefresh()
		if self:InBattle() and wasBattleMember then
			actor.onBattleEnd()
		end
	end
end

function Game_Party:Gold()
	return self._gold
end

function Game_Party:GainGold(amount)
	self._gold = (self._gold + amount).clamp(0, self:MaxGold())
end

function Game_Party:LoseGold(amount)
	self:GainGold(-amount)
end

function Game_Party:MaxGold()
	return 99999999
end

function Game_Party:Steps()
	return self._steps
end

function Game_Party:IncreaseSteps()
	self._steps++
end

function Game_Party:NumItems(item)
	local container = self:ItemContainer(item)
	return container ? container[item.id] or 0 : 0
end

function Game_Party:MaxItems(/*item*/)
	return 99
end

function Game_Party:HasMaxItems(item)
	return self:NumItems(item) >= self:MaxItems(item)
end

function Game_Party:HasItem(item, includeEquip)
	if self:NumItems(item) > 0 then
		return true
	end else if includeEquip and self:IsAnyMemberEquipped(item) then
		return true
	end else {
		return false
	end
end

function Game_Party:IsAnyMemberEquipped(item)
	return self:Members().some((actor) => actor.equips().includes(item))
end

function Game_Party:GainItem(item, amount, includeEquip)
	local container = self:ItemContainer(item)
	if container then
		local lastNumber = self:NumItems(item)
		local newNumber = lastNumber + amount
		container[item.id] = newNumber.clamp(0, self:MaxItems(item))
		if container[item.id] === 0 then
			delete container[item.id]
		end
		if includeEquip and newNumber < 0 then
			self:DiscardMembersEquip(item, -newNumber)
		end
		Game.Map.requestRefresh()
	end
end

function Game_Party:DiscardMembersEquip(item, amount)
	local n = amount
	for (local actor of self:Members()) {
		while (n > 0 and actor.isEquipped(item)) {
			actor.discardEquip(item)
			n--
		end
	end
end

function Game_Party:LoseItem(item, amount, includeEquip)
	self:GainItem(item, -amount, includeEquip)
end

function Game_Party:ConsumeItem(item)
	if DataManager.isItem(item) and item.consumable then
		self:LoseItem(item, 1)
	end
end

function Game_Party:CanUse(item)
	return self:Members().some((actor) => actor.canUse(item))
end

function Game_Party:CanInput()
	return self:Members().some((actor) => actor.canInput())
end

function Game_Party:IsAllDead()
	if Game_Unit.prototype.isAllDead.call(this) then
		return self:InBattle() or !self:IsEmpty()
	end else {
		return false
	end
end

function Game_Party:IsEscaped()
	return self:IsAllDead() and self:HiddenBattleMembers().length > 0
end

function Game_Party:OnPlayerWalk()
	for (local actor of self:Members()) {
		actor.onPlayerWalk()
	end
end

function Game_Party:MenuActor()
	local actor = Game.Actors.actor(self._menuActorId)
	if !self:Members().includes(actor) then
		actor = self:Members()[0]
	end
	return actor
end

function Game_Party:SetMenuActor(actor)
	self._menuActorId = actor.actorId()
end

function Game_Party:MakeMenuActorNext()
	local index = self:Members().indexOf(self:MenuActor())
	if index >= 0 then
		index = (index + 1) % self:Members().length
		self:SetMenuActor(self:Members()[index])
	end else {
		self:SetMenuActor(self:Members()[0])
	end
end

function Game_Party:MakeMenuActorPrevious()
	local index = self:Members().indexOf(self:MenuActor())
	if index >= 0 then
		index = (index + self:Members().length - 1) % self:Members().length
		self:SetMenuActor(self:Members()[index])
	end else {
		self:SetMenuActor(self:Members()[0])
	end
end

function Game_Party:TargetActor()
	local actor = Game.Actors.actor(self._targetActorId)
	if !self:Members().includes(actor) then
		actor = self:Members()[0]
	end
	return actor
end

function Game_Party:SetTargetActor(actor)
	self._targetActorId = actor.actorId()
end

function Game_Party:LastItem()
	return self._lastItem.object()
end

function Game_Party:SetLastItem(item)
	self._lastItem.setObject(item)
end

function Game_Party:SwapOrder(index1, index2)
	local temp = self._actors[index1]
	self._actors[index1] = self._actors[index2]
	self._actors[index2] = temp
	Game.Player.refresh()
end

function Game_Party:CharactersForSavefile()
	return self:BattleMembers().map((actor) => [actor.characterName(), actor.characterIndex()])
end

function Game_Party:FacesForSavefile()
	return self:BattleMembers().map((actor) => [actor.faceName(), actor.faceIndex()])
end

function Game_Party:PartyAbility(abilityId)
	return self:BattleMembers().some((actor) => actor.partyAbility(abilityId))
end

function Game_Party:HasEncounterHalf()
	return self:PartyAbility(Game_Party.ABILITY_ENCOUNTER_HALF)
end

function Game_Party:HasEncounterNone()
	return self:PartyAbility(Game_Party.ABILITY_ENCOUNTER_NONE)
end

function Game_Party:HasCancelSurprise()
	return self:PartyAbility(Game_Party.ABILITY_CANCEL_SURPRISE)
end

function Game_Party:HasRaisePreemptive()
	return self:PartyAbility(Game_Party.ABILITY_RAISE_PREEMPTIVE)
end

function Game_Party:HasGoldDouble()
	return self:PartyAbility(Game_Party.ABILITY_GOLD_DOUBLE)
end

function Game_Party:HasDropItemDouble()
	return self:PartyAbility(Game_Party.ABILITY_DROP_ITEM_DOUBLE)
end

function Game_Party:RatePreemptive(troopAgi)
	local rate = self:Agility() >= troopAgi ? 0.05 : 0.03
	if self:HasRaisePreemptive() then
		rate *= 4
	end
	return rate
end

function Game_Party:RateSurprise(troopAgi)
	local rate = self:Agility() >= troopAgi ? 0.03 : 0.05
	if self:HasCancelSurprise() then
		rate = 0
	end
	return rate
end

function Game_Party:PerformVictory()
	for (local actor of self:Members()) {
		actor.performVictory()
	end
end

function Game_Party:PerformEscape()
	for (local actor of self:Members()) {
		actor.performEscape()
	end
end

function Game_Party:RemoveBattleStates()
	for (local actor of self:Members()) {
		actor.removeBattleStates()
	end
end

function Game_Party:RequestMotionRefresh()
	for (local actor of self:Members()) {
		actor.requestMotionRefresh()
	end
end

function Game_Party:OnEscapeFailure()
	for (local actor of self:Members()) {
		actor.onEscapeFailure()
	end
end

-------------------------------------------------------------------------------
-- Game_Troop
--
-- The game object class for a troop and the battle-related data.

function Game_Troop.new()
	self:Initialize(...arguments)
end

Game_Troop.prototype = Object.create(Game_Unit.prototype)
Game_Troop.prototype.constructor = Game_Troop

-- prettier-ignore
Game_Troop.LETTER_TABLE_HALF = [
	" A"," B"," C"," D"," E"," F"," G"," H"," I"," J"," K"," L"," M",
	" N"," O"," P"," Q"," R"," S"," T"," U"," V"," W"," X"," Y"," Z"
]
-- prettier-ignore
Game_Troop.LETTER_TABLE_FULL = [
	"Ａ","Ｂ","Ｃ","Ｄ","Ｅ","Ｆ","Ｇ","Ｈ","Ｉ","Ｊ","Ｋ","Ｌ","Ｍ",
	"Ｎ","Ｏ","Ｐ","Ｑ","Ｒ","Ｓ","Ｔ","Ｕ","Ｖ","Ｗ","Ｘ","Ｙ","Ｚ"
]

function Game_Troop:Initialize()
	Game_Unit.prototype.initialize.call(this)
	self._interpreter = new Game_Interpreter()
	self:Clear()
end

function Game_Troop:IsEventRunning()
	return self._interpreter.isRunning()
end

function Game_Troop:UpdateInterpreter()
	self._interpreter.update()
end

function Game_Troop:TurnCount()
	return self._turnCount
end

function Game_Troop:Members()
	return self._enemies
end

function Game_Troop:Clear()
	self._interpreter.clear()
	self._troopId = 0
	self._eventFlags = {end
	self._enemies = []
	self._turnCount = 0
	self._namesCount = {end
end

function Game_Troop:Troop()
	return Data.Troops[self._troopId]
end

function Game_Troop:Setup(troopId)
	self:Clear()
	self._troopId = troopId
	self._enemies = []
	for (local member of self:Troop().members) {
		if Data.Enemies[member.enemyId] then
			local enemyId = member.enemyId
			local x = member.x
			local y = member.y
			local enemy = new Game_Enemy(enemyId, x, y)
			if member.hidden then
				enemy.hide()
			end
			self._enemies.push(enemy)
		end
	end
	self:MakeUniqueNames()
end

function Game_Troop:MakeUniqueNames()
	local table = self:LetterTable()
	for (local enemy of self:Members()) {
		if enemy.isAlive() and enemy.isLetterEmpty() then
			local name = enemy.originalName()
			local n = self._namesCount[name] or 0
			enemy.setLetter(table[n % table.length])
			self._namesCount[name] = n + 1
		end
	end
	self:UpdatePluralFlags()
end

function Game_Troop:UpdatePluralFlags()
	for (local enemy of self:Members()) {
		local name = enemy.originalName()
		if self._namesCount[name] >= 2 then
			enemy.setPlural(true)
		end
	end
end

function Game_Troop:LetterTable()
	return Game.System.isCJK() ? Game_Troop.LETTER_TABLE_FULL : Game_Troop.LETTER_TABLE_HALF
end

function Game_Troop:EnemyNames()
	local names = []
	for (local enemy of self:Members()) {
		local name = enemy.originalName()
		if enemy.isAlive() and !names.includes(name) then
			names.push(name)
		end
	end
	return names
end

function Game_Troop:MeetsConditions(page)
	local c = page.conditions
	if !c.turnEnding and !c.turnValid and !c.enemyValid and !c.actorValid and !c.switchValid then
		return false -- Conditions not set
	end
	if c.turnEnding then
		if !BattleManager.isTurnEnd() then
			return false
		end
	end
	if c.turnValid then
		local n = self._turnCount
		local a = c.turnA
		local b = c.turnB
		if b === 0 and n ~= a then
			return false
		end
		if b > 0 and (n < 1 or n < a or n % b ~= a % b) then
			return false
		end
	end
	if c.enemyValid then
		local enemy = Game.Troop.members()[c.enemyIndex]
		if !enemy or enemy.hpRate() * 100 > c.enemyHp then
			return false
		end
	end
	if c.actorValid then
		local actor = Game.Actors.actor(c.actorId)
		if !actor or actor.hpRate() * 100 > c.actorHp then
			return false
		end
	end
	if c.switchValid then
		if !Game.Switches.value(c.switchId) then
			return false
		end
	end
	return true
end

function Game_Troop:SetupBattleEvent()
	if !self._interpreter.isRunning() then
		if self._interpreter.setupReservedCommonEvent() then
			return
		end
		local pages = self:Troop().pages
		for (local i = 0 i < pages.length i++) {
			local page = pages[i]
			if self:MeetsConditions(page) and !self._eventFlags[i] then
				self._interpreter.setup(page.list)
				if page.span <= 1 then
					self._eventFlags[i] = true
				end
				break
			end
		end
	end
end

function Game_Troop:IncreaseTurn()
	local pages = self:Troop().pages
	for (local i = 0 i < pages.length i++) {
		local page = pages[i]
		if page.span === 1 then
			self._eventFlags[i] = false
		end
	end
	self._turnCount++
end

function Game_Troop:ExpTotal()
	return self:DeadMembers().reduce((r, enemy) => r + enemy.exp(), 0)
end

function Game_Troop:GoldTotal()
	local members = self:DeadMembers()
	return members.reduce((r, enemy) => r + enemy.gold(), 0) * self:GoldRate()
end

function Game_Troop:GoldRate()
	return Game.Party.hasGoldDouble() ? 2 : 1
end

function Game_Troop:MakeDropItems()
	local members = self:DeadMembers()
	return members.reduce((r, enemy) => r.concat(enemy.makeDropItems()), [])
end

function Game_Troop:IsTpbTurnEnd()
	local members = self:Members()
	local turnMax = Math.max(...members.map((member) => member.turnCount()))
	return turnMax > self._turnCount
end

-------------------------------------------------------------------------------
-- Game_Map
--
-- The game object class for a map. It contains scrolling and passage
-- determination functions.

function Game_Map.new()
	self:Initialize(...arguments)
end

function Game_Map:Initialize()
	self._interpreter = new Game_Interpreter()
	self._mapId = 0
	self._tilesetId = 0
	self._events = []
	self._commonEvents = []
	self._vehicles = []
	self._displayX = 0
	self._displayY = 0
	self._nameDisplay = true
	self._scrollDirection = 2
	self._scrollRest = 0
	self._scrollSpeed = 4
	self._parallaxName = ""
	self._parallaxZero = false
	self._parallaxLoopX = false
	self._parallaxLoopY = false
	self._parallaxSx = 0
	self._parallaxSy = 0
	self._parallaxX = 0
	self._parallaxY = 0
	self._battleback1Name = nil
	self._battleback2Name = nil
	self:CreateVehicles()
end

function Game_Map:Setup(mapId)
	if !Data.Map then
		throw new Error("The map data is not available")
	end
	self._mapId = mapId
	self._tilesetId = Data.Map.tilesetId
	self._displayX = 0
	self._displayY = 0
	self:RefereshVehicles()
	self:SetupEvents()
	self:SetupScroll()
	self:SetupParallax()
	self:SetupBattleback()
	self._needsRefresh = false
end

function Game_Map:IsEventRunning()
	return self._interpreter.isRunning() or self:IsAnyEventStarting()
end

function Game_Map:TileWidth()
	if "tileSize" in Data.System then
		return Data.System.tileSize
	end else {
		return 48
	end
end

function Game_Map:TileHeight()
	return self:TileWidth()
end

function Game_Map:BushDepth()
	return self:TileHeight() / 4
end

function Game_Map:MapId()
	return self._mapId
end

function Game_Map:TilesetId()
	return self._tilesetId
end

function Game_Map:DisplayX()
	return self._displayX
end

function Game_Map:DisplayY()
	return self._displayY
end

function Game_Map:ParallaxName()
	return self._parallaxName
end

function Game_Map:Battleback1Name()
	return self._battleback1Name
end

function Game_Map:Battleback2Name()
	return self._battleback2Name
end

function Game_Map:RequestRefresh()
	self._needsRefresh = true
end

function Game_Map:IsNameDisplayEnabled()
	return self._nameDisplay
end

function Game_Map:DisableNameDisplay()
	self._nameDisplay = false
end

function Game_Map:EnableNameDisplay()
	self._nameDisplay = true
end

function Game_Map:CreateVehicles()
	self._vehicles = []
	self._vehicles[0] = new Game_Vehicle("boat")
	self._vehicles[1] = new Game_Vehicle("ship")
	self._vehicles[2] = new Game_Vehicle("airship")
end

function Game_Map:RefereshVehicles()
	for (local vehicle of self._vehicles) {
		vehicle.refresh()
	end
end

function Game_Map:Vehicles()
	return self._vehicles
end

function Game_Map:Vehicle(type)
	if type === 0 or type === "boat" then
		return self:Boat()
	end else if type === 1 or type === "ship" then
		return self:Ship()
	end else if type === 2 or type === "airship" then
		return self:Airship()
	end else {
		return nil
	end
end

function Game_Map:Boat()
	return self._vehicles[0]
end

function Game_Map:Ship()
	return self._vehicles[1]
end

function Game_Map:Airship()
	return self._vehicles[2]
end

function Game_Map:SetupEvents()
	self._events = []
	self._commonEvents = []
	for (local event of Data.Map.events.filter((event) => !!event)) {
		self._events[event.id] = new Game_Event(self._mapId, event.id)
	end
	for (local commonEvent of self:ParallelCommonEvents()) {
		self._commonEvents.push(new Game_CommonEvent(commonEvent.id))
	end
	self:RefreshTileEvents()
end

function Game_Map:Events()
	return self._events.filter((event) => !!event)
end

function Game_Map:Event(eventId)
	return self._events[eventId]
end

function Game_Map:EraseEvent(eventId)
	self._events[eventId].erase()
end

function Game_Map:AutorunCommonEvents()
	return Data.CommonEvents.filter((commonEvent) => commonEvent and commonEvent.trigger === 1)
end

function Game_Map:ParallelCommonEvents()
	return Data.CommonEvents.filter((commonEvent) => commonEvent and commonEvent.trigger === 2)
end

function Game_Map:SetupScroll()
	self._scrollDirection = 2
	self._scrollRest = 0
	self._scrollSpeed = 4
end

function Game_Map:SetupParallax()
	self._parallaxName = Data.Map.parallaxName or ""
	self._parallaxZero = ImageManager.isZeroParallax(self._parallaxName)
	self._parallaxLoopX = Data.Map.parallaxLoopX
	self._parallaxLoopY = Data.Map.parallaxLoopY
	self._parallaxSx = Data.Map.parallaxSx
	self._parallaxSy = Data.Map.parallaxSy
	self._parallaxX = 0
	self._parallaxY = 0
end

function Game_Map:SetupBattleback()
	if Data.Map.specifyBattleback then
		self._battleback1Name = Data.Map.battleback1Name
		self._battleback2Name = Data.Map.battleback2Name
	end else {
		self._battleback1Name = nil
		self._battleback2Name = nil
	end
end

function Game_Map:SetDisplayPos(x, y)
	if self:IsLoopHorizontal() then
		self._displayX = x.mod(self:Width())
		self._parallaxX = x
	end else {
		local endX = self:Width() - self:ScreenTileX()
		self._displayX = endX < 0 ? endX / 2 : x.clamp(0, endX)
		self._parallaxX = self._displayX
	end
	if self:IsLoopVertical() then
		self._displayY = y.mod(self:Height())
		self._parallaxY = y
	end else {
		local endY = self:Height() - self:ScreenTileY()
		self._displayY = endY < 0 ? endY / 2 : y.clamp(0, endY)
		self._parallaxY = self._displayY
	end
end

function Game_Map:ParallaxOx()
	if self._parallaxZero then
		return self._parallaxX * self:TileWidth()
	end else if self._parallaxLoopX then
		return (self._parallaxX * self:TileWidth()) / 2
	end else {
		return 0
	end
end

function Game_Map:ParallaxOy()
	if self._parallaxZero then
		return self._parallaxY * self:TileHeight()
	end else if self._parallaxLoopY then
		return (self._parallaxY * self:TileHeight()) / 2
	end else {
		return 0
	end
end

function Game_Map:Tileset()
	return Data.Tilesets[self._tilesetId]
end

function Game_Map:TilesetFlags()
	local tileset = self:Tileset()
	if tileset then
		return tileset.flags
	end else {
		return []
	end
end

function Game_Map:DisplayName()
	return Data.Map.displayName
end

function Game_Map:Width()
	return Data.Map.width
end

function Game_Map:Height()
	return Data.Map.height
end

function Game_Map:Data()
	return Data.Map.data
end

function Game_Map:IsLoopHorizontal()
	return Data.Map.scrollType === 2 or Data.Map.scrollType === 3
end

function Game_Map:IsLoopVertical()
	return Data.Map.scrollType === 1 or Data.Map.scrollType === 3
end

function Game_Map:IsDashDisabled()
	return Data.Map.disableDashing
end

function Game_Map:EncounterList()
	return Data.Map.encounterList
end

function Game_Map:EncounterStep()
	return Data.Map.encounterStep
end

function Game_Map:IsOverworld()
	return self:Tileset() and self:Tileset().mode === 0
end

function Game_Map:ScreenTileX()
	return Math.round((Graphics.width / self:TileWidth()) * 16) / 16
end

function Game_Map:ScreenTileY()
	return Math.round((Graphics.height / self:TileHeight()) * 16) / 16
end

function Game_Map:AdjustX(x)
	if self:IsLoopHorizontal() and x < self._displayX - (self:Width() - self:ScreenTileX()) / 2 then
		return x - self._displayX + Data.Map.width
	end else {
		return x - self._displayX
	end
end

function Game_Map:AdjustY(y)
	if self:IsLoopVertical() and y < self._displayY - (self:Height() - self:ScreenTileY()) / 2 then
		return y - self._displayY + Data.Map.height
	end else {
		return y - self._displayY
	end
end

function Game_Map:RoundX(x)
	return self:IsLoopHorizontal() ? x.mod(self:Width()) : x
end

function Game_Map:RoundY(y)
	return self:IsLoopVertical() ? y.mod(self:Height()) : y
end

function Game_Map:XWithDirection(x, d)
	return x + (d === 6 ? 1 : d === 4 ? -1 : 0)
end

function Game_Map:YWithDirection(y, d)
	return y + (d === 2 ? 1 : d === 8 ? -1 : 0)
end

function Game_Map:RoundXWithDirection(x, d)
	return self:RoundX(x + (d === 6 ? 1 : d === 4 ? -1 : 0))
end

function Game_Map:RoundYWithDirection(y, d)
	return self:RoundY(y + (d === 2 ? 1 : d === 8 ? -1 : 0))
end

function Game_Map:DeltaX(x1, x2)
	local result = x1 - x2
	if self:IsLoopHorizontal() and Math.abs(result) > self:Width() / 2 then
		if result < 0 then
			result += self:Width()
		end else {
			result -= self:Width()
		end
	end
	return result
end

function Game_Map:DeltaY(y1, y2)
	local result = y1 - y2
	if self:IsLoopVertical() and Math.abs(result) > self:Height() / 2 then
		if result < 0 then
			result += self:Height()
		end else {
			result -= self:Height()
		end
	end
	return result
end

function Game_Map:Distance(x1, y1, x2, y2)
	return Math.abs(self:DeltaX(x1, x2)) + Math.abs(self:DeltaY(y1, y2))
end

function Game_Map:CanvasToMapX(x)
	local tileWidth = self:TileWidth()
	local originX = self._displayX * tileWidth
	local mapX = Math.floor((originX + x) / tileWidth)
	return self:RoundX(mapX)
end

function Game_Map:CanvasToMapY(y)
	local tileHeight = self:TileHeight()
	local originY = self._displayY * tileHeight
	local mapY = Math.floor((originY + y) / tileHeight)
	return self:RoundY(mapY)
end

function Game_Map:Autoplay()
	if Data.Map.autoplayBgm then
		if Game.Player.isInVehicle() then
			Game.System.saveWalkingBgm2()
		end else {
			AudioManager.playBgm(Data.Map.bgm)
		end
	end
	if Data.Map.autoplayBgs then
		AudioManager.playBgs(Data.Map.bgs)
	end
end

function Game_Map:RefreshIfNeeded()
	if self._needsRefresh then
		self:Refresh()
	end
end

function Game_Map:Refresh()
	for (local event of self:Events()) {
		event.refresh()
	end
	for (local commonEvent of self._commonEvents) {
		commonEvent.refresh()
	end
	self:RefreshTileEvents()
	self._needsRefresh = false
end

function Game_Map:RefreshTileEvents()
	self._tileEvents = self:Events().filter((event) => event.isTile())
end

function Game_Map:EventsXy(x, y)
	return self:Events().filter((event) => event.pos(x, y))
end

function Game_Map:EventsXyNt(x, y)
	return self:Events().filter((event) => event.posNt(x, y))
end

function Game_Map:TileEventsXy(x, y)
	return self._tileEvents.filter((event) => event.posNt(x, y))
end

function Game_Map:EventIdXy(x, y)
	local list = self:EventsXy(x, y)
	return list.length === 0 ? 0 : list[0].eventId()
end

function Game_Map:ScrollDown(distance)
	if self:IsLoopVertical() then
		self._displayY += distance
		self._displayY %= Data.Map.height
		if self._parallaxLoopY then
			self._parallaxY += distance
		end
	end else if self:Height() >= self:ScreenTileY() then
		local lastY = self._displayY
		self._displayY = Math.min(self._displayY + distance, self:Height() - self:ScreenTileY())
		self._parallaxY += self._displayY - lastY
	end
end

function Game_Map:ScrollLeft(distance)
	if self:IsLoopHorizontal() then
		self._displayX += Data.Map.width - distance
		self._displayX %= Data.Map.width
		if self._parallaxLoopX then
			self._parallaxX -= distance
		end
	end else if self:Width() >= self:ScreenTileX() then
		local lastX = self._displayX
		self._displayX = Math.max(self._displayX - distance, 0)
		self._parallaxX += self._displayX - lastX
	end
end

function Game_Map:ScrollRight(distance)
	if self:IsLoopHorizontal() then
		self._displayX += distance
		self._displayX %= Data.Map.width
		if self._parallaxLoopX then
			self._parallaxX += distance
		end
	end else if self:Width() >= self:ScreenTileX() then
		local lastX = self._displayX
		self._displayX = Math.min(self._displayX + distance, self:Width() - self:ScreenTileX())
		self._parallaxX += self._displayX - lastX
	end
end

function Game_Map:ScrollUp(distance)
	if self:IsLoopVertical() then
		self._displayY += Data.Map.height - distance
		self._displayY %= Data.Map.height
		if self._parallaxLoopY then
			self._parallaxY -= distance
		end
	end else if self:Height() >= self:ScreenTileY() then
		local lastY = self._displayY
		self._displayY = Math.max(self._displayY - distance, 0)
		self._parallaxY += self._displayY - lastY
	end
end

function Game_Map:IsValid(x, y)
	return x >= 0 and x < self:Width() and y >= 0 and y < self:Height()
end

function Game_Map:CheckPassage(x, y, bit)
	local flags = self:TilesetFlags()
	local tiles = self:AllTiles(x, y)
	for (local tile of tiles) {
		local flag = flags[tile]
		if (flag & 0x10) ~= 0 then
			-- [*] No effect on passage
			continue
		end
		if (flag & bit) === 0 then
			-- [o] Passable
			return true
		end
		if (flag & bit) === bit then
			-- [x] Impassable
			return false
		end
	end
	return false
end

function Game_Map:TileId(x, y, z)
	local width = Data.Map.width
	local height = Data.Map.height
	return Data.Map.data[(z * height + y) * width + x] or 0
end

function Game_Map:LayeredTiles(x, y)
	local tiles = []
	for (local i = 0 i < 4 i++) {
		tiles.push(self:TileId(x, y, 3 - i))
	end
	return tiles
end

function Game_Map:AllTiles(x, y)
	local tiles = self:TileEventsXy(x, y).map((event) => event.tileId())
	return tiles.concat(self:LayeredTiles(x, y))
end

function Game_Map:AutotileType(x, y, z)
	local tileId = self:TileId(x, y, z)
	return tileId >= 2048 ? Math.floor((tileId - 2048) / 48) : -1
end

function Game_Map:IsPassable(x, y, d)
	return self:CheckPassage(x, y, (1 << (d / 2 - 1)) & 0x0f)
end

function Game_Map:IsBoatPassable(x, y)
	return self:CheckPassage(x, y, 0x0200)
end

function Game_Map:IsShipPassable(x, y)
	return self:CheckPassage(x, y, 0x0400)
end

function Game_Map:IsAirshipLandOk(x, y)
	return self:CheckPassage(x, y, 0x0800) and self:CheckPassage(x, y, 0x0f)
end

function Game_Map:CheckLayeredTilesFlags(x, y, bit)
	local flags = self:TilesetFlags()
	return self:LayeredTiles(x, y).some((tileId) => (flags[tileId] & bit) ~= 0)
end

function Game_Map:IsLadder(x, y)
	return self:IsValid(x, y) and self:CheckLayeredTilesFlags(x, y, 0x20)
end

function Game_Map:IsBush(x, y)
	return self:IsValid(x, y) and self:CheckLayeredTilesFlags(x, y, 0x40)
end

function Game_Map:IsCounter(x, y)
	return self:IsValid(x, y) and self:CheckLayeredTilesFlags(x, y, 0x80)
end

function Game_Map:IsDamageFloor(x, y)
	return self:IsValid(x, y) and self:CheckLayeredTilesFlags(x, y, 0x100)
end

function Game_Map:TerrainTag(x, y)
	if self:IsValid(x, y) then
		local flags = self:TilesetFlags()
		local tiles = self:LayeredTiles(x, y)
		for (local tile of tiles) {
			local tag = flags[tile] >> 12
			if tag > 0 then
				return tag
			end
		end
	end
	return 0
end

function Game_Map:RegionId(x, y)
	return self:IsValid(x, y) ? self:TileId(x, y, 5) : 0
end

function Game_Map:StartScroll(direction, distance, speed)
	self._scrollDirection = direction
	self._scrollRest = distance
	self._scrollSpeed = speed
end

function Game_Map:IsScrolling()
	return self._scrollRest > 0
end

function Game_Map:Update(sceneActive)
	self:RefreshIfNeeded()
	if sceneActive then
		self:UpdateInterpreter()
	end
	self:UpdateScroll()
	self:UpdateEvents()
	self:UpdateVehicles()
	self:UpdateParallax()
end

function Game_Map:UpdateScroll()
	if self:IsScrolling() then
		local lastX = self._displayX
		local lastY = self._displayY
		self:DoScroll(self._scrollDirection, self:ScrollDistance())
		if self._displayX === lastX and self._displayY === lastY then
			self._scrollRest = 0
		end else {
			self._scrollRest -= self:ScrollDistance()
		end
	end
end

function Game_Map:ScrollDistance()
	return Math.pow(2, self._scrollSpeed) / 256
end

function Game_Map:DoScroll(direction, distance)
	switch (direction) {
		case 2:
			self:ScrollDown(distance)
			break
		case 4:
			self:ScrollLeft(distance)
			break
		case 6:
			self:ScrollRight(distance)
			break
		case 8:
			self:ScrollUp(distance)
			break
	end
end

function Game_Map:UpdateEvents()
	for (local event of self:Events()) {
		event.update()
	end
	for (local commonEvent of self._commonEvents) {
		commonEvent.update()
	end
end

function Game_Map:UpdateVehicles()
	for (local vehicle of self._vehicles) {
		vehicle.update()
	end
end

function Game_Map:UpdateParallax()
	if self._parallaxLoopX then
		self._parallaxX += self._parallaxSx / self:TileWidth() / 2
	end
	if self._parallaxLoopY then
		self._parallaxY += self._parallaxSy / self:TileHeight() / 2
	end
end

function Game_Map:ChangeTileset(tilesetId)
	self._tilesetId = tilesetId
	self:Refresh()
end

function Game_Map:ChangeBattleback(battleback1Name, battleback2Name)
	self._battleback1Name = battleback1Name
	self._battleback2Name = battleback2Name
end

function Game_Map:ChangeParallax(name, loopX, loopY, sx, sy)
	self._parallaxName = name
	self._parallaxZero = ImageManager.isZeroParallax(self._parallaxName)
	if self._parallaxLoopX and !loopX then
		self._parallaxX = 0
	end
	if self._parallaxLoopY and !loopY then
		self._parallaxY = 0
	end
	self._parallaxLoopX = loopX
	self._parallaxLoopY = loopY
	self._parallaxSx = sx
	self._parallaxSy = sy
end

function Game_Map:UpdateInterpreter()
	for () {
		self._interpreter.update()
		if self._interpreter.isRunning() then
			return
		end
		if self._interpreter.eventId() > 0 then
			self:UnlockEvent(self._interpreter.eventId())
			self._interpreter.clear()
		end
		if !self:SetupStartingEvent() then
			return
		end
	end
end

function Game_Map:UnlockEvent(eventId)
	if self._events[eventId] then
		self._events[eventId].unlock()
	end
end

function Game_Map:SetupStartingEvent()
	self:RefreshIfNeeded()
	if self._interpreter.setupReservedCommonEvent() then
		return true
	end
	if self:SetupTestEvent() then
		return true
	end
	if self:SetupStartingMapEvent() then
		return true
	end
	if self:SetupAutorunCommonEvent() then
		return true
	end
	return false
end

function Game_Map:SetupTestEvent()
	if window.TestEvent then
		self._interpreter.setup(TestEvent, 0)
		TestEvent = nil
		return true
	end
	return false
end

function Game_Map:SetupStartingMapEvent()
	for (local event of self:Events()) {
		if event.isStarting() then
			event.clearStartingFlag()
			self._interpreter.setup(event.list(), event.eventId())
			return true
		end
	end
	return false
end

function Game_Map:SetupAutorunCommonEvent()
	for (local commonEvent of self:AutorunCommonEvents()) {
		if Game.Switches.value(commonEvent.switchId) then
			self._interpreter.setup(commonEvent.list)
			return true
		end
	end
	return false
end

function Game_Map:IsAnyEventStarting()
	return self:Events().some((event) => event.isStarting())
end

-------------------------------------------------------------------------------
-- Game_CommonEvent
--
-- The game object class for a common event. It contains functionality for
-- running parallel process events.

function Game_CommonEvent.new()
	self:Initialize(...arguments)
end

function Game_CommonEvent:Initialize(commonEventId)
	self._commonEventId = commonEventId
	self:Refresh()
end

function Game_CommonEvent:Event()
	return Data.CommonEvents[self._commonEventId]
end

function Game_CommonEvent:List()
	return self:Event().list
end

function Game_CommonEvent:Refresh()
	if self:IsActive() then
		if !self._interpreter then
			self._interpreter = new Game_Interpreter()
		end
	end else {
		self._interpreter = nil
	end
end

function Game_CommonEvent:IsActive()
	local event = self:Event()
	return event.trigger === 2 and Game.Switches.value(event.switchId)
end

function Game_CommonEvent:Update()
	if self._interpreter then
		if !self._interpreter.isRunning() then
			self._interpreter.setup(self:List())
		end
		self._interpreter.update()
	end
end

-------------------------------------------------------------------------------
-- Game_CharacterBase
--
-- The superclass of Game_Character. It handles basic information, such as
-- coordinates and images, shared by all characters.

function Game_CharacterBase.new()
	self:Initialize(...arguments)
end

Object.defineProperties(Game_CharacterBase.prototype, {
	x: {
		get: function .new()
			return self._x
		end,
		configurable: true,
	end,
	y: {
		get: function .new()
			return self._y
		end,
		configurable: true,
	end,
end)

function Game_CharacterBase:Initialize()
	self:InitMembers()
end

function Game_CharacterBase:InitMembers()
	self._x = 0
	self._y = 0
	self._realX = 0
	self._realY = 0
	self._moveSpeed = 4
	self._moveFrequency = 6
	self._opacity = 255
	self._blendMode = 0
	self._direction = 2
	self._pattern = 1
	self._priorityType = 1
	self._tileId = 0
	self._characterName = ""
	self._characterIndex = 0
	self._isObjectCharacter = false
	self._walkAnime = true
	self._stepAnime = false
	self._directionFix = false
	self._through = false
	self._transparent = false
	self._bushDepth = 0
	self._animationId = 0
	self._balloonId = 0
	self._animationPlaying = false
	self._balloonPlaying = false
	self._animationCount = 0
	self._stopCount = 0
	self._jumpCount = 0
	self._jumpPeak = 0
	self._movementSuccess = true
end

function Game_CharacterBase:Pos(x, y)
	return self._x === x and self._y === y
end

function Game_CharacterBase:PosNt(x, y)
	-- No through
	return self:Pos(x, y) and !self:IsThrough()
end

function Game_CharacterBase:MoveSpeed()
	return self._moveSpeed
end

function Game_CharacterBase:SetMoveSpeed(moveSpeed)
	self._moveSpeed = moveSpeed
end

function Game_CharacterBase:MoveFrequency()
	return self._moveFrequency
end

function Game_CharacterBase:SetMoveFrequency(moveFrequency)
	self._moveFrequency = moveFrequency
end

function Game_CharacterBase:Opacity()
	return self._opacity
end

function Game_CharacterBase:SetOpacity(opacity)
	self._opacity = opacity
end

function Game_CharacterBase:BlendMode()
	return self._blendMode
end

function Game_CharacterBase:SetBlendMode(blendMode)
	self._blendMode = blendMode
end

function Game_CharacterBase:IsNormalPriority()
	return self._priorityType === 1
end

function Game_CharacterBase:SetPriorityType(priorityType)
	self._priorityType = priorityType
end

function Game_CharacterBase:IsMoving()
	return self._realX ~= self._x or self._realY ~= self._y
end

function Game_CharacterBase:IsJumping()
	return self._jumpCount > 0
end

function Game_CharacterBase:JumpHeight()
	return (self._jumpPeak * self._jumpPeak - Math.pow(Math.abs(self._jumpCount - self._jumpPeak), 2)) / 2
end

function Game_CharacterBase:IsStopping()
	return !self:IsMoving() and !self:IsJumping()
end

function Game_CharacterBase:CheckStop(threshold)
	return self._stopCount > threshold
end

function Game_CharacterBase:ResetStopCount()
	self._stopCount = 0
end

function Game_CharacterBase:RealMoveSpeed()
	return self._moveSpeed + (self:IsDashing() ? 1 : 0)
end

function Game_CharacterBase:DistancePerFrame()
	return Math.pow(2, self:RealMoveSpeed()) / 256
end

function Game_CharacterBase:IsDashing()
	return false
end

function Game_CharacterBase:IsDebugThrough()
	return false
end

function Game_CharacterBase:Straighten()
	if self:HasWalkAnime() or self:HasStepAnime() then
		self._pattern = 1
	end
	self._animationCount = 0
end

function Game_CharacterBase:ReverseDir(d)
	return 10 - d
end

function Game_CharacterBase:CanPass(x, y, d)
	local x2 = Game.Map.roundXWithDirection(x, d)
	local y2 = Game.Map.roundYWithDirection(y, d)
	if !Game.Map.isValid(x2, y2) then
		return false
	end
	if self:IsThrough() or self:IsDebugThrough() then
		return true
	end
	if !self:IsMapPassable(x, y, d) then
		return false
	end
	if self:IsCollidedWithCharacters(x2, y2) then
		return false
	end
	return true
end

function Game_CharacterBase:CanPassDiagonally(x, y, horz, vert)
	local x2 = Game.Map.roundXWithDirection(x, horz)
	local y2 = Game.Map.roundYWithDirection(y, vert)
	if self:CanPass(x, y, vert) and self:CanPass(x, y2, horz) then
		return true
	end
	if self:CanPass(x, y, horz) and self:CanPass(x2, y, vert) then
		return true
	end
	return false
end

function Game_CharacterBase:IsMapPassable(x, y, d)
	local x2 = Game.Map.roundXWithDirection(x, d)
	local y2 = Game.Map.roundYWithDirection(y, d)
	local d2 = self:ReverseDir(d)
	return Game.Map.isPassable(x, y, d) and Game.Map.isPassable(x2, y2, d2)
end

function Game_CharacterBase:IsCollidedWithCharacters(x, y)
	return self:IsCollidedWithEvents(x, y) or self:IsCollidedWithVehicles(x, y)
end

function Game_CharacterBase:IsCollidedWithEvents(x, y)
	local events = Game.Map.eventsXyNt(x, y)
	return events.some((event) => event.isNormalPriority())
end

function Game_CharacterBase:IsCollidedWithVehicles(x, y)
	return Game.Map.boat().posNt(x, y) or Game.Map.ship().posNt(x, y)
end

function Game_CharacterBase:SetPosition(x, y)
	self._x = Math.round(x)
	self._y = Math.round(y)
	self._realX = x
	self._realY = y
end

function Game_CharacterBase:CopyPosition(character)
	self._x = character._x
	self._y = character._y
	self._realX = character._realX
	self._realY = character._realY
	self._direction = character._direction
end

function Game_CharacterBase:Locate(x, y)
	self:SetPosition(x, y)
	self:Straighten()
	self:RefreshBushDepth()
end

function Game_CharacterBase:Direction()
	return self._direction
end

function Game_CharacterBase:SetDirection(d)
	if !self:IsDirectionFixed() and d then
		self._direction = d
	end
	self:ResetStopCount()
end

function Game_CharacterBase:IsTile()
	return self._tileId > 0 and self._priorityType === 0
end

function Game_CharacterBase:IsObjectCharacter()
	return self._isObjectCharacter
end

function Game_CharacterBase:ShiftY()
	return self:IsObjectCharacter() ? 0 : 6
end

function Game_CharacterBase:ScrolledX()
	return Game.Map.adjustX(self._realX)
end

function Game_CharacterBase:ScrolledY()
	return Game.Map.adjustY(self._realY)
end

function Game_CharacterBase:ScreenX()
	local tw = Game.Map.tileWidth()
	return Math.floor(self:ScrolledX() * tw + tw / 2)
end

function Game_CharacterBase:ScreenY()
	local th = Game.Map.tileHeight()
	return Math.floor(self:ScrolledY() * th + th - self:ShiftY() - self:JumpHeight())
end

function Game_CharacterBase:ScreenZ()
	return self._priorityType * 2 + 1
end

function Game_CharacterBase:IsNearTheScreen()
	local gw = Graphics.width
	local gh = Graphics.height
	local tw = Game.Map.tileWidth()
	local th = Game.Map.tileHeight()
	local px = self:ScrolledX() * tw + tw / 2 - gw / 2
	local py = self:ScrolledY() * th + th / 2 - gh / 2
	return px >= -gw and px <= gw and py >= -gh and py <= gh
end

function Game_CharacterBase:Update()
	if self:IsStopping() then
		self:UpdateStop()
	end
	if self:IsJumping() then
		self:UpdateJump()
	end else if self:IsMoving() then
		self:UpdateMove()
	end
	self:UpdateAnimation()
end

function Game_CharacterBase:UpdateStop()
	self._stopCount++
end

function Game_CharacterBase:UpdateJump()
	self._jumpCount--
	self._realX = (self._realX * self._jumpCount + self._x) / (self._jumpCount + 1.0)
	self._realY = (self._realY * self._jumpCount + self._y) / (self._jumpCount + 1.0)
	self:RefreshBushDepth()
	if self._jumpCount === 0 then
		self._realX = self._x = Game.Map.roundX(self._x)
		self._realY = self._y = Game.Map.roundY(self._y)
	end
end

function Game_CharacterBase:UpdateMove()
	if self._x < self._realX then
		self._realX = Math.max(self._realX - self:DistancePerFrame(), self._x)
	end
	if self._x > self._realX then
		self._realX = Math.min(self._realX + self:DistancePerFrame(), self._x)
	end
	if self._y < self._realY then
		self._realY = Math.max(self._realY - self:DistancePerFrame(), self._y)
	end
	if self._y > self._realY then
		self._realY = Math.min(self._realY + self:DistancePerFrame(), self._y)
	end
	if !self:IsMoving() then
		self:RefreshBushDepth()
	end
end

function Game_CharacterBase:UpdateAnimation()
	self:UpdateAnimationCount()
	if self._animationCount >= self:AnimationWait() then
		self:UpdatePattern()
		self._animationCount = 0
	end
end

function Game_CharacterBase:AnimationWait()
	return (9 - self:RealMoveSpeed()) * 3
end

function Game_CharacterBase:UpdateAnimationCount()
	if self:IsMoving() and self:HasWalkAnime() then
		self._animationCount += 1.5
	end else if self:HasStepAnime() or !self:IsOriginalPattern() then
		self._animationCount++
	end
end

function Game_CharacterBase:UpdatePattern()
	if !self:HasStepAnime() and self._stopCount > 0 then
		self:ResetPattern()
	end else {
		self._pattern = (self._pattern + 1) % self:MaxPattern()
	end
end

function Game_CharacterBase:MaxPattern()
	return 4
end

function Game_CharacterBase:Pattern()
	return self._pattern < 3 ? self._pattern : 1
end

function Game_CharacterBase:SetPattern(pattern)
	self._pattern = pattern
end

function Game_CharacterBase:IsOriginalPattern()
	return self:Pattern() === 1
end

function Game_CharacterBase:ResetPattern()
	self:SetPattern(1)
end

function Game_CharacterBase:RefreshBushDepth()
	if self:IsNormalPriority() and !self:IsObjectCharacter() and self:IsOnBush() and !self:IsJumping() then
		if !self:IsMoving() then
			self._bushDepth = Game.Map.bushDepth()
		end
	end else {
		self._bushDepth = 0
	end
end

function Game_CharacterBase:IsOnLadder()
	return Game.Map.isLadder(self._x, self._y)
end

function Game_CharacterBase:IsOnBush()
	return Game.Map.isBush(self._x, self._y)
end

function Game_CharacterBase:TerrainTag()
	return Game.Map.terrainTag(self._x, self._y)
end

function Game_CharacterBase:RegionId()
	return Game.Map.regionId(self._x, self._y)
end

function Game_CharacterBase:IncreaseSteps()
	if self:IsOnLadder() then
		self:SetDirection(8)
	end
	self:ResetStopCount()
	self:RefreshBushDepth()
end

function Game_CharacterBase:TileId()
	return self._tileId
end

function Game_CharacterBase:CharacterName()
	return self._characterName
end

function Game_CharacterBase:CharacterIndex()
	return self._characterIndex
end

function Game_CharacterBase:SetImage(characterName, characterIndex)
	self._tileId = 0
	self._characterName = characterName
	self._characterIndex = characterIndex
	self._isObjectCharacter = ImageManager.isObjectCharacter(characterName)
end

function Game_CharacterBase:SetTileImage(tileId)
	self._tileId = tileId
	self._characterName = ""
	self._characterIndex = 0
	self._isObjectCharacter = true
end

function Game_CharacterBase:CheckEventTriggerTouchFront(d)
	local x2 = Game.Map.roundXWithDirection(self._x, d)
	local y2 = Game.Map.roundYWithDirection(self._y, d)
	self:CheckEventTriggerTouch(x2, y2)
end

function Game_CharacterBase:CheckEventTriggerTouch(/*x, y*/)
	return false
end

function Game_CharacterBase:IsMovementSucceeded(/*x, y*/)
	return self._movementSuccess
end

function Game_CharacterBase:SetMovementSuccess(success)
	self._movementSuccess = success
end

function Game_CharacterBase:MoveStraight(d)
	self:SetMovementSuccess(self:CanPass(self._x, self._y, d))
	if self:IsMovementSucceeded() then
		self:SetDirection(d)
		self._x = Game.Map.roundXWithDirection(self._x, d)
		self._y = Game.Map.roundYWithDirection(self._y, d)
		self._realX = Game.Map.xWithDirection(self._x, self:ReverseDir(d))
		self._realY = Game.Map.yWithDirection(self._y, self:ReverseDir(d))
		self:IncreaseSteps()
	end else {
		self:SetDirection(d)
		self:CheckEventTriggerTouchFront(d)
	end
end

function Game_CharacterBase:MoveDiagonally(horz, vert)
	self:SetMovementSuccess(self:CanPassDiagonally(self._x, self._y, horz, vert))
	if self:IsMovementSucceeded() then
		self._x = Game.Map.roundXWithDirection(self._x, horz)
		self._y = Game.Map.roundYWithDirection(self._y, vert)
		self._realX = Game.Map.xWithDirection(self._x, self:ReverseDir(horz))
		self._realY = Game.Map.yWithDirection(self._y, self:ReverseDir(vert))
		self:IncreaseSteps()
	end
	if self._direction === self:ReverseDir(horz) then
		self:SetDirection(horz)
	end
	if self._direction === self:ReverseDir(vert) then
		self:SetDirection(vert)
	end
end

function Game_CharacterBase:Jump(xPlus, yPlus)
	if Math.abs(xPlus) > Math.abs(yPlus) then
		if xPlus ~= 0 then
			self:SetDirection(xPlus < 0 ? 4 : 6)
		end
	end else {
		if yPlus ~= 0 then
			self:SetDirection(yPlus < 0 ? 8 : 2)
		end
	end
	self._x += xPlus
	self._y += yPlus
	local distance = Math.round(Math.sqrt(xPlus * xPlus + yPlus * yPlus))
	self._jumpPeak = 10 + distance - self._moveSpeed
	self._jumpCount = self._jumpPeak * 2
	self:ResetStopCount()
	self:Straighten()
end

function Game_CharacterBase:HasWalkAnime()
	return self._walkAnime
end

function Game_CharacterBase:SetWalkAnime(walkAnime)
	self._walkAnime = walkAnime
end

function Game_CharacterBase:HasStepAnime()
	return self._stepAnime
end

function Game_CharacterBase:SetStepAnime(stepAnime)
	self._stepAnime = stepAnime
end

function Game_CharacterBase:IsDirectionFixed()
	return self._directionFix
end

function Game_CharacterBase:SetDirectionFix(directionFix)
	self._directionFix = directionFix
end

function Game_CharacterBase:IsThrough()
	return self._through
end

function Game_CharacterBase:SetThrough(through)
	self._through = through
end

function Game_CharacterBase:IsTransparent()
	return self._transparent
end

function Game_CharacterBase:BushDepth()
	return self._bushDepth
end

function Game_CharacterBase:SetTransparent(transparent)
	self._transparent = transparent
end

function Game_CharacterBase:StartAnimation()
	self._animationPlaying = true
end

function Game_CharacterBase:StartBalloon()
	self._balloonPlaying = true
end

function Game_CharacterBase:IsAnimationPlaying()
	return self._animationPlaying
end

function Game_CharacterBase:IsBalloonPlaying()
	return self._balloonPlaying
end

function Game_CharacterBase:EndAnimation()
	self._animationPlaying = false
end

function Game_CharacterBase:EndBalloon()
	self._balloonPlaying = false
end

-------------------------------------------------------------------------------
-- Game_Character
--
-- The superclass of Game_Player, Game_Follower, GameVehicle, and Game_Event.

function Game_Character.new()
	self:Initialize(...arguments)
end

Game_Character.prototype = Object.create(Game_CharacterBase.prototype)
Game_Character.prototype.constructor = Game_Character

Game_Character.ROUTE_END = 0
Game_Character.ROUTE_MOVE_DOWN = 1
Game_Character.ROUTE_MOVE_LEFT = 2
Game_Character.ROUTE_MOVE_RIGHT = 3
Game_Character.ROUTE_MOVE_UP = 4
Game_Character.ROUTE_MOVE_LOWER_L = 5
Game_Character.ROUTE_MOVE_LOWER_R = 6
Game_Character.ROUTE_MOVE_UPPER_L = 7
Game_Character.ROUTE_MOVE_UPPER_R = 8
Game_Character.ROUTE_MOVE_RANDOM = 9
Game_Character.ROUTE_MOVE_TOWARD = 10
Game_Character.ROUTE_MOVE_AWAY = 11
Game_Character.ROUTE_MOVE_FORWARD = 12
Game_Character.ROUTE_MOVE_BACKWARD = 13
Game_Character.ROUTE_JUMP = 14
Game_Character.ROUTE_WAIT = 15
Game_Character.ROUTE_TURN_DOWN = 16
Game_Character.ROUTE_TURN_LEFT = 17
Game_Character.ROUTE_TURN_RIGHT = 18
Game_Character.ROUTE_TURN_UP = 19
Game_Character.ROUTE_TURN_90D_R = 20
Game_Character.ROUTE_TURN_90D_L = 21
Game_Character.ROUTE_TURN_180D = 22
Game_Character.ROUTE_TURN_90D_R_L = 23
Game_Character.ROUTE_TURN_RANDOM = 24
Game_Character.ROUTE_TURN_TOWARD = 25
Game_Character.ROUTE_TURN_AWAY = 26
Game_Character.ROUTE_SWITCH_ON = 27
Game_Character.ROUTE_SWITCH_OFF = 28
Game_Character.ROUTE_CHANGE_SPEED = 29
Game_Character.ROUTE_CHANGE_FREQ = 30
Game_Character.ROUTE_WALK_ANIME_ON = 31
Game_Character.ROUTE_WALK_ANIME_OFF = 32
Game_Character.ROUTE_STEP_ANIME_ON = 33
Game_Character.ROUTE_STEP_ANIME_OFF = 34
Game_Character.ROUTE_DIR_FIX_ON = 35
Game_Character.ROUTE_DIR_FIX_OFF = 36
Game_Character.ROUTE_THROUGH_ON = 37
Game_Character.ROUTE_THROUGH_OFF = 38
Game_Character.ROUTE_TRANSPARENT_ON = 39
Game_Character.ROUTE_TRANSPARENT_OFF = 40
Game_Character.ROUTE_CHANGE_IMAGE = 41
Game_Character.ROUTE_CHANGE_OPACITY = 42
Game_Character.ROUTE_CHANGE_BLEND_MODE = 43
Game_Character.ROUTE_PLAY_SE = 44
Game_Character.ROUTE_SCRIPT = 45

function Game_Character:Initialize()
	Game_CharacterBase.prototype.initialize.call(this)
end

function Game_Character:InitMembers()
	Game_CharacterBase.prototype.initMembers.call(this)
	self._moveRouteForcing = false
	self._moveRoute = nil
	self._moveRouteIndex = 0
	self._originalMoveRoute = nil
	self._originalMoveRouteIndex = 0
	self._waitCount = 0
end

function Game_Character:MemorizeMoveRoute()
	self._originalMoveRoute = self._moveRoute
	self._originalMoveRouteIndex = self._moveRouteIndex
end

function Game_Character:RestoreMoveRoute()
	self._moveRoute = self._originalMoveRoute
	self._moveRouteIndex = self._originalMoveRouteIndex
	self._originalMoveRoute = nil
end

function Game_Character:IsMoveRouteForcing()
	return self._moveRouteForcing
end

function Game_Character:SetMoveRoute(moveRoute)
	if self._moveRouteForcing then
		self._originalMoveRoute = moveRoute
		self._originalMoveRouteIndex = 0
	end else {
		self._moveRoute = moveRoute
		self._moveRouteIndex = 0
	end
end

function Game_Character:ForceMoveRoute(moveRoute)
	if !self._originalMoveRoute then
		self:MemorizeMoveRoute()
	end
	self._moveRoute = moveRoute
	self._moveRouteIndex = 0
	self._moveRouteForcing = true
	self._waitCount = 0
end

function Game_Character:UpdateStop()
	Game_CharacterBase.prototype.updateStop.call(this)
	if self._moveRouteForcing then
		self:UpdateRoutineMove()
	end
end

function Game_Character:UpdateRoutineMove()
	if self._waitCount > 0 then
		self._waitCount--
	end else {
		self:SetMovementSuccess(true)
		local command = self._moveRoute.list[self._moveRouteIndex]
		if command then
			self:ProcessMoveCommand(command)
			self:AdvanceMoveRouteIndex()
		end
	end
end

function Game_Character:ProcessMoveCommand(command)
	local gc = Game_Character
	local params = command.parameters
	switch (command.code) {
		case gc.ROUTE_END:
			self:ProcessRouteEnd()
			break
		case gc.ROUTE_MOVE_DOWN:
			self:MoveStraight(2)
			break
		case gc.ROUTE_MOVE_LEFT:
			self:MoveStraight(4)
			break
		case gc.ROUTE_MOVE_RIGHT:
			self:MoveStraight(6)
			break
		case gc.ROUTE_MOVE_UP:
			self:MoveStraight(8)
			break
		case gc.ROUTE_MOVE_LOWER_L:
			self:MoveDiagonally(4, 2)
			break
		case gc.ROUTE_MOVE_LOWER_R:
			self:MoveDiagonally(6, 2)
			break
		case gc.ROUTE_MOVE_UPPER_L:
			self:MoveDiagonally(4, 8)
			break
		case gc.ROUTE_MOVE_UPPER_R:
			self:MoveDiagonally(6, 8)
			break
		case gc.ROUTE_MOVE_RANDOM:
			self:MoveRandom()
			break
		case gc.ROUTE_MOVE_TOWARD:
			self:MoveTowardPlayer()
			break
		case gc.ROUTE_MOVE_AWAY:
			self:MoveAwayFromPlayer()
			break
		case gc.ROUTE_MOVE_FORWARD:
			self:MoveForward()
			break
		case gc.ROUTE_MOVE_BACKWARD:
			self:MoveBackward()
			break
		case gc.ROUTE_JUMP:
			self:Jump(params[0], params[1])
			break
		case gc.ROUTE_WAIT:
			self._waitCount = params[0] - 1
			break
		case gc.ROUTE_TURN_DOWN:
			self:SetDirection(2)
			break
		case gc.ROUTE_TURN_LEFT:
			self:SetDirection(4)
			break
		case gc.ROUTE_TURN_RIGHT:
			self:SetDirection(6)
			break
		case gc.ROUTE_TURN_UP:
			self:SetDirection(8)
			break
		case gc.ROUTE_TURN_90D_R:
			self:TurnRight90()
			break
		case gc.ROUTE_TURN_90D_L:
			self:TurnLeft90()
			break
		case gc.ROUTE_TURN_180D:
			self:Turn180()
			break
		case gc.ROUTE_TURN_90D_R_L:
			self:TurnRightOrLeft90()
			break
		case gc.ROUTE_TURN_RANDOM:
			self:TurnRandom()
			break
		case gc.ROUTE_TURN_TOWARD:
			self:TurnTowardPlayer()
			break
		case gc.ROUTE_TURN_AWAY:
			self:TurnAwayFromPlayer()
			break
		case gc.ROUTE_SWITCH_ON:
			Game.Switches.setValue(params[0], true)
			break
		case gc.ROUTE_SWITCH_OFF:
			Game.Switches.setValue(params[0], false)
			break
		case gc.ROUTE_CHANGE_SPEED:
			self:SetMoveSpeed(params[0])
			break
		case gc.ROUTE_CHANGE_FREQ:
			self:SetMoveFrequency(params[0])
			break
		case gc.ROUTE_WALK_ANIME_ON:
			self:SetWalkAnime(true)
			break
		case gc.ROUTE_WALK_ANIME_OFF:
			self:SetWalkAnime(false)
			break
		case gc.ROUTE_STEP_ANIME_ON:
			self:SetStepAnime(true)
			break
		case gc.ROUTE_STEP_ANIME_OFF:
			self:SetStepAnime(false)
			break
		case gc.ROUTE_DIR_FIX_ON:
			self:SetDirectionFix(true)
			break
		case gc.ROUTE_DIR_FIX_OFF:
			self:SetDirectionFix(false)
			break
		case gc.ROUTE_THROUGH_ON:
			self:SetThrough(true)
			break
		case gc.ROUTE_THROUGH_OFF:
			self:SetThrough(false)
			break
		case gc.ROUTE_TRANSPARENT_ON:
			self:SetTransparent(true)
			break
		case gc.ROUTE_TRANSPARENT_OFF:
			self:SetTransparent(false)
			break
		case gc.ROUTE_CHANGE_IMAGE:
			self:SetImage(params[0], params[1])
			break
		case gc.ROUTE_CHANGE_OPACITY:
			self:SetOpacity(params[0])
			break
		case gc.ROUTE_CHANGE_BLEND_MODE:
			self:SetBlendMode(params[0])
			break
		case gc.ROUTE_PLAY_SE:
			AudioManager.playSe(params[0])
			break
		case gc.ROUTE_SCRIPT:
			eval(params[0])
			break
	end
end

function Game_Character:DeltaXFrom(x)
	return Game.Map.deltaX(self:X, x)
end

function Game_Character:DeltaYFrom(y)
	return Game.Map.deltaY(self:Y, y)
end

function Game_Character:MoveRandom()
	local d = 2 + Math.randomInt(4) * 2
	if self:CanPass(self:X, self:Y, d) then
		self:MoveStraight(d)
	end
end

function Game_Character:MoveTowardCharacter(character)
	local sx = self:DeltaXFrom(character.x)
	local sy = self:DeltaYFrom(character.y)
	if Math.abs(sx) > Math.abs(sy) then
		self:MoveStraight(sx > 0 ? 4 : 6)
		if !self:IsMovementSucceeded() and sy ~= 0 then
			self:MoveStraight(sy > 0 ? 8 : 2)
		end
	end else if sy ~= 0 then
		self:MoveStraight(sy > 0 ? 8 : 2)
		if !self:IsMovementSucceeded() and sx ~= 0 then
			self:MoveStraight(sx > 0 ? 4 : 6)
		end
	end
end

function Game_Character:MoveAwayFromCharacter(character)
	local sx = self:DeltaXFrom(character.x)
	local sy = self:DeltaYFrom(character.y)
	if Math.abs(sx) > Math.abs(sy) then
		self:MoveStraight(sx > 0 ? 6 : 4)
		if !self:IsMovementSucceeded() and sy ~= 0 then
			self:MoveStraight(sy > 0 ? 2 : 8)
		end
	end else if sy ~= 0 then
		self:MoveStraight(sy > 0 ? 2 : 8)
		if !self:IsMovementSucceeded() and sx ~= 0 then
			self:MoveStraight(sx > 0 ? 6 : 4)
		end
	end
end

function Game_Character:TurnTowardCharacter(character)
	local sx = self:DeltaXFrom(character.x)
	local sy = self:DeltaYFrom(character.y)
	if Math.abs(sx) > Math.abs(sy) then
		self:SetDirection(sx > 0 ? 4 : 6)
	end else if sy ~= 0 then
		self:SetDirection(sy > 0 ? 8 : 2)
	end
end

function Game_Character:TurnAwayFromCharacter(character)
	local sx = self:DeltaXFrom(character.x)
	local sy = self:DeltaYFrom(character.y)
	if Math.abs(sx) > Math.abs(sy) then
		self:SetDirection(sx > 0 ? 6 : 4)
	end else if sy ~= 0 then
		self:SetDirection(sy > 0 ? 2 : 8)
	end
end

function Game_Character:TurnTowardPlayer()
	self:TurnTowardCharacter(Game.Player)
end

function Game_Character:TurnAwayFromPlayer()
	self:TurnAwayFromCharacter(Game.Player)
end

function Game_Character:MoveTowardPlayer()
	self:MoveTowardCharacter(Game.Player)
end

function Game_Character:MoveAwayFromPlayer()
	self:MoveAwayFromCharacter(Game.Player)
end

function Game_Character:MoveForward()
	self:MoveStraight(self:Direction())
end

function Game_Character:MoveBackward()
	local lastDirectionFix = self:IsDirectionFixed()
	self:SetDirectionFix(true)
	self:MoveStraight(self:ReverseDir(self:Direction()))
	self:SetDirectionFix(lastDirectionFix)
end

function Game_Character:ProcessRouteEnd()
	if self._moveRoute.repeat then
		self._moveRouteIndex = -1
	end else if self._moveRouteForcing then
		self._moveRouteForcing = false
		self:RestoreMoveRoute()
		self:SetMovementSuccess(false)
	end
end

function Game_Character:AdvanceMoveRouteIndex()
	local moveRoute = self._moveRoute
	if moveRoute and (self:IsMovementSucceeded() or moveRoute.skippable) then
		local numCommands = moveRoute.list.length - 1
		self._moveRouteIndex++
		if moveRoute.repeat and self._moveRouteIndex >= numCommands then
			self._moveRouteIndex = 0
		end
	end
end

function Game_Character:TurnRight90()
	switch (self:Direction()) {
		case 2:
			self:SetDirection(4)
			break
		case 4:
			self:SetDirection(8)
			break
		case 6:
			self:SetDirection(2)
			break
		case 8:
			self:SetDirection(6)
			break
	end
end

function Game_Character:TurnLeft90()
	switch (self:Direction()) {
		case 2:
			self:SetDirection(6)
			break
		case 4:
			self:SetDirection(2)
			break
		case 6:
			self:SetDirection(8)
			break
		case 8:
			self:SetDirection(4)
			break
	end
end

function Game_Character:Turn180()
	self:SetDirection(self:ReverseDir(self:Direction()))
end

function Game_Character:TurnRightOrLeft90()
	switch (Math.randomInt(2)) {
		case 0:
			self:TurnRight90()
			break
		case 1:
			self:TurnLeft90()
			break
	end
end

function Game_Character:TurnRandom()
	self:SetDirection(2 + Math.randomInt(4) * 2)
end

function Game_Character:Swap(character)
	local newX = character.x
	local newY = character.y
	character.locate(self:X, self:Y)
	self:Locate(newX, newY)
end

function Game_Character:FindDirectionTo(goalX, goalY)
	local searchLimit = self:SearchLimit()
	local mapWidth = Game.Map.width()
	local nodeList = []
	local openList = []
	local closedList = []
	local start = {end
	local best = start

	if self:X === goalX and self:Y === goalY then
		return 0
	end

	start.parent = nil
	start.x = self:X
	start.y = self:Y
	start.g = 0
	start.f = Game.Map.distance(start.x, start.y, goalX, goalY)
	nodeList.push(start)
	openList.push(start.y * mapWidth + start.x)

	while (nodeList.length > 0) {
		local bestIndex = 0
		for (local i = 0 i < nodeList.length i++) {
			if nodeList[i].f < nodeList[bestIndex].f then
				bestIndex = i
			end
		end

		local current = nodeList[bestIndex]
		local x1 = current.x
		local y1 = current.y
		local pos1 = y1 * mapWidth + x1
		local g1 = current.g

		nodeList.splice(bestIndex, 1)
		openList.splice(openList.indexOf(pos1), 1)
		closedList.push(pos1)

		if current.x === goalX and current.y === goalY then
			best = current
			break
		end

		if g1 >= searchLimit then
			continue
		end

		for (local j = 0 j < 4 j++) {
			local direction = 2 + j * 2
			local x2 = Game.Map.roundXWithDirection(x1, direction)
			local y2 = Game.Map.roundYWithDirection(y1, direction)
			local pos2 = y2 * mapWidth + x2

			if closedList.includes(pos2) then
				continue
			end
			if !self:CanPass(x1, y1, direction) then
				continue
			end

			local g2 = g1 + 1
			local index2 = openList.indexOf(pos2)

			if index2 < 0 or g2 < nodeList[index2].g then
				local neighbor = {end
				if index2 >= 0 then
					neighbor = nodeList[index2]
				end else {
					nodeList.push(neighbor)
					openList.push(pos2)
				end
				neighbor.parent = current
				neighbor.x = x2
				neighbor.y = y2
				neighbor.g = g2
				neighbor.f = g2 + Game.Map.distance(x2, y2, goalX, goalY)
				if !best or neighbor.f - neighbor.g < best.f - best.g then
					best = neighbor
				end
			end
		end
	end

	local node = best
	while (node.parent and node.parent ~= start) {
		node = node.parent
	end

	local deltaX1 = Game.Map.deltaX(node.x, start.x)
	local deltaY1 = Game.Map.deltaY(node.y, start.y)
	if deltaY1 > 0 then
		return 2
	end else if deltaX1 < 0 then
		return 4
	end else if deltaX1 > 0 then
		return 6
	end else if deltaY1 < 0 then
		return 8
	end

	local deltaX2 = self:DeltaXFrom(goalX)
	local deltaY2 = self:DeltaYFrom(goalY)
	if Math.abs(deltaX2) > Math.abs(deltaY2) then
		return deltaX2 > 0 ? 4 : 6
	end else if deltaY2 ~= 0 then
		return deltaY2 > 0 ? 8 : 2
	end

	return 0
end

function Game_Character:SearchLimit()
	return 12
end

-------------------------------------------------------------------------------
-- Game_Player
--
-- The game object class for the player. It contains event starting
-- determinants and map scrolling functions.

function Game_Player.new()
	self:Initialize(...arguments)
end

Game_Player.prototype = Object.create(Game_Character.prototype)
Game_Player.prototype.constructor = Game_Player

function Game_Player:Initialize()
	Game_Character.prototype.initialize.call(this)
	self:SetTransparent(Data.System.optTransparent)
end

function Game_Player:InitMembers()
	Game_Character.prototype.initMembers.call(this)
	self._vehicleType = "walk"
	self._vehicleGettingOn = false
	self._vehicleGettingOff = false
	self._dashing = false
	self._needsMapReload = false
	self._transferring = false
	self._newMapId = 0
	self._newX = 0
	self._newY = 0
	self._newDirection = 0
	self._fadeType = 0
	self._followers = new Game_Followers()
	self._encounterCount = 0
end

function Game_Player:ClearTransferInfo()
	self._transferring = false
	self._newMapId = 0
	self._newX = 0
	self._newY = 0
	self._newDirection = 0
end

function Game_Player:Followers()
	return self._followers
end

function Game_Player:Refresh()
	local actor = Game.Party.leader()
	local characterName = actor ? actor.characterName() : ""
	local characterIndex = actor ? actor.characterIndex() : 0
	self:SetImage(characterName, characterIndex)
	self._followers.refresh()
end

function Game_Player:IsStopping()
	if self._vehicleGettingOn or self._vehicleGettingOff then
		return false
	end
	return Game_Character.prototype.isStopping.call(this)
end

function Game_Player:ReserveTransfer(mapId, x, y, d, fadeType)
	self._transferring = true
	self._newMapId = mapId
	self._newX = x
	self._newY = y
	self._newDirection = d
	self._fadeType = fadeType
end

function Game_Player:SetupForNewGame()
	local mapId = Data.System.startMapId
	local x = Data.System.startX
	local y = Data.System.startY
	self:ReserveTransfer(mapId, x, y, 2, 0)
end

function Game_Player:RequestMapReload()
	self._needsMapReload = true
end

function Game_Player:IsTransferring()
	return self._transferring
end

function Game_Player:NewMapId()
	return self._newMapId
end

function Game_Player:FadeType()
	return self._fadeType
end

function Game_Player:PerformTransfer()
	if self:IsTransferring() then
		self:SetDirection(self._newDirection)
		if self._newMapId ~= Game.Map.mapId() or self._needsMapReload then
			Game.Map.setup(self._newMapId)
			self._needsMapReload = false
		end
		self:Locate(self._newX, self._newY)
		self:Refresh()
		self:ClearTransferInfo()
	end
end

function Game_Player:IsMapPassable(x, y, d)
	local vehicle = self:Vehicle()
	if vehicle then
		return vehicle.isMapPassable(x, y, d)
	end else {
		return Game_Character.prototype.isMapPassable.call(this, x, y, d)
	end
end

function Game_Player:Vehicle()
	return Game.Map.vehicle(self._vehicleType)
end

function Game_Player:IsInBoat()
	return self._vehicleType === "boat"
end

function Game_Player:IsInShip()
	return self._vehicleType === "ship"
end

function Game_Player:IsInAirship()
	return self._vehicleType === "airship"
end

function Game_Player:IsInVehicle()
	return self:IsInBoat() or self:IsInShip() or self:IsInAirship()
end

function Game_Player:IsNormal()
	return self._vehicleType === "walk" and !self:IsMoveRouteForcing()
end

function Game_Player:IsDashing()
	return self._dashing
end

function Game_Player:IsDebugThrough()
	return Input.isPressed("control") and Game.Temp.isPlaytest()
end

function Game_Player:IsCollided(x, y)
	if self:IsThrough() then
		return false
	end else {
		return self:Pos(x, y) or self._followers.isSomeoneCollided(x, y)
	end
end

function Game_Player:CenterX()
	return (Game.Map.screenTileX() - 1) / 2
end

function Game_Player:CenterY()
	return (Game.Map.screenTileY() - 1) / 2
end

function Game_Player:Center(x, y)
	return Game.Map.setDisplayPos(x - self:CenterX(), y - self:CenterY())
end

function Game_Player:Locate(x, y)
	Game_Character.prototype.locate.call(this, x, y)
	self:Center(x, y)
	self:MakeEncounterCount()
	if self:IsInVehicle() then
		self:Vehicle().refresh()
	end
	self._followers.synchronize(x, y, self:Direction())
end

function Game_Player:IncreaseSteps()
	Game_Character.prototype.increaseSteps.call(this)
	if self:IsNormal() then
		Game.Party.increaseSteps()
	end
end

function Game_Player:MakeEncounterCount()
	local n = Game.Map.encounterStep()
	self._encounterCount = Math.randomInt(n) + Math.randomInt(n) + 1
end

function Game_Player:MakeEncounterTroopId()
	local encounterList = []
	local weightSum = 0
	for (local encounter of Game.Map.encounterList()) {
		if self:MeetsEncounterConditions(encounter) then
			encounterList.push(encounter)
			weightSum += encounter.weight
		end
	end
	if weightSum > 0 then
		local value = Math.randomInt(weightSum)
		for (local encounter of encounterList) {
			value -= encounter.weight
			if value < 0 then
				return encounter.troopId
			end
		end
	end
	return 0
end

function Game_Player:MeetsEncounterConditions(encounter)
	return encounter.regionSet.length === 0 or encounter.regionSet.includes(self:RegionId())
end

function Game_Player:ExecuteEncounter()
	if !Game.Map.isEventRunning() and self._encounterCount <= 0 then
		self:MakeEncounterCount()
		local troopId = self:MakeEncounterTroopId()
		if Data.Troops[troopId] then
			BattleManager.setup(troopId, true, false)
			BattleManager.onEncounter()
			return true
		end else {
			return false
		end
	end else {
		return false
	end
end

function Game_Player:StartMapEvent(x, y, triggers, normal)
	if !Game.Map.isEventRunning() then
		for (local event of Game.Map.eventsXy(x, y)) {
			if event.isTriggerIn(triggers) and event.isNormalPriority() === normal then
				event.start()
			end
		end
	end
end

function Game_Player:MoveByInput()
	if !self:IsMoving() and self:CanMove() then
		local direction = self:GetInputDirection()
		if direction > 0 then
			Game.Temp.clearDestination()
		end else if Game.Temp.isDestinationValid() then
			local x = Game.Temp.destinationX()
			local y = Game.Temp.destinationY()
			direction = self:FindDirectionTo(x, y)
		end
		if direction > 0 then
			self:ExecuteMove(direction)
		end
	end
end

function Game_Player:CanMove()
	if Game.Map.isEventRunning() or Game.Message.isBusy() then
		return false
	end
	if self:IsMoveRouteForcing() or self:AreFollowersGathering() then
		return false
	end
	if self._vehicleGettingOn or self._vehicleGettingOff then
		return false
	end
	if self:IsInVehicle() and !self:Vehicle().canMove() then
		return false
	end
	return true
end

function Game_Player:GetInputDirection()
	return Input.dir4
end

function Game_Player:ExecuteMove(direction)
	self:MoveStraight(direction)
end

function Game_Player:Update(sceneActive)
	local lastScrolledX = self:ScrolledX()
	local lastScrolledY = self:ScrolledY()
	local wasMoving = self:IsMoving()
	self:UpdateDashing()
	if sceneActive then
		self:MoveByInput()
	end
	Game_Character.prototype.update.call(this)
	self:UpdateScroll(lastScrolledX, lastScrolledY)
	self:UpdateVehicle()
	if !self:IsMoving() then
		self:UpdateNonmoving(wasMoving, sceneActive)
	end
	self._followers.update()
end

function Game_Player:UpdateDashing()
	if self:IsMoving() then
		return
	end
	if self:CanMove() and !self:IsInVehicle() and !Game.Map.isDashDisabled() then
		self._dashing = self:IsDashButtonPressed() or Game.Temp.isDestinationValid()
	end else {
		self._dashing = false
	end
end

function Game_Player:IsDashButtonPressed()
	local shift = Input.isPressed("shift")
	if ConfigManager.alwaysDash then
		return !shift
	end else {
		return shift
	end
end

function Game_Player:UpdateScroll(lastScrolledX, lastScrolledY)
	local x1 = lastScrolledX
	local y1 = lastScrolledY
	local x2 = self:ScrolledX()
	local y2 = self:ScrolledY()
	if y2 > y1 and y2 > self:CenterY() then
		Game.Map.scrollDown(y2 - y1)
	end
	if x2 < x1 and x2 < self:CenterX() then
		Game.Map.scrollLeft(x1 - x2)
	end
	if x2 > x1 and x2 > self:CenterX() then
		Game.Map.scrollRight(x2 - x1)
	end
	if y2 < y1 and y2 < self:CenterY() then
		Game.Map.scrollUp(y1 - y2)
	end
end

function Game_Player:UpdateVehicle()
	if self:IsInVehicle() and !self:AreFollowersGathering() then
		if self._vehicleGettingOn then
			self:UpdateVehicleGetOn()
		end else if self._vehicleGettingOff then
			self:UpdateVehicleGetOff()
		end else {
			self:Vehicle().syncWithPlayer()
		end
	end
end

function Game_Player:UpdateVehicleGetOn()
	if !self:AreFollowersGathering() and !self:IsMoving() then
		self:SetDirection(self:Vehicle().direction())
		self:SetMoveSpeed(self:Vehicle().moveSpeed())
		self._vehicleGettingOn = false
		self:SetTransparent(true)
		if self:IsInAirship() then
			self:SetThrough(true)
		end
		self:Vehicle().getOn()
	end
end

function Game_Player:UpdateVehicleGetOff()
	if !self:AreFollowersGathering() and self:Vehicle().isLowest() then
		self._vehicleGettingOff = false
		self._vehicleType = "walk"
		self:SetTransparent(false)
	end
end

function Game_Player:UpdateNonmoving(wasMoving, sceneActive)
	if !Game.Map.isEventRunning() then
		if wasMoving then
			Game.Party.onPlayerWalk()
			self:CheckEventTriggerHere([1, 2])
			if Game.Map.setupStartingEvent() then
				return
			end
		end
		if sceneActive and self:TriggerAction() then
			return
		end
		if wasMoving then
			self:UpdateEncounterCount()
		end else {
			Game.Temp.clearDestination()
		end
	end
end

function Game_Player:TriggerAction()
	if self:CanMove() then
		if self:TriggerButtonAction() then
			return true
		end
		if self:TriggerTouchAction() then
			return true
		end
	end
	return false
end

function Game_Player:TriggerButtonAction()
	if Input.isTriggered("ok") then
		if self:GetOnOffVehicle() then
			return true
		end
		self:CheckEventTriggerHere([0])
		if Game.Map.setupStartingEvent() then
			return true
		end
		self:CheckEventTriggerThere([0, 1, 2])
		if Game.Map.setupStartingEvent() then
			return true
		end
	end
	return false
end

function Game_Player:TriggerTouchAction()
	if Game.Temp.isDestinationValid() then
		local direction = self:Direction()
		local x1 = self:X
		local y1 = self:Y
		local x2 = Game.Map.roundXWithDirection(x1, direction)
		local y2 = Game.Map.roundYWithDirection(y1, direction)
		local x3 = Game.Map.roundXWithDirection(x2, direction)
		local y3 = Game.Map.roundYWithDirection(y2, direction)
		local destX = Game.Temp.destinationX()
		local destY = Game.Temp.destinationY()
		if destX === x1 and destY === y1 then
			return self:TriggerTouchActionD1(x1, y1)
		end else if destX === x2 and destY === y2 then
			return self:TriggerTouchActionD2(x2, y2)
		end else if destX === x3 and destY === y3 then
			return self:TriggerTouchActionD3(x2, y2)
		end
	end
	return false
end

function Game_Player:TriggerTouchActionD1(x1, y1)
	if Game.Map.airship().pos(x1, y1) then
		if TouchInput.isTriggered() and self:GetOnOffVehicle() then
			return true
		end
	end
	self:CheckEventTriggerHere([0])
	return Game.Map.setupStartingEvent()
end

function Game_Player:TriggerTouchActionD2(x2, y2)
	if Game.Map.boat().pos(x2, y2) or Game.Map.ship().pos(x2, y2) then
		if TouchInput.isTriggered() and self:GetOnVehicle() then
			return true
		end
	end
	if self:IsInBoat() or self:IsInShip() then
		if TouchInput.isTriggered() and self:GetOffVehicle() then
			return true
		end
	end
	self:CheckEventTriggerThere([0, 1, 2])
	return Game.Map.setupStartingEvent()
end

function Game_Player:TriggerTouchActionD3(x2, y2)
	if Game.Map.isCounter(x2, y2) then
		self:CheckEventTriggerThere([0, 1, 2])
	end
	return Game.Map.setupStartingEvent()
end

function Game_Player:UpdateEncounterCount()
	if self:CanEncounter() then
		self._encounterCount -= self:EncounterProgressValue()
	end
end

function Game_Player:CanEncounter()
	return !Game.Party.hasEncounterNone() and Game.System.isEncounterEnabled() and !self:IsInAirship() and !self:IsMoveRouteForcing() and !self:IsDebugThrough()
end

function Game_Player:EncounterProgressValue()
	local value = Game.Map.isBush(self:X, self:Y) ? 2 : 1
	if Game.Party.hasEncounterHalf() then
		value *= 0.5
	end
	if self:IsInShip() then
		value *= 0.5
	end
	return value
end

function Game_Player:CheckEventTriggerHere(triggers)
	if self:CanStartLocalEvents() then
		self:StartMapEvent(self:X, self:Y, triggers, false)
	end
end

function Game_Player:CheckEventTriggerThere(triggers)
	if self:CanStartLocalEvents() then
		local direction = self:Direction()
		local x1 = self:X
		local y1 = self:Y
		local x2 = Game.Map.roundXWithDirection(x1, direction)
		local y2 = Game.Map.roundYWithDirection(y1, direction)
		self:StartMapEvent(x2, y2, triggers, true)
		if !Game.Map.isAnyEventStarting() and Game.Map.isCounter(x2, y2) then
			local x3 = Game.Map.roundXWithDirection(x2, direction)
			local y3 = Game.Map.roundYWithDirection(y2, direction)
			self:StartMapEvent(x3, y3, triggers, true)
		end
	end
end

function Game_Player:CheckEventTriggerTouch(x, y)
	if self:CanStartLocalEvents() then
		self:StartMapEvent(x, y, [1, 2], true)
	end
end

function Game_Player:CanStartLocalEvents()
	return !self:IsInAirship()
end

function Game_Player:GetOnOffVehicle()
	if self:IsInVehicle() then
		return self:GetOffVehicle()
	end else {
		return self:GetOnVehicle()
	end
end

function Game_Player:GetOnVehicle()
	local direction = self:Direction()
	local x1 = self:X
	local y1 = self:Y
	local x2 = Game.Map.roundXWithDirection(x1, direction)
	local y2 = Game.Map.roundYWithDirection(y1, direction)
	if Game.Map.airship().pos(x1, y1) then
		self._vehicleType = "airship"
	end else if Game.Map.ship().pos(x2, y2) then
		self._vehicleType = "ship"
	end else if Game.Map.boat().pos(x2, y2) then
		self._vehicleType = "boat"
	end
	if self:IsInVehicle() then
		self._vehicleGettingOn = true
		if !self:IsInAirship() then
			self:ForceMoveForward()
		end
		self:GatherFollowers()
	end
	return self._vehicleGettingOn
end

function Game_Player:GetOffVehicle()
	if self:Vehicle().isLandOk(self:X, self:Y, self:Direction()) then
		if self:IsInAirship() then
			self:SetDirection(2)
		end
		self._followers.synchronize(self:X, self:Y, self:Direction())
		self:Vehicle().getOff()
		if !self:IsInAirship() then
			self:ForceMoveForward()
			self:SetTransparent(false)
		end
		self._vehicleGettingOff = true
		self:SetMoveSpeed(4)
		self:SetThrough(false)
		self:MakeEncounterCount()
		self:GatherFollowers()
	end
	return self._vehicleGettingOff
end

function Game_Player:ForceMoveForward()
	self:SetThrough(true)
	self:MoveForward()
	self:SetThrough(false)
end

function Game_Player:IsOnDamageFloor()
	return Game.Map.isDamageFloor(self:X, self:Y) and !self:IsInAirship()
end

function Game_Player:MoveStraight(d)
	if self:CanPass(self:X, self:Y, d) then
		self._followers.updateMove()
	end
	Game_Character.prototype.moveStraight.call(this, d)
end

function Game_Player:MoveDiagonally(horz, vert)
	if self:CanPassDiagonally(self:X, self:Y, horz, vert) then
		self._followers.updateMove()
	end
	Game_Character.prototype.moveDiagonally.call(this, horz, vert)
end

function Game_Player:Jump(xPlus, yPlus)
	Game_Character.prototype.jump.call(this, xPlus, yPlus)
	self._followers.jumpAll()
end

function Game_Player:ShowFollowers()
	self._followers.show()
end

function Game_Player:HideFollowers()
	self._followers.hide()
end

function Game_Player:GatherFollowers()
	self._followers.gather()
end

function Game_Player:AreFollowersGathering()
	return self._followers.areGathering()
end

function Game_Player:AreFollowersGathered()
	return self._followers.areGathered()
end

-------------------------------------------------------------------------------
-- Game_Follower
--
-- The game object class for a follower. A follower is an allied character,
-- other than the front character, displayed in the party.

function Game_Follower.new()
	self:Initialize(...arguments)
end

Game_Follower.prototype = Object.create(Game_Character.prototype)
Game_Follower.prototype.constructor = Game_Follower

function Game_Follower:Initialize(memberIndex)
	Game_Character.prototype.initialize.call(this)
	self._memberIndex = memberIndex
	self:SetTransparent(Data.System.optTransparent)
	self:SetThrough(true)
end

function Game_Follower:Refresh()
	local characterName = self:IsVisible() ? self:Actor().characterName() : ""
	local characterIndex = self:IsVisible() ? self:Actor().characterIndex() : 0
	self:SetImage(characterName, characterIndex)
end

function Game_Follower:Actor()
	return Game.Party.battleMembers()[self._memberIndex]
end

function Game_Follower:IsVisible()
	return self:Actor() and Game.Player.followers().isVisible()
end

function Game_Follower:IsGathered()
	return !self:IsMoving() and self:Pos(Game.Player.x, Game.Player.y)
end

function Game_Follower:Update()
	Game_Character.prototype.update.call(this)
	self:SetMoveSpeed(Game.Player.realMoveSpeed())
	self:SetOpacity(Game.Player.opacity())
	self:SetBlendMode(Game.Player.blendMode())
	self:SetWalkAnime(Game.Player.hasWalkAnime())
	self:SetStepAnime(Game.Player.hasStepAnime())
	self:SetDirectionFix(Game.Player.isDirectionFixed())
	self:SetTransparent(Game.Player.isTransparent())
end

function Game_Follower:ChaseCharacter(character)
	local sx = self:DeltaXFrom(character.x)
	local sy = self:DeltaYFrom(character.y)
	if sx ~= 0 and sy ~= 0 then
		self:MoveDiagonally(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
	end else if sx ~= 0 then
		self:MoveStraight(sx > 0 ? 4 : 6)
	end else if sy ~= 0 then
		self:MoveStraight(sy > 0 ? 8 : 2)
	end
	self:SetMoveSpeed(Game.Player.realMoveSpeed())
end

-------------------------------------------------------------------------------
-- Game_Followers
--
-- The wrapper class for a follower array.

function Game_Followers.new()
	self:Initialize(...arguments)
end

function Game_Followers:Initialize()
	self._visible = Data.System.optFollowers
	self._gathering = false
	self._data = []
	self:Setup()
end

function Game_Followers:Setup()
	self._data = []
	for (local i = 1 i < Game.Party.maxBattleMembers() i++) {
		self._data.push(new Game_Follower(i))
	end
end

function Game_Followers:IsVisible()
	return self._visible
end

function Game_Followers:Show()
	self._visible = true
end

function Game_Followers:Hide()
	self._visible = false
end

function Game_Followers:Data()
	return self._data.clone()
end

function Game_Followers:ReverseData()
	return self._data.clone().reverse()
end

function Game_Followers:Follower(index)
	return self._data[index]
end

function Game_Followers:Refresh()
	for (local follower of self._data) {
		follower.refresh()
	end
end

function Game_Followers:Update()
	if self:AreGathering() then
		if !self:AreMoving() then
			self:UpdateMove()
		end
		if self:AreGathered() then
			self._gathering = false
		end
	end
	for (local follower of self._data) {
		follower.update()
	end
end

function Game_Followers:UpdateMove()
	for (local i = self._data.length - 1 i >= 0 i--) {
		local precedingCharacter = i > 0 ? self._data[i - 1] : Game.Player
		self._data[i].chaseCharacter(precedingCharacter)
	end
end

function Game_Followers:JumpAll()
	if Game.Player.isJumping() then
		for (local follower of self._data) {
			local sx = Game.Player.deltaXFrom(follower.x)
			local sy = Game.Player.deltaYFrom(follower.y)
			follower.jump(sx, sy)
		end
	end
end

function Game_Followers:Synchronize(x, y, d)
	for (local follower of self._data) {
		follower.locate(x, y)
		follower.setDirection(d)
	end
end

function Game_Followers:Gather()
	self._gathering = true
end

function Game_Followers:AreGathering()
	return self._gathering
end

function Game_Followers:VisibleFollowers()
	return self._data.filter((follower) => follower.isVisible())
end

function Game_Followers:AreMoving()
	return self:VisibleFollowers().some((follower) => follower.isMoving())
end

function Game_Followers:AreGathered()
	return self:VisibleFollowers().every((follower) => follower.isGathered())
end

function Game_Followers:IsSomeoneCollided(x, y)
	return self:VisibleFollowers().some((follower) => follower.pos(x, y))
end

-------------------------------------------------------------------------------
-- Game_Vehicle
--
-- The game object class for a vehicle.

function Game_Vehicle.new()
	self:Initialize(...arguments)
end

Game_Vehicle.prototype = Object.create(Game_Character.prototype)
Game_Vehicle.prototype.constructor = Game_Vehicle

function Game_Vehicle:Initialize(type)
	Game_Character.prototype.initialize.call(this)
	self._type = type
	self:ResetDirection()
	self:InitMoveSpeed()
	self:LoadSystemSettings()
end

function Game_Vehicle:InitMembers()
	Game_Character.prototype.initMembers.call(this)
	self._type = ""
	self._mapId = 0
	self._altitude = 0
	self._driving = false
	self._bgm = nil
end

function Game_Vehicle:IsBoat()
	return self._type === "boat"
end

function Game_Vehicle:IsShip()
	return self._type === "ship"
end

function Game_Vehicle:IsAirship()
	return self._type === "airship"
end

function Game_Vehicle:ResetDirection()
	self:SetDirection(4)
end

function Game_Vehicle:InitMoveSpeed()
	if self:IsBoat() then
		self:SetMoveSpeed(4)
	end else if self:IsShip() then
		self:SetMoveSpeed(5)
	end else if self:IsAirship() then
		self:SetMoveSpeed(6)
	end
end

function Game_Vehicle:Vehicle()
	if self:IsBoat() then
		return Data.System.boat
	end else if self:IsShip() then
		return Data.System.ship
	end else if self:IsAirship() then
		return Data.System.airship
	end else {
		return nil
	end
end

function Game_Vehicle:LoadSystemSettings()
	local vehicle = self:Vehicle()
	self._mapId = vehicle.startMapId
	self:SetPosition(vehicle.startX, vehicle.startY)
	self:SetImage(vehicle.characterName, vehicle.characterIndex)
end

function Game_Vehicle:Refresh()
	if self._driving then
		self._mapId = Game.Map.mapId()
		self:SyncWithPlayer()
	end else if self._mapId === Game.Map.mapId() then
		self:Locate(self:X, self:Y)
	end
	if self:IsAirship() then
		self:SetPriorityType(self._driving ? 2 : 0)
	end else {
		self:SetPriorityType(1)
	end
	self:SetWalkAnime(self._driving)
	self:SetStepAnime(self._driving)
	self:SetTransparent(self._mapId ~= Game.Map.mapId())
end

function Game_Vehicle:SetLocation(mapId, x, y)
	self._mapId = mapId
	self:SetPosition(x, y)
	self:Refresh()
end

function Game_Vehicle:Pos(x, y)
	if self._mapId === Game.Map.mapId() then
		return Game_Character.prototype.pos.call(this, x, y)
	end else {
		return false
	end
end

function Game_Vehicle:IsMapPassable(x, y, d)
	local x2 = Game.Map.roundXWithDirection(x, d)
	local y2 = Game.Map.roundYWithDirection(y, d)
	if self:IsBoat() then
		return Game.Map.isBoatPassable(x2, y2)
	end else if self:IsShip() then
		return Game.Map.isShipPassable(x2, y2)
	end else if self:IsAirship() then
		return true
	end else {
		return false
	end
end

function Game_Vehicle:GetOn()
	self._driving = true
	self:SetWalkAnime(true)
	self:SetStepAnime(true)
	Game.System.saveWalkingBgm()
	self:PlayBgm()
end

function Game_Vehicle:GetOff()
	self._driving = false
	self:SetWalkAnime(false)
	self:SetStepAnime(false)
	self:ResetDirection()
	Game.System.replayWalkingBgm()
end

function Game_Vehicle:SetBgm(bgm)
	self._bgm = bgm
end

function Game_Vehicle:PlayBgm()
	AudioManager.playBgm(self._bgm or self:Vehicle().bgm)
end

function Game_Vehicle:SyncWithPlayer()
	self:CopyPosition(Game.Player)
	self:RefreshBushDepth()
end

function Game_Vehicle:ScreenY()
	return Game_Character.prototype.screenY.call(this) - self._altitude
end

function Game_Vehicle:ShadowX()
	return self:ScreenX()
end

function Game_Vehicle:ShadowY()
	return self:ScreenY() + self._altitude
end

function Game_Vehicle:ShadowOpacity()
	return (255 * self._altitude) / self:MaxAltitude()
end

function Game_Vehicle:CanMove()
	if self:IsAirship() then
		return self:IsHighest()
	end else {
		return true
	end
end

function Game_Vehicle:Update()
	Game_Character.prototype.update.call(this)
	if self:IsAirship() then
		self:UpdateAirship()
	end
end

function Game_Vehicle:UpdateAirship()
	self:UpdateAirshipAltitude()
	self:SetStepAnime(self:IsHighest())
	self:SetPriorityType(self:IsLowest() ? 0 : 2)
end

function Game_Vehicle:UpdateAirshipAltitude()
	if self._driving and !self:IsHighest() then
		self._altitude++
	end
	if !self._driving and !self:IsLowest() then
		self._altitude--
	end
end

function Game_Vehicle:MaxAltitude()
	return 48
end

function Game_Vehicle:IsLowest()
	return self._altitude <= 0
end

function Game_Vehicle:IsHighest()
	return self._altitude >= self:MaxAltitude()
end

function Game_Vehicle:IsTakeoffOk()
	return Game.Player.areFollowersGathered()
end

function Game_Vehicle:IsLandOk(x, y, d)
	if self:IsAirship() then
		if !Game.Map.isAirshipLandOk(x, y) then
			return false
		end
		if Game.Map.eventsXy(x, y).length > 0 then
			return false
		end
	end else {
		local x2 = Game.Map.roundXWithDirection(x, d)
		local y2 = Game.Map.roundYWithDirection(y, d)
		if !Game.Map.isValid(x2, y2) then
			return false
		end
		if !Game.Map.isPassable(x2, y2, self:ReverseDir(d)) then
			return false
		end
		if self:IsCollidedWithCharacters(x2, y2) then
			return false
		end
	end
	return true
end

-------------------------------------------------------------------------------
-- Game_Event
--
-- The game object class for an event. It contains functionality for event page
-- switching and running parallel process events.

function Game_Event.new()
	self:Initialize(...arguments)
end

Game_Event.prototype = Object.create(Game_Character.prototype)
Game_Event.prototype.constructor = Game_Event

function Game_Event:Initialize(mapId, eventId)
	Game_Character.prototype.initialize.call(this)
	self._mapId = mapId
	self._eventId = eventId
	self:Locate(self:Event().x, self:Event().y)
	self:Refresh()
end

function Game_Event:InitMembers()
	Game_Character.prototype.initMembers.call(this)
	self._moveType = 0
	self._trigger = 0
	self._starting = false
	self._erased = false
	self._pageIndex = -2
	self._originalPattern = 1
	self._originalDirection = 2
	self._prelockDirection = 0
	self._locked = false
end

function Game_Event:EventId()
	return self._eventId
end

function Game_Event:Event()
	return Data.Map.events[self._eventId]
end

function Game_Event:Page()
	return self:Event().pages[self._pageIndex]
end

function Game_Event:List()
	return self:Page().list
end

function Game_Event:IsCollidedWithCharacters(x, y)
	return Game_Character.prototype.isCollidedWithCharacters.call(this, x, y) or self:IsCollidedWithPlayerCharacters(x, y)
end

function Game_Event:IsCollidedWithEvents(x, y)
	local events = Game.Map.eventsXyNt(x, y)
	return events.length > 0
end

function Game_Event:IsCollidedWithPlayerCharacters(x, y)
	return self:IsNormalPriority() and Game.Player.isCollided(x, y)
end

function Game_Event:Lock()
	if !self._locked then
		self._prelockDirection = self:Direction()
		self:TurnTowardPlayer()
		self._locked = true
	end
end

function Game_Event:Unlock()
	if self._locked then
		self._locked = false
		self:SetDirection(self._prelockDirection)
	end
end

function Game_Event:UpdateStop()
	if self._locked then
		self:ResetStopCount()
	end
	Game_Character.prototype.updateStop.call(this)
	if !self:IsMoveRouteForcing() then
		self:UpdateSelfMovement()
	end
end

function Game_Event:UpdateSelfMovement()
	if !self._locked and self:IsNearTheScreen() and self:CheckStop(self:StopCountThreshold()) then
		switch (self._moveType) {
			case 1:
				self:MoveTypeRandom()
				break
			case 2:
				self:MoveTypeTowardPlayer()
				break
			case 3:
				self:MoveTypeCustom()
				break
		end
	end
end

function Game_Event:StopCountThreshold()
	return 30 * (5 - self:MoveFrequency())
end

function Game_Event:MoveTypeRandom()
	switch (Math.randomInt(6)) {
		case 0:
		case 1:
			self:MoveRandom()
			break
		case 2:
		case 3:
		case 4:
			self:MoveForward()
			break
		case 5:
			self:ResetStopCount()
			break
	end
end

function Game_Event:MoveTypeTowardPlayer()
	if self:IsNearThePlayer() then
		switch (Math.randomInt(6)) {
			case 0:
			case 1:
			case 2:
			case 3:
				self:MoveTowardPlayer()
				break
			case 4:
				self:MoveRandom()
				break
			case 5:
				self:MoveForward()
				break
		end
	end else {
		self:MoveRandom()
	end
end

function Game_Event:IsNearThePlayer()
	local sx = Math.abs(self:DeltaXFrom(Game.Player.x))
	local sy = Math.abs(self:DeltaYFrom(Game.Player.y))
	return sx + sy < 20
end

function Game_Event:MoveTypeCustom()
	self:UpdateRoutineMove()
end

function Game_Event:IsStarting()
	return self._starting
end

function Game_Event:ClearStartingFlag()
	self._starting = false
end

function Game_Event:IsTriggerIn(triggers)
	return triggers.includes(self._trigger)
end

function Game_Event:Start()
	local list = self:List()
	if list and list.length > 1 then
		self._starting = true
		if self:IsTriggerIn([0, 1, 2]) then
			self:Lock()
		end
	end
end

function Game_Event:Erase()
	self._erased = true
	self:Refresh()
end

function Game_Event:Refresh()
	local newPageIndex = self._erased ? -1 : self:FindProperPageIndex()
	if self._pageIndex ~= newPageIndex then
		self._pageIndex = newPageIndex
		self:SetupPage()
	end
end

function Game_Event:FindProperPageIndex()
	local pages = self:Event().pages
	for (local i = pages.length - 1 i >= 0 i--) {
		local page = pages[i]
		if self:MeetsConditions(page) then
			return i
		end
	end
	return -1
end

function Game_Event:MeetsConditions(page)
	local c = page.conditions
	if c.switch1Valid then
		if !Game.Switches.value(c.switch1Id) then
			return false
		end
	end
	if c.switch2Valid then
		if !Game.Switches.value(c.switch2Id) then
			return false
		end
	end
	if c.variableValid then
		if Game.Variables.value(c.variableId) < c.variableValue then
			return false
		end
	end
	if c.selfSwitchValid then
		local key = [self._mapId, self._eventId, c.selfSwitchCh]
		if Game.SelfSwitches.value(key) ~= true then
			return false
		end
	end
	if c.itemValid then
		local item = Data.Items[c.itemId]
		if !Game.Party.hasItem(item) then
			return false
		end
	end
	if c.actorValid then
		local actor = Game.Actors.actor(c.actorId)
		if !Game.Party.members().includes(actor) then
			return false
		end
	end
	return true
end

function Game_Event:SetupPage()
	if self._pageIndex >= 0 then
		self:SetupPageSettings()
	end else {
		self:ClearPageSettings()
	end
	self:RefreshBushDepth()
	self:ClearStartingFlag()
	self:CheckEventTriggerAuto()
end

function Game_Event:ClearPageSettings()
	self:SetImage("", 0)
	self._moveType = 0
	self._trigger = nil
	self._interpreter = nil
	self:SetThrough(true)
end

function Game_Event:SetupPageSettings()
	local page = self:Page()
	local image = page.image
	if image.tileId > 0 then
		self:SetTileImage(image.tileId)
	end else {
		self:SetImage(image.characterName, image.characterIndex)
	end
	if self._originalDirection ~= image.direction then
		self._originalDirection = image.direction
		self._prelockDirection = 0
		self:SetDirectionFix(false)
		self:SetDirection(image.direction)
	end
	if self._originalPattern ~= image.pattern then
		self._originalPattern = image.pattern
		self:SetPattern(image.pattern)
	end
	self:SetMoveSpeed(page.moveSpeed)
	self:SetMoveFrequency(page.moveFrequency)
	self:SetPriorityType(page.priorityType)
	self:SetWalkAnime(page.walkAnime)
	self:SetStepAnime(page.stepAnime)
	self:SetDirectionFix(page.directionFix)
	self:SetThrough(page.through)
	self:SetMoveRoute(page.moveRoute)
	self._moveType = page.moveType
	self._trigger = page.trigger
	if self._trigger === 4 then
		self._interpreter = new Game_Interpreter()
	end else {
		self._interpreter = nil
	end
end

function Game_Event:IsOriginalPattern()
	return self:Pattern() === self._originalPattern
end

function Game_Event:ResetPattern()
	self:SetPattern(self._originalPattern)
end

function Game_Event:CheckEventTriggerTouch(x, y)
	if !Game.Map.isEventRunning() then
		if self._trigger === 2 and Game.Player.pos(x, y) then
			if !self:IsJumping() and self:IsNormalPriority() then
				self:Start()
			end
		end
	end
end

function Game_Event:CheckEventTriggerAuto()
	if self._trigger === 3 then
		self:Start()
	end
end

function Game_Event:Update()
	Game_Character.prototype.update.call(this)
	self:CheckEventTriggerAuto()
	self:UpdateParallel()
end

function Game_Event:UpdateParallel()
	if self._interpreter then
		if !self._interpreter.isRunning() then
			self._interpreter.setup(self:List(), self._eventId)
		end
		self._interpreter.update()
	end
end

function Game_Event:Locate(x, y)
	Game_Character.prototype.locate.call(this, x, y)
	self._prelockDirection = 0
end

function Game_Event:ForceMoveRoute(moveRoute)
	Game_Character.prototype.forceMoveRoute.call(this, moveRoute)
	self._prelockDirection = 0
end

-------------------------------------------------------------------------------
-- Game_Interpreter
--
-- The interpreter for running event commands.

function Game_Interpreter.new()
	self:Initialize(...arguments)
end

function Game_Interpreter:Initialize(depth)
	self._depth = depth or 0
	self:CheckOverflow()
	self:Clear()
	self._branch = {end
	self._indent = 0
	self._frameCount = 0
	self._freezeChecker = 0
end

function Game_Interpreter:CheckOverflow()
	if self._depth >= 100 then
		throw new Error("Common event calls exceeded the limit")
	end
end

function Game_Interpreter:Clear()
	self._mapId = 0
	self._eventId = 0
	self._list = nil
	self._index = 0
	self._waitCount = 0
	self._waitMode = ""
	self._comments = ""
	self._characterId = 0
	self._childInterpreter = nil
end

function Game_Interpreter:Setup(list, eventId)
	self:Clear()
	self._mapId = Game.Map.mapId()
	self._eventId = eventId or 0
	self._list = list
	self:LoadImages()
end

function Game_Interpreter:LoadImages()
	-- [Note] The certain versions of MV had a more complicated preload scheme.
	--   However it is usually sufficient to preload face and picture images.
	local list = self._list.slice(0, 200)
	for (local command of list) {
		switch (command.code) {
			case 101: -- Show Text
				ImageManager.loadFace(command.parameters[0])
				break
			case 231: -- Show Picture
				ImageManager.loadPicture(command.parameters[1])
				break
		end
	end
end

function Game_Interpreter:EventId()
	return self._eventId
end

function Game_Interpreter:IsOnCurrentMap()
	return self._mapId === Game.Map.mapId()
end

function Game_Interpreter:SetupReservedCommonEvent()
	if Game.Temp.isCommonEventReserved() then
		local commonEvent = Game.Temp.retrieveCommonEvent()
		if commonEvent then
			self:Setup(commonEvent.list)
			return true
		end
	end
	return false
end

function Game_Interpreter:IsRunning()
	return !!self._list
end

function Game_Interpreter:Update()
	while (self:IsRunning()) {
		if self:UpdateChild() or self:UpdateWait() then
			break
		end
		if SceneManager.isSceneChanging() then
			break
		end
		if !self:ExecuteCommand() then
			break
		end
		if self:CheckFreeze() then
			break
		end
	end
end

function Game_Interpreter:UpdateChild()
	if self._childInterpreter then
		self._childInterpreter.update()
		if self._childInterpreter.isRunning() then
			return true
		end else {
			self._childInterpreter = nil
		end
	end
	return false
end

function Game_Interpreter:UpdateWait()
	return self:UpdateWaitCount() or self:UpdateWaitMode()
end

function Game_Interpreter:UpdateWaitCount()
	if self._waitCount > 0 then
		self._waitCount--
		return true
	end
	return false
end

function Game_Interpreter:UpdateWaitMode()
	local character = nil
	local waiting = false
	switch (self._waitMode) {
		case "message":
			waiting = Game.Message.isBusy()
			break
		case "transfer":
			waiting = Game.Player.isTransferring()
			break
		case "scroll":
			waiting = Game.Map.isScrolling()
			break
		case "route":
			character = self:Character(self._characterId)
			waiting = character and character.isMoveRouteForcing()
			break
		case "animation":
			character = self:Character(self._characterId)
			waiting = character and character.isAnimationPlaying()
			break
		case "balloon":
			character = self:Character(self._characterId)
			waiting = character and character.isBalloonPlaying()
			break
		case "gather":
			waiting = Game.Player.areFollowersGathering()
			break
		case "action":
			waiting = BattleManager.isActionForced()
			break
		case "video":
			waiting = Video.isPlaying()
			break
		case "image":
			waiting = !ImageManager.isReady()
			break
	end
	if !waiting then
		self._waitMode = ""
	end
	return waiting
end

function Game_Interpreter:SetWaitMode(waitMode)
	self._waitMode = waitMode
end

function Game_Interpreter:Wait(duration)
	self._waitCount = duration
end

function Game_Interpreter:FadeSpeed()
	return 24
end

function Game_Interpreter:ExecuteCommand()
	local command = self:CurrentCommand()
	if command then
		self._indent = command.indent
		local methodName = "command" + command.code
		if typeof this[methodName] === "function" then
			if !this[methodName](command.parameters) then
				return false
			end
		end
		self._index++
	end else {
		self:Terminate()
	end
	return true
end

function Game_Interpreter:CheckFreeze()
	if self._frameCount ~= Graphics.frameCount then
		self._frameCount = Graphics.frameCount
		self._freezeChecker = 0
	end
	if self._freezeChecker++ >= 100000 then
		return true
	end else {
		return false
	end
end

function Game_Interpreter:Terminate()
	self._list = nil
	self._comments = ""
end

function Game_Interpreter:SkipBranch()
	while (self._list[self._index + 1].indent > self._indent) {
		self._index++
	end
end

function Game_Interpreter:CurrentCommand()
	return self._list[self._index]
end

function Game_Interpreter:NextEventCode()
	local command = self._list[self._index + 1]
	if command then
		return command.code
	end else {
		return 0
	end
end

function Game_Interpreter:IterateActorId(param, callback)
	if param === 0 then
		Game.Party.members().forEach(callback)
	end else {
		local actor = Game.Actors.actor(param)
		if actor then
			callback(actor)
		end
	end
end

function Game_Interpreter:IterateActorEx(param1, param2, callback)
	if param1 === 0 then
		self:IterateActorId(param2, callback)
	end else {
		self:IterateActorId(Game.Variables.value(param2), callback)
	end
end

function Game_Interpreter:IterateActorIndex(param, callback)
	if param < 0 then
		Game.Party.members().forEach(callback)
	end else {
		local actor = Game.Party.members()[param]
		if actor then
			callback(actor)
		end
	end
end

function Game_Interpreter:IterateEnemyIndex(param, callback)
	if param < 0 then
		Game.Troop.members().forEach(callback)
	end else {
		local enemy = Game.Troop.members()[param]
		if enemy then
			callback(enemy)
		end
	end
end

function Game_Interpreter:IterateBattler(param1, param2, callback)
	if Game.Party.inBattle() then
		if param1 === 0 then
			self:IterateEnemyIndex(param2, callback)
		end else {
			self:IterateActorId(param2, callback)
		end
	end
end

function Game_Interpreter:Character(param)
	if Game.Party.inBattle() then
		return nil
	end else if param < 0 then
		return Game.Player
	end else if self:IsOnCurrentMap() then
		return Game.Map.event(param > 0 ? param : self._eventId)
	end else {
		return nil
	end
end

-- prettier-ignore
Game_Interpreter.prototype.operateValue = function(
	operation, operandType, operand
) {
	local value = operandType === 0 ? operand : Game.Variables.value(operand)
	return operation === 0 ? value : -value
end

function Game_Interpreter:ChangeHp(target, value, allowDeath)
	if target.isAlive() then
		if !allowDeath and target.hp <= -value then
			value = 1 - target.hp
		end
		target.gainHp(value)
		if target.isDead() then
			target.performCollapse()
		end
	end
end

-- Show Text
function Game_Interpreter:Command101(params)
	if Game.Message.isBusy() then
		return false
	end
	Game.Message.setFaceImage(params[0], params[1])
	Game.Message.setBackground(params[2])
	Game.Message.setPositionType(params[3])
	Game.Message.setSpeakerName(params[4])
	while (self:NextEventCode() === 401) {
		-- Text data
		self._index++
		Game.Message.add(self:CurrentCommand().parameters[0])
	end
	switch (self:NextEventCode()) {
		case 102: -- Show Choices
			self._index++
			self:SetupChoices(self:CurrentCommand().parameters)
			break
		case 103: -- Input Number
			self._index++
			self:SetupNumInput(self:CurrentCommand().parameters)
			break
		case 104: -- Select Item
			self._index++
			self:SetupItemChoice(self:CurrentCommand().parameters)
			break
	end
	self:SetWaitMode("message")
	return true
end

-- Show Choices
function Game_Interpreter:Command102(params)
	if Game.Message.isBusy() then
		return false
	end
	self:SetupChoices(params)
	self:SetWaitMode("message")
	return true
end

function Game_Interpreter:SetupChoices(params)
	local choices = params[0].clone()
	local cancelType = params[1] < choices.length ? params[1] : -2
	local defaultType = params.length > 2 ? params[2] : 0
	local positionType = params.length > 3 ? params[3] : 2
	local background = params.length > 4 ? params[4] : 0
	Game.Message.setChoices(choices, defaultType, cancelType)
	Game.Message.setChoiceBackground(background)
	Game.Message.setChoicePositionType(positionType)
	Game.Message.setChoiceCallback((n) => {
		self._branch[self._indent] = n
	end)
end

-- When [**]
function Game_Interpreter:Command402(params)
	if self._branch[self._indent] ~= params[0] then
		self:SkipBranch()
	end
	return true
end

-- When Cancel
function Game_Interpreter:Command403()
	if self._branch[self._indent] >= 0 then
		self:SkipBranch()
	end
	return true
end

-- Input Number
function Game_Interpreter:Command103(params)
	if Game.Message.isBusy() then
		return false
	end
	self:SetupNumInput(params)
	self:SetWaitMode("message")
	return true
end

function Game_Interpreter:SetupNumInput(params)
	Game.Message.setNumberInput(params[0], params[1])
end

-- Select Item
function Game_Interpreter:Command104(params)
	if Game.Message.isBusy() then
		return false
	end
	self:SetupItemChoice(params)
	self:SetWaitMode("message")
	return true
end

function Game_Interpreter:SetupItemChoice(params)
	Game.Message.setItemChoice(params[0], params[1] or 2)
end

-- Show Scrolling Text
function Game_Interpreter:Command105(params)
	if Game.Message.isBusy() then
		return false
	end
	Game.Message.setScroll(params[0], params[1])
	while (self:NextEventCode() === 405) {
		self._index++
		Game.Message.add(self:CurrentCommand().parameters[0])
	end
	self:SetWaitMode("message")
	return true
end

-- Comment
function Game_Interpreter:Command108(params)
	self._comments = [params[0]]
	while (self:NextEventCode() === 408) {
		self._index++
		self._comments.push(self:CurrentCommand().parameters[0])
	end
	return true
end

-- Skip
function Game_Interpreter:Command109()
	self:SkipBranch()
	return true
end

-- Conditional Branch
function Game_Interpreter:Command111(params)
	local result = false
	local value1, value2
	local actor, enemy, character
	switch (params[0]) {
		case 0: -- Switch
			result = Game.Switches.value(params[1]) === (params[2] === 0)
			break
		case 1: -- Variable
			value1 = Game.Variables.value(params[1])
			if params[2] === 0 then
				value2 = params[3]
			end else {
				value2 = Game.Variables.value(params[3])
			end
			switch (params[4]) {
				case 0: -- Equal to
					result = value1 === value2
					break
				case 1: -- Greater than or Equal to
					result = value1 >= value2
					break
				case 2: -- Less than or Equal to
					result = value1 <= value2
					break
				case 3: -- Greater than
					result = value1 > value2
					break
				case 4: -- Less than
					result = value1 < value2
					break
				case 5: -- Not Equal to
					result = value1 ~= value2
					break
			end
			break
		case 2: -- Self Switch
			if self._eventId > 0 then
				local key = [self._mapId, self._eventId, params[1]]
				result = Game.SelfSwitches.value(key) === (params[2] === 0)
			end
			break
		case 3: -- Timer
			if Game.Timer.isWorking() then
				local sec = Game.Timer.frames() / 60
				if params[2] === 0 then
					result = sec >= params[1]
				end else {
					result = sec <= params[1]
				end
			end
			break
		case 4: -- Actor
			actor = Game.Actors.actor(params[1])
			if actor then
				local n = params[3]
				switch (params[2]) {
					case 0: -- In the Party
						result = Game.Party.members().includes(actor)
						break
					case 1: -- Name
						result = actor.name() === n
						break
					case 2: -- Class
						result = actor.isClass(Data.Classes[n])
						break
					case 3: -- Skill
						result = actor.hasSkill(n)
						break
					case 4: -- Weapon
						result = actor.hasWeapon(Data.Weapons[n])
						break
					case 5: -- Armor
						result = actor.hasArmor(Data.Armors[n])
						break
					case 6: -- State
						result = actor.isStateAffected(n)
						break
				end
			end
			break
		case 5: -- Enemy
			enemy = Game.Troop.members()[params[1]]
			if enemy then
				switch (params[2]) {
					case 0: -- Appeared
						result = enemy.isAlive()
						break
					case 1: -- State
						result = enemy.isStateAffected(params[3])
						break
				end
			end
			break
		case 6: -- Character
			character = self:Character(params[1])
			if character then
				result = character.direction() === params[2]
			end
			break
		case 7: -- Gold
			switch (params[2]) {
				case 0: -- Greater than or equal to
					result = Game.Party.gold() >= params[1]
					break
				case 1: -- Less than or equal to
					result = Game.Party.gold() <= params[1]
					break
				case 2: -- Less than
					result = Game.Party.gold() < params[1]
					break
			end
			break
		case 8: -- Item
			result = Game.Party.hasItem(Data.Items[params[1]])
			break
		case 9: -- Weapon
			result = Game.Party.hasItem(Data.Weapons[params[1]], params[2])
			break
		case 10: -- Armor
			result = Game.Party.hasItem(Data.Armors[params[1]], params[2])
			break
		case 11: -- Button
			switch (params[2] or 0) {
				case 0:
					result = Input.isPressed(params[1])
					break
				case 1:
					result = Input.isTriggered(params[1])
					break
				case 2:
					result = Input.isRepeated(params[1])
					break
			end
			break
		case 12: -- Script
			result = !!eval(params[1])
			break
		case 13: -- Vehicle
			result = Game.Player.vehicle() === Game.Map.vehicle(params[1])
			break
	end
	self._branch[self._indent] = result
	if self._branch[self._indent] === false then
		self:SkipBranch()
	end
	return true
end

-- Else
function Game_Interpreter:Command411()
	if self._branch[self._indent] ~= false then
		self:SkipBranch()
	end
	return true
end

-- Loop
function Game_Interpreter:Command112()
	return true
end

-- Repeat Above
function Game_Interpreter:Command413()
	do {
		self._index--
	end while (self:CurrentCommand().indent ~= self._indent)
	return true
end

-- Break Loop
function Game_Interpreter:Command113()
	local depth = 0
	while (self._index < self._list.length - 1) {
		self._index++
		local command = self:CurrentCommand()
		if command.code === 112 then
			depth++
		end
		if command.code === 413 then
			if depth > 0 then
				depth--
			end else {
				break
			end
		end
	end
	return true
end

-- Exit Event Processing
function Game_Interpreter:Command115()
	self._index = self._list.length
	return true
end

-- Common Event
function Game_Interpreter:Command117(params)
	local commonEvent = Data.CommonEvents[params[0]]
	if commonEvent then
		local eventId = self:IsOnCurrentMap() ? self._eventId : 0
		self:SetupChild(commonEvent.list, eventId)
	end
	return true
end

function Game_Interpreter:SetupChild(list, eventId)
	self._childInterpreter = new Game_Interpreter(self._depth + 1)
	self._childInterpreter.setup(list, eventId)
end

-- Label
function Game_Interpreter:Command118()
	return true
end

-- Jump to Label
function Game_Interpreter:Command119(params)
	local labelName = params[0]
	for (local i = 0 i < self._list.length i++) {
		local command = self._list[i]
		if command.code === 118 and command.parameters[0] === labelName then
			self:JumpTo(i)
			break
		end
	end
	return true
end

function Game_Interpreter:JumpTo(index)
	local lastIndex = self._index
	local startIndex = Math.min(index, lastIndex)
	local endIndex = Math.max(index, lastIndex)
	local indent = self._indent
	for (local i = startIndex i <= endIndex i++) {
		local newIndent = self._list[i].indent
		if newIndent ~= indent then
			self._branch[indent] = nil
			indent = newIndent
		end
	end
	self._index = index
end

-- Control Switches
function Game_Interpreter:Command121(params)
	for (local i = params[0] i <= params[1] i++) {
		Game.Switches.setValue(i, params[2] === 0)
	end
	return true
end

-- Control Variables
function Game_Interpreter:Command122(params)
	local startId = params[0]
	local endId = params[1]
	local operationType = params[2]
	local operand = params[3]
	local value = 0
	local randomMax = 1
	switch (operand) {
		case 0: -- Constant
			value = params[4]
			break
		case 1: -- Variable
			value = Game.Variables.value(params[4])
			break
		case 2: -- Random
			value = params[4]
			randomMax = params[5] - params[4] + 1
			randomMax = Math.max(randomMax, 1)
			break
		case 3: -- Game Data
			value = self:GameDataOperand(params[4], params[5], params[6])
			break
		case 4: -- Script
			value = eval(params[4])
			break
	end
	for (local i = startId i <= endId i++) {
		if typeof value === "number" then
			local realValue = value + Math.randomInt(randomMax)
			self:OperateVariable(i, operationType, realValue)
		end else {
			self:OperateVariable(i, operationType, value)
		end
	end
	return true
end

function Game_Interpreter:GameDataOperand(type, param1, param2)
	local actor, enemy, character
	switch (type) {
		case 0: -- Item
			return Game.Party.numItems(Data.Items[param1])
		case 1: -- Weapon
			return Game.Party.numItems(Data.Weapons[param1])
		case 2: -- Armor
			return Game.Party.numItems(Data.Armors[param1])
		case 3: -- Actor
			actor = Game.Actors.actor(param1)
			if actor then
				switch (param2) {
					case 0: -- Level
						return actor.level
					case 1: -- EXP
						return actor.currentExp()
					case 2: -- HP
						return actor.hp
					case 3: -- MP
						return actor.mp
					case 12: -- TP
						return actor.tp
					default:
						-- Parameter
						if param2 >= 4 and param2 <= 11 then
							return actor.param(param2 - 4)
						end
				end
			end
			break
		case 4: -- Enemy
			enemy = Game.Troop.members()[param1]
			if enemy then
				switch (param2) {
					case 0: -- HP
						return enemy.hp
					case 1: -- MP
						return enemy.mp
					case 10: -- TP
						return enemy.tp
					default:
						-- Parameter
						if param2 >= 2 and param2 <= 9 then
							return enemy.param(param2 - 2)
						end
				end
			end
			break
		case 5: -- Character
			character = self:Character(param1)
			if character then
				switch (param2) {
					case 0: -- Map X
						return character.x
					case 1: -- Map Y
						return character.y
					case 2: -- Direction
						return character.direction()
					case 3: -- Screen X
						return character.screenX()
					case 4: -- Screen Y
						return character.screenY()
				end
			end
			break
		case 6: -- Party
			actor = Game.Party.members()[param1]
			return actor ? actor.actorId() : 0
		case 8: -- Last
			return Game.Temp.lastActionData(param1)
		case 7: -- Other
			switch (param1) {
				case 0: -- Map ID
					return Game.Map.mapId()
				case 1: -- Party Members
					return Game.Party.size()
				case 2: -- Gold
					return Game.Party.gold()
				case 3: -- Steps
					return Game.Party.steps()
				case 4: -- Play Time
					return Game.System.playtime()
				case 5: -- Timer
					return Game.Timer.seconds()
				case 6: -- Save Count
					return Game.System.saveCount()
				case 7: -- Battle Count
					return Game.System.battleCount()
				case 8: -- Win Count
					return Game.System.winCount()
				case 9: -- Escape Count
					return Game.System.escapeCount()
			end
			break
	end
	return 0
end

function Game_Interpreter:OperateVariable(variableId, operationType, value)
	try {
		local oldValue = Game.Variables.value(variableId)
		switch (operationType) {
			case 0: -- Set
				Game.Variables.setValue(variableId, value)
				break
			case 1: -- Add
				Game.Variables.setValue(variableId, oldValue + value)
				break
			case 2: -- Sub
				Game.Variables.setValue(variableId, oldValue - value)
				break
			case 3: -- Mul
				Game.Variables.setValue(variableId, oldValue * value)
				break
			case 4: -- Div
				Game.Variables.setValue(variableId, oldValue / value)
				break
			case 5: -- Mod
				Game.Variables.setValue(variableId, oldValue % value)
				break
		end
	end catch (e) {
		Game.Variables.setValue(variableId, 0)
	end
end

-- Control Self Switch
function Game_Interpreter:Command123(params)
	if self._eventId > 0 then
		local key = [self._mapId, self._eventId, params[0]]
		Game.SelfSwitches.setValue(key, params[1] === 0)
	end
	return true
end

-- Control Timer
function Game_Interpreter:Command124(params)
	if params[0] === 0 then
		-- Start
		Game.Timer.start(params[1] * 60)
	end else {
		-- Stop
		Game.Timer.stop()
	end
	return true
end

-- Change Gold
function Game_Interpreter:Command125(params)
	local value = self:OperateValue(params[0], params[1], params[2])
	Game.Party.gainGold(value)
	return true
end

-- Change Items
function Game_Interpreter:Command126(params)
	local value = self:OperateValue(params[1], params[2], params[3])
	Game.Party.gainItem(Data.Items[params[0]], value)
	return true
end

-- Change Weapons
function Game_Interpreter:Command127(params)
	local value = self:OperateValue(params[1], params[2], params[3])
	Game.Party.gainItem(Data.Weapons[params[0]], value, params[4])
	return true
end

-- Change Armors
function Game_Interpreter:Command128(params)
	local value = self:OperateValue(params[1], params[2], params[3])
	Game.Party.gainItem(Data.Armors[params[0]], value, params[4])
	return true
end

-- Change Party Member
function Game_Interpreter:Command129(params)
	local actor = Game.Actors.actor(params[0])
	if actor then
		if params[1] === 0 then
			-- Add
			if params[2] then
				-- Initialize
				Game.Actors.actor(params[0]).setup(params[0])
			end
			Game.Party.addActor(params[0])
		end else {
			-- Remove
			Game.Party.removeActor(params[0])
		end
	end
	return true
end

-- Change Battle BGM
function Game_Interpreter:Command132(params)
	Game.System.setBattleBgm(params[0])
	return true
end

-- Change Victory ME
function Game_Interpreter:Command133(params)
	Game.System.setVictoryMe(params[0])
	return true
end

-- Change Save Access
function Game_Interpreter:Command134(params)
	if params[0] === 0 then
		Game.System.disableSave()
	end else {
		Game.System.enableSave()
	end
	return true
end

-- Change Menu Access
function Game_Interpreter:Command135(params)
	if params[0] === 0 then
		Game.System.disableMenu()
	end else {
		Game.System.enableMenu()
	end
	return true
end

-- Change Encounter
function Game_Interpreter:Command136(params)
	if params[0] === 0 then
		Game.System.disableEncounter()
	end else {
		Game.System.enableEncounter()
	end
	Game.Player.makeEncounterCount()
	return true
end

-- Change Formation Access
function Game_Interpreter:Command137(params)
	if params[0] === 0 then
		Game.System.disableFormation()
	end else {
		Game.System.enableFormation()
	end
	return true
end

-- Change Window Color
function Game_Interpreter:Command138(params)
	Game.System.setWindowTone(params[0])
	return true
end

-- Change Defeat ME
function Game_Interpreter:Command139(params)
	Game.System.setDefeatMe(params[0])
	return true
end

-- Change Vehicle BGM
function Game_Interpreter:Command140(params)
	local vehicle = Game.Map.vehicle(params[0])
	if vehicle then
		vehicle.setBgm(params[1])
	end
	return true
end

-- Transfer Player
function Game_Interpreter:Command201(params)
	if Game.Party.inBattle() or Game.Message.isBusy() then
		return false
	end
	local mapId, x, y
	if params[0] === 0 then
		-- Direct designation
		mapId = params[1]
		x = params[2]
		y = params[3]
	end else {
		-- Designation with variables
		mapId = Game.Variables.value(params[1])
		x = Game.Variables.value(params[2])
		y = Game.Variables.value(params[3])
	end
	Game.Player.reserveTransfer(mapId, x, y, params[4], params[5])
	self:SetWaitMode("transfer")
	return true
end

-- Set Vehicle Location
function Game_Interpreter:Command202(params)
	local mapId, x, y
	if params[1] === 0 then
		-- Direct designation
		mapId = params[2]
		x = params[3]
		y = params[4]
	end else {
		-- Designation with variables
		mapId = Game.Variables.value(params[2])
		x = Game.Variables.value(params[3])
		y = Game.Variables.value(params[4])
	end
	local vehicle = Game.Map.vehicle(params[0])
	if vehicle then
		vehicle.setLocation(mapId, x, y)
	end
	return true
end

-- Set Event Location
function Game_Interpreter:Command203(params)
	local character = self:Character(params[0])
	if character then
		if params[1] === 0 then
			-- Direct designation
			character.locate(params[2], params[3])
		end else if params[1] === 1 then
			-- Designation with variables
			local x = Game.Variables.value(params[2])
			local y = Game.Variables.value(params[3])
			character.locate(x, y)
		end else {
			-- Exchange with another event
			local character2 = self:Character(params[2])
			if character2 then
				character.swap(character2)
			end
		end
		if params[4] > 0 then
			character.setDirection(params[4])
		end
	end
	return true
end

-- Scroll Map
function Game_Interpreter:Command204(params)
	if !Game.Party.inBattle() then
		if Game.Map.isScrolling() then
			self:SetWaitMode("scroll")
			return false
		end
		Game.Map.startScroll(params[0], params[1], params[2])
		if params[3] then
			self:SetWaitMode("scroll")
		end
	end
	return true
end

-- Set Movement Route
function Game_Interpreter:Command205(params)
	Game.Map.refreshIfNeeded()
	self._characterId = params[0]
	local character = self:Character(self._characterId)
	if character then
		character.forceMoveRoute(params[1])
		if params[1].wait then
			self:SetWaitMode("route")
		end
	end
	return true
end

-- Get on/off Vehicle
function Game_Interpreter:Command206()
	Game.Player.getOnOffVehicle()
	return true
end

-- Change Transparency
function Game_Interpreter:Command211(params)
	Game.Player.setTransparent(params[0] === 0)
	return true
end

-- Show Animation
function Game_Interpreter:Command212(params)
	self._characterId = params[0]
	local character = self:Character(self._characterId)
	if character then
		Game.Temp.requestAnimation([character], params[1])
		if params[2] then
			self:SetWaitMode("animation")
		end
	end
	return true
end

-- Show Balloon Icon
function Game_Interpreter:Command213(params)
	self._characterId = params[0]
	local character = self:Character(self._characterId)
	if character then
		Game.Temp.requestBalloon(character, params[1])
		if params[2] then
			self:SetWaitMode("balloon")
		end
	end
	return true
end

-- Erase Event
function Game_Interpreter:Command214()
	if self:IsOnCurrentMap() and self._eventId > 0 then
		Game.Map.eraseEvent(self._eventId)
	end
	return true
end

-- Change Player Followers
function Game_Interpreter:Command216(params)
	if params[0] === 0 then
		Game.Player.showFollowers()
	end else {
		Game.Player.hideFollowers()
	end
	Game.Player.refresh()
	return true
end

-- Gather Followers
function Game_Interpreter:Command217()
	if !Game.Party.inBattle() then
		Game.Player.gatherFollowers()
		self:SetWaitMode("gather")
	end
	return true
end

-- Fadeout Screen
function Game_Interpreter:Command221()
	if Game.Message.isBusy() then
		return false
	end
	Game.Screen.startFadeOut(self:FadeSpeed())
	self:Wait(self:FadeSpeed())
	return true
end

-- Fadein Screen
function Game_Interpreter:Command222()
	if Game.Message.isBusy() then
		return false
	end
	Game.Screen.startFadeIn(self:FadeSpeed())
	self:Wait(self:FadeSpeed())
	return true
end

-- Tint Screen
function Game_Interpreter:Command223(params)
	Game.Screen.startTint(params[0], params[1])
	if params[2] then
		self:Wait(params[1])
	end
	return true
end

-- Flash Screen
function Game_Interpreter:Command224(params)
	Game.Screen.startFlash(params[0], params[1])
	if params[2] then
		self:Wait(params[1])
	end
	return true
end

-- Shake Screen
function Game_Interpreter:Command225(params)
	Game.Screen.startShake(params[0], params[1], params[2])
	if params[3] then
		self:Wait(params[2])
	end
	return true
end

-- Wait
function Game_Interpreter:Command230(params)
	self:Wait(params[0])
	return true
end

-- Show Picture
function Game_Interpreter:Command231(params)
	local point = self:PicturePoint(params)
	-- prettier-ignore
	Game.Screen.showPicture(
		params[0], params[1], params[2], point.x, point.y,
		params[6], params[7], params[8], params[9]
	)
	return true
end

-- Move Picture
function Game_Interpreter:Command232(params)
	local point = self:PicturePoint(params)
	-- prettier-ignore
	Game.Screen.movePicture(
		params[0], params[2], point.x, point.y, params[6], params[7],
		params[8], params[9], params[10], params[12] or 0
	)
	if params[11] then
		self:Wait(params[10])
	end
	return true
end

function Game_Interpreter:PicturePoint(params)
	local point = new Point()
	if params[3] === 0 then
		-- Direct designation
		point.x = params[4]
		point.y = params[5]
	end else {
		-- Designation with variables
		point.x = Game.Variables.value(params[4])
		point.y = Game.Variables.value(params[5])
	end
	return point
end

-- Rotate Picture
function Game_Interpreter:Command233(params)
	Game.Screen.rotatePicture(params[0], params[1])
	return true
end

-- Tint Picture
function Game_Interpreter:Command234(params)
	Game.Screen.tintPicture(params[0], params[1], params[2])
	if params[3] then
		self:Wait(params[2])
	end
	return true
end

-- Erase Picture
function Game_Interpreter:Command235(params)
	Game.Screen.erasePicture(params[0])
	return true
end

-- Set Weather Effect
function Game_Interpreter:Command236(params)
	if !Game.Party.inBattle() then
		Game.Screen.changeWeather(params[0], params[1], params[2])
		if params[3] then
			self:Wait(params[2])
		end
	end
	return true
end

-- Play BGM
function Game_Interpreter:Command241(params)
	AudioManager.playBgm(params[0])
	return true
end

-- Fadeout BGM
function Game_Interpreter:Command242(params)
	AudioManager.fadeOutBgm(params[0])
	return true
end

-- Save BGM
function Game_Interpreter:Command243()
	Game.System.saveBgm()
	return true
end

-- Resume BGM
function Game_Interpreter:Command244()
	Game.System.replayBgm()
	return true
end

-- Play BGS
function Game_Interpreter:Command245(params)
	AudioManager.playBgs(params[0])
	return true
end

-- Fadeout BGS
function Game_Interpreter:Command246(params)
	AudioManager.fadeOutBgs(params[0])
	return true
end

-- Play ME
function Game_Interpreter:Command249(params)
	AudioManager.playMe(params[0])
	return true
end

-- Play SE
function Game_Interpreter:Command250(params)
	AudioManager.playSe(params[0])
	return true
end

-- Stop SE
function Game_Interpreter:Command251()
	AudioManager.stopSe()
	return true
end

-- Play Movie
function Game_Interpreter:Command261(params)
	if Game.Message.isBusy() then
		return false
	end
	local name = params[0]
	if name.length > 0 then
		local ext = self:VideoFileExt()
		Video.play("movies/" + name + ext)
		self:SetWaitMode("video")
	end
	return true
end

function Game_Interpreter:VideoFileExt()
	if Utils.canPlayWebm() then
		return ".webm"
	end else {
		return ".mp4"
	end
end

-- Change Map Name Display
function Game_Interpreter:Command281(params)
	if params[0] === 0 then
		Game.Map.enableNameDisplay()
	end else {
		Game.Map.disableNameDisplay()
	end
	return true
end

-- Change Tileset
function Game_Interpreter:Command282(params)
	local tileset = Data.Tilesets[params[0]]
	local allReady = tileset.tilesetNames.map((tilesetName) => ImageManager.loadTileset(tilesetName)).every((bitmap) => bitmap.isReady())
	if allReady then
		Game.Map.changeTileset(params[0])
		return true
	end else {
		return false
	end
end

-- Change Battle Background
function Game_Interpreter:Command283(params)
	Game.Map.changeBattleback(params[0], params[1])
	return true
end

-- Change Parallax
function Game_Interpreter:Command284(params)
	-- prettier-ignore
	Game.Map.changeParallax(
		params[0], params[1], params[2], params[3], params[4]
	)
	return true
end

-- Get Location Info
function Game_Interpreter:Command285(params)
	local x, y, value
	if params[2] === 0 then
		-- Direct designation
		x = params[3]
		y = params[4]
	end else if params[2] === 1 then
		-- Designation with variables
		x = Game.Variables.value(params[3])
		y = Game.Variables.value(params[4])
	end else {
		-- Designation by a character
		local character = self:Character(params[3])
		x = character.x
		y = character.y
	end
	switch (params[1]) {
		case 0: -- Terrain Tag
			value = Game.Map.terrainTag(x, y)
			break
		case 1: -- Event ID
			value = Game.Map.eventIdXy(x, y)
			break
		case 2: -- Tile ID (Layer 1)
		case 3: -- Tile ID (Layer 2)
		case 4: -- Tile ID (Layer 3)
		case 5: -- Tile ID (Layer 4)
			value = Game.Map.tileId(x, y, params[1] - 2)
			break
		default:
			-- Region ID
			value = Game.Map.regionId(x, y)
			break
	end
	Game.Variables.setValue(params[0], value)
	return true
end

-- Battle Processing
function Game_Interpreter:Command301(params)
	if !Game.Party.inBattle() then
		local troopId
		if params[0] === 0 then
			-- Direct designation
			troopId = params[1]
		end else if params[0] === 1 then
			-- Designation with a variable
			troopId = Game.Variables.value(params[1])
		end else {
			-- Same as Random Encounters
			troopId = Game.Player.makeEncounterTroopId()
		end
		if Data.Troops[troopId] then
			BattleManager.setup(troopId, params[2], params[3])
			BattleManager.setEventCallback((n) => {
				self._branch[self._indent] = n
			end)
			Game.Player.makeEncounterCount()
			SceneManager.push(Scene_Battle)
		end
	end
	return true
end

-- If Win
function Game_Interpreter:Command601()
	if self._branch[self._indent] ~= 0 then
		self:SkipBranch()
	end
	return true
end

-- If Escape
function Game_Interpreter:Command602()
	if self._branch[self._indent] ~= 1 then
		self:SkipBranch()
	end
	return true
end

-- If Lose
function Game_Interpreter:Command603()
	if self._branch[self._indent] ~= 2 then
		self:SkipBranch()
	end
	return true
end

-- Shop Processing
function Game_Interpreter:Command302(params)
	if !Game.Party.inBattle() then
		local goods = [params]
		while (self:NextEventCode() === 605) {
			self._index++
			goods.push(self:CurrentCommand().parameters)
		end
		SceneManager.push(Scene_Shop)
		SceneManager.prepareNextScene(goods, params[4])
	end
	return true
end

-- Name Input Processing
function Game_Interpreter:Command303(params)
	if !Game.Party.inBattle() then
		if Data.Actors[params[0]] then
			SceneManager.push(Scene_Name)
			SceneManager.prepareNextScene(params[0], params[1])
		end
	end
	return true
end

-- Change HP
function Game_Interpreter:Command311(params)
	local value = self:OperateValue(params[2], params[3], params[4])
	self:IterateActorEx(params[0], params[1], (actor) => {
		self:ChangeHp(actor, value, params[5])
	end)
	return true
end

-- Change MP
function Game_Interpreter:Command312(params)
	local value = self:OperateValue(params[2], params[3], params[4])
	self:IterateActorEx(params[0], params[1], (actor) => {
		actor.gainMp(value)
	end)
	return true
end

-- Change TP
function Game_Interpreter:Command326(params)
	local value = self:OperateValue(params[2], params[3], params[4])
	self:IterateActorEx(params[0], params[1], (actor) => {
		actor.gainTp(value)
	end)
	return true
end

-- Change State
function Game_Interpreter:Command313(params)
	self:IterateActorEx(params[0], params[1], (actor) => {
		local alreadyDead = actor.isDead()
		if params[2] === 0 then
			actor.addState(params[3])
		end else {
			actor.removeState(params[3])
		end
		if actor.isDead() and !alreadyDead then
			actor.performCollapse()
		end
		actor.clearResult()
	end)
	return true
end

-- Recover All
function Game_Interpreter:Command314(params)
	self:IterateActorEx(params[0], params[1], (actor) => {
		actor.recoverAll()
	end)
	return true
end

-- Change EXP
function Game_Interpreter:Command315(params)
	local value = self:OperateValue(params[2], params[3], params[4])
	self:IterateActorEx(params[0], params[1], (actor) => {
		actor.changeExp(actor.currentExp() + value, params[5])
	end)
	return true
end

-- Change Level
function Game_Interpreter:Command316(params)
	local value = self:OperateValue(params[2], params[3], params[4])
	self:IterateActorEx(params[0], params[1], (actor) => {
		actor.changeLevel(actor.level + value, params[5])
	end)
	return true
end

-- Change Parameter
function Game_Interpreter:Command317(params)
	local value = self:OperateValue(params[3], params[4], params[5])
	self:IterateActorEx(params[0], params[1], (actor) => {
		actor.addParam(params[2], value)
	end)
	return true
end

-- Change Skill
function Game_Interpreter:Command318(params)
	self:IterateActorEx(params[0], params[1], (actor) => {
		if params[2] === 0 then
			actor.learnSkill(params[3])
		end else {
			actor.forgetSkill(params[3])
		end
	end)
	return true
end

-- Change Equipment
function Game_Interpreter:Command319(params)
	local actor = Game.Actors.actor(params[0])
	if actor then
		actor.changeEquipById(params[1], params[2])
	end
	return true
end

-- Change Name
function Game_Interpreter:Command320(params)
	local actor = Game.Actors.actor(params[0])
	if actor then
		actor.setName(params[1])
	end
	return true
end

-- Change Class
function Game_Interpreter:Command321(params)
	local actor = Game.Actors.actor(params[0])
	if actor and Data.Classes[params[1]] then
		actor.changeClass(params[1], params[2])
	end
	return true
end

-- Change Actor Images
function Game_Interpreter:Command322(params)
	local actor = Game.Actors.actor(params[0])
	if actor then
		actor.setCharacterImage(params[1], params[2])
		actor.setFaceImage(params[3], params[4])
		actor.setBattlerImage(params[5])
	end
	Game.Player.refresh()
	return true
end

-- Change Vehicle Image
function Game_Interpreter:Command323(params)
	local vehicle = Game.Map.vehicle(params[0])
	if vehicle then
		vehicle.setImage(params[1], params[2])
	end
	return true
end

-- Change Nickname
function Game_Interpreter:Command324(params)
	local actor = Game.Actors.actor(params[0])
	if actor then
		actor.setNickname(params[1])
	end
	return true
end

-- Change Profile
function Game_Interpreter:Command325(params)
	local actor = Game.Actors.actor(params[0])
	if actor then
		actor.setProfile(params[1])
	end
	return true
end

-- Change Enemy HP
function Game_Interpreter:Command331(params)
	local value = self:OperateValue(params[1], params[2], params[3])
	self:IterateEnemyIndex(params[0], (enemy) => {
		self:ChangeHp(enemy, value, params[4])
	end)
	return true
end

-- Change Enemy MP
function Game_Interpreter:Command332(params)
	local value = self:OperateValue(params[1], params[2], params[3])
	self:IterateEnemyIndex(params[0], (enemy) => {
		enemy.gainMp(value)
	end)
	return true
end

-- Change Enemy TP
function Game_Interpreter:Command342(params)
	local value = self:OperateValue(params[1], params[2], params[3])
	self:IterateEnemyIndex(params[0], (enemy) => {
		enemy.gainTp(value)
	end)
	return true
end

-- Change Enemy State
function Game_Interpreter:Command333(params)
	self:IterateEnemyIndex(params[0], (enemy) => {
		local alreadyDead = enemy.isDead()
		if params[1] === 0 then
			enemy.addState(params[2])
		end else {
			enemy.removeState(params[2])
		end
		if enemy.isDead() and !alreadyDead then
			enemy.performCollapse()
		end
		enemy.clearResult()
	end)
	return true
end

-- Enemy Recover All
function Game_Interpreter:Command334(params)
	self:IterateEnemyIndex(params[0], (enemy) => {
		enemy.recoverAll()
	end)
	return true
end

-- Enemy Appear
function Game_Interpreter:Command335(params)
	self:IterateEnemyIndex(params[0], (enemy) => {
		enemy.appear()
		Game.Troop.makeUniqueNames()
	end)
	return true
end

-- Enemy Transform
function Game_Interpreter:Command336(params)
	self:IterateEnemyIndex(params[0], (enemy) => {
		enemy.transform(params[1])
		Game.Troop.makeUniqueNames()
	end)
	return true
end

-- Show Battle Animation
function Game_Interpreter:Command337(params)
	local param = params[0]
	if params[2] then
		param = -1
	end
	local targets = []
	self:IterateEnemyIndex(param, (enemy) => {
		if enemy.isAlive() then
			targets.push(enemy)
		end
	end)
	Game.Temp.requestAnimation(targets, params[1])
	return true
end

-- Force Action
function Game_Interpreter:Command339(params)
	self:IterateBattler(params[0], params[1], (battler) => {
		if !battler.isDeathStateAffected() then
			battler.forceAction(params[2], params[3])
			BattleManager.forceAction(battler)
			self:SetWaitMode("action")
		end
	end)
	return true
end

-- Abort Battle
function Game_Interpreter:Command340()
	BattleManager.abort()
	return true
end

-- Open Menu Screen
function Game_Interpreter:Command351()
	if !Game.Party.inBattle() then
		SceneManager.push(Scene_Menu)
		Window_MenuCommand.initCommandPosition()
	end
	return true
end

-- Open Save Screen
function Game_Interpreter:Command352()
	if !Game.Party.inBattle() then
		SceneManager.push(Scene_Save)
	end
	return true
end

-- Game Over
function Game_Interpreter:Command353()
	SceneManager.goto(Scene_Gameover)
	return true
end

-- Return to Title Screen
function Game_Interpreter:Command354()
	SceneManager.goto(Scene_Title)
	return true
end

-- Script
function Game_Interpreter:Command355()
	local script = self:CurrentCommand().parameters[0] + "\n"
	while (self:NextEventCode() === 655) {
		self._index++
		script += self:CurrentCommand().parameters[0] + "\n"
	end
	eval(script)
	return true
end

-- Plugin Command MV (deprecated)
function Game_Interpreter:Command356(params)
	local args = params[0].split(" ")
	local command = args.shift()
	self:PluginCommand(command, args)
	return true
end

function Game_Interpreter:PluginCommand()
	-- deprecated
end

-- Plugin Command
function Game_Interpreter:Command357(params)
	local pluginName = Utils.extractFileName(params[0])
	PluginManager.callCommand(this, pluginName, params[1], params[3])
	return true
end

-------------------------------------------------------------------------------
