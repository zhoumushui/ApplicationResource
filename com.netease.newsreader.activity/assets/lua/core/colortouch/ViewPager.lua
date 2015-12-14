require "stdlib/class/Class"

--[[
  eventListener: startscroll, offsetchanged, pagechanged, didEndOffset, didEndOffsetByProgram, numberOfPagesChanged(oldnumber, newnumber)
]]

-- 子页面横向的排版
ViewPager = Class.Class("ViewPager",
                         {
                            base=Container,

                            properties={
                               contentinset = Class.undefined, --iOS
                               
                               isRecycleEnabled = false,

                               adapter = Class.undefined,

                               canAutoPaging = Class.undefined,
                               autoPagingInterval = Class.undefined,

                               --private members
                               -- 页面的索引，从0开始，在init里面会主动设置为0
                               -- pageIndex = Class.undefined,
                               numberOfPagesChangedCallbacks = {},
                               pageChangedCallbacks = {},

                               --纪录viewPager的{width, height}
                               size = {},
                               currentPageIndex = 0, --从0开始，而接口getViewPagerIndex从1开始
                               currentNumberOfPages = 0,
                            }
                         }
)

function ViewPager.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   if self._isRecycleEnabled ~= nil then
      self:onIsRecycleEnabledChanged("isRecycleEnabled", nil, self._isRecycleEnabled)
   end
   if self._items == nil then
      self._items = {}
   end

   if self._canAutoPaging then
      self:onCanAutoPagingChanged("canAutoPaging", nil, self._canAutoPaging)
   end
   if self._autoPagingInterval then
      self:onAutoPagingIntervalChanged("autoPagingInterval", nil, self._autoPagingInterval)
   end

   if platform.isIOS() then
      self:initEventListener()
   end

   if self._adapter then
      self:onAdapterChanged("adapter", nil, self._adapter)
   end

   self._size = {}
end

function ViewPager.prototype:createPlatFormView()
   return PlatformViewPager(self)
end

function ViewPager.prototype:createRenderObject()
   return ContainerRenderObject(self)
end

function ViewPager.prototype:onLayoutComplete()
   Node.prototype.onLayoutComplete(self)

   -- local width = self:computedWidth()
   -- local height = self:computedHeight()
   -- print("zzz initViewPagerFrame, width=", width, "height=", height)
   -- if self._dir == VBox then
   --    self:setContentSize{width, height*3}
   -- else
   --    self:setContentSize{width*3, height}
   -- end

   local width = self._renderObject:getRenderStyle().width
   local height = self._renderObject:getRenderStyle().height
   if self._size.width ~= width or self._size.height ~= height then
      self:reloadData()
      self._size.width = width
      self._size.height = height
   end
end

function ViewPager.prototype:onNumberOfPagesChanged(prop, old, new)
   for cb, isExist in pairs(self._numberOfPagesChangedCallbacks) do
      if isExist then
         cb(old, new)
      end
   end
   if new then
      self._currentNumberOfPages = new
   end
end

function ViewPager.prototype:onCanAutoPagingChanged(prop, old, new)
   if new == nil then
      print("warn running: canAutoPaging is nil")
      return
   end
   self._pv:setCanAutoPaging(new)
end

function ViewPager.prototype:onAutoPagingIntervalChanged(prop, old, new)
   if type(new) ~= "number" then
      print("warn running: invalid type of autoPagingInterval")
      return
   end
   self._pv:setAutoPagingInterval(new)
end

-- iOS native回调的接口
-- oldPageId, pageId从0开始
function ViewPager.prototype:doPageChangedListeners(oldPageId, pageId)
   for cb, isExist in pairs(self._pageChangedCallbacks) do
      if isExist then
         cb({oldPageId=oldPageId, pageId=pageId})
      end
   end
   self._currentPageIndex = pageId
end

function ViewPager.prototype:onAdapterChanged(prop, old, new)
   self._pv:setAdapter(new)
   if new then
      new:setViewPager(self)
      -- self._currentNumberOfPages = new:numberOfPages()
   end
end

function ViewPager.prototype:onIsRecycleEnabledChanged(prop, old, new)
   if new ~= nil then
      self._pv:setIsRecycleEnabled(new)
   end
end

function ViewPager.prototype:onItemsChanged(prop, old, new)
   if not platform.isIOS() then
      Node.prototype.onItemsChanged(self, prop, old, new)
   end
end

function ViewPager.prototype:onShowsVerticalScrollIndicatorChanged(name, old, new)
   if new then
      self._pv:setShowsVerticalScrollIndicator(new)
   end
end

function ViewPager.prototype:onShowsHorizontalScrollIndicatorChanged(name, old, new)
   if new then
      self._pv:setShowsHorizontalScrollIndicator(new)
   end
end

function ViewPager.prototype:setFrameSize(width, height)
   self:setWidth(width)
   self:setHeight(height)
   self:reloadData()
end

-- function ViewPager.prototype:onAlwaysBounceVerticalChanged(name, old, new)
-- end

-- function ViewPager.prototype:onAlwaysBounceHorizontalChanged(name, old, new)
-- end

function ViewPager.prototype:reloadData()
   -- print(debug.traceback())
   self._pv:notifyDataChanged()
end

function ViewPager.prototype:getContentOffset()
   return self._pv:getContentOffset()
end

-- index 从1开始
function ViewPager.prototype:getViewPagerIndex()
   return self._pv:getViewPagerIndex() + 1
end

-- iOS无动画
-- index 从1开始
function ViewPager.prototype:setViewPagerIndex(index, bAnim)
   index = index - 1
   self._pv:setViewPagerIndex(index, bAnim)
end

function ViewPager.prototype:pageToPrev(bAnim)
   if bAnim == nil then bAnim = true end
   self._pv:pageToPrev(bAnim)
end

function ViewPager.prototype:pageToNext(bAnim)
   if bAnim == nil then bAnim = true end
   self._pv:pageToNext(bAnim)
end

function ViewPager.prototype:addEventListener(evtName, cb)
   if evtName == "numberOfPagesChanged" then
      self._numberOfPagesChangedCallbacks[cb] = true
      local disposable = Disposable.Disposable(function()   
            self._numberOfPagesChangedCallbacks[cb] = nil        
         end)
      return disposable
   end
   
   if platform.isIOS() then
      if evtName == "pagechanged" then --iOS平台下，拦截scrollview的pagechanged监听
         self._pageChangedCallbacks[cb] = true
         local disposable = Disposable.Disposable(function()
               self._pageChangedCallbacks[cb] = nil
            end)
         return disposable
      elseif evtName == "offsetchanged" or evtName == "didEndOffset" or evtName == "didEndOffsetByProgram" then
         local cb_wrap = function(offset)
            self:convertOffsetValue(offset)
            cb(offset)
         end
         return Node.prototype.addEventListener(self, evtName, cb_wrap)
      end
   end
   
   if platform.isIOS() then
      return Node.prototype.addEventListener(self, evtName, cb)
   else
      return self._pv:addEventListener(evtName, cb)
   end
end

function ViewPager.prototype:removeEventListener(evtName, cb)
   if evtName == "numberOfPagesChanged" then
      self._numberOfPagesChangedCallbacks[cb] = nil
      return
   end

   return Node.prototype.removeEventListener(self, evtName, cb)
end

function ViewPager.prototype:setContentSize(size)
   self._pv:setContentSize(size)
end

if platform.isIOS() then
   function ViewPager.prototype:initEventListener()
      -- 因为offsetchanged事件已经被封装，所以这里直接通过Node调用，避免被包一层
      Node.prototype.addEventListener(self, "didEndOffset", function()
            self._pv:didEndOffset()
         end)
      Node.prototype.addEventListener(self, "didEndOffsetByProgram", function()
            self._pv:didEndOffset()
         end)
      self:addEventListener("startscroll", function()
            self:setUserInteractionEnabled(false)
         end)
    end

   function ViewPager.prototype:setScrollEnabled(bEnabled)
      self._pv:setScrollEnabled(bEnabled)
   end

   --目前仅支持top方向上的loadmore
   function ViewPager.prototype:refreshableInsetForDirection(direction)
      print("call ViewPager.prototype:refreshableInsetForDirection")
      if direction ~= RefreshDirectionTop or nil == self._pullRefreshIndicatorView then
         return 0
      end

      --print("call ViewPager.prototype:refreshableInsetForDirection1")
      local robj = self._pullRefreshIndicatorView._renderObject
      if nil == robj then
        return 0
      end

      --print("call ViewPager.prototype:refreshableInsetForDirection2")
      local rstyle = robj:getRenderStyle()
      --print(tostring(rstyle))
      if nil == rstyle then
        return 0
      end

      --print("call ViewPager.prototype:refreshableInsetForDirection3")
      --print(table.tostring(rstyle))
      return rstyle.height
   end

   ----------load more------------
   function ViewPager.prototype:canRefreshInDirection(direction)
      --print("call ScrollView.prototype:canRefreshInDirection")
      return direction == RefreshDirectionTop and self._pullRefreshIndicatorView ~= nil
   end
else
   --整个接口有必要么？
   function ViewPager.prototype:removeAllChildren()
      self._pv:removeAllChildren()
   end
end

-- private functions
if platform.isIOS() then
   -- iOS中，因为viewpager是用scrollview实现的，scrollview仅维护3个或2个子view
   -- 所以offsetchanged的offset值在这里是错误的，需要我们根据当前的pageindex进行换算成使用者希望的offset值
   function ViewPager.prototype:convertOffsetValue(offset)
      if self._adapter == nil or self._currentNumberOfPages == nil then
         return
      end

      if not self._isRecycleEnabled and self._currentPageIndex == 0 then
          return
      end

      local width = self._renderObject:getRenderStyle().width
      -- local height = self._renderObject:getRenderStyle().height
      
      offset.x = offset.x - width + self._currentPageIndex * width

      if self._isRecycleEnabled and offset.x < 0 then
         offset.x = self._currentNumberOfPages * width + offset.x
      end
      -- print("new x = ", offset.x)
      -- offset.y = offset.y - height + self._currentPageIndex * height
   end
end

