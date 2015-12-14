require "colortouch/Node"
require "stdlib/class/Class"
require "stdlib/mixins/StateProperty"


--[[
/**
  @section{Button控件概述}
  可点击并为"click"事件注册相应回调的按钮控件

  ---------------------------------------------------------------

  @iclass[Button Node]{
    可点击并为"click"事件注册相应回调的按钮控件
  }

  @property[text]{
    @class[Button]

    按钮上设置的文本内容
  }

  @property[color]{
    @class[Button]

    按钮的整体颜色属性，参数为rgba类型
  }

  @property[activeColor]{
    @class[Button]

    按钮启用（即可点击）状态下的颜色属性，参数为rgba类型
  }

  @property[state]{
    @class[Button]

    设置按钮的状态，支持的参数有 "normal" "hilighted" "enabled" "disabled"等
  }

  @property[enabled]{
    @class[Button]

    设置按钮是否起效，设为false不会相应click事件
  }

  @property[fontSize]{
    @class[Button]

    设置text对应文字的字体大小
  }

  @property[fontStyle]{
    @class[Button]

    设置text对应文字的样式，如"bold"代表加粗
  }

  @property[backgroundImage]{
      @class[Container]

      设置背景图片资源路径
   }

  @property[backgroundEdgeInset]{
      @class[Container]

      对backgroundImage设置edgeInset属性，
      edgeInset这个参数的格式是(top,left,bottom,right)，从上、左、下、右分别在图片上画了一道线，这样就给一个图片加了一个框
      只有在框里面的部分才会被拉伸，而框外面的部分则不会改变
   }
*/
]]

Button = Class.Class("Button",
                     {
                        base=Node,
                        properties={
                           text="",
                           color=Class.undefined,
                           activeColor = Class.undefined,
                           --state 是一个只读属性
                           state=Class.undefined,
                           states = Class.undefined,
                           enabled = Class.undefined,

                           fontSize=Class.undefined,
                           fontStyle=Class.undefined,

                           backgroundImage = Class.undefined,
                           backgroundEdgeInset = Class.undefined,

                           hilightedBackgroundImage = Class.undefined,
                           hilightedBackgroundImageEdgeInset = Class.undefined,
                        },
                        
                        mixins={
                           stateproperty=StateProperty
                        }
                     }
)

--@override
function Button.prototype:init(inlineprops, ...)
   local bEnabled = inlineprops["enabled"]
   inlineprops["enabled"] = nil

   Node.prototype.init(self, inlineprops, ...)

   if self["_text"] then
      self:onTextChanged("text", nil, self["_text"])
   end
   if self["_color"] then
      self:onColorChanged("color", nil, self["_color"])
   end
   if self["_activeColor"] then
      self:onActiveColorChanged("activeColor", nil, self["_activeColor"])
   end
   if self["_enabled"] ~= nil then
      self:onEnabledChanged("enabled", nil, self["_enabled"])
   end
   if self["_backgroundImage"] then
      self:onBackgroundImageChanged("backgroundImage", nil, self["_backgroundImage"])
   end
   if self["_backgroundEdgeInset"] then
      self:onBackgroundEdgeInsetChanged("backgroundEdgeInset", nil, self["_backgroundEdgeInset"])
   end

   if self["_hilightedBackgroundImage"] then
      self:onHilightedBackgroundImageChanged("hilightedBackgroundImage", nil,
                                             self["_hilightedBackgroundImage"])
   end

   if self["_hilightedBackgroundImageInset"] then
      self:onHilightedBackgroundImageInsetChanged("hilightedBackgroundImageInset",nil,
                                                  self["_hilightedBackgroundImageInset"])
   end

   if self["_fontSize"] ~= nil then
      self:onFontSizeChanged("fontSize", nil, self["_fontSize"])
   end
   if self["_fontStyle"] ~= nil then
      self:onFontStyleChanged("fontStyle", nil, self["_fontStyle"])
   end
   
   self:addEventListener("normal",
                         function(evt)
                            self:setState("normal")
                         end)

   
   self:addEventListener("hilighted",
                         function(evt)
                            self:setState("hilighted")
   end)
   self:addEventListener("enabled",
                         function(evt)
                            self:setState("enabled")
   end)

   self:addEventListener("disabled",
                         function(evt)
                            --print("button state is disabled")
                            self:setState("disabled")
   end)
   
   self:addEventListener("click",
                         function(evt)
                            --print("_______________________")
                            --print("click event")
                            self:fireEvent("click", evt)
   end)

   self.mixins.stateproperty:setStatePropertyName("onStateChanged")
   if bEnabled ~= nil then
      self:setEnabled(bEnabled)
   else
      self:setEnabled(true)
   end

   if self:getEnabled() ~= false then
      self:setState("normal")
   end
end

--@override
function Button.prototype:createPlatFormView()
   return PlatformButton(self)
end

function Button.prototype:onEnabledChanged(prop, old, new)
   --print("button set enabled" .. tostring(new))
   self._pv:setEnable(new)
end

function Button.prototype:onTextChanged(prop, old, new)
   self._pv:setText(new)

   self:setNeedsLayout(true)
end

function Button.prototype:onFontSizeChanged(prop, old, new)
   self._pv:setFontSize(new)
   self:setNeedsLayout(true)
end

function Button.prototype:onFontStyleChanged(prop, old, new)
   self._pv:setFontStyle(new)
   self:setNeedsLayout(true)
end

function Button.prototype:onColorChanged(prop, old, new)
   --print("button on colorchanged")
   --print(new)
   self._pv:setColor(new)
end

function Button.prototype:onActiveColorChanged(prop, old, new)
   self._pv:setActiveColor(new)
end

function Button.prototype:onBackgroundImageChanged(prop, old, new)
   self._pv:setBackgroundImage(new)

   local inset = self:getBackgroundEdgeInset()
   if inset then
      self._pv:setBackgroundImageEdgeInset(inset)
   end
end

function Button.prototype:onBackgroundEdgeInsetChanged(prop, old, new)
   if new == nil then
      new = edgeInset(0,0,0,0)
   end

   self._pv:setBackgroundImageEdgeInset(new)
end


function Button.prototype:onHilightedBackgroundImageChanged(prop, old, new)
   self._pv:setHilightedBackgroundImage(new)
end




--------------------一些组合出来的button-------------------------
ImageButton = Class.Class("ImageButton",
                          {
                             base=Container,

                             properties={
                                btn = Class.undefined,
                                img = Class.undefined,

                                src = Class.undefined,
                             }
})

function ImageButton.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)

   local img = ImageView{
--      borderWidth=1,borderColor=rgba{255,255,0,1},
   }

   local btn = Button{
      left=0,top=0,width="100%",height="100%",
      id=inlineprops.buttonid,
--      borderWidth=1,borderColor=rgba{255,0,255,1},
   }

   self:setLayout("flex")
   self:setAlign(Center)
   self:setPack(Center)

   self._btn = btn
   self._img = img

   if self._src ~= nil then
      img:setSrc(self._src)
   end

   self:setItems({img, btn})
end

function ImageButton.prototype:onSrcChanged(prop, old, new)
   self._img:setSrc(new)
end

function ImageButton.prototype:addEventListener(evtName, cb)
   if evtName == "click" then
      self:getBtn():addEventListener(evtName, cb)
   else
      Node.addEventListener(self, evtName, cb)
   end
end