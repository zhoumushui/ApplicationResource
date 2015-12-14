PlatformLoadingIndicator = createNewPlatformView(View)
function PlatformLoadingIndicator:newPlatformView(...)
	print('PlatformLoadingIndicator now support...')
   return IOS.UILoadingIndicator_Proxy()
end

function PlatformLoadingIndicator:setIndicatorImgsrc(url)
   self["handler"]:setIndicatorImgsrc(url)
end
