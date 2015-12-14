require "stdlib/class/Class"

if platform.isIOS() then
   require "ios.view.PlatformScrollView"
else
end

--[[
   events:
        startscroll: 无参数
        pagechanged: {oldPageId=, pageId=}
        didEndOffset: {x=, y=}
]]

ScrollView = Class.Class("ScrollView",
                         {
                            base=Container,

                            properties={
                               --contentSize默认为scrollView的size
                               contentSize = Class.undefined,
                               pagingEnabled = Class.undefined,
                               contentinset = Class.undefined,
                               showsVerticalScrollIndicator = true,
                               showsHorizontalScrollIndicator = true,
                               alwaysBounceVertical = false,
                               alwaysBounceHorizontal = false,
                               
                               scrollEnabled = Class.undefined,

                               --支持下拉更多
                               pullRefreshIndicatorView = Class.undefined,
                               pullRefreshDirection = Class.undefined,
                           
                            }
                         }
)

--可以同时允许多个方向的loadmore，所以pullRefreshDirection使用这里的bitmask
RefreshingDirectionNone    = 0
RefreshingDirectionTop     = 1
RefreshingDirectionLeft    = 2
RefreshingDirectionBottom  = 4
RefreshingDirectionRight   = 8

--从native传递过来的direction
RefreshDirectionTop = 0
RefreshDirectionLeft = 1
RefreshDirectionBottom = 2
RefreshDirectionRight = 3

function ScrollView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
   
   if self._contentSize then
      self:onContentSizeChanged("contentSize", nil, self._contentSize)
   end
   
   if self._pagingEnabled then
      self:onPagingEnabledChanged("pagingEnabled", nil, self._pagingEnabled)
   end
   if self._contentinset then
      self:onContentinsetChanged("contentinset", nil, self._contentinset)
   end
   if self._showsVerticalScrollIndicator ~= nil then
      self:onShowsVerticalScrollIndicatorChanged("showsVerticalScrollIndicator", nil, self._showsVerticalScrollIndicator)
   end
   if self._showsHorizontalScrollIndicator ~= nil then
      self:onShowsHorizontalScrollIndicatorChanged("showsHorizontalScrollIndicator", nil, self._showsHorizontalScrollIndicator)
   end
   
   if self._alwaysBounceVertical ~= nil then
      self:onAlwaysBounceVerticalChanged("alwaysBounceVertical", nil, self._alwaysBounceVertical)
   end

   if self._alwaysBounceHorizontal ~= nil then
      self:onAlwaysBounceHorizontalChanged("alwaysBounceHorizontal", nil, self._alwaysBounceHorizontal)
   end

   if self._pullRefreshIndicatorView ~= nil then
      self:onPullRefreshIndicatorViewChanged("pullRefreshIndicatorViewChanged", nil, self._pullRefreshIndicatorView)
   end
   
   if self._scrollEnabled ~= nil then
      self:onScrollEnabledChanged("scrollEnabled", nil, self._scrollEnabled)
   end
end

function ScrollView.prototype:onLayoutComplete()
   Container.prototype.onLayoutComplete(self)

   if self._contentSize == nil then
      --孩子中最大的宽高
      local robj = self._renderObject
      local rstyle = robj:getRenderStyle()
      
      local maxw, maxh = rstyle.width, rstyle.height

      for _, child in ipairs(self._children) do
         robj = child._renderObject
         rstyle = robj:getRenderStyle()

         if rstyle == nil then
            print(debug.traceback())
         end
         local w = rstyle.left + rstyle.width
         local h = rstyle.top + rstyle.height

         if w > maxw then
            maxw = w
         end
         
         if h > maxh then
            maxh = h
         end
      end

      self._pv:setContentSize({maxw,maxh})
   end

--   self._pv['handler']:setClipsToBounds(false)
--   self._pv['handler']:setPagingEnabled(true)
--      self._pv:setPagingEnabled(true)
end

function ScrollView.prototype:onContentinsetChanged(name, old, new)
   self._pv:setContentinset(new)
end

function ScrollView.prototype:onContentSizeChanged(name, old, new)
   self._pv:setContentSize(new)
end

function ScrollView.prototype:onPagingEnabledChanged(name, old, new)
   self._pv:setPagingEnabled(new)
end

function ScrollView.prototype:createPlatFormView()
   local pv = PlatformScrollView(self)
   return pv
end

function ScrollView.prototype:onShowsVerticalScrollIndicatorChanged(name, old, new)
   self._pv:setShowsVerticalScrollIndicator(new)
end

function ScrollView.prototype:onShowsHorizontalScrollIndicatorChanged(name, old, new)
   self._pv:setShowsHorizontalScrollIndicator(new)
end

function ScrollView.prototype:onAlwaysBounceVerticalChanged(name, old, new)
   if platform.isIOS() then
      self._pv:setAlwaysBounceVertical(new)
   end
end

function ScrollView.prototype:onAlwaysBounceHorizontalChanged(name, old, new)
   if platform.isIOS() then
      self._pv:setAlwaysBounceHorizontal(new)
   end
end

function ScrollView.prototype:getContentOffset()
   return self._pv:getContentOffset()
end

function ScrollView.prototype:setContentOffset(offset, bAni)
   self._pv:setContentOffset(offset, bAni)
end

function ScrollView.prototype:onScrollEnabledChanged(name, old, new)
   self._pv:setScrollEnabled(new)
end

----------load more------------
function ScrollView.prototype:canRefreshInDirection(direction)
   --print("call ScrollView.prototype:canRefreshInDirection")
   return direction == RefreshDirectionTop and self._pullRefreshIndicatorView ~= nil
end

--目前仅支持top方向上的loadmore
function ScrollView.prototype:refreshableInsetForDirection(direction)
   --print("call ScrollView.prototype:refreshableInsetForDirection")
   if direction ~= RefreshDirectionTop or nil == self._pullRefreshIndicatorView then
      return 0
   end

   --print("call ScrollView.prototype:refreshableInsetForDirection1")
   local robj = self._pullRefreshIndicatorView._renderObject
   if nil == robj then
      return 0
   end

   --print("call ScrollView.prototype:refreshableInsetForDirection2")
   local rstyle = robj:getRenderStyle()
   --print(tostring(rstyle))
   if nil == rstyle then
      return 0
   end

   --print("call ScrollView.prototype:refreshableInsetForDirection3")
   --print(table.tostring(rstyle))
   return rstyle.height
end

--如果希望有不同的方式放置indicatornew，需要重载这个方法
function ScrollView.prototype:onPullRefreshIndicatorViewChanged(prop, old, new)
	if platform.isIOS() then
   --print("ScrollView.prototype:onPullRefreshIndicatorViewChanged")
   if old then
      old:removeFromParent()
   end

   if nil == new then
      return
   end

   if self._pullRefreshDirection == RefreshingDirectionTop then
   else
      return
   end

   --print("______tableview add indicator view and start do layout")
   self:addChild(new)
   self:layout()
   --print("______tableview after layout")

   local robj = new._renderObject
   if not robj then return end

   local rstyle = robj:getRenderStyle()
   if nil == rstyle then
      return
   end

   if self._pullRefreshDirection == RefreshingDirectionTop then
       new:setTop(-rstyle.height)
   end
   print(table.tostring(rstyle))
   print(tostring(new:getTop()))
   print("ScrollView.prototype:onPullRefreshIndicatorViewChanged1")
   end
end

function ScrollView.prototype:startRefreshingDirection(direction, bAni)
   self._pv:startRefreshingDirection(direction, bAni)
end

function ScrollView.prototype:finishRefreshingDirection(direction, bAni)
   self._pv:finishRefreshingDirection(direction, bAni)
end
if not platform.isIOS() then
function ScrollView.prototype:addEventListener(evtName, cb)
     return self._pv:addEventListener(evtName, cb)

end

function ScrollView.prototype:onPullRefreshDirectionChanged(prop, old, new)
  print("scrollview ....onPullRefreshDirectionChanged"..new)
    self._pv:setPullRefreshDirection(new)
end
end