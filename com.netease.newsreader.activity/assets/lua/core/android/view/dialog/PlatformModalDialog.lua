PlatformModalDialog = createNewPlatformView(View)

function PlatformModalDialog:newPlatformView(absView, ...)
	self['type']="PlatformModalDialog"
  	 if dialogUtil == nil then
  	 		print("")

  	   	  dialogUtil = luabridge.bindClass("com.netease.colorui.view.util.ModalDialogUtil")
  	 end
  	 if dialogUtil ==nil then
  	 		print("why ,dialogUtil should not be nil")
  	 end
 	return  dialogUtil["newDialog.(Landroid/content/Context;)Lcom/netease/colorui/view/ModalDialog;"](dialogUtil,currentContext)
end

function PlatformModalDialog:addSubView(subView)
	self["handler"]["addSubView.(Landroid/view/View;)V"](self["handler"],subView["handler"])
end


function PlatformModalDialog:show()

	dialogUtil["showDialog.(Lcom/netease/colorui/view/ModalDialog;)V"](dialogUtil,self["handler"])

end

function PlatformModalDialog:dismiss()
	dialogUtil["dismissDialog.(Lcom/netease/colorui/view/ModalDialog;)V"](dialogUtil,self["handler"])
end

function PlatformModalDialog:setBgAlpha(a)
	--print("PlatformModalDialog:setBgAlpha..")
   --self["handler"]:setBgAlpha(a)
end

function PlatformModalDialog:setFrame(l, t, w, h)  
	self["handler"]["setFrame.(FFFF)V"](self['handler'],SystemInfo:getPX(l),SystemInfo:getPX(t),SystemInfo:getPX(w),SystemInfo:getPX(h))

end

function PlatformModalDialog:setBackgroundColor(c)
--	ViewOwner['View']["setBackgroundColor.(Landroid/view/View;I)V"](ViewOwner['View'],self['handler'],c)
end

--@platform
function PlatformModalDialog:removeFromParent()
  self["handler"]["cancel.()V"](self["handler"])
  --["removeFromParent.(Landroid/view/View;)V"](ViewOwner['View'],self['handler'])
end




function PlatformModalDialog:preferredSize(size)
		local swidth = size.width
		local sheight = size.height
		local rect = self["handler"]["getPreferredSize.(II)Ljava/lang/String;"](self["handler"],sheight,swidth)
		local _,index = string.find(rect,'_')	
		local rectwidth =tonumber( string.sub(rect,1,index-1))
		local rectheight =tonumber( string.sub(rect,index+1))
  		return {width=rectwidth,height=rectheight};
end


function PlatformModalDialog:addEventListener(evtName, cb)
	-- View.initUUIDCallback(self)
	 self:initUUIDCallback()
    if evtName == "startshow" then

        local dialoginterface={}
        function dialoginterface.onShow(dialog)
          cb() 
        end
        self.__viewcbs[evtName] = dialoginterface
        local listenerProxy  = luabridge.createSoftProxy('android.content.DialogInterface$OnShowListener',self["uuid"],evtName)    
      	self["handler"]["setOnShowListener.(Landroid/content/DialogInterface$OnShowListener;)V"]( self["handler"],listenerProxy)   
    end

end 
