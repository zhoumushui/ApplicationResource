

module("SmartCameraApplication", package.seeall)


local Application = require("application.Application")

local SmartCameraApplication = Class.Class("SmartCameraApplication",
                                     {
                                        base = Application,

                                        properties = {
                                           httpComponent = Class.undefined,
                                        }
})

function SmartCameraApplication.prototype:init(appName, displayName, version, coreVersion)
   Application.prototype.init(self, appName, displayName, version, coreVersion)
end


function SmartCameraApplication.prototype:enter(...)
   self:setViewportWidth(self:getScreenWidthUnit())

   return Application.prototype.enter(self, ...)
end


function SmartCameraApplication.prototype:createRootViewController(params)
   local DiscoveryViewController = require("DiscoveryViewController")

   local vc = DiscoveryViewController()

   self:on("onReceiveMsg",function(scope, userdata, msg)
              local msgData = cjson.decode(msg)
              if (msgData.eventType == "userRefreshed") then
                  vc:refresh()
              end
   end)


   return vc
end

function SmartCameraApplication.prototype:isLogin()
   local netsService = self:getServiceMgr():createNTESService()
   return netsService:userInfo() ~= nil
end

function SmartCameraApplication.prototype:userInfo()
   local netsService = self:getServiceMgr():createNTESService()
   local userinfoString = netsService:userInfo()
   if userinfoString then
      return cjson.decode(userinfoString)
   end
end


function SmartCameraApplication.prototype:openUrl(url)
   local netsService = self:getServiceMgr():createNTESService()
   netsService:openHTTPUrl(url)
end


function SmartCameraApplication.prototype:login(cb)
   local netsService = self:getServiceMgr():createNTESService()
   netsService:login(function(status)
      if status == "success" then
         cb(true)
      else
         cb(false)
      end
   end, false)
end

function SmartCameraApplication.prototype:isIOSNightMode()
   if platform.isIOS() and self:getServiceMgr():createNTESService():nightTheme() then
      return true
   end

   return false
end

--如果没有未读红点，需要通知到nativeapp
function SmartCameraApplication.prototype:checkRemind()
   local remindMgr = require("RemindMgr")
   if not remindMgr:hasNeedRemindContent() then
      getApplication():getServiceMgr():createNTESService():notifyDiscoveryHasNoRemind()
   end
end

return SmartCameraApplication
