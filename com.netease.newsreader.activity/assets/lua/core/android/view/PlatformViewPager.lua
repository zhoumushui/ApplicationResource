PlatformViewPager = createNewPlatformView(View)

function PlatformViewPager:newPlatformView(absView, ...)
   self["type"]="ViewPager"
   return ViewOwner:createView("ViewPager",currentContext)
end

--@platform
--[[
function PlatformViewPager:setContentSize(s)
 --  print("set contentSize:")
  -- print(CGSize(s[1], s[2]))
    --ViewOwner.HorizontalScrollView["setContentSize.(Lcom/netease/colorui/view/HorizontalColorScrollView;II)V"](ViewOwner.HorizontalScrollView,self['handler'],s[1], s[2])
  
  --self['handler']:setContentSize(CGSize(s[1], s[2]))
end
]]

function PlatformViewPager:setAdapter(adapter)
   self["handler"]["setAdapter.(Lcom/netease/colorui/view/model/ColorUIPageAdapter;)V"](self["handler"], adapter._pv)
end

function PlatformViewPager:setShowsVerticalScrollIndicator(s)
   self["handler"]["setVerticalScrollBarEnabled.(Z)V"](self["handler"], s)
end

function PlatformViewPager:setShowsHorizontalScrollIndicator(s)
--   self['handler']:setShowsHorizontalScrollIndicator(s)
end

function PlatformViewPager:setPagingEnabled(s)
--   self['handler']:setPagingEnabled(s)
end

function PlatformViewPager:setContentinset(s)
end

function PlatformViewPager:setAlwaysBounceVertical(b)
  print("PlatformScrollView:setAlwaysBounceVertical")
end
   
function PlatformViewPager:setAlwaysBounceHorizontal(b)
    print("PlatformScrollView:setAlwaysBounceHorizontal")
end

function PlatformViewPager:getViewPagerIndex()
   return self["handler"]["getViewPagerIndex.()I"](self["handler"])
end

function PlatformViewPager:setViewPagerIndex(index, bAnim)
   self["handler"]["setViewPagerIndex.(IZ)V"](self["handler"],index, bAnim)
end

function PlatformViewPager:getContentOffset()
   local data = self["handler"]["getContentOffset.()Ljava/lang/String;"](self["handler"])
   local offset = cjson.decode(data)
   offset.x = SystemInfo:getDP(offset.x)
   offset.y = SystemInfo:getDP(offset.y)
   return offset
end

function PlatformViewPager:notifyDataChanged()
   self["handler"]["notifyDataChanged.()V"](self["handler"])
end

function PlatformViewPager:addEventListener(evtName, cb)
   if evtName == nil then error("evtName should not be nil") end
   
   if evtName == "pagechanged" then
      local pageChanged_cb = function(json)
         local pageInfo = cjson.decode(json)
         cb(pageInfo)
      end
      View.insertUUIDCallback(self, evtName, "onResponse", pageChanged_cb)
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.ColorUIResponseListener',self["uuid"],evtName)
      self["handler"]["setPageChangedListener.(Lcom/netease/colorui/lightapp/ColorUIResponseListener;)V"](self["handler"],listenerProxy)
   elseif evtName == "startscroll" then
      local startScroll_cb = function()
         cb()
      end
      View.insertUUIDCallback(self, evtName, "onInvoke", startScroll_cb)
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.ColorUIInvokeListener',self["uuid"],evtName)
      self["handler"]["setStartScrollListener.(Lcom/netease/colorui/interfaces/ColorUIInvokeListener;)V"](self["handler"],listenerProxy)
   elseif evtName == "offsetchanged" then
      local offsetChanged_cb = function(json)
         local offset = cjson.decode(json)
         offset.x = SystemInfo:getDP(offset.x)
         offset.y = SystemInfo:getDP(offset.y)
         cb(offset)
      end
      View.insertUUIDCallback(self, evtName, "onResponse", offsetChanged_cb)
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.ColorUIResponseListener',self["uuid"],evtName)
      self["handler"]["setOffsetChangeListener.(Lcom/netease/colorui/lightapp/ColorUIResponseListener;)V"](self["handler"],listenerProxy)
   else
      View.addEventListener(self, evtName, cb)
   end
end

function PlatformViewPager:removeAllChildren()
   self['handler']["removeAllChildren.()V"](self['handler'])
end

function PlatformViewPager:setIsRecycleEnabled(b)
   self['handler']["setIsRecycleEnabled.(Z)V"](self['handler'], b)
end

function PlatformViewPager:pageToPrev(bAnim)
   self['handler']["pageToPrev.(Z)V"](self['handler'], bAnim)
end

function PlatformViewPager:pageToNext(bAnim)
   self['handler']["pageToNext.(Z)V"](self['handler'], bAnim)
end

function PlatformViewPager:setCanAutoPaging(b)
   self['handler']["setCanAutoPaging.(Z)V"](self['handler'], b)
end

function PlatformViewPager:setAutoPagingInterval(interval)
   self['handler']["setAutoPagingInterval.(D)V"](self['handler'], interval)
end