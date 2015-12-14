module("ActivityCell", package.seeall)
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

--整个cell的高度
-- local cellHeight = activityImgHeight +  45
local cellHeight = activityImgHeight +  Globals.cellTitleFontSize + 31



local cellTitleTop = activityImgHeight + 8

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

local ActivityCell = Class.Class("ActivityCell",
                                 {
                                    base = Container,
                                    properties = {
                                       width=cellWidth,height=cellHeight,
                                       data = Class.undefined,

                                       _leftImgView = Class.undefined,
                                       _leftTitleView = Class.undefined,

                                       _rightImgView = Class.undefined,

                                       _rightTitleView = Class.undefined,

                                       _leftBtn = Class.undefined,
                                       _rightBtn = Class.undefined,
                                    }
})

function ActivityCell.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:setBackgroundColor(Globals.getBackgroundColor())
   self:initSubViews()
end

function ActivityCell.prototype:initSubViews()
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
   self._leftTitleView = leftTitleView


   self._leftImgView = leftImg
   self._leftBtn = leftBtn


   self:addChild(leftBtn)   
   self:addChild(leftImg)
   self:addChild(leftNightMask)
   self:addChild(leftTitleView)

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
   self._rightBtn = rightBtn
   self._rightImgView = rightImg

   self._rightTitleView = rightTitleView

   self:addChild(rightBtn)
   self:addChild(rightImg)
   self:addChild(rightNightMask)

   self:addChild(rightTitleView)
end

function ActivityCell.prototype:onDataChanged(prop, old, new)
   if self._data then
      -- print("zp")
      -- print(table.tostring(self._data))
      self._leftImgView:setSrc(self._data[1].icon)
      self._leftImgView:setContentMode("scaleToFill")
      self._leftBtn.url = self._data[1].url
      self:addImgOnLoadAnimation(self._leftImgView)

      self._rightImgView:setSrc(self._data[2].icon)
      self._rightImgView:setContentMode("scaleToFill")
      self._rightBtn.url = self._data[2].url
      self:addImgOnLoadAnimation(self._rightImgView)

      self._leftTitleView:setText(self._data[1].title)
      self._rightTitleView:setText(self._data[2].title)
   else
      self._leftImgView:setSrc(Globals.getDefaultImg())
      self._leftImgView:setContentMode("center")
      self._leftBtn.url = nil
      self._rightImgView:setSrc(Globals.getDefaultImg())
      self._rightImgView:setContentMode("center")
      self._rightBtn.url = nil

      self._leftTitleView:setText("")

      self._rightTitleView:setText("")
   end
end

function ActivityCell.prototype:addImgOnLoadAnimation(image)
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

function ActivityCell.prototype:openUrl(url)
   getApplication():openUrl(url)
end
  
ActivityCell.cellHeight = cellHeight

return ActivityCell
