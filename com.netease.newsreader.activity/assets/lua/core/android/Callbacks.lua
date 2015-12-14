--[[
全局弱引用,
	key值:控件uuid
	value:回调函数表
]]
Callbacks = {}
setmetatable(Callbacks, { __mode = "v" })





function callbacksInvoke(uuid,evtname,methodname,...)
	local callback = Callbacks[uuid]
	if callback ~=nil then
		 --local oncallback = callback[evtname][methodname]
		-- local evtCallbacks = callback[evtname][methodname]
		 local oncallback = callback[evtname][methodname]

		 if type(oncallback) == 'function' then
		 		return	oncallback(...)
		 elseif type(oncallback) == "table" then
			  for k, v in pairs(oncallback) do
			    v(...)
			  end
		 else
		 	print("callbcak function is nil...")
		 end
	 	 --return	callback[evtname][methodname](...)
	else
		print("calback is nil,uuid is:\t"..uuid.."evname is:\t"..evtname.."methodname is;\t"..methodname)
	end
	
end