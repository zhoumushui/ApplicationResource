require "colortouch/Node"
require "stdlib/class/Class"

EditText = Class.Class("EditText",
                    {
                       base=Node,
                       properties={
                          text="",
                          hint="",
                          color=Class.undefined,
                          fontSize=14,
                          fontStyle=Class.undefined,
                          lineSpacing=0,
                          maxLength=Class.undefined,
                          hintColor=Class.undefined,
                       
                       }
                    }
)

--@override
function EditText.prototype:createPlatFormView()
   return PlatformEditText(self)
end

function EditText.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
   
   if self._text then
      self:onTextChanged("text", nil, self._text)
   end
   if self._color then
      self:onColorChanged("color", nil, self._color)
   end
   if self._fontSize then
      self:onFontSizeChanged("fontSize", nil, self._fontSize)
   end
   if self._fontStyle then
      self:onFontStyleChanged("fontStyle", nil, self._fontStyle)
   end
   if self._lineSpacing then
      self:onLineSpacingChanged("lineSpacing", nil, self._lineSpacing)
   end

   if self._hint then
      self:onHintChanged("hint", nil, self._hint)
   end

    if self._hintColor then
      self:onHintColorChanged("hintColor", nil, self._hintColor)
   end
    if self._maxLength ~= nil then
      self:onMaxLengthChanged("maxLength", nil, self._maxLength)
   end

   self:initListeners()
end

function EditText.prototype:initListeners()
   --通知到viewcontroller有输入，此时需要更新view controller的位置，避免键盘挡住输入框
   self:addEventListener("beginEdit", 
                         function()
                            print("begin edit")
                            self:getVC():beginEdit(self._pv["handler"])
                         end)
end


function EditText.prototype:onTextChanged(prop, old, new)
   self._pv:setText(new)
   self:setNeedsLayout(true)
end

function EditText.prototype:onColorChanged(prop, old, new)
   self._pv:setColor(new)
end

function EditText.prototype:onFontSizeChanged(prop, old, new)
   self._pv:setFontSize(new)
   self:setNeedsLayout(true)
end

function EditText.prototype:onFontStyleChanged(prop, old, new)
   self._pv:setFontStyle(new)
   self:setNeedsLayout(true)
end

function EditText.prototype:onLineSpacingChanged(prop, old, new)
   self._pv:setLineSpacing(new)
   self:setNeedsLayout(true)
end

function EditText.prototype:onHintChanged(prop, old, new)
   self._pv:setHint(new)
   self:setNeedsLayout(true)
end

function EditText.prototype:getText()
   return self._pv:getText()
end

function EditText.prototype:onHintColorChanged(prop,old,new)
if not platform.isIOS() then
    self._pv:setHintColor(new)
   self:setNeedsLayout(true)
   end
end

function EditText.prototype:onMaxLengthChanged(prop,old,new)
    self._pv:setMaxLength(new)
   self:setNeedsLayout(true)
end
  
