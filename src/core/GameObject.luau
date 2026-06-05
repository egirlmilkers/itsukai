-- without the return statement, we wouldn't be able to declare this variable
local Object = require('Object')

-- Remember: Everything is a table
-- Exactly like before except we combine the derived class with our starter table
local GameObject = setmetatable({}, Object)
-- Then everything builds off of that
-- Same how object builds off an empty table
GameObject.__index = GameObject
GameObject.Super = Object

-- Because of the index combination, we don't need to rewrite :IsA() if we aren't going to change it
-- We have to change this though:
GameObject.ClassName = 'GameObject' -- <= now GameObject to reflect this separate class

function GameObject.new()
	-- create the parent class
	local object = Object.new()
	-- now we combine
	local self = setmetatable(object, GameObject)

	return self
end

-- why did the metatables parameters swap?
-- Think of it like this:
-- > For the index, we are looking.
--      So, GameObject (first param) will look in Object (second param) when it can't find in itself
-- > For the creation of the object, we are creating a new object from a table.
--      So, we want Object (first param) to look in GameObject (second param) for what new changes to make

return GameObject