local luajava=luajava
local print=print
local getApplication = getApplication
local lightappInfo = lightappInfo
module "luabridge"



 
--	hasJavaMethod，判断是否存在某个方法  hasJavaMethod(obj,"toString.()Ljava/lang/String;")
function  hasJavaMethod(javaObject,methodName)
		return luajava.hasJavaMethod(javaObject,methodName)
end


-- b

function newInstance(constructName,...)
	return luajava.newJavaInstance(constructName,...)
end


function bindClass(clsName)
	return luajava.bindClass(clsName)
end

function createSoftProxy(listenerName,listenerUUID,evtName)
	return luajava.createSoftProxy(listenerName,listenerUUID,evtName,lightappInfo.appName)
end
