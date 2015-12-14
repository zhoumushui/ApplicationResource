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


NetworkStateService = Class.Class(
   "NetworkStateService",
   {
                       properties={
                         appName  =Class.undefined,
                     }
 
   
   }
)

--

function NetworkStateService.prototype:isReachAble()
  return  self._pv["isReachAble.()Z"](self._pv)
end



function NetworkStateService.prototype:init(appName)
   local commonservcecls = luabridge.bindClass("com.netease.colorui.services.NetworkStateService")
   self._pv = commonservcecls['newInstance.()Lcom/netease/colorui/services/NetworkStateService;'](commonservcecls)
end
 
function NetworkStateService.prototype:isWifi()
  return self._pv["isWifi.()Z"](self._pv)
end



