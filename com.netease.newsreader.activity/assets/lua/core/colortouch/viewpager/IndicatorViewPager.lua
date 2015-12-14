require "stdlib/class/Class"

--[[
  eventListener: --startscroll, offsetchanged, pagechanged, didEndOffset, didEndOffsetByProgram, numberOfPagesChanged(oldnumber, newnumber)
]]

IndicatorViewPager = Class.Class("ViewPager",
                         {
                            base=Container,

                            properties={
                               contentinset = Class.undefined,
                               isRecycleEnabled = false,
                               adapter = Class.undefined,

                               activeIndicatorSrc = Class.undefined,
                               indicatorSrc = Class.undefined,

                               canAutoPaging = Class.undefined,
                               autoPagingInterval = Class.undefined,

                               --private members
                               viewPager = Class.undefined,
                               pageIndicator = Class.undefined,
                            }
                         }
)

function IndicatorViewPager.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)

   self:setLayout("flex")
   self:setDir(VBox)
   self:setPack(End)
   self:setAlign(Center)

   self._viewPager = ViewPager {
      left = 0, top = 0,
      width="100%", height="100%",
      -- width=0, height=0,

      pagingEnabled = self._pagingEnabled,
      contentinset = self._contentinset,
      isRecycleEnabled = self._isRecycleEnabled,
      adapter = self._adapter,
      canAutoPaging = self._canAutoPaging,
      autoPagingInterval = self._autoPagingInterval,
   }
   self._pageIndicator = PageIndicator{
      width=10, height = 10,
      numberOfPages = 1,
      currentPage = 1, --从1开始
      indicatorSrc = self._indicatorSrc,
      activeIndicatorSrc = self._activeIndicatorSrc,
      isRecycleEnabled = self._isRecycleEnabled,
   }

   self._viewPager:addEventListener("numberOfPagesChanged", function(old, new)
         local height = self._pageIndicator:computedHeight()
         self._pageIndicator:setWidth(new * height)
         self._pageIndicator:setNumberOfPages(new)
      end)
   self._viewPager:addEventListener("pagechanged", function(pageInfo)
         local pageId = pageInfo.pageId + 1
         ctLog("IndicatorViewPager Pagechanged=", pageId)
         self._pageIndicator:setCurrentPage(pageId)
      end)

   if self._adapter then
      self:onAdapterChanged("adapter", nil, self._adapter)
   end

   self:setItems{
      self._viewPager,
      self._pageIndicator,
      Spacer{height=5,}
   }
end

-- function IndicatorViewPager.prototype:onLayoutComplete()
--    Node.prototype.onLayoutComplete(self)

--    self:initPageIndicatorFrame()
-- end

-- function IndicatorViewPager.prototype:initPageIndicatorFrame()
--    local width = self:computedWidth()
--    local height = self:computedHeight()
   
--    -- do somethind ?
-- end

function IndicatorViewPager.prototype:onAdapterChanged(prop, old, new)
   if self._viewPager:getAdapter() ~= new then
      self._viewPager:setAdapter(new)
   end
   if new then
      local numberOfIndicators = new:numberOfPages()
      self._pageIndicator:setNumberOfPages(numberOfIndicators)
   end
end

function IndicatorViewPager.prototype:onIsRecycleEnabledChanged(prop, old, new)
   self._viewPager:setIsRecycleEnabled(new)
   self._pageIndicator:setIsRecycleEnabled(new)
end

function IndicatorViewPager.prototype:onContentinsetChanged(prop, old, new)
   self._viewPager:setContentinset(new)
end

function IndicatorViewPager.prototype:onActiveIndicatorSrcChanged(prop, old, new)
   self._pageIndicator:setActiveIndicatorSrc(new)
end

function IndicatorViewPager.prototype:onIndicatorSrcChanged(prop, old, new)
   self._pageIndicator:setIndicatorSrc(new)
end

function IndicatorViewPager.prototype:onCanAutoPagingChanged(prop, old, new)
   self._viewPager:setCanAutoPaging(new)
end

function IndicatorViewPager.prototype:onAutoPagingIntervalChanged(prop, old, new)
   self._viewPager:setAutoPagingInterval(new)
end

-- public functions
function IndicatorViewPager.prototype:addEventListener(evtName, cb)
   self._viewPager:addEventListener(evtName, cb)
end

function IndicatorViewPager.prototype:removeEventListener(evtName, cb)
   self._viewPager:removeEventListener(evtName, cb)
end

function IndicatorViewPager.prototype:pageToPrev(bAnim)
   self._viewPager:pageToPrev(bAnim)
   -- self._pageIndicator:pageToPrev()
end

function IndicatorViewPager.prototype:pageToNext(bAnim)
   self._viewPager:pageToNext(bAnim)
   -- self._pageIndicator:pageToNext()
end

function IndicatorViewPager.prototype:setViewPagerIndex(index, bAnim)
   self._viewPager:setViewPagerIndex(index, bAnim)
   -- self._pageIndicator:setCurrentPage(index)
end

function IndicatorViewPager.prototype:getViewPagerIndex()
   self._pageIndicator:getCurrentPage()
end

function IndicatorViewPager.prototype:reloadData()
   self._viewPager:reloadData()
end

function IndicatorViewPager.prototype:getContentOffset()
   return self._viewPager:getContentOffset()
end

if platform.isIOS() then
   --目前仅支持top方向上的loadmore
   function IndicatorViewPager.prototype:refreshableInsetForDirection(direction)
      self._viewPager:refreshableInsetForDirection(direction)
   end

   ----------load more------------
   function IndicatorViewPager.prototype:canRefreshInDirection(direction)
      return self._viewPager:canRefreshInDirection(direction)
   end
else
   --Android
end