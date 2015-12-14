PlatformVedioPlayView = createNewPlatformView(View)

--@override
--@platform
function PlatformVedioPlayView:newPlatformView(absView, ...)
	self["type"]="VedioPlayView"
	return ViewOwner:createView("VedioPlayerView",currentContext)

end

function PlatformVedioPlayView:playMovieStream(url)
   --return self["handler"]:playMovieStream(url)
end

function PlatformVedioPlayView:setMovieStream(url)
   --return self["handler"]:setMovieStream(url)
end