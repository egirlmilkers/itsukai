local JSON = require("../lib/json")

local JsonSerializer = {}

local registry: { [string]: any } = {}
local encode
local decode


function JsonSerializer.Register(class: any)
	assert(class.ClassName, "Class must have a ClassName field to be registered")
	registry[class.ClassName] = class
end

function JsonSerializer.Stringify(value: any): any
	-- Prepare the table safely, THEN stringify the entire thing at once
	local safeTable = encode(value)
	return JSON.encode(safeTable)
end

function JsonSerializer.Parse(jsonString: string): any
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
			warn("Unregistered class found in JSON: " .. tostring(className))
		end
	end

	return value
end

JsonSerializer.Register(require("Object"))
JsonSerializer.Register(require("GameObject"))

return JsonSerializer