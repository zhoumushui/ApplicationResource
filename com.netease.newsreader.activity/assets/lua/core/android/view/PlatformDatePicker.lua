PlatformDatePicker = createNewPlatformView(View)

--@override
--@platform
function PlatformDatePicker:newPlatformView(...)
	self["type"]="DatePicker"
	return  ViewOwner:createView("DatePicker",currentContext)
end

function PlatformDatePicker:setStartTime(s)
   self["handler"]["setStartTime.(Ljava/lang/String;)V"]( self["handler"],s)
end

function PlatformDatePicker:setEndTime(s)
	   self["handler"]["setEndTime.(Ljava/lang/String;)V"]( self["handler"],s)

end

function PlatformDatePicker:setCurTime(s)
	   self["handler"]["setCurTime.(Ljava/lang/String;)V"]( self["handler"],s)

end

function PlatformDatePicker:setMode(mode)
	   self["handler"]["setMode.(Ljava/lang/String;)V"]( self["handler"],mode)
end

function PlatformDatePicker:getCurTime()
   return self["handler"]["getCurTime.()Ljava/lang/String;"](self["handler"])
end
