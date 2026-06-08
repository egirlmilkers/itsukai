local GameObject = require('../engine/GameObject')

local C = require('../types/core')

type Stage = C.Stage


local Stage = setmetatable({}, GameObject)

Stage.__index = Stage
Stage.Super = GameObject

Stage.ClassName = 'Stage'

function Stage.new(): Stage
	local gameObject = GameObject.new()
	local self = setmetatable(gameObject, Stage)
	return self
end

--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

function Stage.Destroy(self: Stage)
	GameObject.Destroy(self, true)
end


return Stage