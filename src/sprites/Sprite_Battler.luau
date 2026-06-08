local GameObject = require('../engine/GameObject')

local Sprite_Battler = setmetatable({}, GameObject)

Sprite_Battler.__index = Sprite_Battler
Sprite_Battler.Super = GameObject


Sprite_Battler.ClassName = 'Sprite_Battler'

function Sprite_Battler.new()
	local gameObject = GameObject.new()
	local self = setmetatable(gameObject, Sprite_Battler)
	return self
end


return Sprite_Battler