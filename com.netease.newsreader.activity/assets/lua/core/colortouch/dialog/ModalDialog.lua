require "stdlib/class/Class"

ModalDialog = Class.Class("ModalDialog",
                          {
                             base=Container,
                             bgAlpha = Class.undefined,
})

function ModalDialog.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)

   local preSize = self:getPreferredSize({width=0,height=0})
   self._width = preSize.width
   self._height = preSize.height

   if self._bgAlpha ~= nil then
      self:onBgAlphaChanged("bgAlpha", nil, self._bgAlpha)
   end
end

function ModalDialog.prototype:show()
   self._pv:show()
end

function ModalDialog.prototype:dismiss()
   self._pv:dismiss()
end

function ModalDialog.prototype:onBgAlphaChanged(prop, old, new)
   self._pv:setBgAlpha(new)
end

function ModalDialog.prototype:setWidth(prop, old, new)
end

function ModalDialog.prototype:setHeight(prop, old, new)
end

function ModalDialog.prototype:setLeft(prop, old, new)
end

function ModalDialog.prototype:setTop(prop, old, new)
end

function ModalDialog.prototype:getPreferredSize(size)
   if self.__preferSize == nil then
      self.__preferSize = self:preferredSize(size)
   end

   return self.__preferSize
end

function ModalDialog.prototype:getWidth(prop, old, new)
   return self:getPreferredSize({width=0,height=0}).width
end

function ModalDialog.prototype:getHeight(prop, old, new)
   return self:getPreferredSize({width=0,height=0}).height
end

function ModalDialog.prototype:getLeft(prop, old, new)
   return 0
end

function ModalDialog.prototype:getTop(prop, old, new)
   return 0
end

--@override
function ModalDialog.prototype:createPlatFormView()
   return PlatformModalDialog(self)
end
if not platform.isIOS() then
function ModalDialog.prototype:removeFromParent()
   self._pv:removeFromParent()
  --["removeFromParent.(Landroid/view/View;)V"](ViewOwner['View'],self['handler'])
end
end
