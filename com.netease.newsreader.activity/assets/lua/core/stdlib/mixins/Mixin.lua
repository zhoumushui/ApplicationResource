require "stdlib/class/Class"

Mixin = Class.Class("Mixin",
                    {
                       properties={
                          owner=Class.undefined,
                       },

                       methods={
                          init=function(self, owner)
                             self:setOwner(owner)
                          end                          
                       },

                       statics={
                          methods=function(self)
                             return {}
                          end
                       }
})

function Mixin.prototype:name()
   return "mixin"
end

function Mixin.prototype:tostring()
   local name = self:name()
   return name .. ":" .. table.address(self)
end

