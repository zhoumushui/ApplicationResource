PlatformGifImageView = createNewPlatformView(View)

--@override
--@platform
function PlatformGifImageView:newPlatformView(...)
	self["type"]="GifImageView"
	return ViewOwner:createView("GifImageView",currentContext)
end

function PlatformGifImageView:setImageWithUrl(url)
end


function PlatformGifImageView:setSrc(url)

		local imgurl = url

	if string.starts(url,"app://") then

			local appName = lightappInfo.appName	
			imgurl =  string.gsub(url,"app://","app://"..appName.."/")
	end

	self["handler"]["setImageWithUrl.(Ljava/lang/String;)V"](self["handler"],imgurl)
end



function PlatformGifImageView:addEventListener(evtName, cb)
	PlatformImageView.addEventListener(self,evtName,cb)
end
