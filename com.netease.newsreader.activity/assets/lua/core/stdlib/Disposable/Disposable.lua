module("Disposable", package.seeall)

local emptyFunc = function() end

Disposable = function(doDispose)
   local dis = {}
   dis.dispose = function()
   		doDispose()
   		dis.dispose = emptyFunc
   end
   return dis
end

return Disposable