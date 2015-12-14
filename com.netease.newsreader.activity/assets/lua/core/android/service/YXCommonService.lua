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


YXCommonService = Class.Class(
   "YXCommonService",
   {
                       properties={
                         appName  =Class.undefined,
                     }
 
   
   }
)


function YXCommonService.prototype:init(appName)
   local xyxcommonservcecls = luabridge.bindClass("com.netease.colorui.services.YXCommonService")
   self._pv = xyxcommonservcecls['newInstance.()Lcom/netease/colorui/services/YXCommonService;'](xyxcommonservcecls)
end
 

----({"yx43fed63b01884d6f8485aee9f2b32b5d", "公共摄像头 － " .. deviceName, abstractInfo, thumbImgUrl, webUrl})

function YXCommonService.prototype:shareNewsToTimeline(sharemodal)
  local sign = sharemodal[1]
  local title =  sharemodal[2]
  local desc = sharemodal[3]
  local imgUrl = sharemodal[4]
  local url = sharemodal[5]
 -- sign,title,desc,imgUrl,url
print("shareNewsToTimeline.....")
  self._pv["shareNewsToTimeline.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"](self._pv,sign,title,desc,imgUrl,url)

end


function YXCommonService.prototype:shareNewsToFriend(sharemodal)
  local sign = sharemodal[1]
  local title =  sharemodal[2]
  local desc = sharemodal[3]
  local imgUrl = sharemodal[4]
  local url = sharemodal[5]
print("shareNewsToFriend.....")

  return self._pv["shareNewsToFriend.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"](self._pv,sign,title,desc,imgUrl,url)
end

--todo current friends

