PlatformQRView = createNewPlatformView(View)

--@override
--@platform
function PlatformQRView:newPlatformView(absView, ...)
	self["type"]="QRView"
	return ViewOwner:createView("QRView",currentContext)
end

function PlatformQRView:start()
   self["handler"]["start.()V"](self["handler"])
end

function PlatformQRView:stop()
	self["handler"]["stop.()V"](self["handler"])
end

function PlatformQRView:addEventListener(evtName,cb)
	View.initUUIDCallback(self)
   	if evtName == "QRGetResult" then
  	  local viewclick_cb={}
	  function viewclick_cb.onQRResult(result)
			cb(result)	
	  end
	   self.__viewcbs[evtName] = viewclick_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.QRView$OnQRGetResultListener',self["uuid"],evtName)	   
	   self["handler"]["setQRGetResultListener.(Lcom/netease/colorui/view/QRView$OnQRGetResultListener;)V"]( self["handler"],listenerProxy)   
	end
end
