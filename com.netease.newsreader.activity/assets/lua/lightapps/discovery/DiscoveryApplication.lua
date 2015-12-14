
module("DiscoveryApplication", package.seeall)

local Application = require("application.Application")

local DiscoveryApplication = Class.Class("DiscoveryApplication",
                                     {
                                        base = Application,

                                        properties = {
                                           httpComponent = Class.undefined,
                                           nightMode  = false,
                                           storeChecking = false,
                                        }
})

function DiscoveryApplication.prototype:init(appName, displayName, version, coreVersion)
   Application.prototype.init(self, appName, displayName, version, coreVersion)
end

function DiscoveryApplication.prototype:enter(...)
   self:setViewportWidth(self:getScreenWidthUnit())

   return Application.prototype.enter(self, ...)
end

function DiscoveryApplication.prototype:createRootViewController(params)
  
   if params then
      if params.storechecking ~= nil and tonumber(params.storechecking) == 1 then
         self:setStoreChecking(true)
      end
   end

   local DiscoveryViewController = require("DiscoveryViewController")
   local vc = DiscoveryViewController()

   self:on("onReceiveMsg",function(scope, userdata, msg)
        local msgData = cjson.decode(msg)
        if (msgData.eventType == "userRefreshed") then
           vc:refresh()
        end
      end)

   if not platform.isIOS() then
	    self:on("onChangeTheme",function(scope, userdata, msg)

      	      if msg == 'night' then
                 if not self:getNightMode() then
                    self:setNightMode(true)
                    vc:changeTheme(msg)
                 end 

      	      elseif msg == 'day' then
      	         if self:getNightMode() then
  	                self:setNightMode(false)
  	                vc:changeTheme(msg)
      	         end 
      	      end
	     end)
    end

   return vc
end

function DiscoveryApplication.prototype:isLogin()
   local netsService = self:getServiceMgr():createNTESService()
   return netsService:userInfo() ~= nil
end

function DiscoveryApplication.prototype:userInfo()
   local netsService = self:getServiceMgr():createNTESService()
   local userinfoString = netsService:userInfo()
   if userinfoString then
      return cjson.decode(userinfoString)
   end
end

function DiscoveryApplication.prototype:openUrl(url)
   local netsService = self:getServiceMgr():createNTESService()
   netsService:openHTTPUrl(url)
end

function DiscoveryApplication.prototype:login(cb)
   local netsService = self:getServiceMgr():createNTESService()
   netsService:login(function(status)
      if status == "success" then
         cb(true)
      else
         cb(false)
      end
   end, false)
end

function DiscoveryApplication.prototype:isNightMode()
   if platform.isIOS() then
      return self:getServiceMgr():createNTESService():nightTheme() 
   else
      return self:getNightMode()
   end

end

--如果没有未读红点，需要通知到nativeapp
function DiscoveryApplication.prototype:checkRemind()
   local remindMgr = require("RemindMgr")
   if not remindMgr:hasNeedRemindContent() then
      if platform.isIOS() then
         getApplication():getServiceMgr():createNTESService():notifyDiscoveryHasNoRemind()
      end
   end
end

function DiscoveryApplication.prototype:getChannelId()
   local netsService = self:getServiceMgr():createNTESService()
   if netsService.getChannelId then
      local channelId = netsService:getChannelId()
      return channelId
   end
end


return DiscoveryApplication
