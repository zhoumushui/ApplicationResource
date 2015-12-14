--[[
require "colortouch/Node"
require "stdlib/class/Class"
require "stdlib/mixins/StateProperty"

SegmentButtons = Class.Class("SegmentButtons",
                     {
                        base=Node,
                        properties={
                           buttonCount = Class.undefined,
                           texts = Class.undefined,
                           clickFunctions = Class.undefined,

                           buttonDownIndex = 1
                           buttonDownColor = Class.undefined,
                           buttonUpColor = Class.undefined,
                           activeColor = Class.undefined,
                           
                           --state 是一个只读属性
                           --state = Class.undefined,
                           --states = Class.undefined,
                           enabled = Class.undefined,

                           fontSize=Class.undefined,
                           fontStyle=Class.undefined,

                           backgroundImage = Class.undefined,
                           backgroundEdgeInset = Class.undefined,
                        },
                        
                        mixins={
                           stateproperty=StateProperty
                        }
                     }
)

--@override
function SegmentButtons.prototype:init(inlineprops, ...)
   if type(self._buttonCount) ~= "number" or self._buttonCount
      error("buttons count invalid")
   end
   if not self._texts or #(self._texts) ~= self._buttonCount then
      error("buttons texts invalid")
   end
   if not self._buttonDownIndex then self._buttonDownIndex = 1 end
   if self._buttonDownIndex < 1 or self._buttonDownIndex > self._buttonCount then
      error("buttonDownIndex invalid")
   end

   local defaultButtonDownColor = rgba{192,217,217,1}
   local defaultButtonUpColor = rgba{109,109,109,1}
   if not self._buttonDownColor then
      self._buttonDownColor = defaultButtonDownColor
   end
   if not self._buttonUpColor then
      self._buttonUpColor = defaultButtonUpColor
   end


end

]]