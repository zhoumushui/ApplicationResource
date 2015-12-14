module("RefreshTableView", package.seeall)

require("colortouch.tableview.HostRefreshView")

local refreshViewTop = platform.isIOS() and 64 or 0
local refreshViewHeight = platform.isIOS() and getApplication():getScreenHeightUnit() - refreshViewTop or 0
local refreshViewWidth = platform.isIOS() and getApplication():getScreenWidthUnit() or 0

local createRefreshLoadingView = function()
   local HostRefreshView = HostRefreshView.HostRefreshView
   local hostClassName = platform.isIOS() and "CTNTESBeneatsView" or ""
   local refreshView = HostRefreshView({hostClassName = hostClassName,
                                        backgroundColor=Globals.getBackgroundColor(),})

   refreshView:setLeft(0):setTop(refreshViewTop):setWidth(refreshViewWidth):setHeight(refreshViewHeight)

   return refreshView
end

local RefreshTableView = Class.Class("TableView",
                     {
                        base=TableView,
                        
                        properties = {
                           vc = Class.undefined,
                           refreshView = Class.undefined,
                        }
})

function RefreshTableView.prototype:init(inlineprops, ...)
   TableView.prototype.init(self, inlineprops, ...)

   local refreshView = createRefreshLoadingView()
   self:getVc():getView():addChild(refreshView)

   self:setRefreshView(refreshView)
   self:initListeners(refreshView)
end

function RefreshTableView.prototype:initListeners(refreshView)
   local refreshStatus = HostRefreshView.status
   self:addEventListener("refresh", function()
                                 refreshView:setStatus(refreshStatus.refresh)

                                 setTimeout(function()
                                               self:refreshFinish()
                                            end,
                                            3)
   end)

   self:addEventListener("pullToRefresh", function()
                                 refreshView:setStatus(refreshStatus.pullRefresh)
   end)

   self:addEventListener("cancelPullToRefresh", function()
                                 refreshView:setStatus(refreshStatus.calcelRefresh)                          
   end)   

   self:addEventListener("pullPercent", function(evt)
                            refreshView:setPullPercent(evt.x)
   end)
end

function RefreshTableView.prototype:refreshFinish()
   local refreshStatus = HostRefreshView.status
   self:finishRefreshingDirection(RefreshDirectionTop, true)
   self._refreshView:setStatus(refreshStatus.refreshEnded)
end

function RefreshTableView.prototype:canRefreshInDirection(direction)
   return direction == RefreshDirectionTop
end

function RefreshTableView.prototype:refreshableInsetForDirection(direction)
   return platform.isIOS() and self._refreshView:refreshableInset() or 0
end

function RefreshTableView.prototype:onPullRefreshIndicatorViewChanged(prop, old, new)
   if old then 
      old:removeFromParent()
   end

   if new then
      self:addChild(new)
   end
end

return RefreshTableView
