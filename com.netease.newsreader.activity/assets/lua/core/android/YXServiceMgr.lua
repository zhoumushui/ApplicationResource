serverMgrContructor = function(cls, absView, ...)
   local self = setmetatable({}, cls)
   return self   
end

createServerMgr = function(base)
   local newC = {}
   newC.__index = newC
   setmetatable(newC, {
                   __index = base,
                   __call = serverMgrContructor,
   })
   return newC
end


YXServiceMgr = createServerMgr(nil)


--@override
--@platform
function YXServiceMgr:getCommonService()
  -- 一个state只有servicemgr不处理appname
   if self["services"] == nil then
      self["services"]  = {}
   end
   if self.services["common"] == nil then
      self.services["common"] = CommonService(lightappInfo.appName)
   end
	return  self.services["common"]
end


function YXServiceMgr:getNetworkStateService()
   if self["services"] == nil then
      self["services"]  = {}
   end
   if self.services["networkstate"] == nil then
      self.services["networkstate"] = NetworkStateService(lightappInfo.appName)
   end
  return  self.services["networkstate"] 
end

function YXServiceMgr:getLocationService()
   if self["services"] == nil then
      self["services"]  = {}
   end
   if self.services["location"] == nil then
      self.services["location"] = LocationService(lightappInfo.appName)
   end
  return  self.services["location"] 
end

function YXServiceMgr:createHTTPComponent()
   if self["services"] == nil then
      self["services"]  = {}
   end
   if self.services["http"] == nil then
      self.services["http"] = HTTPComponent(lightappInfo.appName)
   end
  return  self.services["http"]

end

function YXServiceMgr:createNTESService()
   if self["services"] == nil then
      self["services"]  = {}
   end
   if self.services["NTES"] == nil then
      self.services["NTES"] = CTNTESCommonService()
   end
  return  self.services["NTES"]



end

function YXServiceMgr:createServiceByName(name)


end

function YXServiceMgr:getServiceByName(name)
end


function YXServiceMgr:getYXCommonService()
   if self["services"] == nil then
      self["services"]  = {}
   end
   if self.services["yxcommon"] == nil then
      self.services["yxcommon"] = YXCommonService(lightappInfo.appName)
   end
  return  self.services["yxcommon"]
end

