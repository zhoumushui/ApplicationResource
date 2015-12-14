PlatformAVQueuePlayer = createNewPlatformView(View)

--@override
--@platform
function PlatformAVQueuePlayer:newPlatformView(absView, ...)
	self["type"]="AVQueuePlayer"
	return ViewOwner:createView("AVQueuePlayer",currentContext)
end

function PlatformAVQueuePlayer:play()
   return self["handler"]["play.()V"](self["handler"])
end
   
function PlatformAVQueuePlayer:stop()
	return self["handler"]["stop.()V"](self["handler"])
   
end

function PlatformAVQueuePlayer:pause()
	return self["handler"]["pause.()V"](self["handler"])
end
   
function PlatformAVQueuePlayer:isPlaying()
  -- return self["handler"]["isPlaying.()Z"](self["handler"])
end


function PlatformAVQueuePlayer:start(url)
  self["handler"]["start.(Ljava/lang/String;)V"](self["handler"],url)
end

function PlatformAVQueuePlayer:setPlayUrls(urls)
	
	-- local jsonlurls = cjson.encode(urls)
 --   self["handler"]["setPlayUrls.(Ljava/lang/String;)V"]( self["handler"],jsonlurls)
end

function PlatformAVQueuePlayer:resume()
   self["handler"]["resume.()V"](self["handler"])
end

function PlatformAVQueuePlayer:seekToUrl(url, seconds)
   self["handler"]["seekToUrl.(Ljava/lang/String;I)V"](self["handler"],url,seconds)
end

function PlatformAVQueuePlayer:addEventListener(evtName, cb)
   View.initUUIDCallback(self)
   --timechanged
   --statechanged
   -- if evtName == "statechanged" then
   --     local viewclick_cb={}
   --     function viewclick_cb.onChange(v)
   --       local data = cjson.decode(v)
   --       cb(data) 
   --     end
   --     self.__viewcbs[evtName] = viewclick_cb
   --     local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.OnAVQueuePlayerStateChangeListener',self["uuid"],evtName)    
   --     self["handler"]["setStateChangeListener.(Lcom/netease/colorui/interfaces/OnAVQueuePlayerStateChangeListener;)V"]( self["handler"],listenerProxy) 
   -- elseif evtName =="timechanged" then 
   --     local viewclick_cb={}
   --     function viewclick_cb.onChange(v)
   --       local data = cjson.decode(v)
   --       cb(data) 
   --     end
   --     self.__viewcbs[evtName] = viewclick_cb
   --     local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.OnAVQueuePlayerTimeChangeListener',self["uuid"],evtName)    
   --     self["handler"]["setTimeChangeListener.(Lcom/netease/colorui/interfaces/OnAVQueuePlayerTimeChangeListener;)V"]( self["handler"],listenerProxy) 
   -- end
end


--[[

itemchanged, url or "" 空字符串表示没有视频播放
timechanged: {url:"", totalTime:time, currentTime:time}
statechanged: {url:"...", state:"..."}  state取值：unknown readytoplay failed play stop

]]


function PlatformAVQueuePlayer:snapshotToSystemAlbum()
   --self["handler"]["snapshotToSystemAlbum.()V"](self["handler"])
end


