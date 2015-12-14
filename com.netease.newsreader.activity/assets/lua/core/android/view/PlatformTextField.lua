PlatformTextField = createNewPlatformView(PlatformEditText)

--@override
--@platform
function PlatformTextField:newPlatformView(absView, ...)
	self["type"]="TextField"
	print('platformtextfieldd')
	  local handler =  ViewOwner:createView("EditText",currentContext)
	  handler['setSingleLine.(Z)V'](handler,true)
	  --17 == Gravity.Center
	  --16==CENTER_VERTICAL
	  handler['setGravity.(I)V'](handler,16)
	  return handler

end

function PlatformTextField:setSecureTextEntry(b)
		self["handler"]["setColorUISecureTextEntry.(Landroid/widget/EditText;Z)V"](self["handler"],b)
end

function PlatformTextField:addEventListener(evtName,cb)
	View.initUUIDCallback(self)
	--willBeginEdit
	--endEdit

   if evtName == "willBeginEdit" then
  		local viewtouch_cb={}
		function viewtouch_cb.onGet()		
			cb()				
		end
		self.__viewcbs[evtName] = viewtouch_cb
	   local touchProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.GetFocusListener',self["uuid"],evtName)
	   self["handler"]["setGetFocusListener.(Lcom/netease/colorui/interfaces/GetFocusListener;)V"](self["handler"],touchProxy)
  	 elseif evtName == "endEdit" then
  	 	local viewtouch_cb={}
		function viewtouch_cb.onLost()		
			cb()				
		end
		self.__viewcbs[evtName] = viewtouch_cb
	   local touchProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.LostFocusListener',self["uuid"],evtName)
	   self["handler"]["setLostFocusListener.(Lcom/netease/colorui/interfaces/LostFocusListener;)V"](self["handler"],touchProxy)
	elseif evtName == "textChange" then
  	 	local viewtouch_cb={}
		function viewtouch_cb.onTextChange()		
			cb()				
		end
		self.__viewcbs[evtName] = viewtouch_cb
	   local touchProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.TextChangeListener',self["uuid"],evtName)
	   self["handler"]["setTextChangeListener.(Lcom/netease/colorui/interfaces/TextChangeListener;)V"](self["handler"],touchProxy)
  	end

end


