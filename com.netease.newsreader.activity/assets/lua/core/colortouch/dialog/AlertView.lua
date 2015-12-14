AlertView = Class.Class("AlertView",
                     {
                        base=Node
})

if platform.isIOS() then
   require "ios.view.PlatformAlertView"
else
end



-- withType:用于支持带输入框的弹框提示，type配置为"withTextEdit"即可启用，且cb将返回idx 和 已输入的字符两个参数；不配置则只返回idx
-- keyboardType: 用于设置键盘类型, nil为默认字符键盘, "numberpad"为数字键盘，暂只支持这两个
-- hint:输入之前的占位提示字符
-- content: 输入之前即已默认带上可编辑的文本
-- textMaxLength:如果withType为"withTextField",则该字段可以指定其可输入的最大字符数
function AlertView.prototype:init(title, message, buttons, cb, withType, keyboardType, hint, content, textMaxLength)
   
   Node.prototype.init(self, {})
   
   self._pv:setTitle(title)
   self._pv:setMessage(message)
   self._pv:setButtons(buttons)

   if withType ~= nil then
      self._pv:setType(withType)
   end
   
   if textMaxLength then
      self._pv:setTextFieldMaxLength(textMaxLength)
   end

   if keyboardType ~= nil and type(keyboardType) == "string" then
      self._pv:setKeyboardType(keyboardType)
   end
   
   if hint ~= nil and type(hint) == "string" then
      self._pv:setHint(hint)      
   end

   if content ~= nil and type(content) == "string" then
      self._pv:setContent(content)
   end

   if cb then
      self:addEventListener("click",
                            function(idx, text)
                               cb(idx, text)
      end)
   end


end

--@override
function AlertView.prototype:createPlatFormView()
   return PlatformAlertView(self)
end

function AlertView.prototype:show()
   self._pv:show()
end

function AlertView.prototype:dismiss(bAnimated)
   self._pv:dismiss(bAnimated and bAnimated or false)
end