PlatformHTMLLabel = createNewPlatformView(View)

--@override
--@platform
function PlatformHTMLLabel:newPlatformView(absView, ...)
	self["type"]="HtmlTextView"
	return ViewOwner:createView("HtmlTextView",currentContext)
end

--@platform
function PlatformHTMLLabel:setText(w)
   if w then
 		ViewOwner['HtmlTextView']["setText.(Landroid/widget/TextView;Ljava/lang/String;)V"](ViewOwner['HtmlTextView'],self["handler"],w)
   end
end

--@platform
function PlatformHTMLLabel:setFontSize(s)

	ViewOwner['HtmlTextView']["setTextSize.(Landroid/widget/TextView;F)V"](ViewOwner['HtmlTextView'],self["handler"],SystemInfo:getPX(s))
end

--@platform
function PlatformHTMLLabel:setColor(c)
	ViewOwner['HtmlTextView']["setTextColor.(Landroid/widget/TextView;I)V"](ViewOwner['HtmlTextView'],self["handler"],c)
end

--@platform
function PlatformHTMLLabel:setFontStyle(s)
	ViewOwner['HtmlTextView']["setFontStyle.(Landroid/widget/TextView;Ljava/lang/String;)V"](ViewOwner['HtmlTextView'],self["handler"],s)	
end

--@platform
function PlatformHTMLLabel:setLineSpacing(s)
  -- return self["handler"]:setLineSpacing(s)
end
