WebView = Class.Class("WebView",
                     {
                        base=Container,

                        properties={
                           registeredHandlers = Class.undefined
                        }
})

--[[
suppor event:
didStartLoad
didFinishLoad
didFailLoad
]]

function WebView.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)

   self._registeredHandlers = {}
end

--@override
function WebView.prototype:createPlatFormView()
   return PlatformWebView(self)
end

function WebView.prototype:loadUrl(url)
   return self._pv:loadUrl(tostring(url))
end

function WebView.prototype:loadHTMLString(html, url)
   return self._pv:loadHTMLString(tostring(html), tostring(url))
end

function WebView.prototype:stringByEvaluatingJavaScriptFromString(script)
   return self._pv:stringByEvaluatingJavaScriptFromString(tostring(script))
end

function WebView.prototype:registerHandler(name, cb)
   self._registeredHandlers[name] = cb

   return self._pv:registerHandler(tostring(name), cb)
end

function WebView.prototype:unregisterHandler(name)
   self._registeredHandlers[name] = nil

   return self._pv:unregisterHandler(tostring(name))
end

function WebView.prototype:reload()
   return self._pv:reload()
end

function WebView.prototype:stopLoading()
   return self._pv:stopLoading()
end
