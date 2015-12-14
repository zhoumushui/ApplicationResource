DEBUG = true
LAYOUT = false
LAYOUTWARNING = false
NODE = false

LAYOUTFRAME = false

if not platform.isIOS() then 

	androidlog=nil
	function print(...)
		if not DEBUG then return end
		local strlog = ""
		if type(strlog) ~= "string" then
			return
		end
      for i,v in ipairs{...} do
       strlog = strlog .." ".. tostring(v) 
    end

		if androidlog==nil then
		   	androidlog = luabridge.bindClass('android.util.Log')	
	   end
	    androidlog["i.(Ljava/lang/String;Ljava/lang/String;)I"](androidlog,"lua",strlog);
	end
end


function ctLog(...)
   print(...)
end

function logNodeCreation(n)
   if not DEBUG then return end
   printTable(n:properties())
end

function logCreatePlatformView(pv)
   if not DEBUG then return end
end

function logError(format, ...)
   print(debug.traceback())
   error(string.format(format, ...))
end

function log(format, ...)
   if DEBUG then
      print(string.format(format, ...))
   end
end

function layoutLog(format, ...)
   if DEBUG and LAYOUT then
      local newformat = string.format("%s:%s", "layout", format)
      print(string.format(newformat, ...))
   end
end

function layoutError(format, ...)
   print("!!!!!!!!!!!!!!!!!layout error!!!!!!!!!!!!!!!")
   print(debug.traceback())
   error(string.format(format, ...))
end

function layoutWarning(format, ...)
   if not LAYOUTWARNING then return end
   
   local newformat = string.format("%s, %s", "Layout Warning:", format)
   print(string.format(newformat, ...))
end


function nodeLog(format, ...)
   if NODE and DEBUG then
      local newformat = string.format("%s:%s", "node", format)
      print(string.format(newformat, ...))
   end
end

function nodeError(format, ...)
   print("!!!!!!!!!!!!!!!!!node error!!!!!!!!!!!!!!!")
   print(debug.traceback())
   error(string.format(format, ...))
end
