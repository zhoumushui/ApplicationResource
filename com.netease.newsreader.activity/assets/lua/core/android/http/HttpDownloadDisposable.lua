require "stdlib/class/Class"
--module("HttpDownloadDisposable", package.seeall)

--[[
   layout state:
   init
   beginlayout
   doinglayout
   done
   init
]]


HttpDownloadDisposable = Class.Class(
   "HttpDownloadDisposable",
   {
       properties={
            uuid= Class.undefined,

       }
   }
)

function HttpDownloadDisposable.prototype:setDownloadPV(pv)
   self.downloadpv = pv
end

function HttpDownloadDisposable.prototype:dispose()
	if self._uuid ~= nil then
	   	 Callbacks[self._uuid] = nil
	end
   if self.downloadpv~=nil then
      self.downloadpv["cancelDownload.()V"](self.downloadpv)
   end
end



