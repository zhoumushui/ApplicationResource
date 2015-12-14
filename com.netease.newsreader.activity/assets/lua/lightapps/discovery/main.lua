module("main", package.seeall)

require "controller.YXViewController"
require "Resources"
function main(appname, displayname, version, coreVersion)

   local DiscoveryApplication = require("DiscoveryApplication")

   local app = DiscoveryApplication(appname, displayname, version, coreVersion)

   --测试
   -- app.url = "http://t.c.m.163.com/nc/topicset/uc/api/discovery/index"
   --线上
   app.url = "http://c.m.163.com/nc/topicset/uc/api/discovery/indexV52"
   
   local serviceMgr = nil
   if platform.isIOS() then
   	serviceMgr = IOS.CTServiceMgr_sharedYXService()
   else
   	serviceMgr = YXServiceMgr()
   end
   
   app:setServiceMgr(serviceMgr)
   app:setHttpComponent(serviceMgr:createHTTPComponent(appname))

   return app
end

