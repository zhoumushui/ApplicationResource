PlatformTableView = createNewPlatformView(View)

--@override
--@platform
function PlatformTableView:newPlatformView(absView, ...)
	self["type"]="TableView"
	return ViewOwner:createView("TableView",currentContext)
end

function PlatformTableView:setDataSource(ds)
   self["handler"]['setAdapter.(Landroid/widget/ListAdapter;)V'](self['handler'],ds._pv);
end

function PlatformTableView:reloadData()
	ViewOwner['TableView']['reloadData.(Lcom/netease/colorui/view/ColoruiListView;)V'](ViewOwner['TableView'],self['handler']);
   --self["handler"]:reloadData()
end

function PlatformTableView:startRefreshingDirection(direction, bAni)
  -- self["handler"]:startRefreshingDirection(direction, bAni)
end



function PlatformTableView:setPullRefreshDirection(new)
     self["handler"]["setPullRefreshDirection.(I)V"](self["handler"],new)

end


function PlatformTableView:finishRefreshingDirection(direction, bAni)
     self["handler"]["finishRefreshingDirection.()V"](self["handler"])

--self["handler"]:finishRefreshingDirection(direction, bAni)
end

function PlatformTableView:setBShowSeperatorChanged(b)
   --self["handler"]:setBShowSeperatorChanged(b)
end


function PlatformTableView:addEventListener(evtName, cb)
  View.initUUIDCallback(self)

   if evtName == "scrollToBottom" then
      local refresh_cb={}
      function refresh_cb.scrollToBottom()
        cb() 
      end
     self.__viewcbs[evtName] = refresh_cb
     local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.TableScrollToBottomListener',self["uuid"],evtName)    
     self["handler"]["setScrollToBottomListener.(Lcom/netease/colorui/interfaces/TableScrollToBottomListener;)V"]( self["handler"],listenerProxy)   

   elseif evtName == "refresh" then
      local refresh_cb={}
      function refresh_cb.onRefresh(v)
        cb(v) 
      end
     self.__viewcbs[evtName] = refresh_cb
     local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColoruiListView$OnColorUIRefreshListener',self["uuid"],evtName)    
     self["handler"]["setColorUIRefreshListener.(Lcom/netease/colorui/view/ColoruiListView$OnColorUIRefreshListener;)V"]( self["handler"],listenerProxy)   
   end
end



function PlatformTableView:setShowsVerticalScrollIndicator(b)
    --TODO android只有一个方向
 --  self._pv:setShowsVerticalScrollIndicator(b)
end

function PlatformTableView:setShowsHorizontalScrollIndicator(b)
      --TODO android只有一个方向

  -- self._pv:setShowsHorizontalScrollIndicator(b)
end

