require "android/view/View"
PlatformLayout = createNewPlatformView(View)
--		layoututil = luabridge.bindClass("com.netease.colorui.view.util.ViewLayoutUtil")

--@override
--@platform
function PlatformLayout:newPlatformView(...)
	self['type']="FrameLayout"
	return ViewOwner:createView("FrameLayout",currentContext)
end


--设置view
function PlatformLayout:setPlatformView(pv)
	self['handler']  = pv;
	return self;
end

function View:addSubView(subView)	
	ViewOwner.FrameLayout["addSubView.(Landroid/view/View;Landroid/view/View;IIII)V"](ViewOwner.FrameLayout,self['handler'],subView['handler'],SystemInfo:getPX(subView["left"]),SystemInfo:getPX(subView["top"]),SystemInfo:getPX(subView["width"]),SystemInfo:getPX(subView["height"]))		
end


function View:insertSubViewBelowSubView(subView,slidingsubView)
	ViewOwner.FrameLayout["insertSubViewBelowSubView.(Landroid/view/View;Landroid/view/View;Landroid/view/View;IIII)V"](ViewOwner['FrameLayout'],self['handler'],subView['handler'],slidingsubView['handler'],SystemInfo:getPX(subView["left"]),SystemInfo:getPX(subView["top"]),SystemInfo:getPX(subView["width"]),SystemInfo:getPX(subView["height"]))	
end


--@platform
function PlatformLayout:setBackgroundImage(url)

		local imgurl = url
	if string.starts(url,"app://") then

			local appName = lightappInfo.appName	
			imgurl =  string.gsub(url,"app://","app://"..appName.."/")
	end

   ViewOwner['FrameLayout']["setBackgroundImage.(Landroid/view/View;Ljava/lang/String;)V"](ViewOwner['FrameLayout'],self["handler"],imgurl)
end

function View:insertSubviewAtIndex(subView,idx)	
	ViewOwner.FrameLayout["insertSubViewAtIndex.(Landroid/view/View;Landroid/view/View;IIIII)V"](ViewOwner.FrameLayout,self['handler'],subView['handler'],idx,SystemInfo:getPX(subView["left"]),SystemInfo:getPX(subView["top"]),SystemInfo:getPX(subView["width"]),SystemInfo:getPX(subView["height"]))
end


