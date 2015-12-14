module("AdsScrollViewForIOS", package.seeall)

require("Globals")
require("colortouch.ScrollView")

local AdsScrollView = Class.Class("AdsScrollView",
                            {
                               base = ScrollView,
                               properties = {
                                  left=0, top=0, 
                                  pagingEnabled=true, 
                                  showsVerticalScrollIndicator=false, 
                                  showsHorizontalScrollIndicator=false,

                                  clickCB = Class.undefined,
                                  
                                  layout="flex", dir=HBox,
                                  
                                  activityList = Class.undefined,
                                  -- 当前活动索引
                                  curActivityIndex = 1,
                                  -- 用于放置所有活动图片的scrollView
                                  imageScrollView = Class.undefined,
                                  -- 用于自动切换下一张活动图片的timer
                                  imageScrollViewTimer = Class.undefined,
                                  -- 翻到上一页的时候，imageScrollView 的offset
                                  prevOffset = Class.undefined,
                                  -- 用于显示活动标题的label
                                  activityTitleLabel = Class.undefined,
                                  -- 用于指示当前活动的indicator
                                  activityScrollIndicators = Class.undefined,
                               },
})

--FIXME:需要支持根据数据变化动态调整

function AdsScrollView.prototype:init(inlineprops, ...)
   ScrollView.prototype.init(self, inlineprops, ...)
   self:doInit()
end

function AdsScrollView.prototype:doInit()

   -- 拷贝activityList，然后对拷贝进行操作
   local activityList = {}
   for i,v in ipairs(self._activityList) do
      activityList[i] = v
   end

   -- 实现循环滚动，scrollView有bounce，为了防止空白的出现，必须保证滚动前当前页左右两边至少有两页
   -- 所以必须调整页面的数量和位置，以下按原始页数分情况讨论
   -- 如果有两页，本来是 [1] 2，调整成 1 2 [1] 2 1 2
   -- 如果有三页，本来是 [1] 2 3，调整成 2 3 [1] 2 3 1
   -- 如果有四页，本来是 [1] 2 3 4，调整成 1 2 3 4 [1] 2 3 4
   -- 五页及以上，本来是 [1] 2 ... n，调整成 n-1 n [1] 2 3 ...
   -- 每次翻下一页后，就将第一页移至最后；翻上一页后，就将最后一个移至最前
   -- 这样初始化时显示的页数需要动态计算，即scrollView要调整contentOffset
   local num = #activityList
   if num == 2 then
      local activity1 = activityList[1]
      local activity2 = activityList[2]
      table.insert(activityList, 1, activity2)
      table.insert(activityList, 1, activity1)
      table.insert(activityList, activity1)
      table.insert(activityList, activity2)
   elseif num == 3 then
      local activity1 = activityList[1]
      local activity2 = activityList[2]
      local activity3 = activityList[3]
      table.insert(activityList, 1, activity3)
      table.insert(activityList, 1, activity2)
      table.insert(activityList, activity1)
   elseif num == 4 then
      local activity1 = activityList[1]
      local activity2 = activityList[2]
      local activity3 = activityList[3]
      local activity4 = activityList[4]
      table.insert(activityList, 1, activity4)
      table.insert(activityList, 1, activity3)
      table.insert(activityList, 1, activity2)
      table.insert(activityList, 1, activity1)
   elseif num >= 5 then
      local lastActivity = activityList[num]
      local activityBeforeLast = activityList[num-1]
      table.remove(activityList)
      table.remove(activityList)
      table.insert(activityList, 1, lastActivity)
      table.insert(activityList, 1, activityBeforeLast)
   end

   -- 初始化用于放置活动图片的imageViews
   local imageViews = {}
   for i, activity in ipairs(activityList) do
      local imageView = ImageView{
         width="100%", height="100%",
         src=activity.image,
         contentMode="scaleToFill",
      }
      local btn = Button{
         top=0, left=0, width="100%", height="100%",
      }
      local nightMask = Node{
         left=0, top=0, width="100%", height="100%",
         backgroundColor= Globals.getMaskColor(),
      }
      
      local clickFunc = function() if self._clickCB then self._clickCB(activity) end end
      btn:addEventListener("click", clickFunc)
      local c = Container{
         class="ImageView",
         width="100%", height="100%",
         layout="flex", dir="HBox",
         items={
            imageView,
            nightMask,
            btn,
         }
      }
      
      self:addImageOnLoadAnimation(imageView)
      imageViews[#imageViews+1] = c
      self:addChild(c)
   end

   local imageScrollView = self
   self._imageScrollView = imageScrollView
   
   -- 初始化翻上一页所产生的offset
   local prevOffset = nil
   local num = #self._activityList
   if num == 4 then
      prevOffset = self._width * 3
   else
      prevOffset = self._width
   end
   self._prevOffset = prevOffset
   -- 如果图片数量超过一张，需要根据第一张图片的位置调整offset，同时启动自动翻页计时器
   if #activityList >= 2 then
      imageScrollView:layout()
      self:updateImageScrollViewOffset()
      -- 启动自动翻页的timer，同时监听事件，当滚动开始时清除timer，当滚动结束后重启timer
      self:startImageScrollViewTimer()
      imageScrollView:addEventListener("startscroll", function() self:onScrollStarted() end)
      imageScrollView:addEventListener("didEndOffset", function() self:onScrollEnded() end)
      imageScrollView:addEventListener("didEndOffsetByProgram", function() self:onScrollEnded() end)
   end

   imageScrollView:layout()

   return imageScrollView
end

function AdsScrollView.prototype:addImageOnLoadAnimation(image)
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

-- 自动切换图片
-- 启动自动翻页的timer
function AdsScrollView.prototype:startImageScrollViewTimer()
   self:clearImageScrollViewTimer()

   self._imageScrollViewTimer = setInterval(function() self:switchToNextImage() end, 3)
end
-- 清除自动翻页的timer
function AdsScrollView.prototype:clearImageScrollViewTimer()
   if self._imageScrollViewTimer ~= nil then
      self._imageScrollViewTimer:dispose()
      self._imageScrollViewTimer = nil
   end
end
-- 自动切换到下一页
function AdsScrollView.prototype:switchToNextImage()
   self:updateImageScrollView()
   self:updateActivityScrollIndicators()

   local contentOffset = self._imageScrollView:getContentOffset()
   contentOffset.x = contentOffset.x + self._width
   self._imageScrollView:setContentOffset(contentOffset, true)

   self:layout()
end

-- 用户手动滚动时，清除计时器
function AdsScrollView.prototype:onScrollStarted()
   self:clearImageScrollViewTimer()
end
-- 用户手动滚动结束后，重启计时器
function AdsScrollView.prototype:onScrollEnded()
   self:startImageScrollViewTimer()
   self:updateImageScrollView()
   --self:updateActivityTitleLabel()
   self:updateActivityScrollIndicators()
end
-- 自动/手动滚动结束后，调整scrollView
function AdsScrollView.prototype:updateImageScrollView()
   -- 翻上一页后，就将最后一页移至最前
   -- 翻下一页后，就将第一页移至最后
   local x = self._imageScrollView:getContentOffset().x
   if x == self._prevOffset then
      self:moveLastImageToFirst()
   elseif x == self._prevOffset + self._width*2 then
      self:moveFirstImageToLast()
   end

   self:updateImageScrollViewOffset()

   self:layout()
end

function AdsScrollView.prototype:moveLastImageToFirst()
   local imageViews = self._imageScrollView:queryNodesByClass("ImageView")
   local imageView = imageViews[#imageViews]
   imageView:removeFromParent()
   self._imageScrollView:insertSubviewAtIndex(imageView, 0)
   self._curActivityIndex = self._curActivityIndex - 1
   if (self._curActivityIndex == 0) then
      self._curActivityIndex = #self._activityList
   end
end

function AdsScrollView.prototype:moveFirstImageToLast()
   local imageViews = self._imageScrollView:queryNodesByClass("ImageView")
   local imageView = imageViews[1]
   imageView:removeFromParent()
   self._imageScrollView:addChild(imageView)
   self._curActivityIndex = self._curActivityIndex + 1
   if (self._curActivityIndex > #self._activityList) then
      self._curActivityIndex = 1
   end
end

function AdsScrollView.prototype:updateImageScrollViewOffset()
   -- 调整当前正确的offset，不要触发动画
   self._imageScrollView:setContentOffset({x=self._prevOffset+self._width,y=0}, false)
end

function AdsScrollView.prototype:updateActivityTitleLabel()
   -- 如果当前活动要显示标题，那么显示它的标题，否则显示为空
   local title = ""
   if self._activityList[self._curActivityIndex].titleshown == 1 then
      title = self._activityList[self._curActivityIndex].title
   end
   self._activityTitleLabel:setText(title)
end

function AdsScrollView.prototype:updateActivityScrollIndicators()
   self._activityScrollIndicators:setCurrentPage(self._curActivityIndex)
end

function AdsScrollView.prototype:onActivityScrollIndicatorsChanged()
   self._activityScrollIndicators:setCurrentPage(self._curActivityIndex,true)
end

return AdsScrollView
