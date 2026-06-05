-- Everything is a table, so this class is a table
local Object = {}
-- All unknown lookups will redirect here
Object.__index = Object

local deepCopy

-- A *property* outside makes it static
-- All *functions* are defined outside
-- Just like ES5
Object.ClassName = "Object"

-- Our constructor.
-- Can technically be named anything, but why not be familiar?
function Object.new()
	-- metatable is basically an object but since everything is a table, the syntax makes sure we don't forget
	-- we create an empty table to combine with Object
	-- when this gets inherited, we will be combining this object with the inherited class
	local self = {}
	
	return setmetatable(self, Object)
end

-- Whether this object is the class or subclass of className
function Object:IsA(className: string): boolean
	local current = self
	while current do
		if current.ClassName == className then
			return true
		end
		-- The derived class is grabbed until there is none, 
		-- in which this will be nil and break from the loop
		current = current.Super
	end
	return false
end

function Object:Clone()
    return deepCopy(self)
end


--[[=======================
---- PRIVATE FUNCTIONS ----
=======================]]--

function deepCopy(original: any): any
    -- If it's a primitive (number, string) or LÖVE userdata (like an Image), 
    -- just return the value directly. We don't deep clone textures.
    if typeof(original) ~= "table" then 
        return original 
    end
    
    local copy = {}
    
    -- Loop through the instance's unique properties
    for k, v in pairs(original) do
        copy[k] = deepCopy(v)
    end
    
    -- Grab the blueprint of the original and attach it to the clone
    local mt = getmetatable(original)
    if mt then
        setmetatable(copy, mt)
    end
    
    return copy
end


-- Return this "class" so this can be assigned to variables in other scripts
return Object