
PlatformEditText = createNewPlatformView(View)

--@override
--@platform
function PlatformEditText:newPlatformView(absView, ...)
	self["type"]="EditText"
	return ViewOwner:createView("EditText",currentContext)
end

--@platform
function PlatformEditText:setHint(str1)
		if str1~=nil and type(str1)~='string' then
			-- if type(str1) ~= 'string' then
			-- 	str1 = str1 .. ""
			-- end	
				str1=str1..""
	end
		self["handler"]["setHint.(Ljava/lang/String;)V"](self["handler"],str1)

end


--@platform
function PlatformEditText:getHint()
		return self["handler"]["getColorUIHint.()Ljava/lang/String;"](ViewOwner['EditText'],self["handler"])
end


--@platform
function PlatformEditText:setText(str1)
		
		if str1~=nil and type(str1)~='string' then
			-- if type(str1) ~= 'string' then
			-- 	str1 = str1 .. ""
			-- end	
				str1=str1..""
		end
		self["handler"]["setColorUIText.(Ljava/lang/String;)V"](self["handler"],str1)

end


--@platform
function PlatformEditText:getText()
		return self["handler"]["getColorUIText.()Ljava/lang/String;"](self["handler"])
end


--@platform
function PlatformEditText:setColor(c)
	self["handler"]["setTextColor.(I)V"](self["handler"],c)
end

--@platform
function PlatformEditText:setFontSize(s)
	self["handler"]["setColorUITextSize.(F)V"](self["handler"],SystemInfo:getPX(s))

end

--@platform
function PlatformEditText:setFontStyle(s)	
	self["handler"]["setFontStyle.(Ljava/lang/String;)V"](self["handler"],s)	
end

--@platform
function PlatformEditText:setLineSpacing(s)
--   return self["handler"]:setLineSpacing(s,0)
end


function PlatformEditText:setHintColor(c)	
	self["handler"]["setHintTextColor.(I)V"](self["handler"],c)	
end

function PlatformEditText:setMaxLength(c)	
	self["handler"]["setMaxLength.(I)V"](self["handler"],c)	
end


