local Graphics = require("./core/Graphics")
local Util = require('core/Util')
local AudioManager = require('managers/AudioManager')


function love.load(arg)
	-- This will run once when the game loads
	for i = 1, #arg do
		local v = arg[i]
		
		-- Check if the argument starts with '--'
		if v:sub(1, 2) == "--" then
			local key = v:sub(3) -- Strip the '--'
			
			-- Look ahead to see if the next argument is a value or another flag
			local nextVal = arg[i + 1]
			if nextVal and nextVal:sub(1, 2) ~= "--" then
				Util.Flags[key] = nextVal
			else
				Util.Flags[key] = true -- Treat it as a boolean flag
			end
		end
	end
end

function love.update(dt)
	-- This will run every frame
	Graphics:Update(dt)
	AudioManager.Update(dt)
end

function love.draw()
	-- This will run every time a new frame will be drawn
end