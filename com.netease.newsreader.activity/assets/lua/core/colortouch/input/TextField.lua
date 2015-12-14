TextField = Class.Class("TextField",
                    {
                       base=EditText,
                       
                       properties={
                       secureTextEntry = Class.undefined,
                       maxLength=Class.undefined,
                       }
                    }
)

--@override
function TextField.prototype:createPlatFormView()
   return PlatformTextField(self)
end

function TextField.prototype:init(inlineprops, ...)
   EditText.prototype.init(self, inlineprops, ...)
   
   if self._secureTextEntry ~= nil then
      self:onSecureTextEntryChanged("secureTextEntry", nil, self._secureTextEntry)
   end
   
   if self._maxLength ~= nil then
      self:onMaxLengthChanged("maxLength", nil, self._maxLength)
   end
end

function TextField.prototype:onSecureTextEntryChanged(p, old, new)
   self._pv:setSecureTextEntry(new)
end

function TextField.prototype:onMaxLengthChanged(prop,old,new)
   self._pv:setMaxLength(new)
   self:setNeedsLayout(true)
end

function TextField.prototype:endEditing(b)
  self._pv:endEditing(b)
end

function TextField.prototype:showClearButton()
  self._pv:showClearButton()
end

function TextField.prototype:beginEditing()
  self._pv:beginEditing()
end