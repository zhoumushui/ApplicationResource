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


CTNTESCommonService = Class.Class(
   "CTNTESCommonService",
   {
                       properties={
                         appName  =Class.undefined,
                     }
 
   
   }
)




function CTNTESCommonService.prototype:init(appName)


     local ctServiceMgrCls = luabridge.bindClass("com.netease.colorui.services.CTServiceMgr")
    local ctServiceMgr = ctServiceMgrCls["getInstance.()Lcom/netease/colorui/services/CTServiceMgr;"](ctServiceMgrCls)
self._pv =  ctServiceMgr["getServiceByName.(Ljava/lang/String;)Ljava/lang/Object;"](ctServiceMgr,"NTES")

end
 




function CTNTESCommonService.prototype:openHTTPUrl(url)
     return self._pv["openHTTPUrl.(Ljava/lang/String;)V"](self._pv,url)
  
end

function CTNTESCommonService.prototype:getUserInfo()
   local jsonUserInfo =  self._pv["getUserInfo.()Ljava/lang/String;"](self._pv)  
   if jsonUserInfo and string.len(jsonUserInfo) >0 then
      return  cjson.decode(jsonUserInfo)
   else
      return nil
   end

end


function CTNTESCommonService.prototype:getDeviceInfo()
   return self._pv["getDeviceInfo.()Ljava/lang/String;"](self._pv)  
end


function CTNTESCommonService.prototype:openClientPage(url,methodtype,what,content,bb,timeout,cb)
end
--    netsService:share(self._data.url, self._data.title, self._data.subtitle,self._viewPagerData[1].image,nil,Globals.getShareMode())

function CTNTESCommonService.prototype:share(url,title,subtitle,thumbUrl,phoneUrl,mode)
      self._pv["localShare.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"](self._pv,url,title,subtitle,thumbUrl,phoneUrl,mode)  
end

--    public void localShare(String url,String title,String subTitle,String thumbUrl,String imageUrl,int mode){

function CTNTESCommonService.prototype:getChannelId()
  return self._pv["getChannelId.()Ljava/lang/String;"](self._pv)
end








