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


CommonService = Class.Class(
   "CommonService",
   {
                       properties={
                         appName  =Class.undefined,
                     }
 
   
   }
)

--

function CommonService.prototype:forwardCard(vchand ,uid)
  self._pv["forwardCard.(Ljava/lang/String;)V"](self._pv,uid)

end


function CommonService.prototype:serviceEnvironment()
  if self._serviceEnvironment == nil then
    self._serviceEnvironment = self._pv["getServiceEnvironment.()I"](self._pv)
  end
  return self._serviceEnvironment
end

function CommonService.prototype:isWifi()
  return self._pv["isWifi.()Z"](self._pv)
end

--todo current friends




function CommonService.prototype:init(appName)
	 --local commonservcecls = luabridge.bindClass("com.netease.colorui.services.CommonService")
--	 self._pv = commonservcecls['newInstance.(Ljava/lang/String;)Lcom/netease/colorui/services/CommonService;'](commonservcecls,appName)
     local ctServiceMgrCls = luabridge.bindClass("com.netease.colorui.services.CTServiceMgr")
    local ctServiceMgr = ctServiceMgrCls["getInstance.()Lcom/netease/colorui/services/CTServiceMgr;"](ctServiceMgrCls)
  self._pv =  ctServiceMgr["getServiceByName.(Ljava/lang/String;)Ljava/lang/Object;"](ctServiceMgr,"common")
  if self._pv then
    print("CommonService is not null")
  else
        print("CommonService is  null")

  end
end
 
function CommonService.prototype:getYXCookie()
    if self._yxCoookie == nil then
      self._yxCoookie = self._pv["getBase64SessionKey.()Ljava/lang/String;"](self._pv)
    end
    return self._yxCoookie
end

function CommonService.prototype:getYXOpenId()
  if self._yxOpenID == nil then
          self._yxOpenID = self._pv["getOpenID.()Ljava/lang/String;"](self._pv)
  end
  return self._yxOpenID
end


function CommonService.prototype:yxUserId()
  	if self._yxUserid ==nil  then
		self._yxUserid = self._pv["yxUserId.()Ljava/lang/String;"](self._pv)
	end
	return self._yxUserid
	
end


function CommonService.prototype:nickName(yxuid)
     return self._pv["getNickName.(Ljava/lang/String;)Ljava/lang/String;"](self._pv,yxuid)
  
end

function CommonService.prototype:getSSIDName()
   return self._pv["getSSIDName.()Ljava/lang/String;"](self._pv)  
end



function CommonService.prototype:sendHTTPRequest(url,methodtype,what,content,bb,timeout,cb)
	local request_uuid = uuid()
	-- local cbs = {}
	--cbs.http =  {}
  if self["cbs"] == nil then
    self["cbs"] = {}
  end
  -- self["cbs"][request_uuid]={}
  print("sendhttp,uuid is;\t"..request_uuid)
  local _cbs={}
   _cbs.http= {}
  self["cbs"][request_uuid] = _cbs
  	function _cbs.http.onResponse(res,httperror)
      print("res is "..res)
		  cb(res,httperror)	
      self["cbs"][request_uuid] = nil
      Callbacks[request_uuid] = nil
  	end
	Callbacks[request_uuid] = self["cbs"][request_uuid]
  
  local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.http.ColorUIHttpResponseListener',request_uuid,"http")	  
  self._pv["sendHTTPRequest.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZILcom/netease/colorui/http/ColorUIHttpResponseListener;)V"](self._pv,url,methodtype,content,bb,timeout,listenerProxy)
end


function CommonService.prototype:pasteboard(str)
  self._pv["parseBoard.(Ljava/lang/String;)V"](self._pv,str)
end

function CommonService.prototype:download(url,path,bb,cb)
  local request_uuid = uuid()
  if self["cbs"] == nil then
    self["cbs"] = {}
  end
  local _cbs={}
   _cbs.httpdownload= {}
  self["cbs"][request_uuid] = _cbs

    function _cbs.httpdownload.onProgress(precent)
      cb(precent) 
    end
  Callbacks[request_uuid] = self["cbs"][request_uuid]
 local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.http.ColorUIHttpDownloadProgressListener',request_uuid,"httpdownload")   
 self._pv["download.(Ljava/lang/String;Ljava/lang/String;Lcom/netease/colorui/http/ColorUIHttpDownloadProgressListener;)V"](self._pv,url,path,listenerProxy)
end




function CommonService.prototype:getCurrentActivityContext()
  return self._pv["getCurrentActivityContext.()Landroid/content/Context;"](self._pv)
end

function CommonService.prototype:getAllSSID()
  local strssids =  self._pv["getAllSSIDs.()Ljava/lang/String;"](self._pv)
  return cjson.decode(strssids)

end

function CommonService.prototype:connectWifiBySSID(ssidName,cb)
  if self["cbs"] == nil then
    self["cbs"] = {}
  end
  -- -- self["cbs"][request_uuid]={}
  -- print("sendhttp,uuid is;\t"..request_uuid)
  -- local _cbs={}
  --  _cbs.http= {}
  -- self["cbs"][request_uuid] = _cbs
  --   function _cbs.http.onResponse(res,httperror)
  --     print("res is "..res)
  --     cb(res,httperror) 
  --     self["cbs"][request_uuid] = nil
  --     Callbacks[request_uuid] = nil
  --   end
  -- Callbacks[request_uuid] = self["cbs"][request_uuid]

  local request_uuid = uuid()

  local _cbs={}
   _cbs.wificonnect= {}

  self["cbs"][request_uuid] = _cbs
  function _cbs.wificonnect.onChange(wifiState,msg)
      print(wifiState,msg)

      cb(wifiState,msg) 
      self["cbs"][request_uuid] = nil

    end
  Callbacks[request_uuid] = self["cbs"][request_uuid]
 local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.ColorUIWifiChangeListener',request_uuid,"wificonnect")   
 return self._pv["connectWifiBySSID.(Ljava/lang/String;Lcom/netease/colorui/interfaces/ColorUIWifiChangeListener;)Z"](self._pv,ssidName,listenerProxy)
end

function CommonService.prototype:connectPrevWifiSSID()
 return self._pv["connectPrevWifiSSID.()V"](self._pv)
end

function CommonService.prototype:openChat()
   return self._pv["switchPublicMessageMode.(Ljava/lang/String;)V"](self._pv,lightappInfo.appName)
  -- body
end



function CommonService.prototype:invoke(methodName,params,callback)
    local request_uuid = uuid()
    local _cbs={}
   _cbs.invoke= {}

  if self["cbs"] == nil then
    self["cbs"] = {}
  end


  self["cbs"][request_uuid] = _cbs

  function _cbs.invoke.onResponse(msg)
      callback(msg) 
      self["cbs"][request_uuid] = nil
    end
  Callbacks[request_uuid] = self["cbs"][request_uuid]

  local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.ColorUIResponseListener',request_uuid,"invoke")   
  self._pv["invoke.(Ljava/lang/String;Ljava/lang/String;Lcom/netease/colorui/lightapp/ColorUIResponseListener;)V"](self._pv,methodName,cjson.encode(params),listenerProxy)

end

function CommonService.prototype:call(methodName,params)
  self._pv["call.(Ljava/lang/String;Ljava/lang/String;)V"](self._pv,methodName,cjson.encode(params))

end

function CommonService.prototype:getLocalContacts(vchandler,isMulti,callback)
  local params = {}
  params.isMulti = isMulti
  self:invoke("getLocalContacts",params,callback)
end

function CommonService.prototype:getCurrentPosition(useCache,callback)
  local params = {}
  params.useCache = useCache
  self:invoke("getCurrentPosition",params,callback)
end

--[[

 {"mode":"sysSms","params":{"number":["12345","676878"],"content":"系统短信"}}

]]

function CommonService.prototype:launchCommunicate(vchandler,mode,params)
  local tbparams = {}
  tbparams.mode = mode
  tbparams.params = params

  self:call("launchCommunicate",tbparams)
end


