local Ext = {}


function Ext.padZeroes(num: number, padAmount: number): string
	return string.format(`%0{padAmount}d`, num)
end

function Ext.defineProperty(obj: any, prop: string, descriptor: { get: ((any) -> any)?, set: ((any, any) -> ())? })
	if type(obj) ~= "table" then
		error("You can only define properties on Lua tables. Native userdata is locked.", 2)
	end

	-- CLASS PROTOTYPE INJECTION
	-- If 'obj' has an __index field, it's acting as a class prototype.
	if obj.__index ~= nil then
		if not obj.__props then obj.__props = {} end
		obj.__props[prop] = descriptor
		
		local originalIndex = obj.__index
		if obj.__index_wrapper ~= originalIndex then
			obj.__index_wrapper = function(self, key)
				local desc = obj.__props[key]
				if desc and desc.get then return desc.get(self) end
				
				if type(originalIndex) == "function" then return originalIndex(self, key)
				elseif originalIndex ~= nil then return originalIndex[key]
				end
				return nil
			end
			obj.__index = obj.__index_wrapper
		end
		
		local originalNewIndex = obj.__newindex
		if obj.__newindex_wrapper ~= originalNewIndex then
			obj.__newindex_wrapper = function(self, key, value)
				local desc = obj.__props[key]
				if desc and desc.set then 
					desc.set(self, value)
					return
				end
				
				if type(originalNewIndex) == "function" then originalNewIndex(self, key, value)
				elseif originalNewIndex ~= nil then originalNewIndex[key] = value
				else rawset(self, key, value)
				end
			end
			obj.__newindex = obj.__newindex_wrapper
		end
		return
	end

	-- INSTANCE / SINGLETON ISOLATION
	local mt = getmetatable(obj)
	
	if mt and not mt.__is_shadow then
		-- This instance already has a shared class metatable so we wrap it
		-- in a personal shadow metatable to prevent prototype pollution.
		local shadow = { __is_shadow = true, __props = {} }
		
		shadow.__index = function(self, key)
			local desc = shadow.__props[key]
			if desc and desc.get then return desc.get(self) end
			
			local orig_index = mt.__index
			if type(orig_index) == "function" then return orig_index(self, key)
			elseif orig_index ~= nil then return orig_index[key]
			end
			return mt[key]
		end
		
		shadow.__newindex = function(self, key, value)
			local desc = shadow.__props[key]
			if desc and desc.set then 
				desc.set(self, value)
				return
			end
			
			local orig_newindex = mt.__newindex
			if type(orig_newindex) == "function" then orig_newindex(self, key, value)
			elseif orig_newindex ~= nil then orig_newindex[key] = value
			else rawset(self, key, value)
			end
		end
		
		-- Forward standard operator metamethods (__tostring, __add, etc.)
		for k, v in pairs(mt) do
			if type(k) == "string" and k:sub(1,2) == "__" and k ~= "__index" and k ~= "__newindex" then
				shadow[k] = v
			end
		end
		
		setmetatable(obj, shadow)
		mt = shadow

	elseif not mt then
		-- Singleton so just slap a new metatable on it.
		mt = { __is_shadow = true, __props = {} }
		mt.__index = function(self, key)
			local desc = mt.__props[key]
			if desc and desc.get then return desc.get(self) end
			return nil
		end
		mt.__newindex = function(self, key, value)
			local desc = mt.__props[key]
			if desc and desc.set then 
				desc.set(self, value)
				return
			end
			rawset(self, key, value)
		end
		setmetatable(obj, mt)
	end
	
	-- Register the property on our guaranteed-safe wrapper
	mt.__props[prop] = descriptor
end

function Ext.filter<T>(array: {T}, predicate: (value: T) -> boolean)
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