PlatformActionSheet = createNewPlatformView(View)

--@override
--@platform
function PlatformActionSheet:newPlatformView(absView, ...)
	ActionSheetCls = luabridge.bindClass("com.netease.colorui.view.util.ActionSheetUtil")
	return ActionSheetCls["newView.(Landroid/content/Context;)Lcom/netease/colorui/view/ActionSheet;"](ActionSheetCls,currentContext)

end

function PlatformActionSheet:showInView(v)
   self["handler"]["show.()V"]( self["handler"])
end

function PlatformActionSheet:setButtons(title, cancel, desctruction, others)
	self["handler"]["setTitle.(Ljava/lang/String;)V"](self["handler"],title)
	self["handler"]["addItem.(Ljava/lang/String;)V"](self["handler"],cancel)
	self["handler"]["addItem.(Ljava/lang/String;)V"](self["handler"],desctruction)
	if others == nil then
		return
	end
   for _, item in ipairs(others) do   	
      self["handler"]["addItem.(Ljava/lang/String;)V"](self["handler"],item)
   end

end
function PlatformActionSheet:addEventListener(evtName, cb)
	View.initUUIDCallback(self)
	
   if evtName == "click" then
  	  local viewitemclick_cb={}
	  function viewitemclick_cb.onClick(idx)
			cb(idx)	
	  end
	   self.__viewcbs[evtName] = viewitemclick_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ActionSheet$OnItemClick',self["uuid"],evtName)	   
	   self["handler"]["setItemClickListener.(Lcom/netease/colorui/view/ActionSheet$OnItemClick;)V"]( self["handler"],listenerProxy)   
	end
	end