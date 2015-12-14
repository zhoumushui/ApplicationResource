PlatformButton = createNewPlatformView(View)

--@override
--@platform
function PlatformButton:newPlatformView(absView, ...)
	self["type"]="Button"
	return  ViewOwner:createView("Button",currentContext)
end



function PlatformButton:onClickListener(v)
		 self["owner"]:fireEvent("click", nil)
end

--@platform
--@override
function PlatformButton:addEventListener(evtName, cb)
	--todo 回调不到
    return View.addEventListener( self,evtName, cb)
end


--@platform
function PlatformButton:setText(w)
		self["handler"]["setColorUIText.(Ljava/lang/String;)V"](self["handler"],w)
end

--@platform
function PlatformButton:setFontSize(s)
	elf["handler"]["setColorUITextSize.(F)V"](self["handler"],SystemInfo:getPX(s))
end


--@platform
function PlatformButton:setColor(w)
	self["handler"]["setTextColor.(I)V"](self["handler"],w)
end

--@platform
function PlatformButton:setFontStyle(s)	
	self["handler"]["setFontStyle.(Ljava/lang/String;)V"](self["handler"],s)	
end

--@platform
function PlatformButton:setEnable(bEnabled)
   return self["handler"]["setEnabled.(Z)V"](self["handler"],bEnabled)
 
end


--@platform
function PlatformButton:setActiveColor(w)
   --return self["handler"]:setActiveColor(w)
   --TODO 
end

--@platform
function PlatformButton:setColorWithState(color, state)
   --return self["handler"]:setTitleColor_forState(color, state)
end

--@platform
function PlatformButton:setBackgroundImage(url)
	local imgurl = url
	if string.starts(url,"app://") then

			local appName = lightappInfo.appName	
			imgurl =  string.gsub(url,"app://","app://"..appName.."/")
	end

	self["handler"]["setColorUIBackgroundImage.(Ljava/lang/String;)V"](self["handler"],imgurl)
end

--@platform
function PlatformButton:setBackgroundImageEdgeInset(inset)
 --  self["handler"]:setBackgroundImageEdgeInset(inset)
end


function PlatformButton:setHilightedBackgroundImage(url)
	local imgurl = url
	if string.starts(url,"app://") then

			local appName = lightappInfo.appName	
			imgurl =  string.gsub(url,"app://","app://"..appName.."/")
	end

	self["handler"]["setHilightedBackgroundImage.(Ljava/lang/String;)V"](self["handler"],imgurl)
end




--@platform
--@override
function PlatformButton:addEventListener(evtName, cb,target)
	if target ==nil then
	print("paltform button is nil  ")

	end
   return View.addEventListener(self, evtName, cb,target)
end
