--[[
/**
   @section{概述}
   标签控件。
   
   ---------------------------------------------------------------

   @iclass[Label Node]{
      用于显示文本信息的控件
      其余所有控件共有的属性和方法，详见Node类定义
   }

   @property[text]{
     @class[Label]

     设置控件的文本内容
   }

   @property[color]{
     @class[Label]

     设置控件的文本颜色
   }

   @property[fontSize]{
     @class[Label]

     设置控件的文本字体大小
   }

   @property[fontStyle]{
     @class[Label]

     设置控件的文本字体类型
   }

   @property[lineSpacing]{
     @class[Label]

     设置多行文本的行间距
   }

   @property[maxLines]{
     @class[Label]

     设置label允许显示的文本行数
   }

   @property[gravity]{
     @class[ImageView]

     设置本文在控件中的对齐方式
     可选参数为：
     left：文本左对齐
     right：文本右对齐
     center：文本居中对齐
   }
*/
]]

require "colortouch/Node"
require "stdlib/class/Class"

Label = Class.Class("Label",
                    {
                       base=Node,
                       properties={
                          text="",
                          color=Class.undefined,
                          fontSize=14,
                          fontStyle=Class.undefined,
                          lineSpacing=0,
                  	       maxLines=0,
                           gravity=Class.undefined,
                       }
                    }
)

--@override
function Label.prototype:createPlatFormView()
   return PlatformLabel(self)
end

function Label.prototype:init(inlineprops, ...)
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
   if self._lineSpacingChanged then
      self:onLineSpacingChanged("lineSpacing", nil, self._lineSpacing)
   end
 
   if self._maxLines then
      self:onMaxLinesChanged("maxLines", nil, self._maxLines)
   end

      if self._gravity then
      self:onGravityChanged("gravity", nil, self._gravity)
   end


end


function Label.prototype:onTextChanged(prop, old, new)
   self._pv:setText(new)
   self:setNeedsLayout(true)
end

function Label.prototype:onColorChanged(prop, old, new)
   self._pv:setColor(new)
end

function Label.prototype:onFontSizeChanged(prop, old, new)
   self._pv:setFontSize(new)
   self:setNeedsLayout(true)
end

function Label.prototype:onFontStyleChanged(prop, old, new)
   self._pv:setFontStyle(new)
   self:setNeedsLayout(true)
end

function Label.prototype:onLineSpacingChanged(prop, old, new)
   self._pv:setLineSpacing(new)
   self:setNeedsLayout(true)
end

function Label.prototype:onMaxLinesChanged(prop,old,new)
   self._pv:setMaxLines(new)
   self:setNeedsLayout(true)
end

function Label.prototype:onGravityChanged(prop,old,new)
  self._pv:setGravity(new)
end
