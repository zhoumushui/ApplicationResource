module("AdsCell", package.seeall)
require("Globals")
local AdsScrollView,AdsViewPager,genAdsViewPagerAdapterDelegateFunc = nil,nil,nil

if platform.isIOS() then
    AdsScrollView = require("AdsScrollViewForIOS")
    PageIndicator = require("PageIndicator")
else
    AdsViewPager = require("AdsViewPagerForAndroid")
    genAdsViewPagerAdapterDelegateFunc = require("AdsViewPagerAdapterDelegateForAndroid")
end

local scaleFactor = Globals.cellWidth / 375

local cellWidth = getApplication():getScreenWidthUnit()
local cellHeight = Globals.adsViewHeight

local AdsCell = Class.Class("AdsCell",
                            {
                               base = Container,
                               properties = {
                                  width=cellWidth,height=cellHeight,
                                  data = Class.undefined,
                                  
                                  adsView = Class.undefined,
                                  indicator = Class.undefined,
                               },
})

function AdsCell.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:setBackgroundColor(backgroundColor)

   self:doInit()

   self:onDataChanged("data", nil, self._data)
end

function AdsCell.prototype:doInit()
   self:addDefaultBgImg()
end

if not platform.isIOS() then

  function AdsCell.prototype:initAdapter(activityList,cb)
     local num = #activityList

     -- 初始化用于放置活动图片的imageViews
     local imageViews = {}
     for i, activity in ipairs(activityList) do
        local imageView = ImageView{
           id="adsCellImageView",
           width="100%", height="100%",
           src=activity.image,
           contentMode="scaleToFill",
        }
        local btn = Button{
           id =  "btnClick",
           top=0, left=0, width="100%", height="100%",
        }
        local nightMask = Node{
           left=0, top=0, width="100%", height="100%",
           backgroundColor= Globals.getMaskColor(),
        }
        
        local clickFunc = function() if cb then cb(activity) end end
        btn:addEventListener("click", clickFunc)
        btn._clickFunc = clickFunc
        local c = Container{
           class="ImageView",
           width=cellWidth,height=cellHeight,
           layout="flex", dir="HBox",
           items={
              imageView,
              nightMask,
              btn,
           }
        }
        imageViews[#imageViews+1] = c
     end
     local delegate = genAdsViewPagerAdapterDelegateFunc(cellWidth,cellHeight)
     delegate.pages = imageViews
     delegate.data = activityList
     return ViewPagerAdapter{
        delegate = delegate,
     }

  end

end
function AdsCell.prototype:onDataChanged(prop, old, new)

   if self._adsView then
      self._adsView:removeFromParent()
   end
   
   if self._indicator then
      self._indicator:removeFromParent()
   end

   if self._data and #self._data > 0 then
      local adsView = nil
      local clickCB = function(item)
         self:clickedAtIndex(item)
      end

      if platform.isIOS() then
          adsView = AdsScrollView{
            width = cellWidth,
            height = cellHeight,
            activityList = self._data,
            clickCB = clickCB
          }
      else
          local adapter = self:initAdapter(self._data, clickCB)
      	  adsView = AdsViewPager{
	           activityList = self._data,
             adapter = adapter,
          }
      end
  
      self:addChild(adsView)
      self._adsView = adsView

      if platform.isIOS() then

        local numberOfPages = #self._data
        local distance = Globals.itemIndicatorSpace
        local width = distance*numberOfPages
        local activeIndicatorSize = Globals.itemHilightIndicatorWidth

        local indicator = PageIndicator{
          width = width,
          height = activeIndicatorSize,
          left = cellWidth - width - 15,
          top = cellHeight - 10,
          numberOfPages = numberOfPages,
          indicatorColor = Globals.getIndicatorColor(),
          activeIndicatorColor = Globals.getHilightedIndicatorColor(),
          indicatorSize = Globals.itemIndicatorWidth,
          activeIndicatorSize = activeIndicatorSize,
          distance = distance,
        }
        
        self:addChild(indicator)
        self._indicator = indicator
        adsView:setActivityScrollIndicators(indicator)
      else
        indicator = adsView:createActivityScrollIndicators()
        self:addChild(indicator)
        self._indicator = indicator
      end
   end

   self:layout()
end

function AdsCell.prototype:clickedAtIndex(item)
   getApplication():openUrl(item.url)
end

function AdsCell.prototype:addDefaultBgImg()
   local img = ImageView{
      src=Globals.getDefaultImg(),
      width="100%",
      height="100%",
      left=0,top=0,
      contentMode="center",
      backgroundColor=Globals.getImageBackgroundColor()
   }
   self:addChild(img)
end

AdsCell.cellHeight = cellHeight
AdsCell.cellWidth = cellWidth

function AdsCell.class.prototype:getCellHeight(data)
   return cellHeight
end

return AdsCell
