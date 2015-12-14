--大部分情况下，用户只需要关心text属性，其他属性各个平台都有默认的值

IToast = Class.Class("IToast",
                     {
                        base=Node,
                        text=Class.undefined,
                        position = Class.undefined,
                        duration = 2,
})

function IToast.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)

   if self._text then
      self:onTextChanged("text", nil, self._text)
   end

   if self._position then
      self:onPositionChanged("position", nil, self._position)
   end

   if self._duration ~= nil then
      self:onDurationChanged("duration", nil, self._duration)
   end
end

--@override
function IToast.prototype:createPlatFormView()
   return PlatformIToast(self)
end

function IToast.prototype:show()
   self._pv:show()
end


function IToast.prototype:onTextChanged(prop, old, new)
   self._pv:setText(new)
end

function IToast.prototype:onPositionChanged(prop, old, new)
   if new and type(new) == "table" and new.x ~= nil and new.y ~= nil then
      self._pv:setPosition(new.x, new.y)
   else
      self._pv:setPosition(0, 0)
   end
end

function IToast.prototype:onDurationChanged(prop, old, new)
   self._pv:setDuration(new)
end
