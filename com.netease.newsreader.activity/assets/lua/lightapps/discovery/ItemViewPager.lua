module("ItemViewPager", package.seeall)
local AdsScrollView,AdsViewPager,genAdsViewPagerAdapterDelegateFunc = nil,nil,nil

if platform.isIOS() then
    AdsScrollView = require("AdsScrollViewForIOS")
    PageIndicator = require("PageIndicator")
else
    AdsViewPager = require("ItemViewPagerForAndroid")
    genAdsViewPagerAdapterDelegateFunc = require("AdsViewPagerAdapterDelegateForAndroid")
end

local scaleFactor = Globals.scaleFactor

local cellHeight,cellWidth = math.floor(Globals.bigImgHeight), Globals.cellWidth

local backgroundColor = Globals.backgroundColor

local ItemViewPager = Class.Class("ItemViewPager",
                            {
                               base = Container,
                               properties = {
                                  data = Class.undefined,                                  
                                  adsView = Class.undefined,
                                  indicator = Class.undefined,
                               },
})

function ItemViewPager.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:setBackgroundColor(backgroundColor)

   self:doInit()

   self:onDataChanged("data", nil, self._data)
end

function ItemViewPager.prototype:doInit()
   	self:addDefaultBgImg()
end

if not platform.isIOS() then

  function ItemViewPager.prototype:initAdapter(activityList,cb)
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
        Globals.applyItemHilightStyle(btn)
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

function ItemViewPager.prototype:onDataChanged(prop, old, new)
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
				activityList = self._data,
				clickCB = clickCB,
        width = cellWidth,
        height = cellHeight,
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
        left = (cellWidth - width)/2,
        top = cellHeight - 10,
        numberOfPages = numberOfPages,
        indicatorColor = Globals.itemIndicatorColor,
        activeIndicatorColor = Globals.itemIndicatorHilightColor,
        indicatorSize = Globals.itemIndicatorWidth,
        activeIndicatorSize = activeIndicatorSize,
        distance = distance,
      }
      
      self:addChild(indicator)
      self._indicator = indicator
      adsView:setActivityScrollIndicators(indicator)
    else
  		local indicator = adsView:createActivityScrollIndicators()
  		self:addChild(indicator)
  		self._indicator = indicator
    end
	end

	self:layout()
end

function ItemViewPager.prototype:clickedAtIndex(item)
   	getApplication():openUrl(item.url)
end

function ItemViewPager.prototype:addDefaultBgImg()
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

ItemViewPager.cellHeight = cellHeight
ItemViewPager.cellWidth = cellWidth

return ItemViewPager
