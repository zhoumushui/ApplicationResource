require "android/http/HttpRequestDisposable"
HTTPComponent = Class.Class(
   "HTTPComponent",
   {
                       properties={
                         appName  =Class.undefined,
                          commonService=Class.undefined,
                     }
 
   
   }
)
function HTTPComponent.prototype:init(appName)
	 local commonservcecls = luabridge.bindClass("com.netease.colorui.services.HTTPComponent")
	 self._pv = commonservcecls['newInstance.(Ljava/lang/String;)Lcom/netease/colorui/services/HTTPComponent;'](commonservcecls,appName)
end



function HTTPComponent.prototype:sendHTTPRequest(url,methodtype,head,content,bb,timeout,cb)
	local request_uuid = uuid()
  if self["cbs"] == nil then
    self["cbs"] = {}
  end
  local _cbs={}
   _cbs.http= {}
  self["cbs"][request_uuid] = _cbs
  	function _cbs.http.onResponse(res,httperror)
		  cb(res,httperror)	
      self["cbs"][request_uuid] = nil
      Callbacks[request_uuid] = nil
  	end
	Callbacks[request_uuid] = self["cbs"][request_uuid]
  local httpDisposable = HttpRequestDisposable{
  		uuid=request_uuid,
}
 

  local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.http.ColorUIHttpResponseListener',request_uuid,"http")	  
  self._pv["sendHTTPRequest.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZILcom/netease/colorui/http/ColorUIHttpResponseListener;)V"](self._pv,url,methodtype,cjson.encode(head),content,bb,timeout,listenerProxy)
  return httpDisposable
end


function HTTPComponent.prototype:download(url,path,bb,cb)
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
    local httpDownloadDisposable = HttpDownloadDisposable{
  		uuid=request_uuid,	
  }
 local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.http.ColorUIHttpDownloadProgressListener',request_uuid,"httpdownload")   
  httpDownloadDisposable:setDownloadPV(downloadPV)

 local downloadPV = self._pv["download.(Ljava/lang/String;Ljava/lang/String;Lcom/netease/colorui/http/ColorUIHttpDownloadProgressListener;)Lcom/netease/colorui/disposable/HttpDownloadDisposable;"](self._pv,url,path,listenerProxy)

 return httpDownloadDisposable
end
