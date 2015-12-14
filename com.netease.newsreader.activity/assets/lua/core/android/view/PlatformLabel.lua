
PlatformLabel = createNewPlatformView(View)

--@override
--@platform
function PlatformLabel:newPlatformView(absView, ...)
	self["type"]="TextView"
	return ViewOwner:createView("TextView",currentContext)
end

--@platform
function PlatformLabel:setText(str1)
		if str1~=nil and type(str1)~='string' then
				str1=str1..""
	end
		ViewOwner['TextView']["setText.(Landroid/widget/TextView;Ljava/lang/String;)V"](ViewOwner['TextView'],self["handler"],str1)
end

--@platform
function PlatformLabel:setColor(c)
	ViewOwner['TextView']["setTextColor.(Landroid/widget/TextView;I)V"](ViewOwner['TextView'],self["handler"],c)
end

--@platform
function PlatformLabel:setFontSize(s)
	ViewOwner['TextView']["setTextSize.(Landroid/widget/TextView;F)V"](ViewOwner['TextView'],self["handler"],SystemInfo:getPX(s))
end

--@platform
function PlatformLabel:setFontStyle(s)	
	ViewOwner['TextView']["setFontStyle.(Landroid/widget/TextView;Ljava/lang/String;)V"](ViewOwner['TextView'],self["handler"],s)	
end

--@platform
function PlatformLabel:setLineSpacing(s)
--   return self["handler"]:setLineSpacing(s,0)
end

function PlatformLabel:setMaxLines(s)
	ViewOwner['TextView']["setMaxLines.(Landroid/widget/TextView;I)V"](ViewOwner['TextView'],self["handler"],s)	
end

function PlatformLabel:setGravity(new)
	self["handler"]["setColorUIGravity.(Ljava/lang/String;)V"](self["handler"],new)

end
