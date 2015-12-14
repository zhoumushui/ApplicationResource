AVQueuePlayer = Class.Class("AVQueuePlayer",
                     {
                        base=Container,
                        urls = Class.undefined,
})

--[[
itemchanged, url or "" 空字符串表示没有视频播放
timechanged: {url:"", totalTime:time, currentTime:time}
statechanged: {url:"...", state:"..."}  state取值：unknown readytoplay failed play stop
]]

--@override
function AVQueuePlayer.prototype:createPlatFormView()
   return PlatformAVQueuePlayer(self)
end

function AVQueuePlayer.prototype:play()
   return self._pv:play()
end
   
function AVQueuePlayer.prototype:stop()
   return self._pv:stop()
end
if not platform.isIOS() then
	function AVQueuePlayer.prototype:resume()
	   return self._pv:resume()
	end
end


function AVQueuePlayer.prototype:pause()
   return self._pv:pause()
end
   
function AVQueuePlayer.prototype:isPlaying()
   return self._pv:isPlaying()
end

function AVQueuePlayer.prototype:setPlayUrls(urls)
   self._pv:setPlayUrls(urls)
end

function AVQueuePlayer.prototype:seekToUrl(url, seconds)
   self._pv:seekToUrl(url, seconds)
end

function AVQueuePlayer.prototype:snapshotToSystemAlbum()
   self._pv:snapshotToSystemAlbum()
end
if not platform.isIOS() then
	function AVQueuePlayer.prototype:start(url)
	   self._pv:start(url)
	end
end