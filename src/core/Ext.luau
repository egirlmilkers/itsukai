local Ext = {}


function Ext.PadZeroes(num: number, padAmount: number): string
	return string.format(`%0{padAmount}d`, num)
end

function Ext.DefineProperty(obj: any, prop: string, descriptor: { get: ((any) -> any)?, set: ((any, any) -> ())? })
	local mt = getmetatable(obj)
	if not mt then
		mt = {}
		setmetatable(obj, mt)
	end
	
	-- Initialize a hidden registry for properties on this metatable
	if not mt.__props then
		mt.__props = {}
	end
	
	-- Save this property's getter/setter
	mt.__props[prop] = descriptor
	
	-- Track original fallbacks if they already exist (like for class methods)
	local originalIndex = mt.__index
	local originalNewIndex = mt.__newindex

	-- Setup __index ONLY once
	if originalIndex ~= mt.__index_wrapper then
		mt.__index_wrapper = function(self, key)
			local desc = mt.__props[key]
			if desc and desc.get then
				return desc.get(self) -- Trigger getter
			end
			
			-- Fallback to original behavior if it's not a defined property
			if type(originalIndex) == "function" then return originalIndex(self, key)
			elseif type(originalIndex) == "table" then return originalIndex[key]
			end
			return nil
		end
		mt.__index = mt.__index_wrapper
	end

	-- Setup __newindex ONLY once
	if originalNewIndex ~= mt.__newindex_wrapper then
		mt.__newindex_wrapper = function(self, key, value)
			local desc = mt.__props[key]
			if desc and desc.set then
				desc.set(self, value) -- Trigger setter
				return
			end
			
			-- Fallback to original behavior
			if type(originalNewIndex) == "function" then originalNewIndex(self, key, value)
			elseif type(originalNewIndex) == "table" then originalNewIndex[key] = value
			else rawset(self, key, value)
			end
		end
		mt.__newindex = mt.__newindex_wrapper
	end
end

function Ext.Filter<T>(array: {T}, predicate: (value: T) -> boolean)
	local writeIndex = 1

	-- shift passing elements forward
	for readIndex = 1, #array do
		local value = array[readIndex]
		if predicate(value) then
			array[writeIndex] = value
			writeIndex += 1
		end
	end

	-- clear out the leftover trailing elements
	for i = writeIndex, #array do
		array[i] = nil
	end
end


return Ext