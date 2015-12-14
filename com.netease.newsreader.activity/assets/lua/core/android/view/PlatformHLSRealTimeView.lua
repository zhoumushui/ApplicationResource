PlatformHLSRealTimeView = createNewPlatformView(View)

--@override
--@platform
function PlatformHLSRealTimeView:newPlatformView(absView, ...)
	self['type']="HLSRealTimeView"
	return ViewOwner:createView("HLSRealTimeView",currentContext)
end




function PlatformHLSRealTimeView:startSession(params)
   self["handler"]["startSession.(Ljava/lang/String;)V"](self["handler"],params)
end

function PlatformHLSRealTimeView:stopSession()
	self["handler"]["stopSession.()V"](self["handler"])
end

function PlatformHLSRealTimeView:pauseSession()
  self["handler"]["onRealTimePause.()V"](self["handler"])
end


function PlatformHLSRealTimeView:resetScaleTransform()
   
end

function PlatformHLSRealTimeView:onPause()
	self["handler"]["onRealTimePause.()V"](self["handler"])
end


function PlatformHLSRealTimeView:onResume()
	self["handler"]["onRealTimeResume.()V"](self["handler"])
end

function PlatformHLSRealTimeView:ipCamClientPerformance()
 --return self["handler"]["ipCamClientPerformance.()I"](self["handler"])
end


function PlatformHLSRealTimeView:setFullScreenBtnPressed(b)
  self["handler"]["setFullScreenBtnPressed.(Z)V"](self["handler"],b)
end

function PlatformHLSRealTimeView:setBackBtnPressed(b)
    self["handler"]["setBackBtnPressed.(Z)V"](self["handler"],b)
end

function PlatformHLSRealTimeView:getCurrentPosition()
 return  self["handler"]["getCurrentPosition.()I"](self["handler"])
end


function PlatformHLSRealTimeView:addEventListener(evtName,cb)
     View.initUUIDCallback(self)
   if evtName == "statechanged" then
       local viewclick_cb={}
       function viewclick_cb.onChange(state1)
          local data ={}
            data["state"]=state1
            cb(data) 
       end

       self.__viewcbs[evtName] = viewclick_cb
       local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIRealTimeView$RealTimeVideoChangeListener',self["uuid"],evtName)    
       self["handler"]["setRealTimeVideoChangeListner.(Lcom/netease/colorui/view/ColorUIRealTimeView$RealTimeVideoChangeListener;)V"]( self["handler"],listenerProxy) 

   elseif evtName == "timechanged" then
    local viewclick_cb={}
    function viewclick_cb.onResponse(res)
        print(".full.timechange"..res)

        cb( cjson.decode(res))
    end
    self.__viewcbs[evtName] = viewclick_cb

    local listenerProxy  = luabridge.createSoftProxy('im.yixin.lightapp.ColorUIResponseListener',self["uuid"],evtName)   
    self["handler"]["setTimeChangeListener.(Lim/yixin/lightapp/ColorUIResponseListener;)V"](self["handler"],listenerProxy)

   end

end
