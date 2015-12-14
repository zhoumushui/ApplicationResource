PlatformAlertView = createNewPlatformView(View)

--@override
--@platform
function PlatformAlertView:newPlatformView(absView, ...)
	print("....new platformview ..............AlertDialogUtil")
	if AlertViewCls == nil then
			AlertViewCls = luabridge.bindClass("com.netease.colorui.view.util.AlertDialogUtil")
	end
		print("....new platformview ..............newPlatformView....1")

	return AlertViewCls["newView.(Landroid/content/Context;)Lcom/netease/colorui/view/ColorUIAlertDialog;"](AlertViewCls,currentContext)
end

function PlatformAlertView:show()
   self["handler"]["show.()V"](self["handler"])
end

function PlatformAlertView:setTitle(title)

	self["handler"]["setTitle.(Ljava/lang/String;)V"](self["handler"],title)
end

function PlatformAlertView:setMessage(message)

	self["handler"]["setMessage.(Ljava/lang/String;)V"](self["handler"],message)
end

function PlatformAlertView:setButtons(buttons)

	local jsonbtns = cjson.encode(buttons)
   self["handler"]["setButtons.(Ljava/lang/String;)V"](self["handler"],jsonbtns)
end

function PlatformAlertView:setType(type)

   self["handler"]["setType.(Ljava/lang/String;)V"](self["handler"],type)
end

function PlatformAlertView:setKeyboardType(type)
	self["handler"]["setKeyboardType.(Ljava/lang/String;)V"](self["handler"],type)
end

function PlatformAlertView:setHint(hint)
	self["handler"]["setHint.(Ljava/lang/String;)V"](self["handler"],hint)
end

function PlatformAlertView:addEventListener(evtName,cb)
	View.initUUIDCallback(self)
   if evtName == "click" then
  	  local viewclick_cb={}
	  function viewclick_cb.onClick(index,text)
			cb(index,text)	
	  end
	   self.__viewcbs[evtName] = viewclick_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIAlertDialog$AlertDialogListener',self["uuid"],evtName)	   
	   self["handler"]["setAlertDialogClickListener.(Lcom/netease/colorui/view/ColorUIAlertDialog$AlertDialogListener;)V"]( self["handler"],listenerProxy)   
	end

end

function PlatformAlertView:dismiss()
	self["handler"]["dismiss.()V"](self["handler"])
end

function PlatformAlertView:setContent(content)
	self["handler"]["setEditContent.(Ljava/lang/String;)V"](self["handler"],content)
end

function PlatformAlertView:setTextFieldMaxLength(length)
	self["handler"]["setTextFieldMaxLength.(I)V"](self["handler"],length)
end