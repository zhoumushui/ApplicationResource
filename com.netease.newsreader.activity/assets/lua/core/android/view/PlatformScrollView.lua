PlatformScrollView = createNewPlatformView(View)

function PlatformScrollView:newPlatformView(absView, ...)
	self["type"]="ScrollView"
	print('now PlatformScrollView ..............')
	return ViewOwner:createView("ScrollView",currentContext)
end

--@platform
function PlatformScrollView:setContentSize(s)
    self['handler']["setContentSize.(II)V"]( self['handler'],SystemInfo:getPX(s[1]), SystemInfo:getPX(s[2]))

 --  print("set contentSize:")
  -- print(CGSize(s[1], s[2]))
  	--ViewOwner.HorizontalScrollView["setContentSize.(Lcom/netease/colorui/view/HorizontalColorScrollView;II)V"](ViewOwner.HorizontalScrollView,self['handler'],s[1], s[2])
  
 	--self['handler']:setContentSize(CGSize(s[1], s[2]))
end

function PlatformScrollView:setShowsVerticalScrollIndicator(s)
 --  self['handler']:setShowsVerticalScrollIndicator(s)
end

function PlatformScrollView:setShowsHorizontalScrollIndicator(s)
--   self['handler']:setShowsHorizontalScrollIndicator(s)
end
function PlatformScrollView:setPagingEnabled(s)
--   self['handler']:setPagingEnabled(s)
end

function PlatformScrollView:setContentinset(s)

--   print("set content inset @@@@@@@@@@@")
--   print(tostring(s))
--   self['handler']:setContentInset(s)
end


function PlatformScrollView:setScrollEnabled(new)
            
end

function PlatformScrollView:setAlwaysBounceVertical(b)
  print("PlatformScrollView:setAlwaysBounceVertical")
  -- self["handler"]:setAlwaysBounceVertical(b)
end
   
function PlatformScrollView:setAlwaysBounceHorizontal(b)
    print("PlatformScrollView:setAlwaysBounceHorizontal")

   --self["handler"]:setAlwaysBounceHorizontal(b)
end

function PlatformScrollView:setContentOffset(new, bAni)
      print("PlatformScrollView:setContentOffset")

   --self["handler"]:setContentOffset(new.x, new.y, bAni)
end

function PlatformScrollView:getContentOffset()
        print("PlatformScrollView:getContentOffset")

   --local x = self["handler"]:getContentOffsetX()
   --local y = self["handler"]:getContentOffsetY()

   --return {x=x, y=y}
end

function PlatformScrollView:pullRefreshDirection(direction)
            print("PlatformScrollView:pullRefreshDirection.............")

  -- self["handler"]["pullRefreshDirection.(I)V"](self["handler"],direction)
   --self["handler"]:startRefreshingDirection(direction, bAni)
end

function PlatformScrollView:setScrollEnabled(new)
            
end



function PlatformScrollView:setPullRefreshDirection(new)
  print("..................setPullRefreshDirection")
  print("new is..."..new)
     self["handler"]["setPullRefreshDirection.(I)V"](self["handler"],new)

end

function PlatformScrollView:startRefreshingDirection(direction, bAni)
          print("PlatformScrollView:startRefreshingDirection")
 --  self["handler"]["pullRefreshDirection.(I)V"](self["handler"],direction)
   --self["handler"]:startRefreshingDirection(direction, bAni)
end

function PlatformScrollView:finishRefreshingDirection(direction, bAni)
         --   print("PlatformScrollView:finishRefreshingDirection")

   self["handler"]["finishRefreshingDirection.()V"](self["handler"])
end



function PlatformScrollView:addEventListener(evtName, cb)
  View.initUUIDCallback(self)

   if evtName == "refresh" then
      local refresh_cb={}
      function refresh_cb.onRefresh(v)
        cb(v) 
      end
     self.__viewcbs[evtName] = refresh_cb
     local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIScrollView1$OnColorUIRefreshListener',self["uuid"],evtName)    
     self["handler"]["setColorUIRefreshListener.(Lcom/netease/colorui/view/ColorUIScrollView1$OnColorUIRefreshListener;)V"]( self["handler"],listenerProxy)   
   end
end
