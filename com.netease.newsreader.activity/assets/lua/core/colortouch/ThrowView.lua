ThrowView = Class.Class("ThrowView",
                        {
                           base=Container,
                            properties={
                              cardLeft=Class.undefined,
                              cardTop = Class.undefined,
                              cardWidth = Class.undefined,
                              cardHeight = Class.undefined,
                           }
})

--[[

   支持的事件：
   willThrow 
   throwEnded
]]

--@override
function ThrowView.prototype:createPlatFormView()
   return PlatformThrowView(self)
end

function ThrowView.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)

   if not platform.isIOS() then
      if self["_cardLeft"] then
          self:onCardLeftChanged("cardLeft", nil, self["_cardLeft"])
      end

      if self["_cardTop"] then
          self:onCardTopChanged("cardTop", nil, self["_cardTop"])
      end

      if self["_cardWidth"] then
        print("ThrowView..init ..onCardiwdht")
          self:onCardWidthChanged("cardWidth", nil, self["_cardWidth"])
      end

      if self["_cardHeight"] then
          self:onCardHeightChanged("cardHeight", nil, self["_cardHeight"])
      end
   end
end

if not platform.isIOS() then
  function ThrowView.prototype:onCardLeftChanged(prop, old, new)
        self._pv:setCardLeft(new)
    

  end

  function ThrowView.prototype:onCardTopChanged(prop, old, new)
  self._pv:setCardTop(new)

  end


  function ThrowView.prototype:onCardWidthChanged(prop, old, new)
        print("ThrowView .onCardWidthChanged.."..new)

    self._pv:setCardWidth(new)  

  end

  function ThrowView.prototype:onCardHeightChanged(prop, old, new)
    print("ThrowView .onCardHegithChange.."..new)
  self._pv:setCardHeight(new)    

  end

  function ThrowView.prototype:layoutCard()
    self._pv:layoutCard()
  end

end


function ThrowView.prototype:setBCanDrag(bCanDrag)
    self._pv:setBCanDrag(bCanDrag)
end


-- if not platform.isIOS() then
--   function ThrowView.prototype:setCardLeft(cardLeft)
--     self._pv:setCardLeft(cardLeft)
--   end

--   function ThrowView.prototype:setCardTop(cardTop)
--     self._pv:setCardTop(cardTop)
--     --self._pv:setBCanDrag(bCanDrag)
--   end

--   function ThrowView.prototype:setCardWidth(cardWidth)
--     self._pv:setCardLeft(cardWidth)
--     --self._pv:setBCanDrag(bCanDrag)
--   end

--   function ThrowView.prototype:setCardHeight(cardHeight)
--     self._pv:setCardLeft(cardHeight)
--   end
-- end

