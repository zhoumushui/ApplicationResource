PlatformWebView = createNewPlatformView(View)

--@override
--@platform
function PlatformWebView:newPlatformView(absView, ...)
	self["type"]="WebView"
	return ViewOwner:createView("WebView",currentContext)
end

function PlatformWebView:loadUrl(url)
	return self["handler"]['loadUrl.(Ljava/lang/String;)V'](self["handler"],url)
  -- return self["handler"]:loadUrl(tostring(url))
end

function PlatformWebView:loadHTMLString(html, url)
   return self["handler"]['loadUrl.(Ljava/lang/String;)V'](self["handler"],url)
   --return self["handler"]:loadHTMLString(tostring(html), tostring(url))
end

function PlatformWebView:stringByEvaluatingJavaScriptFromString(script)

	return self["handler"]['loadUrl.(Ljava/lang/String;)V'](self["handler"],"javascript:"..script)
end


function PlatformWebView:reload()
  return self["handler"]['reload.()V'](self["handler"])
  -- return self["handler"]:reload()
end

function PlatformWebView:stopLoading()
	 return self["handler"]['stopLoading.()V'](self["handler"])
end


function PlatformWebView:notifyJsWebView(id)
		-- local a = {};
		-- aa.bb = 'bb'
	 self["handler"]['notifyJs.(Ljava/lang/String;I)V'](self["handler"],"",id)

		--jsApi.onCallback(jsonObject, id);
end


--[[

   	if evtName == "QRGetResult" then
  	  local viewclick_cb={}
	  function viewclick_cb.onQRResult(result)
			cb(result)	
	  end
	   self.__viewcbs[evtName] = viewclick_cb
	   local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.view.QRView$OnQRGetResultListener',self["uuid"],evtName)	   
	   self["handler"]["setQRGetResultListener.(Lcom/netease/colorui/view/QRView$OnQRGetResultListener;)V"]( self["handler"],listenerProxy)   
	end


]]

function PlatformWebView:addEventListener(evtName,cb)
	View.initUUIDCallback(self)

   	if evtName == "jshandler" then
  	  local js_cb={}
	  function js_cb.onJsInvoke(id,methodname,data)
	  		cb(self,id,methodname,data)
	  		--call onJsHandlerCallback
	  end
	  print("jshandler....")
	  self.__viewcbs[evtName] = js_cb
	  local jsCbProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIWebView$OnJSBridgeListener',self["uuid"],evtName)	   
	  self["handler"]["setJSBridgeListener.(Lcom/netease/colorui/view/ColorUIWebView$OnJSBridgeListener;)V"]( self["handler"],jsCbProxy)   
	elseif evtName == "didFinishLoad" then
		local page_cb={}
		function page_cb.onPageFinishLoad()
				cb()
		end
	  	self.__viewcbs[evtName] = page_cb
	  	local pageCbProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIWebView$OnWebPageFinishListener',self["uuid"],evtName)	   
	  	self["handler"]["setWebPageFinishListener.(Lcom/netease/colorui/view/ColorUIWebView$OnWebPageFinishListener;)V"]( self["handler"],pageCbProxy)   
	elseif evtName == "didStartLoad" then
			local page_cb={}
			function page_cb.onPageStartLoad()
					cb()
			end
			self.__viewcbs[evtName] = page_cb

			local pageCbProxy  = luabridge.createSoftProxy('com.netease.colorui.view.ColorUIWebView$OnWebPageStartListener',self["uuid"],evtName)	   
	  		self["handler"]["setWebPageStartListener.(Lcom/netease/colorui/view/ColorUIWebView$OnWebPageStartListener;)V"]( self["handler"],pageCbProxy)   
	end
end

function PlatformWebView:onJsHandlerCallback(id,methodname,data)
		print("now on jshandlercallack.....method name is:\t"..methodname)
	 		local onjscb = function()
	  			self:notifyJsWebView(id)
	  		end
			self["_jshandler"][methodname](data,onjscb)
end


function PlatformWebView:registerHandler(name, cb)
	if self["_jshandler"] == nil then
		self["_jshandler"] = {}
		self:addEventListener("jshandler",self.onJsHandlerCallback)
	end
		self['_jshandler'][name]=cb

end

function PlatformWebView:unregisterHandler(name)
	self['_jshandler'][name] = nil
end
