PlatformHorizontalScrollView = createNewPlatformView(View)

function PlatformHorizontalScrollView:newPlatformView(absView, ...)
	self["type"]="HorizontalScrollView"
	return ViewOwner:createView("HorizontalScrollView",currentContext)
end

--@platform
function PlatformHorizontalScrollView:setContentSize(s)
end

function PlatformHorizontalScrollView:setShowsVerticalScrollIndicator(s)
 --  self['handler']:setShowsVerticalScrollIndicator(s)
end
function PlatformHorizontalScrollView:setShowsHorizontalScrollIndicator(s)
--   self['handler']:setShowsHorizontalScrollIndicator(s)
end
function PlatformHorizontalScrollView:setPagingEnabled(s)
--   self['handler']:setPagingEnabled(s)
end

function PlatformHorizontalScrollView:setContentinset(s)
   --self['handler']:setContentInset(s)
end
