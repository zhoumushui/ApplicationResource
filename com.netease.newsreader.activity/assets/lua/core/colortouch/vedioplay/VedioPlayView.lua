VedioPlayView = Class.Class("VedioPlayView",
                            {
                               base=Node,
})

--@override
function VedioPlayView.prototype:createPlatFormView()
   return PlatformVedioPlayView(self)
end


function VedioPlayView.prototype:playMovieStream(url)
   return self._pv:playMovieStream(url)
end

function VedioPlayView.prototype:setMovieStream(url)
   return self._pv:setMovieStream(url)
end