
PlatformGuaguaKa = createNewPlatformView(View)

--@override
--@platform
function PlatformGuaguaKa:newPlatformView(absView, ...)
	self["type"]="GuaguaKa"
	return ViewOwner:createView("GuaguaKa",currentContext)
end



function PlatformGuaguaKa:setMaskImage(img)
	self["handler"]["setMaskImage.(Ljava/lang/String;)V"](self["handler"],img)	
end


--[[
function PlatformGuaguaKa:setMaskColor(c)
	self["handler"]["setMaskColor.(I)V"](self["handler"],c)	
end
]]
