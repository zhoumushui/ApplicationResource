module("AdsViewPager", package.seeall)

require("Globals")
require("colortouch.ViewPager")

local scaleFactor = Globals.cellWidth / 375
local activityCellHeight = 150 * scaleFactor
local adsWidth = getApplication():getScreenWidthUnit()

local indicatorBgRightMargin = 10
--内部小点距离背景右边缘的距离
local indicatorMargin = 6

local indicatorBgTop = activityCellHeight - 22

local indicatorTotalHeight = 12
local indicatorWidth,indicatorHeight = 4,4
local hilightIndicatorWidth,hilightIndicatorHeight = 6,6
local indicatorSpace = 6

local normalIndicatorTop = (indicatorTotalHeight - indicatorHeight) / 2
local hilightIndicatorTop = (indicatorTotalHeight - hilightIndicatorHeight) / 2

local indicatorColor = rgba{255,255,255,0.3}
local indicatorHilightColor = rgba{255,255,255,1}

local AdsViewPager = Class.Class("AdsViewPager",
                            {
                               base = ViewPager,
                               properties = {
                                  left=0, top=0, width=adsWidth,height=activityCellHeight,
                               --   pagingEnabled=true, 
                                  showsVerticalScrollIndicator=false, 
                                  showsHorizontalScrollIndicator=false,

                                  clickCB = Class.undefined,
                                  
                                 -- layout="flex", dir=HBox,
                                  
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
                                  isRecycleEnabled = true,

                               },
})

--FIXME:需要支持根据数据变化动态调整

function AdsViewPager.prototype:init(inlineprops, ...)
   ViewPager.prototype.init(self, inlineprops, ...)
  
   -- self._activityList = {
   --    {image="http://nos.netease.com/yixinpublic/pr_y129cyprmuf8yg2_9g3sxa==_1420354770_446745"},
   --    {image="http://nos.netease.com/yixinpublic/pr_w-dwjga3iskoq_vzq05z9g==_1419560947_440018"},
   --    {image="http://nos.netease.com/yixinpublic/pr_6waffhafpmwk9bb31iawew==_1420354730_446744"},
   -- }
 
   self:doInit()
end

function AdsViewPager.prototype:initAdpater()
end

function AdsViewPager.prototype:doInit()
   -- 拷贝activityList，然后对拷贝进行操作

   if self._activityList ==nil then
      print("why adsview pager is nil")
    end

   local activityList = {}
   for i,v in ipairs(self._activityList) do
      activityList[i] = v
   end
   local num = #activityList

  
   local imageScrollView = self
   self._imageScrollView = imageScrollView
   
   -- 初始化翻上一页所产生的offset
   local prevOffset = nil
   local num = #self._activityList
   if num == 4 then
      prevOffset = adsWidth * 3
   else
      prevOffset = adsWidth
   end
   self._prevOffset = prevOffset
   -- 如果图片数量超过一张，需要根据第一张图片的位置调整offset，同时启动自动翻页计时器
   if #activityList >= 2 then
      imageScrollView:layout()
      self:updateImageScrollViewOffset()
      -- 启动自动翻页的timer，同时监听事件，当滚动开始时清除timer，当滚动结束后重启timer
      self:tryStartImageScrollViewTimer()

    imageScrollView:addEventListener("startscroll", function()
            self:onScrollStarted()
         end)
      imageScrollView:addEventListener("pagechanged", function(pageInfo)
         -- if pageInfo.pageId + 1 > #self._activityList then
         --   self._curActivityIndex = 1
         -- else
             self._curActivityIndex = pageInfo.pageId + 1
         -- end
         self:onPageChanged()
         end)

   end



   imageScrollView:layout()

   return imageScrollView
end


function AdsViewPager.prototype:onPageChanged()
   self:tryStartImageScrollViewTimer()
 --  self:updateActivityTitleLabel()

   self:updateActivityScrollIndicators()

end

function AdsViewPager.prototype:addImageOnLoadAnimation(image)
   image:removeEventAllListener("load")
   
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

function AdsViewPager.prototype:createActivityScrollIndicators()
   -- 初始化用于放置indicator图片和空隙节点的nodes
   local nodes = {}

   local startX = indicatorMargin
   local activityLength = 0

   if self._activityList and #self._activityList > 0 then 
      activityLength = #self._activityList
   else
      nodes = nil
   end

   for i=1,#self._activityList do
      local indicator = ImageView{width=indicatorWidth,
                                  height=indicatorHeight,
                                  backgroundColor=indicatorColor, 
                                  left=startX + (i-1) * (indicatorWidth + indicatorSpace), 
                                  top = normalIndicatorTop,
                                  class="indicator"
      }
      nodes[#nodes+1] = indicator
   end
   
   local indicatorTotalWidth = indicatorMargin * 2 + indicatorWidth * activityLength + indicatorSpace * (activityLength-1)

   local container = Container{
      left=Globals.cellWidth - indicatorTotalWidth - indicatorBgRightMargin, top=indicatorBgTop,
      height=indicatorTotalHeight,
      width=indicatorTotalWidth,
      items=nodes,
      backgroundImage="app://indicator-bg.png"
   }
   self._activityScrollIndicators = container

   self:updateActivityScrollIndicators()
   return container
end

-- 自动切换到下一页
function AdsViewPager.prototype:androidSwitchToNextImage()
   self:updateActivityScrollIndicators()
   local oldPageId = self._imageScrollView:getViewPagerIndex()
   local newPageId = oldPageId+1 

   if newPageId > #self._activityList then
     newPageId = 1
   end
   self._imageScrollView:setViewPagerIndex(newPageId, true)
end


-- 自动切换图片
-- 启动自动翻页的timer
function AdsViewPager.prototype:tryStartImageScrollViewTimer()
   self:clearImageScrollViewTimer()
    self._imageScrollViewTimer = setInterval(function() self:androidSwitchToNextImage() end, 5)
end
-- 清除自动翻页的timer
function AdsViewPager.prototype:clearImageScrollViewTimer()
   if self._imageScrollViewTimer ~= nil then
      self._imageScrollViewTimer:dispose()
      self._imageScrollViewTimer = nil
   end
end
-- 自动切换到下一页
function AdsViewPager.prototype:switchToNextImage()
   self:updateImageScrollView()
   self:updateActivityScrollIndicators()

   local contentOffset = self._imageScrollView:getContentOffset()
   contentOffset.x = contentOffset.x + adsWidth
   self._imageScrollView:setContentOffset(contentOffset, true)

   self:layout()
end

-- 用户手动滚动时，清除计时器
function AdsViewPager.prototype:onScrollStarted()
   self:clearImageScrollViewTimer()
end
-- 用户手动滚动结束后，重启计时器
function AdsViewPager.prototype:onScrollEnded()
  --TODO android不会调用到
   -- self:startImageScrollViewTimer()
   -- self:updateImageScrollView()
   --self:updateActivityTitleLabel()
   self:updateActivityScrollIndicators()
end
-- 自动/手动滚动结束后，调整scrollView
function AdsViewPager.prototype:updateImageScrollView()
   -- 翻上一页后，就将最后一页移至最前
   -- 翻下一页后，就将第一页移至最后
   -- local x = self._imageScrollView:getContentOffset().x
   -- if x == self._prevOffset then
   --    self:moveLastImageToFirst()
   -- elseif x == self._prevOffset + adsWidth*2 then
   --    self:moveFirstImageToLast()
   -- end

   -- self:updateImageScrollViewOffset()

   self:layout()
end

function AdsViewPager.prototype:moveLastImageToFirst()
   -- local imageViews = self._imageScrollView:queryNodesByClass("ImageView")
   -- local imageView = imageViews[#imageViews]
   -- imageView:removeFromParent()
   -- self._imageScrollView:insertSubviewAtIndex(imageView, 0)
   -- self._curActivityIndex = self._curActivityIndex - 1
   -- if (self._curActivityIndex == 0) then
   --    self._curActivityIndex = #self._activityList
   -- end
end

function AdsViewPager.prototype:moveFirstImageToLast()
   -- local imageViews = self._imageScrollView:queryNodesByClass("ImageView")
   -- local imageView = imageViews[1]
   -- imageView:removeFromParent()
   -- self._imageScrollView:addChild(imageView)
   -- self._curActivityIndex = self._curActivityIndex + 1
   -- if (self._curActivityIndex > #self._activityList) then
   --    self._curActivityIndex = 1
   -- end
end

function AdsViewPager.prototype:updateImageScrollViewOffset()
   -- 调整当前正确的offset，不要触发动画
   -- self._imageScrollView:setContentOffset({x=self._prevOffset+adsWidth,y=0}, false)
end

function AdsViewPager.prototype:updateActivityTitleLabel()
   -- 如果当前活动要显示标题，那么显示它的标题，否则显示为空
   local title = ""
   if self._activityList[self._curActivityIndex].titleshown == 1 then
      title = self._activityList[self._curActivityIndex].title
   end
   self._activityTitleLabel:setText(title)
end
function AdsViewPager.prototype:updateActivityScrollIndicators()
   -- 将所有的scrollIndicator重置，然后设置指示当前activity的scrollIndicator
   local imageViews = self._activityScrollIndicators:queryNodesByClass("indicator")
   for i, imageView in ipairs(imageViews) do
      imageView:setWidth(indicatorWidth):setHeight(indicatorHeight):setTop(normalIndicatorTop):setBackgroundColor(Globals.getIndicatorColor()):setBorderRadius(indicatorWidth/2)
   end
    imageViews[self._curActivityIndex]:setWidth(hilightIndicatorWidth):setHeight(hilightIndicatorHeight):setTop(hilightIndicatorTop):setBackgroundColor(Globals.getHilightedIndicatorColor()):setBorderRadius(hilightIndicatorWidth/2)

end

return AdsViewPager
