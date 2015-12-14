PlatformSwitchButton = createNewPlatformView(View)

--@override
--@platform
function PlatformSwitchButton:newPlatformView(absView, ...)
		self["type"]="SwitchButton"

	return ViewOwner:createView("SwitchButton",currentContext)
end

function PlatformSwitchButton:isOn()
	return	ViewOwner['SwitchButton']["isOn.(Lcom/netease/colorui/view/ColorUISwitchButton;)Z"](ViewOwner['SwitchButton'],self["handler"])

end

function PlatformSwitchButton:setOn(b)
	ViewOwner['SwitchButton']["setOn.(Lcom/netease/colorui/view/ColorUISwitchButton;Z)V"](ViewOwner['SwitchButton'],self["handler"],b)
end

function PlatformSwitchButton:addEventListener(evtName,cb)

	 --PlatformButton.addEventListener(self,evtName, cb)
	View.initUUIDCallback(self)

	-- View.initUUIDCallback(self)

    if evtName == "valueChanged" then
  	  local viewclick_cb={}

	  function viewclick_cb.onValueChange(checkState)
			cb()	
	  end
	  self.__viewcbs[evtName] = viewclick_cb
	  -- im.yixin.ui.widget.SwitchButton$OnChangedListener
	  local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUISwitchButton$SwitchButtonListener',self["uuid"],evtName)	   
	  self["handler"]["setValueChangeListener.(Lcom/netease/colorui/view/ColorUISwitchButton$SwitchButtonListener;)V"]( self["handler"],listenerProxy) 
	else
		View.addEventListener(self,evtName,cb)
	end
end
