PlatformCTRealTimeView = createNewPlatformView(View)

--@override
--@platform
function PlatformCTRealTimeView:newPlatformView(absView, ...)
	self['type']="CTRealTimeView"
	return ViewOwner:createView("CTRealTimeView",currentContext)
end




function PlatformCTRealTimeView:startSession(params)
   self["handler"]["startSession.(Ljava/lang/String;)V"](self["handler"],params)
end

function PlatformCTRealTimeView:stopSession()
	self["handler"]["stopSession.()V"](self["handler"])
end


function PlatformCTRealTimeView:resetScaleTransform()
   
end

function PlatformCTRealTimeView:onPause()
	self["handler"]["onRealTimePause.()V"](self["handler"])
end


function PlatformCTRealTimeView:onResume()
	self["handler"]["onRealTimeResume.()V"](self["handler"])
end

function PlatformCTRealTimeView:ipCamClientPerformance()
 return self["handler"]["ipCamClientPerformance.()I"](self["handler"])
end
function PlatformCTRealTimeView:addEventListener(evtName,cb)
     View.initUUIDCallback(self)
   --timechanged
   --statechanged
   if evtName == "statechanged" then
             print("PlatformCTRealTimeViewvideo ctrealtimeview,uuid,self...pv.is .."..tostring(self["handler"]))

         print("video ctrealtimeview,self...uuid.is.."..self["uuid"])

       local viewclick_cb={}
       function viewclick_cb.onChange(state1)
           print("videolua.....state1 is.."..state1)
           cb(state1) 
       end
       self.__viewcbs[evtName] = viewclick_cb
       
       print("PlatformCTRealTimeView:addEventListener")									   
       local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIRealTimeView$RealTimeVideoChangeListener',self["uuid"],evtName)    
       self["handler"]["setRealTimeVideoChangeListner.(Lcom/netease/colorui/view/ColorUIRealTimeView$RealTimeVideoChangeListener;)V"]( self["handler"],listenerProxy) 

   end


end
