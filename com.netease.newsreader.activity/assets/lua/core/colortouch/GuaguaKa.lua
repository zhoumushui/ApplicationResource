require "stdlib/class/Class"

GuaguaKa = Class.Class("GuaguaKa",
                     {
                        base=Node,
                        properties={
                          
                          maskImage = Class.undefined,
                          maskColor = Class.undefined,
                           
                        }
})

function GuaguaKa.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
    if self["_maskImage"] then
      --self:onMaskImageChanged("maskImage", nil, self["_maskImage"])
   end
   --[[
    if self["_maskColor"] then
      self:onMaskColorChanged("maskColor", nil, self["_maskColor"])
   end
]]
 --  self:initEvents()
 
   self:on("layoutComplete",
            function()
               if self._maskImage then
                  self._pv:setMaskImage(self._maskImage)
               end
            end)
end

--@override
function GuaguaKa.prototype:createPlatFormView()
   return PlatformGuaguaKa(self)
end


function GuaguaKa.prototype:onMaskImageChanged(prop, old, new)
   self._pv:setMaskImage(new)
end


--[[
function GuaguaKa.prototype:onMaskColorChanged(prop, old, new)
   self._pv:setMaskColor(new)
end
]]