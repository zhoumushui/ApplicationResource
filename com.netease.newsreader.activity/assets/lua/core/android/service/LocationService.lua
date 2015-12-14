require "stdlib/class/Class"
--module("Context", package.seeall)

--[[
   layout state:
   init
   beginlayout
   doinglayout
   done
   init
]]


LocationService = Class.Class(
   "LocationService",
   {
                       properties={
                         appName  =Class.undefined,
                     }
 
   
   }
)

--

function LocationService.prototype:init(appName)
   local locationService = luabridge.bindClass("com.netease.colorui.services.LocationService")
   self._pv = locationService['newInstance.()Lcom/netease/colorui/services/LocationService;'](locationService)
end

function LocationService.prototype:startPositioning(cb)

  local request_uuid = uuid()
  if self["cbs"] == nil then
    self["cbs"] = {}
  end
  local _cbs={}
   _cbs.location= {}
  self["cbs"][request_uuid] = _cbs

    function _cbs.location.onGetLocation(ret)
      cb(ret) 
    end
  Callbacks[request_uuid] = self["cbs"][request_uuid]
 local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.services.LocationService$LocationListener',request_uuid,"location")   
 self._pv["startPositioning.(Lcom/netease/colorui/services/LocationService$LocationListener;)V"](self._pv,listenerProxy)

end


