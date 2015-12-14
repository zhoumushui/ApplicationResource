require "stdlib/class/Class"
require "stdlib/mixins/observable"
require "colortouch/layout/AutoLayout"
require "colortouch/layout/SizeModel"
--module("Timer", package.seeall)

--[[
   layout state:
   init
   beginlayout
   doinglayout
   done
   init
]]


Timer = Class.Class(
   "Timer",
   {
          
   
   }
)

function setDisplayLink(cb)
	local cbwrap = function()
		cb("",os.clock())
	end	
	return setInterval(cbwrap,0.5)
end

function setInterval(f,delay)
	-- if globalhandler ==nil then
	local	handlercls = luabridge.bindClass('com.netease.os.ColorHandler')
	local handler = handlercls["createNewHandler.()Lcom/netease/os/ColorHandler;"](handlercls);

	local timer = Timer()
	local task={}
	function task.run()
		f()

	end		
		-- end
	timer["runnable"] = luabridge.createSoftProxy('java.lang.Runnable',timer["uuid"],"time")	
	--非全局handler
	timer["handler"] = handler;
 	timer.__callbacks["time"] = task
	handler["postInterval.(Ljava/lang/Runnable;I)V"](handler,timer["runnable"] ,delay*1000)
	return timer
end


function Timer.prototype:invalidate()
		Callbacks[self["uuid"]] = nil
	if self.handler ~=nil then
	   self.handler['cancelInterval.()V'](self.handler)
	   self["task"] = null; 
	   self.runnable = nil
	else
	  if globalhandler~=nil and self.runnable~=nil then	  
	  		globalhandler['cancel.(Ljava/lang/Runnable;)V'](globalhandler,self.runnable)
	  end 	 
	  self["task"] = null; 
	  self.runnable = nil
	 end 
end

--@override
function Timer.prototype:init(inlineprops, ...)	
		self.__callbacks={}
		self["uuid"]= uuid()
     	Callbacks[self["uuid"]] = self.__callbacks
end


function Timer.prototype:dispose()
	self:invalidate()
end

function setTimeout(f,delay)
	local timer = Timer()
	local task={}
	function task.run()
		f()
	end		
 	timer.__callbacks["time"] = task
	timer["global"] =true

	if globalhandler ==nil then
		local	handlercls = luabridge.bindClass('com.netease.os.ColorHandler')
		globalhandler = handlercls["getInstanceHandler.()Lcom/netease/os/ColorHandler;"](handlercls);
	end
	timer["runnable"] = luabridge.createSoftProxy('java.lang.Runnable',timer["uuid"],"time")	
	globalhandler["postDelayed1.(Ljava/lang/Runnable;J)Z"](globalhandler,timer["runnable"] ,delay)
	return timer
end


