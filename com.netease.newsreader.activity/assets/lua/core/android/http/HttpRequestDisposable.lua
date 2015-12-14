require "stdlib/class/Class"
--module("HttpRequestDisposable", package.seeall)

--[[
   layout state:
   init
   beginlayout
   doinglayout
   done
   init
]]


HttpRequestDisposable = Class.Class(
   "HttpRequestDisposable",
   {
      properties={
            uuid= Class.undefined,
      }
   }
)




function HttpRequestDisposable.prototype:dispose()
	if self._uuid ~= nil then
	   	Callbacks[self._uuid] = nil
	end
end



