module("TemplateCell", package.seeall)
require("Globals")

--整个cell的宽度
local cellWidth = Globals.cellWidth

local firstActivyLeft,firstActivyTop = 10, 0

--在375屏幕下，宽度为175,其他屏幕下等比缩放
local scaleFactor = cellWidth / 375

--不考虑中间的空隙情况下，图片等比缩放的宽度
local activityImgOriginWidth,activityImgOriginHeight = 175, 125

--图片中间的空隙等比缩放。左右空隙不变。剩余空间分给图片
local spacerWidth = 5 * scaleFactor
local activityImgWidth = (cellWidth - spacerWidth - firstActivyLeft * 2)/2

--高度等比缩放
local activityImgHeight = activityImgWidth * activityImgOriginHeight / activityImgOriginWidth

local activitySpace = cellWidth - firstActivyLeft * 2 - activityImgWidth * 2

--图片title的宽高，位置
local titleImgWidth,titleImgHeight=35,35
local titleImgTop=0

--整个cell的高度
-- local cellHeight = activityImgHeight + 65
local cellHeight = activityImgHeight + 14 * scaleFactor + Globals.cellTitleFontSize  + 37

local cellCoinFontSize = 14 * scaleFactor

local cellTitleTop = activityImgHeight + 8

-- local cellCoinTop = activityImgHeight + 26


local cellCoinTop = activityImgHeight + 12 + Globals.cellTitleFontSize


--model
--[[
  {
   image="qiandao.icon",
   url = "http://163.com"
   },
   {
   image="qiandao.icon",
   url = "http://163.com"
   },
]]

local TemplateCell = Class.Class("TemplateCell",
                                 {
                                    base = Container,
                                    properties = {
                                       width=cellWidth,height=cellHeight,
                                       data = Class.undefined,

                                       _leftImgView = Class.undefined,
                                       _leftImgTitleView = Class.undefined,
                                       _leftTitleView = Class.undefined,
                                       _leftCoinView = Class.undefined,

                                       _rightImgView = Class.undefined,
                                       _rightImgTitleView = Class.undefined,

                                       _rightTitleView = Class.undefined,
                                       _rightCoinView = Class.undefined,


                                       _leftBtn = Class.undefined,
                                       _rightBtn = Class.undefined,
                                    }
})

function TemplateCell.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:setBackgroundColor(Globals.getBackgroundColor())
   self:initSubViews()
end

function TemplateCell.prototype:initSubViews()
   --left
   local src = self._data and self._data[1].image or Globals.getDefaultImg()
   local contentMode = src == Globals.getDefaultImg() and "center" or "scaleToFill"
   local leftBgImg = ImageView{
      width=activityImgWidth,height=activityImgHeight,left=firstActivyLeft,top=firstActivyTop,
      src=Globals.getDefaultImg(),
      contentMode = "center",
      backgroundColor=Globals.getImageBackgroundColor()
   }
   self:addChild(leftBgImg)

   local leftImg = ImageView{
      width=activityImgWidth,height=activityImgHeight,left=firstActivyLeft,top=firstActivyTop,
      src=self._data and self._data[1].image or nil,
      contentMode = "scaleToFill",
      backgroundColor=Globals.getImageBackgroundColor(),
      alpha = 0,
   }
   leftImg:setUserInteractionEnabled(false)
   local leftTitleImg = ImageView{
      width=titleImgWidth,height=titleImgHeight,left=leftImg:getLeft()+leftImg:getWidth()-titleImgWidth,top=titleImgTop,
   }
   local leftNightMask = Node{
      left=leftImg:getLeft(), top=leftImg:getTop(), width=leftImg:getWidth(), height=leftImg:getHeight(),
      backgroundColor= Globals.getMaskColor()
   }
   leftNightMask:setUserInteractionEnabled(false)

   local leftBtn = Button{
      width=leftImg._width, height=cellHeight, left=leftImg._left, top=leftImg._top,
      id="leftActivityBtn",
   }
   leftBtn.url = self._data and self._data[1].image or nil
   leftBtn:addEventListener("click",
                            function(evt)
                               return self:openUrl(evt.target.url)
   end)
   Globals.applyBtnHilightStyle(leftBtn)


   local leftTitleView = Label{
         left=firstActivyLeft,
         top =cellTitleTop,
         fontSize = Globals.cellTitleFontSize,
         color = Globals.getTitleFontColor(),
         maxLines =1,
         maxWidth = activityImgWidth,
   }
   local leftCoinView = Label{
         left=firstActivyLeft,
         top =cellCoinTop,
         fontSize = cellCoinFontSize,
         color = Globals.getGoldRedColor(),
         maxLines =1,
         maxWidth = activityImgWidth,

   }
   self._leftTitleView = leftTitleView
   self._leftCoinView = leftCoinView


   self._leftImgView = leftImg
   self._leftBtn = leftBtn
   self._leftImgTitleView = leftTitleImg


   self:addChild(leftBtn)   
   self:addChild(leftImg)
   self:addChild(leftTitleImg)
   self:addChild(leftNightMask)
   self:addChild(leftTitleView)
   self:addChild(leftCoinView)

   --right
   local rightBgImg = ImageView{
      width=activityImgWidth,height=activityImgHeight,left=firstActivyLeft+activityImgWidth+activitySpace,top=firstActivyTop,
      src=Globals.getDefaultImg(),
      contentMode = contentMode,
      backgroundColor=Globals.getImageBackgroundColor()
   }
   self:addChild(rightBgImg)
   local rightImg = ImageView{
      width=activityImgWidth,height=activityImgHeight,left=firstActivyLeft+activityImgWidth+activitySpace,top=firstActivyTop,
      src=self._data and self._data[2].image or nil,
      contentMode = contentMode,
      backgroundColor=Globals.getImageBackgroundColor(),
      alpha=0,
   }
   rightImg:setUserInteractionEnabled(false)
   local rightTitleImg = ImageView{
      width=titleImgWidth,height=titleImgHeight,left=rightImg:getLeft()+rightImg:getWidth()-titleImgWidth,top=titleImgTop,
   }
   local rightNightMask = Node{
      left=rightImg:getLeft(), top=rightImg:getTop(), width=rightImg:getWidth(), height=rightImg:getHeight(),
      backgroundColor= Globals.getMaskColor()
   }
   rightNightMask:setUserInteractionEnabled(false)
   local rightBtn = Button{
      width=rightImg._width, height=cellHeight, left=rightImg._left, top=rightImg._top,
      id="rightActivityBtn"
   }
   rightBtn.url = self._data and self._data[2].image or nil
   rightBtn:addEventListener("click",
                            function(evt)
                               return self:openUrl(evt.target.url)
   end)
   Globals.applyBtnHilightStyle(rightBtn)


   local rightTitleView = Label{
         left=rightImg:getLeft(),
         top =cellTitleTop,
         fontSize = Globals.cellTitleFontSize,
         color = Globals.getTitleFontColor(),
         maxLines =1,
         maxWidth = activityImgWidth,
   }
   local rightCoinView = Label{
         left=rightImg:getLeft(),
         top =cellCoinTop,
         fontSize = cellCoinFontSize,
         color = Globals.getGoldRedColor(),
         maxLines =1,
         maxWidth = activityImgWidth,

   }


   self._rightBtn = rightBtn
   self._rightImgTitleView = rightTitleImg
   self._rightImgView = rightImg

   self._rightTitleView = rightTitleView
   self._rightCoinView = rightCoinView

   self:addChild(rightBtn)
   self:addChild(rightImg)
   self:addChild(rightTitleImg)
   self:addChild(rightNightMask)

   self:addChild(rightTitleView)
   self:addChild(rightCoinView)
end

function TemplateCell.prototype:onDataChanged(prop, old, new)
   if self._data then
      self._leftImgView:setSrc(self._data[1].image)
      self._leftImgView:setContentMode("scaleToFill")
      self._leftBtn.url = self._data[1].url
      self:addImgOnLoadAnimation(self._leftImgView)

      self._rightImgView:setSrc(self._data[2].image)
      self._rightImgView:setContentMode("scaleToFill")
      self._rightBtn.url = self._data[2].url
      self:addImgOnLoadAnimation(self._rightImgView)
      
      if self._data[1].tag == "兑换" then
         self._leftImgTitleView:setSrc("app://tradeoffs.png")
      elseif self._data[1].tag == "抵现" then
         self._leftImgTitleView:setSrc("app://exchange.png")
      end

      if self._data[2].tag == "兑换" then
         self._rightImgTitleView:setSrc("app://tradeoffs.png")
      elseif self._data[2].tag == "抵现" then
         self._rightImgTitleView:setSrc("app://exchange.png")
      end

      self._leftTitleView:setText(self._data[1].title)
      if self._data[1].money and string.len(self._data[1].money) > 0 then
         self._leftCoinView:setText(self._data[1].coin .. "金币+" .. self._data[1].money .. "元")
      else
         self._leftCoinView:setText(self._data[1].coin .. "金币")
      end

      self._rightTitleView:setText(self._data[2].title)
      if self._data[2].money and string.len(self._data[2].money) > 0 then
         self._rightCoinView:setText(self._data[2].coin .. "金币+" .. self._data[2].money .. "元")
      else
         self._rightCoinView:setText(self._data[2].coin .. "金币")
      end

   else
      self._leftImgView:setSrc(Globals.getDefaultImg())
      self._leftImgView:setContentMode("center")
      self._leftBtn.url = nil
      self._rightImgView:setSrc(Globals.getDefaultImg())
      self._rightImgView:setContentMode("center")
      self._rightBtn.url = nil

      self._leftImgTitleView:setSrc(nil)
      self._rightImgTitleView:setSrc(nil)
      self._leftTitleView:setText("")

      self._rightTitleView:setText("")

      self._leftCoinView:setText("")
      self._rightCoinView:setText("")

   end
end

function TemplateCell.prototype:addImgOnLoadAnimation(image)
   image:removeEventAllListener("load")

   image:setAlpha(1)

   if false then
      image:setAlpha(0)
      return
   end
 
   local onLoad = function()
      if IOS then
         IOS.animWithPredefinedType(image._pv["handler"],
                                    "alpha",
                                    0, --start value
                                    1, --end value
                                    0.20, --duration
                                    0, --start offset
                                    1, --linear
                                    function()
         end)
      end
   end

   image:addEventListener("load", onLoad)
end

function TemplateCell.prototype:openUrl(url)
   getApplication():openUrl(url)
end
  
TemplateCell.cellHeight = cellHeight

return TemplateCell
