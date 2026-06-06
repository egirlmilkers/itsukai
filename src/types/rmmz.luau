RMMZ = {}


--[[=======================
-------- Save Types -------
=======================]]--

export type Global = {
	title: string;
	characters: {{string | number}};
	faces: {{string | number}};
	playtime: string;
	timestamp: number;
}

export type Config = {
	alwaysDash: boolean;
	commandRemember: boolean;
	touchUi: boolean;
	bgmVolume: number;
	bgsVolume: number;
	meVolume: number;
	seVolume: number;
}

export type Save = {
	-- TODO: data objects
	system: any;
	screen: any;
	timer: any;
	switches: any;
	variables: any;
	selfSwitches: any;
	actors: any;
	party: any;
	map: any;
	player: any;
}


--[[=======================
------- Data Objects ------
=======================]]--

export type DataObj = {
	note: string?;
	meta: string?;
}

export type Actor = DataObj & {
	id: number;
	battlerName: string;
	characterIndex: number;
	characterName: string;
	classId: number;
	equips: {number};
	faceIndex: number;
	faceName: string;
	traits: {Trait};
	initialLevel: number;
	maxLevel: number;
	name: string;
	nickname: string;
	profile: string;
}

export type Armor = DataObj & {
	id: number;
	atypeId: number;
	description: string;
	etypeId: number;
	traits: {Trait};
	iconIndex: number;
	name: string;
	params: {number};
	price: number;
}

export type Class = DataObj & {
	id: number;
	expParams: {number};
	traits: {Trait};
	learnings: {Learning};
	name: string;
	params: {{number}};
}

export type Enemy = DataObj & {
	id: number;
	actions: {Action};
	battlerHue: number;
	battlerName: string;
	dropItems: {DropItem};
	exp: number;
	traits: {Trait};
	gold: number;
	name: string;
	params: {number};
}

export type Event = DataObj & {
	id: number;
	name: string;
	pages: {EventPage};
	x: number;
	y: number;
}

export type Item = DataObj & {
	id: number;
	animationId: number;
	consumable: boolean;
	damage: Damage;
	description: string;
	effects: {Effect};
	hitType: number;
	iconIndex: number;
	itypeId: number;
	name: string;
	occasion: number;
	price: number;
	repeats: number;
	scope: number;
	speed: number;
	successRate: number;
	tpGain: number;
}

export type Map = DataObj & {
	autoplayBgm: boolean?;
	autoplayBgs: boolean?;
	battleback1Name: string?;
	battleback2Name: string?;
	bgm: Audio?;
	bgs: Audio?;
	disableDashing: boolean?;
	displayName: string?;
	encounterList: {Encounter}?;
	encounterStep: number?;
	height: number;
	parallaxLoopX: boolean?;
	parallaxLoopY: boolean?;
	parallaxName: string?;
	parallaxShow: boolean?;
	parallaxSx: number?;
	parallaxSy: number?;
	scrollType: number;
	specifyBattleback: boolean?;
	tilesetId: number?;
	width: number;
	data: {number};
	events: {Event?};
}

export type Skill = DataObj & {
	id: number;
	animationId: number;
	damage: Damage;
	description: string;
	effects: {Effect};
	hitType: number;
	iconIndex: number;
	message1: string;
	message2: string;
	mpCost: number;
	name: string;
	occasion: number;
	repeats: number;
	requiredWtypeId1: number;
	requiredWtypeId2: number;
	scope: number;
	speed: number;
	stypeId: number;
	successRate: number;
	tpCost: number;
	tpGain: number;
	messageType: number;
}

export type State = DataObj & {
	id: number;
	autoRemovalTiming: number;
	chanceByDamage: number;
	iconIndex: number;
	maxTurns: number;
	message1: string;
	message2: string;
	message3: string;
	message4: string;
	minTurns: number;
	motion: number;
	name: string;
	overlay: number;
	priority: number;
	removeAtBattleEnd: boolean;
	removeByDamage: boolean;
	removeByRestriction: boolean;
	removeByWalking: boolean;
	restriction: number;
	stepsToRemove: number;
	traits: {Trait};
	messageType: number;
}

export type Tileset = DataObj & {
	id: number;
	flags: {number};
	mode: number;
	name: string;
	tilesetNames: {string};
}

export type Weapon = DataObj & {
	id: number;
	animationId: number;
	description: string;
	etypeId: number;
	traits: {Trait};
	iconIndex: number;
	name: string;
	params: {number};
	price: number;
	wtypeId: number;
}

--v Non-DataObj Sublasses v--

export type Animation = {
	id: number;
	displayType: number;
	effectName: string;
	flashTimings: {FlashTiming};
	name: string;
	offsetX: number;
	offsetY: number;
	rotation: {x: number, y: number, z: number};
	scale: number;
	soundTimings: {SoundTiming};
	speed: number;
}

export type CommonEvent = {
	id: number;
	list: {EventCommand};
	name: string;
	switchId: number;
	trigger: number;
}

export type MapInfo = {
	id: number;
	expanded: boolean;
	name: string;
	order: number;
	parentId: number;
	scrollX: number;
	scrollY: number;
}

export type Troop = {
	id: number;
	members: {Member};
	name: string;
	pages: {TroopPage};
}


--[[=======================
------- System Data -------
=======================]]--

export type System = {
	advanced: Advanced;
	airship: Vehicle;
	armorTypes: {string};
	attackMotions: {AttackMotion};
	battleBgm: Audio;
	battleback1Name: string;
	battleback2Name: string;
	battlerHue: number;
	battlerName: string;
	battleSystem: number;
	boat: Vehicle;
	currencyUnit: string;
	defeatMe: Audio;
	editMapId: number;
	elements: {string};
	equipTypes: {string};
	gameTitle: string;
	gameoverMe: Audio;
	itemCategories: {boolean};
	locale: string;
	magicSkills: {number};
	menuCommands: {boolean};
	optAutosave: boolean;
	optDisplayTp: boolean;
	optDrawTitle: boolean;
	optExtraExp: boolean;
	optFloorDeath: boolean;
	optFollowers: boolean;
	optKeyItemsNumber: boolean;
	optSideView: boolean;
	optSlipDeath: boolean;
	optTransparent: boolean;
	partyMembers: {number};
	ship: Vehicle;
	skillTypes: {string};
	sounds: {Audio};
	startMapId: number;
	startX: number;
	startY: number;
	switches: {string};
	terms: Terms;
	testBattlers: {TestBattler};
	testTroopId: number;
	tileSize: number?;
	title1Name: string;
	title2Name: string;
	titleBgm: Audio;
	titleCommandWindow: CommandWindow;
	variables: {string};
	versionId: number;
	victoryMe: Audio;
	weaponTypes: {string};
	windowTone: {number};
	optSplashScreen: boolean;
	hasEncryptedImages: boolean;
	hasEncryptedAudio: boolean;
	encryptionKey: string;
	optMessageSkip: boolean;
}

export type Advanced = {
	gameId: number;
	screenWidth: number;
	screenHeight: number;
	uiAreaWidth: number;
	uiAreaHeight: number;
	numberFontFilename: string;
	fallbackFonts: string;
	fontSize: number;
	mainFontFilename: string;
	windowOpacity: number;
	screenScale: number;
}

export type Vehicle = {
	bgm: Audio;
	characterIndex: number;
	characterName: string;
	startMapId: number;
	startX: number;
	startY: number;
}

export type AttackMotion = {
	type: number;
	weaponImageId: number;
}

export type Terms = {
	basic: {string};
	commands: {string?};
	params: {string};
	messages: Messages;
}

export type TestBattler = {
	actorId: number;
	level: number;
	equips: {number};
}

export type CommandWindow = {
	offsetX: number;
	offsetY: number;
	background: number;
}

export type Messages = {
	alwaysDash: string;
	commandRemember: string;
	touchUI: string;
	bgmVolume: string;
	bgsVolume: string;
	meVolume: string;
	seVolume: string;
	possession: string;
	expTotal: string;
	expNext: string;
	saveMessage: string;
	loadMessage: string;
	file: string;
	autosave: string;
	partyName: string;
	emerge: string;
	preemptive: string;
	surprise: string;
	escapeStart: string;
	escapeFailure: string;
	victory: string;
	defeat: string;
	obtainExp: string;
	obtainGold: string;
	obtainItem: string;
	levelUp: string;
	obtainSkill: string;
	useItem: string;
	criticalToEnemy: string;
	criticalToActor: string;
	actorDamage: string;
	actorRecovery: string;
	actorGain: string;
	actorLoss: string;
	actorDrain: string;
	actorNoDamage: string;
	actorNoHit: string;
	enemyDamage: string;
	enemyRecovery: string;
	enemyGain: string;
	enemyLoss: string;
	enemyDrain: string;
	enemyNoDamage: string;
	enemyNoHit: string;
	evasion: string;
	magicEvasion: string;
	magicReflection: string;
	counterAttack: string;
	substitute: string;
	buffAdd: string;
	debuffAdd: string;
	buffRemove: string;
	actionFailure: string;
}


--[[=======================
-------- Sub Types --------
=======================]]--

export type Trait = {
	code: number;
	dataId: number;
	value: number;
}

export type Learning = {
	level: number;
	note: string;
	skillId: number;
}

export type Action = {
	conditionParam1: number;
	conditionParam2: number;
	conditionType: number;
	rating: number;
	skillId: number;
}

export type DropItem = {
	dataId: number;
	denominator: number;
	kind: number;
}

export type EventPage = {
	conditions: EventConditions;
	directionFix: boolean;
	image: Image;
	list: {EventCommand};
	moveFrequency: number;
	moveRoute: MoveRoute;
	moveSpeed: number;
	moveType: number;
	priorityType: number;
	stepAnime: boolean;
	through: boolean;
	trigger: number;
	walkAnime: boolean;
}

export type EventConditions = {
	actorId: number;
	actorValid: number;
	itemId: number;
	itemValid: number;
	selfSwitchCh: string;
	selfSwitchValid: boolean;
	switch1Id: number;
	switch1Valid: boolean;
	switch2Id: number;
	switch2Valid: boolean;
	variableId: number;
	variableValid: boolean;
	variableValue: number;
}

export type EventCommand = {
	code: number;
	indent: number;
	parameters: {any};
}

export type MoveRoute = {
	list: {MoveRouteCommand};
	['repeat']: boolean;
	skippable: boolean;
	wait: boolean;
}

export type MoveRouteCommand = {
	code: number;
	indent: number?;
	parameters: {any};
}

export type Damage = {
	critical: boolean;
	elementId: number;
	formula: string;
	type: number;
	variance: number;
}

export type Effect = {
	code: number;
	dataId: number;
	value1: number;
	value2: number;
}

export type Audio = {
	name: string?;
	volume: number;
	pitch: number;
	pan: number?;
	pos: number?;
}

export type Encounter = {
	weight: number;
	troopId: number;
	regionSet: {number};
}

export type FlashTiming = {
	frame: number;
	duration: number;
	color: {number};
}

export type SoundTiming = {
	frame: number;
	se: Audio;
}

export type Member = {
	enemyId: number;
	x: number;
	y: number;
	hidden: boolean;
}

export type TroopConditions = {
	actorHp: number;
	actorId: number;
	actorValid: boolean;
	enemyHp: number;
	enemyIndex: number;
	enemyValid: boolean;
	switchId: number;
	switchValid: boolean;
	turnA: number;
	turnB: number;
	turnEnding: boolean;
	turnValid: boolean;
}

export type TroopPage = {
	conditions: TroopConditions;
	list: {EventCommand};
	span: number;
}


return RMMZ