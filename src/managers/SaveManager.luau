local JSON = require('../lib/json')
local JsonSerializer = require("../core/JsonSerializer")

local SaveManager = {}


function SaveManager.Save(saveName: string, object: any)
	local saveFile = `{saveName}.hozon`
	local jsonStr
	-- a save file uses our custom classes so we use our special encoder
	if saveName:lower():sub(1, 4) == "file" then
		jsonStr = JsonSerializer.Stringify(object)
	-- global and config are basic json files
	-- so save them and any other file as basic json
	else
		jsonStr = JSON.encode(object)
	end

	local success, err = love.filesystem.write(saveFile, jsonStr)
	if not success then
		-- TODO: Ingame popup
		error(`Failed to save {saveFile}!\n Error: {err}`)
	end
end

function SaveManager.Load(saveName: string): any?
	local saveFile = `{saveName}.hozon`

	-- Check if the file even exists in the save directory
	if not love.filesystem.getInfo(saveFile) then
		-- This is totally normal for a new player, just return nil silently
		return nil 
	end

	-- Read the raw text from the drive
	local contents, err = love.filesystem.read(saveFile)
	if not contents then
		warn(`Failed to read {saveFile}!\n Error: {err}`)
		return nil
	end

	-- Route the raw text to the correct parser
	if saveName:lower():sub(1, 4) == "file" then
		return JsonSerializer.Parse(contents) 
	else
		return JSON.decode(contents)
	end
end


return SaveManager