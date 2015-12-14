module("PlaceHolderLoadingView", package.seeall)
require "stdlib/class/Class"

if platform.isIOS() then
   require "ios/view/PlatformNTESPlaceHolderLoadingView"
else
   require "android/view/PlatformNTESPlaceHolderLoadingView"

end

local PlaceHolderLoadingView = Class.Class("PlaceHolderLoadingView",
                        {
                           base=Node,

                           properties={
                              state = Class.undefined,
                              type=Class.undefined,
                              textColor=Class.undefined,
                              text = Class.undefined,
                              nightMode = Class.undefined,
                           }
                        }
)


function PlaceHolderLoadingView.prototype:createPlatFormView()
   return PlatformNTESPlaceHolderLoadingView(self)
end

function PlaceHolderLoadingView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
   
   if self._state ~= nil then
      self:onStateChanged("state", nil, self._state)
   end

   if self._textColor ~= nil then
      self:onTextColorChanged("textColor", nil, self._textColor)
   end

   if self._type ~= nil then
      self:onTypeChanged("type", nil, self._type)
   end
      if self._nightMode ~= nil then
      self:onNightModeChanged("nightMode", nil, self._nightMode)
   end

end

function PlaceHolderLoadingView.prototype:onStateChanged(prop, old, new)
   self._pv:setState(new)
end

function PlaceHolderLoadingView.prototype:onTypeChanged(prop, old, new)
   self._pv:setType(new)
end

function PlaceHolderLoadingView.prototype:onTextChanged(prop, old, new)
   self._pv:setSuggestText(new)
end

function PlaceHolderLoadingView.prototype:onTextColorChanged(prop, old, new)
   self._pv:setTextColor(new)
end

function PlaceHolderLoadingView.prototype:onNightModeChanged(prop, old, new)
   self._pv:setNightMode(new)
end


return PlaceHolderLoadingView
