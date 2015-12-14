
PlatformNTESPlaceHolderLoadingView = createNewPlatformView(View)

--@override
--@platform
function PlatformNTESPlaceHolderLoadingView:newPlatformView(absView, ...)
	self["type"]="PlaceHolderLoadingView"
   	local loadingView = luabridge.newInstance("com/netease/nr/colortouch/NrPlaceHolderLoadingView.(Landroid/content/Context;)V",currentContext)
    return loadingView
end



function PlatformNTESPlaceHolderLoadingView:setState(state)
	self["handler"]["setState.(I)V"](self["handler"],state)	
end
function PlatformNTESPlaceHolderLoadingView:setType(type)
end

function PlatformNTESPlaceHolderLoadingView:setSuggestText(text)
end

function PlatformNTESPlaceHolderLoadingView:setTextColor(color)

end

function PlatformNTESPlaceHolderLoadingView:setNightMode(bNight)
  self["handler"]["applyTheme.(Z)V"]( self["handler"],bNight)
end


function PlatformNTESPlaceHolderLoadingView:addEventListener(evtName, cb,target)
    View.initUUIDCallback(self)
   if evtName =='reload' then
  	   local reload = {}
  	   function reload.onInvoke()
  			cb()
  	   end
	   self.__viewcbs[evtName] = reload
	   local reloadProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.ColorUIInvokeListener',self["uuid"],evtName)
	   self["handler"]["setReloadListener.(Lcom/netease/colorui/interfaces/ColorUIInvokeListener;)V"](self["handler"],reloadProxy)
	end
end


--[[
function PlatformGuaguaKa:setMaskColor(c)
	self["handler"]["setMaskColor.(I)V"](self["handler"],c)	
end
]]
