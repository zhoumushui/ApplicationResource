module("Resources",package.seeall)

getPlatformResource = function(localUrl)
   if platform.isIOS() then
      return localUrl
   else
      return "app://"..localUrl
   end
end


