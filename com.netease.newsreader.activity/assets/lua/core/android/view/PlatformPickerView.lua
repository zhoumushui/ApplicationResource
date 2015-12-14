PlatformPickerView = createNewPlatformView(View)

--@override
--@platform
function PlatformPickerView:newPlatformView(absView, ...)
	self["type"]="PickerView"
	return ViewOwner:createView("PickerView",currentContext)
end

--@platform
--@override
function PlatformPickerView:addEventListener(evtName, cb)
	if evtName == "itemclick" then
			View.initUUIDCallback(self)
			local itemclick_cb={}
			function itemclick_cb.onItemSelected(parent,v,position,id)
					cb()
			end		
			self.__viewcbs[evtName] = itemclick_cb  
			local itemselectedProxy = luabridge.createSoftProxy("OnPickerViewItemSelectProxy",self['uuid'],evtName)
		   ViewOwner["PickerView"]["setOnClickListener.(Landroid/view/View;Lcom/netease/colorui/view/PickerView$PickerViewSelectListener;)V"]( ViewOwner["PickerView"], self["handler"],itemselectedProxy)   			
	end
	return 	View.addEventListener(self,evtName,cb)
	
end

function PlatformPickerView:reloadComponent(c)
		print("TODO PlatformPickerView:reloadComponent")

 --  return self["handler"]:reloadComponent(c)
end

function PlatformPickerView:reloadAllComponents()
		print("TODO PlatformPickerView:reloadAllComponents")

 --  return self["handler"]:reloadAllComponents()
end

function PlatformPickerView:selectRowInComponent(r, c, bAni)
  	 self["handler"]['selectRowInComponent.(I)V']( self["handler"],r)
end

function PlatformPickerView:selectedRowInComponent(c)
	return self['handler']['selectedRowInComponent.()I'](self['handler'])
end

function PlatformPickerView:setDataSource(source)
--		print("TODO PlatformPickerView:setDataSource")
		return self["handler"]["setPickVewDataSource.(Lcom/netease/colorui/view/model/PickerViewDataSource;)V"](self["handler"],source["handler"])
  -- return self["handler"]:setDataSource(source["handler"])
end


function PlatformPickerView:preferredSize(size)
		local swidth = size.width
		local sheight = size.height
		local rect = self["handler"]["getPreferredSize.(II)Ljava/lang/String;"](self["handler"],sheight,swidth)
		local _,index = string.find(rect,'_')	
		local rectwidth =tonumber( string.sub(rect,1,index-1))
		local rectheight =tonumber( string.sub(rect,index+1))
  		return {width=rectwidth,height=rectheight};
end 

