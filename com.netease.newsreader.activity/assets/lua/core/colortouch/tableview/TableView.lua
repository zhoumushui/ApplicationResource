local bit = require("bit")

local getDefaultRefreshIndicatorView = function()
   return Container{
      width=25, height=25,
      backgroundColor = rgba{255,255,255,0},
   }
end

TableView = Class.Class("TableView",
                     {
                        base=Container,
                        properties={
                           dataSource = Class.undefined,
                           contentSize = Class.undefined,
                           pullRefreshIndicatorView = Class.undefined,
                           pullRefreshDirection = Class.undefined,
                           --废弃的属性
                           --bShowSeperator = false,

                           --refresh and loadmore
                           isRefreshable = Class.undefined,
                           --refreshView = Class.undefined,
                           isLoadMorable = false,
                           loadMoreView = Class.undefined,
                        }
})

--[[
   @section(列表控件)   
   @iclass[tableview](
      列表控件，列表item是可复用
   )

   @property[dataSource]{
      tableview关联的数据源
   }
   @property[contentSize]{
      @class[table]
      tableview滚动区域,该属性只针对ios平台有效
   }
   @property[pullRefreshIndicatorView]{
      @class[View]
       下拉刷新时的加载视图，该属性只针对ios有效
   }
   @property[bShowSepertor]{
      @class[bool]
      是否显示分隔栏
   }
   @property[pullRefreshDirection]{
      tableview刷新模式,允许两个方向的刷新，使用bitmask
      RefreshingDirectionNone    
      RefreshingDirectionTop     = 1
      RefreshingDirectionBottom  = 4
   }
   
   @method[reloadData]{
      将数据源刷新到视图
   }
   @method[canRefreshInDirection]{
      是否支持下拉刷新/上拉加载更多
   }
   @method[setContentOffset]{
      --TODO
   }
   @method[refreshableInsetForDirection]{
      --TODO
   }
   @method[finishRefreshingDirection]{
      停止加载视图
   }
   @method[addEventListener]{
      普通事件参考Node类
      @param[evtName]{
         scrollToBottom:tableview滚动到底部的事件（参数：无）
         refresh:列表开始刷新事件,开发者接受到该事件回调后，异步更新后台数据（参数：无）
         offsetchanged: 列表滑动的时候，响应（参数：offset｛x,y｝）
         didEndOffset: 列表停止滑动的时候，响应（参数：offset｛x,y｝）
         startscroll: 列表开始滑动的时候，响应（参数：无）
         itemSelected: 列表中的某一项被选中，响应（参数：section， row）
      }
   }
]]

--可以同时允许多个方向的loadmore，所以pullRefreshDirection使用这里的bitmask
--在android当中，仅能用RefreshingDirectionNone，RefreshingDirectionLeft，RefreshingDirectionRight
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

function TableView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
   if platform.isIOS() then
      if self._contentSize then
         self:onContentSizeChanged("contentSize", nil, self._contentSize)
      end
   end
   
   if self._dataSource then
      self:onDataSourceChanged("dataSource", nil, self._dataSource)
   end
   
   --[[
   -- 废弃的属性
   if self._bShowSeperator ~= nil then
      self:onBShowSeperatorChanged("bShowSeperator", nil, self._bShowSeperator)
   end
   ]]

   if not self._pullRefreshDirection then
      if self._isRefreshable == true then
         self:setPullRefreshDirection(RefreshingDirectionTop)
      elseif self._isRefreshable == false then
         self:setPullRefreshDirection(RefreshingDirectionNone)
      end
   end

   if self._pullRefreshDirection~=nil then
      self:onPullRefreshDirectionChanged("pullRefreshDirection", nil, self._pullRefreshDirection)
   end

   if self._isRefreshable ~= nil then
      self:onIsRefreshableChanged("isRefreshable", nil, self._isRefreshable)
   end

   --refresh indicator
   if platform.isIOS() then
      if self._isRefreshable and not self._pullRefreshIndicatorView then
         self._pullRefreshIndicatorView = getDefaultRefreshIndicatorView()
      end
   end
   if self._pullRefreshIndicatorView ~= nil then
      self:onPullRefreshIndicatorViewChanged("pullRefreshIndicatorViewChanged", nil, self._pullRefreshIndicatorView)
   end
   
   if self._isLoadMorable then
      self:onIsLoadMorableChanged("isLoadMorable", nil, self._isLoadMorable)
   end

  -- print("self._pullRefreshIndicatorView=", self._pullRefreshIndicatorView)
   --print("self._pullRefreshDirection=", self._pullRefreshDirection)
   --print("self._isRefreshable=", self._isRefreshable)

   self:addEventListener("refresh", function()
      self:_tryRefresh()
   end)
   self:addEventListener("scrollToBottom", function()
      self:_tryLoadMore()
   end)
end

--@override
function TableView.prototype:createPlatFormView()
   return PlatformTableView(self)
end

if platform.isIOS() then
function TableView.prototype:getContentSize()
   return self._pv:getContentSize()
end

--[[
function TableView.prototype:onContentSizeChanged(name, old, new)
   self._pv:setContentSize(new)
end
]]
end

function TableView.prototype:setShowsVerticalScrollIndicator(b)
   self._pv:setShowsVerticalScrollIndicator(b)
end

function TableView.prototype:setShowsHorizontalScrollIndicator(b)
   self._pv:setShowsHorizontalScrollIndicator(b)
end

function TableView.prototype:reloadData()
   self._pv:reloadData()
end

function TableView.prototype:onDataSourceChanged(prop, old, new)
   --print("onDataSourceChanged")
   --print(tostring(new))

   self._pv:setDataSource(new)
   if self._dataSource then
      self._dataSource:setTableView(self)
   end
   self._pv:reloadData()
end

function TableView.prototype:canRefreshInDirection(direction)
   if platform.isIOS() then
      --print("call TableView.prototype:canRefreshInDirection")
      if self._pullRefreshDirection ~= nil then
         return bit.band(bit.lshift(1,direction), self._pullRefreshDirection) ~= 0
      end
      return false
   else
      --print("call TableView.prototype:canRefreshInDirection")
      if self._pullRefreshDirection ~= nil then
         if bit.band(bit.lshift(1,direction), self._pullRefreshDirection) ~= 0 then
            return (direction == RefreshingDirectionTop) or (direction == RefreshingDirectionBottom)
         end
      end
      
      return false
      --return direction == RefreshDirectionTop and self._pullRefreshIndicatorView ~= nil
   end
end

--目前仅支持top,bottom方向上的loadmore
function TableView.prototype:refreshableInsetForDirection(direction)
   --print("call TableView.prototype:refreshableInsetForDirection1")
   if platform.isIOS() then
      if self._pullRefreshIndicatorView == nil then
         return 0
      end
   else
      if direction ~= RefreshDirectionTop or nil == self._pullRefreshIndicatorView then
         return 0
      end
   end

   local robj = self._pullRefreshIndicatorView._renderObject
   if nil == robj then
      return 0
   end

   --print("call TableView.prototype:refreshableInsetForDirection2")
   local rstyle = robj:getRenderStyle()
   --print(tostring(rstyle))
   if nil == rstyle then
      return 0
   end

   --print("call TableView.prototype:refreshableInsetForDirection3")
   --print(table.tostring(rstyle))
   return rstyle.height
end

--如果希望有不同的方式放置indicatornew，需要重载这个方法
function TableView.prototype:onPullRefreshIndicatorViewChanged(prop, old, new)
if platform.isIOS() then
   --print("TableView.prototype:onPullRefreshIndicatorViewChanged")
   if old then
      old:removeFromParent()
   end

   if nil == new then
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

--   print(table.tostring(rstyle))
--   print(tostring(new:getTop()))
--   print("TableView.prototype:onPullRefreshIndicatorViewChanged1")
end
end

--[[
-- 废弃的属性
function TableView.prototype:onBShowSeperatorChanged(prop, old, new)
   if platform.isIOS() then
      self._pv:setBShowSeperatorChanged(new)
   end
end
]]

function TableView.prototype:startRefreshingDirection(direction, bAni)
   self._pv:startRefreshingDirection(direction, bAni)
end

function TableView.prototype:finishRefreshingDirection(direction, bAni)
   self._pv:finishRefreshingDirection(direction, bAni)
end

function TableView.prototype:onPullRefreshDirectionChanged(prop, old, new)
   if self._isRefreshable == true and new == RefreshingDirectionNone then
      error("Refresh direction cannot be RefreshingDirectionNone in a refreshable tableView")
   elseif self._isRefreshable == false and new ~= RefreshingDirectionNone then
      if platform.isIOS() then
         error("When isRefreshable == false, pullRefreshDirection must be RefreshingDirectionNone")
      else
         if new == RefreshingDirectionTop or new == RefreshingDirectionBottom then
            error("When isRefreshable == false, pullRefreshDirection cannot be RefreshingDirectionTop or RefreshingDirectionBottom")
         end
      end

   --[[
   elseif not self._isRefreshable and new ~= RefreshingDirectionNone then
      if platform.isIOS() then
         if self:canRefreshInDirection(RefreshingDirectionTop) or self:canRefreshInDirection(RefreshingDirectionBottom) then
            self._isRefreshable = true
         end
      else
         self._isRefreshable = true
      end
      ]]
   end

   if not platform.isIOS() then
      self._pv:setPullRefreshDirection(new)
   end
end

function TableView.prototype:setContentOffset(new, bAni)
   self._pv:setContentOffset(new, bAni)
end

function TableView.prototype:onIsRefreshableChanged(prop, old, new)
   if self._pullRefreshDirection == RefreshingDirectionNone and new == true then
      self:setPullRefreshDirection(RefreshingDirectionTop)
   elseif self._pullRefreshDirection ~= RefreshingDirectionNone and new == false then
      self:setPullRefreshDirection(RefreshingDirectionNone)
   end
end

function TableView.prototype:onIsLoadMorableChanged(prop, old, new)
   --
   print("onIsLoadMorableChanged")
end

--@override
function TableView.prototype:refresh()
   print("tableView refresh")
end

--@Override
function TableView.prototype:loadMore()
   print("load more")
end

--[[
--在tableview停止滚动的时候，让滚动条消失
--暂时仅在android上有效
function TableView.prototype:setScrollbarFadingEnabled(b)
   if not platform.isIOS() then
      self._pv:setScrollbarFadingEnabled(b)
   end
end
]]

-------------------------------
-- private functions
-- cannot be override
-------------------------------
function TableView.prototype:_tryRefresh()
   print("_tryRefresh")
   if self._isRefreshable then
      self:_notifyToReloadData()
      if self._dataSource then
         self._dataSource:refresh(self)
      end
      self:refresh()
   end
end

function TableView.prototype:_tryLoadMore()
   if self._isLoadMorable then
      self:_notifyToReloadData()
      if self._dataSource and self._dataSource:_shouldShowLoadMoreView() then
         self._dataSource:loadMore(self)
      end
      self:loadMore()
   end
end

-- android中使用的函数，为避免numberOfSession或者numberOfRowsInSession返回的值发生变化
-- 而有可能导致tableview崩溃的问题，因此colortouch内部会主动调用notifyToReloadData()
-- Android native代码getCount()中主动触发reloadData
function TableView.prototype:_notifyToReloadData()
   if not platform.isIOS() then
      self._pv:notifyToReloadData()
   end
end