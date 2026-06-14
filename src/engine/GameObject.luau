-- without the return statement, we wouldn't be able to declare this variable
local Object = require('./Object')

local E = require('../types/engine')

type GameObj = E.GameObject


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

function GameObject.new(): GameObj
	-- create the parent class
	local object = Object.new()
	-- now we combine
	local self = setmetatable(object, GameObject)

	-- Scene tree
	self.Children = {}
	self.Parent = nil

	-- Transform (local space, relative to parent)
	self.X = 0
	self.Y = 0
	self.Rotation = 0  -- radians
	self.ScaleX = 1
	self.ScaleY = 1
	self.PivotX = 0  -- rotation/scale origin in local space
	self.PivotY = 0

	-- Display
	self.Visible = true
	self.Alpha = 1  -- multiplied with parent alpha

	self._destroyed = false

	return self
end

-- why did the metatables parameters swap?
-- Think of it like this:
-- > For the index, we are looking.
--      So, GameObject (first param) will look in Object (second param) when it can't find in itself
-- > For the creation of the object, we are creating a new object from a table.
--      So, we want Object (first param) to look in GameObject (second param) for what new changes to make

--[[=======================
----- PUBLIC FUNCTIONS ----
=======================]]--

--- Append child (or move it here if it already has a parent).
--- @return The child so callers can do: `local s = gameObject:AddChild(GameObject.new())`
function GameObject.AddChild(self: GameObj, child: any): any
	assert(child ~= self, 'GameObject cannot be its own child')

	if child.Parent then
		child.Parent:RemoveChild(child)
	end

	table.insert(self.Children, child)
	child.Parent = self

	return child
end

-- Insert child at a specific index and return it.
function GameObject.AddChildAt(self: GameObj, child: any, index: number): any
	assert(child ~= self, 'GameObject cannot be its own child')

	if child.Parent then
		child.Parent:RemoveChild(child)
	end

	table.insert(self.Children, index, child)
	child.Parent = self

	return child
end

--- Removes a specific child by object and returns it.
function GameObject.RemoveChild(self: GameObj, child: any): any
	for i, c in ipairs(self.Children) do
		if c == child then
			table.remove(self.Children, i)
			child.Parent = nil
			return child
		end
	end
	return child
end

--- Removes the child at the given index and returns it.
function GameObject.RemoveChildAt(self: GameObj, index: number): any
	local child = self.Children[index]
	if child then
		table.remove(self.Children, index)
		child.Parent = nil
	end
	return child
end

--- Remove all children.
--- @return The removed children as an array.
function GameObject.RemoveChildren(self: GameObj): {any}
	local removed = self.Children
	for _, child in ipairs(removed) do
		child.Parent = nil
	end
	self.Children = {}
	return removed
end

--- Detaches self from its parent, if any.
function GameObject.RemoveFromParent(self: GameObj)
	if self.Parent then
		self.Parent:RemoveChild(self)
	end
end

--- In Pixi.JS, `UpdateTransform()` walks the scene tree and multiplies matrices.
---
--- In LÖVE we replicate this with `love.graphics.push`/`pop`.
---
--- Override `Draw()` in subclasses to render the object itself (children are
--- drawn automatically after `Draw()` returns).
function GameObject.UpdateTransform(self: GameObj)
	if not self.Visible then return end

	love.graphics.push()

	-- Translate to position, then undo pivot so rotation/scale is pivot-relative
	love.graphics.translate(self.X + self.PivotX, self.Y + self.PivotY)
	love.graphics.rotate(self.Rotation)
	love.graphics.scale(self.ScaleX, self.ScaleY)
	love.graphics.translate(-self.PivotX, -self.PivotY)

	-- Apply alpha (stacks with whatever the parent already set)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(r, g, b, a * self.Alpha)

	-- Draw this object, then its children in order
	self:Draw()

	for _, child in ipairs(self.Children) do
		if child.UpdateTransform then
			child:UpdateTransform()
		end
	end

	-- Restore alpha and transform
	love.graphics.setColor(r, g, b, a)
	love.graphics.pop()
end

function GameObject.Draw(self: GameObj)
	-- Override in subclasses for custom rendering. Transform is already applied.
end

--- Removes itself from its parent (if defined) and prepares self for garbage collection.
--- @param destroyChildren Whether or not all children should also be recursively destroyed.
function GameObject.Destroy(self: GameObj, destroyChildren: boolean)
	if self._destroyed then return end
	self._destroyed = true

	self:RemoveFromParent()

	if destroyChildren then
		-- Iterate a snapshot (children will edit self.Children with RemoveChild)
		local snapshot = { table.unpack(self.Children) }
		for _, child in ipairs(snapshot) do
			if child.Destroy then
				child:Destroy(destroyChildren)
			end
		end
	else
		-- Orphan children without destroying them
		for _, child in ipairs(self.Children) do
			child.Parent = nil
		end
	end

	self.Children = {}
	self.Parent = nil
end


return GameObject