require "stdlib/class/Class"



EventTrackerService = Class.Class(
    "EventTrackerService",
    {
                       properties={
                         appName  =Class.undefined,
                     }
 
   
    }
)

function EventTrackerService.prototype:init(appName)
   self._pv =luabridge.bindClass("com.netease.colorui.services.EventTrackerService")
end

function EventTrackerService.prototype:trackEvent(eventId,lable,eventData)
	print("....loading trackEvent1")
    self._pv["trackEvent.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"](self._pv,eventId,self._appName,lable,cjson.encode(eventData))
end

function EventTrackerService.prototype:trackEventCostTime(eventId,time,lable,eventData)
		print("....loading trackEvent2")

    self._pv["trackEventCostTime.(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"](self._pv,eventId,time,self._appName,lable,cjson.encode(eventData))
end