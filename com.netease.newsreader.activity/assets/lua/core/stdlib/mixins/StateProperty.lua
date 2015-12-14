require "stdlib.mixins.Mixin"

StateProperty = Class.Class("StateProperty",
                            {
                               base=Mixin,
                               properties={
                                  statePropertyName = Class.undefined
                               }
                            }
)

function StateProperty.prototype:init(owner)
   Mixin.prototype.init(self, owner)
end

function StateProperty.prototype:onStatePropertyNameChanged(prop, old, new)
   local owner = self:getOwner()
   if owner == nil then
      return
   end
--[[
   print(string.format("%s on state property name changed, old:%s, new:%s",
                       self, tostring(old), tostring(new)))
]]
   if old then
      owner:un(old, self.onStateChanged, self)
   end

   if new then
      owner:on(new, self.onStateChanged, self)
   end
end

function StateProperty.prototype:onStateChanged(_, prop, old, new)
   --print("state changed, assign properties")
   local owner = self:getOwner()
   if owner == nil then
      return
   end

   local states = owner:getStates()
   if states == nil then
      return
   end
   
   local props = states[new]
   if props == nil then
      return
   end

--   print(table.tostring(props))
   for k, v in pairs(props) do
      owner:setProperty(k, v)
   end
end
