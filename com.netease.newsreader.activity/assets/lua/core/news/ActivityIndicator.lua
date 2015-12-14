module("ActivityIndicator", package.seeall)
require "stdlib/class/Class"

if platform.isIOS() then
   require "ios/view/PlatformNTESLoadingIndicator"
end

local ActivityIndicator = Class.Class("ActivityIndicator",
                        {
                           base=Node,
                        }
)


function ActivityIndicator.prototype:createPlatFormView()
   return PlatformNTESLoadingIndicator(self)
end

function ActivityIndicator.prototype:startAnimation()
   print(self._pv)
   self._pv:startAnimation()
end

function ActivityIndicator.prototype:stopAnimation()
   self._pv:stopAnimation()
end

return ActivityIndicator
