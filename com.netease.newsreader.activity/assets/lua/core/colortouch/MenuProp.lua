require "stdlib/class/Class"

module("MenuProp", package.seeall)

local getRootByNode = function(n)
   log("%s", n)
   local parent = n
   while parent and parent:getParent() do
      parent = parent:getParent()
   end
   return parent
end

isRootCopy = function(node)
	local root = getRootByNode(node)
	local menuactions = node:getProperty("menuactions")	
	if menuactions == nil then
		return false
	end
	if menuactions.copy ~= nil then
		return true
	end
   
	return false
end

getRootCopyContent = function(node)
	local root = getRootByNode(node)
	local menuactions = node:getProperty("menuactions")	
	if menuactions == nil then
		return nil
	end
	local val = menuactions.copy
	if type(val) == "string" then
		return val
	elseif type(val) == "table" and val.isKindOf and val:isKindOf(EventProp.Property) then
		local val = EventProp.getPropertyVal(node,val)
		return  tostring(val)
	elseif type(val) == "function" then
     return tostring(val())
	else 
		return ""
	end
end

