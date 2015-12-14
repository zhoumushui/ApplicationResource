PlatformImageView = createNewPlatformView(View)

--@override
--@platform
function PlatformImageView:newPlatformView(...)
	self["type"]="ImageView"
	return ViewOwner:createView("ImageView",currentContext)
end

function PlatformImageView:setImageWithUrl(url)
end


function PlatformImageView:setSrc(url)

	local imgurl = url

	if string.starts(url,"app://") then

			local appName = lightappInfo.appName	
			imgurl =  string.gsub(url,"app://","app://"..appName.."/")
	end
	ViewOwner['ImageView']["setImageWithUrl.(Landroid/widget/ImageView;Ljava/lang/String;)V"](ViewOwner['ImageView'],self['handler'],imgurl)
	--to nothing
end


function PlatformImageView:blured()
	self["handler"]["blured.()V"](self["handler"])
end


function PlatformImageView:setAsLoadingIndicator()
	
  ViewOwner['ImageView']["setAsLoadingIndicator.(Landroid/widget/ImageView;)V"](ViewOwner['ImageView'],self["handler"])
end

function PlatformImageView:stopLoadingIndicator()
  ViewOwner['ImageView']["stopLoadingIndicator.(Landroid/widget/ImageView;)V"](ViewOwner['ImageView'],self["handler"])
end



function PlatformImageView:setContentMode(new)
	self["handler"]["setContentMode.(Ljava/lang/String;)V"](self["handler"],new)
end

function PlatformImageView:setCornerRadius(new)
	self["handler"]["setCornerRadius.(F)V"](self["handler"],new)
end

function PlatformImageView:setNighty(new)
	self["handler"]["setNighty.(Z)V"](self["handler"],new)

end

function PlatformImageView:addEventListener(evtName, cb)
	View.initUUIDCallback(self)

	
	if evtName == "load" then

  	  local viewclick_cb={}
	  function viewclick_cb.onLoad(v)
			cb(v)	
	  end
	   self.__viewcbs[evtName] = viewclick_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.ImageLoadListener',self["uuid"],evtName)	   
	   self["handler"]["setImageLoadListener.(Lcom/netease/colorui/interfaces/ImageLoadListener;)V"]( self["handler"],listenerProxy)   
	elseif evtName == "error" then


	else
		View.addEventListener(self,evtName,cb)
	end

end
