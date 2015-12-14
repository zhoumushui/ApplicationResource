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


Context = Class.Class(
   "Context",
   {
          
   
   }
)

--function Context.prototype:setAndroidContext(androidContext)
--		--对应成 base context
--	self._androidContext = androidCotext;
--end

function Context.prototype:setStoreContext(storeContext)
	self._storeContext = storeContext;
end

function Context.prototype:setWidth(width)
	 self.width = width;
end

function Context.prototype:save(store)
	   self._storeContext["save.(Ljava/lang/String;)V"](self._storeContext,store)
end


function Context.prototype:openWebView_callback(url,callback)	
		 self._storeContext["openWebView.(Ljava/lang/String;)V"](self._storeContext,url)
end





function Context.prototype:submit_cb(url,callback)
	if self.__cbs == nil then
     	 self.__cbs = {}
	 	 self["uuid"]= uuid()
     	 Callbacks[self["uuid"]] = self.__cbs
  	  end
  	  local aa = self
  	  local http_cb={}
	  function http_cb.onResponse(res)
			callback(res)	
	  end
	   self.__cbs["cmd"] = http_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.ColorUIResponseListener',self["uuid"],"cmd")	  
	   self._storeContext["sendLuaCmdRequest.(Ljava/lang/String;Lcom/netease/colorui/lightapp/ColorUIResponseListener;)V"](self._storeContext,url,listenerProxy)
end


function Context.prototype:sendCmdRequest_callback(url,callback)
	if self.__cbs == nil then
     	 self.__cbs = {}
	 	 self["uuid"]= uuid()
     	 Callbacks[self["uuid"]] = self.__cbs
  	  end
  	  local http_cb={}
	  function http_cb.onResponse(res)
			callback(res)	
	  end
	   self.__cbs["cmd"] = http_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.ColorUIResponseListener',self["uuid"],"cmd")	  
	   self._storeContext["sendLuaCmdRequest.(Ljava/lang/String;Lcom/netease/colorui/lightapp/ColorUIResponseListener;)V"](self._storeContext,url,listenerProxy)
end



function Context.prototype:forwardCard( uid, nickname, photourl)
	   self._storeContext["sendBuddyCard.(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V"](self._storeContext,uid,nickname,photourl)
end


function Context.prototype:delSelfMessage()
		   self._storeContext["delMessage.()V"](self._storeContext)
end

function Context.prototype:sendHttpRequest_callback(url,callback)
	print("http,now sendHttpRequest_callback")
	local request_uuid = uuid()

	if self.__cbs == nil then
     	 self.__cbs = {}
  	  end

  local _cbs={}
   _cbs.http= {}
  self["__cbs"][request_uuid] = _cbs
  	function _cbs.http.onResponse(res,httperror)
      print("res is "..res)
		  callback(res)	
      self["__cbs"][request_uuid] = nil
      Callbacks[request_uuid] = nil
  	end
	Callbacks[request_uuid] = self["__cbs"][request_uuid]
  	print("http,now sendLuaHttpRequest")

  local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.http.ColorUIHttpResponseListener',request_uuid,"http")	  
 self._storeContext["sendLuaHttpRequest.(Ljava/lang/String;Lcom/netease/colorui/http/ColorUIHttpResponseListener;)V"](self._storeContext,url,listenerProxy)
end

--Context context = Context()
			 
function initColorTouchContext(width,storeContext)
--	if context==nil then
--		context = Context()
--	end
	local context = Context()
	context:setWidth(width)
	context:setStoreContext(storeContext)
	return context
end

function Context.prototype:showYXInput(editText)
	   self._storeContext["showYXInput.(Landroid/widget/EditText;)V"](self._storeContext,editText._pv['handler'])
end

function Context.prototype:openLightApp(url)
	   self._storeContext["openLightApp.(Landroid/content/Context;Ljava/lang/String;)V"](self._storeContext,currentContext,url)
end