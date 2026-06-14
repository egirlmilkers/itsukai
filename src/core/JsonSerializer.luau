local JSON = require("../lib/json")

local JsonSerializer = {}

local registry: { [string]: any } = {}
local encode
local decode


function JsonSerializer.register(class: any)
	assert(class.ClassName, "Class must have a ClassName field to be registered")
	registry[class.ClassName] = class
end

function JsonSerializer.stringify(value: any): any
	-- Prepare the table safely, THEN stringify the entire thing at once
	local safeTable = encode(value)
	return JSON.encode(safeTable)
end

function JsonSerializer.parse(jsonString: string): any
	-- Parse the string into a raw table, THEN rebuild the metatables
	local rawTable = JSON.decode(jsonString)
	return decode(rawTable)
end


--[[=======================
---- PRIVATE FUNCTIONS ----
=======================]]--

function encode(value: any): any
	if typeof(value) ~= "table" then return value end

	local data = {}
	for k, v in pairs(value) do
		if k ~= "ClassName" and k ~= "Super" then
			data[k] = encode(v) 
		end
	end

	if value.ClassName then
		data.__type = value.ClassName
	end

	return data
end

function decode(value: any): any
	if typeof(value) ~= "table" then return value end

	for k, v in pairs(value) do
		value[k] = decode(v) 
	end

	local className = value.__type
	if className then
		local classBlueprint = registry[className]
		if classBlueprint then
			value.__type = nil
			setmetatable(value, classBlueprint)
		else
			error("Unregistered class found in JSON: " .. tostring(className))
		end
	end

	return value
end

JsonSerializer.register(require("../engine/Object"))
JsonSerializer.register(require("../engine/GameObject"))
JsonSerializer.register(require("../core/LoveAudio"))
JsonSerializer.register(require("../core/Stage"))

return JsonSerializer