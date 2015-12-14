module("TitleCell", package.seeall)

require("Globals")

local cellHeight, cellWidth = 44, Globals.cellWidth

local titleTop, titleWidth= 14, 200

local TitleCell = Class.Class("TitleCell",
                                 {
                                    base = Container,
                                    properties = {
                                       width=cellWidth, height=cellHeight,

                                       data = Class.undefined,
                                       titleView = Class.undefined,
                                    }
})

function TitleCell.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:setBackgroundColor(Globals.getBackgroundColor())

   self:initSubviews()
   self:onDataChanged()
end

function TitleCell.prototype:initSubviews()
   self:addClickBtn()

   local rightArrow = ImageView{
      left=Globals.cellWidth - Globals.rightArrowRight - Globals.arrowWidth,
      top=Globals.rightArrowTop,
      width=Globals.arrowWidth,
      height=Globals.arrowHeight,
      src=Globals.getImageArrowImg()
   }
   self:addChild(rightArrow)

   --title
   local title = Label{
      left=Globals.cellTitleLeftMargin,top=15,
      fontSize=Globals.cellTitleFontSize,
      color=Globals.getTitleFontColor(),
      text=""
   }
   self:addChild(title)
   self._titleView = title
end

function TitleCell.prototype:addClickBtn()
   local btn = Button{
      left=0,top=0,width="100%",height="100%",
      backgroundColor=rgba{0,0,0,0}
   }

   Globals.applyBtnHilightStyle(btn)

   self:addChild(btn)

   btn:addEventListener("click",
                        function()
                           self:onButtonClicked()
   end)
end

function TitleCell.prototype:onDataChanged(prop, old, new)
   if self._data then
      self._titleView:setText(self._data.title)
   else
      self._titleView:setText("")
   end
end

function TitleCell.prototype:onButtonClicked()
   if self._data then
      getApplication():openUrl(self._data.url)
   end
end

TitleCell.cellWidth = cellWidth
TitleCell.cellHeight= cellHeight

return TitleCell
