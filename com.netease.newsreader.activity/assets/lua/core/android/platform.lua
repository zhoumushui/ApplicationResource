function rgba(r,g,b,a)
   if type(r) == "table" then
      g = r[2]
      b = r[3]
      a = r[4]
      r = r[1]
   end
   if androidcolor == nil then
   		 androidcolor = luabridge.bindClass('android.graphics.Color')
   end
    return androidcolor["argb.(IIII)I"](androidcolor,a*255,r,g,b)
end

function setContext(context)
	currentContext = context
end



function getContext()
	return currentContext
end




function setStoreString(store)
	
end

function getAndroidViewWithStore(msgwidth,storeContext,cc1)
 	local context = initColorTouchContext(msgwidth,storeContext)
 	local store=loadstring(store1)
 	local cc = loadstring(cc1)
	local nodePropStore = Store.NodePropStore() 
	store:setContext(context) 
	nodePropStore:setNode(cc) 
	nodePropStore:setStore(store) 
	nodePropStore:setup() 
	EventProp.processNodeEventsProp(cc,context)   
	local handler =  cc:getPV()['handler'] 
	return handler 
end



function getAndroidView(msgwidth,storeContext,store1,cc1)
 	local context = initColorTouchContext(msgwidth,storeContext)
 	local store=loadstring(store1)
 	local cc = loadstring(cc1)
	local nodePropStore = Store.NodePropStore() 
	store:setContext(context) 
	nodePropStore:setNode(cc) 
	nodePropStore:setStore(store) 
	nodePropStore:setup() 
	EventProp.processNodeEventsProp(cc,context)   
	local handler =  cc:getPV()['handler'] 
	return handler 
end

function popViewControllerById(vcId)
		 local vc =  getNodeRef(vcId)
		 vc:pop()

end

function luagc()
end

function destroyApp(appId)
	   		--print(".....destroyApp")
	unNodeRef(appId)
	setApplication(nil)
	collectgarbage("collect")
end


function exitApp(appId)
	 local app =  getNodeRef(appId)
	  app:exit() 
	collectgarbage("collect")
end

function onChangeTheme(appName,themeName)
		local app = getNodeRef(appName)
		app:changeTheme(themeName)
end

function onLoginChange(appName,bLogin)
	local app = getNodeRef(appName)
	app:onLoginChange(appName)
end

function newLightApp(name,displayname,version,coreVersion)
 local app =main.main(name,displayname,version,coreVersion) 
 setApplication(app) 
 local key = addNodeRef(app) 
 return key 
end




function  enterApp(appId,params)
	local app = getNodeRef(appId) 
	local paramstb =nil if params ~=nil then paramstb = cjson.decode(params) end
	local cc =  app:enter(paramstb)
	return   cc['_pv']['handler'] 
end


function receiveMsg(appId,msg)
	local app = getNodeRef(appId) 
	app:receiveMessage(msg)
end

function getRootAppDir(appname)
	if appProfile== nil then
		appProfile = luabridge.bindClass("com.netease.colorui.AppProfile")
	end
	 local apppath =  appProfile['getRootAppDir.(Ljava/lang/String;)Ljava/lang/String;'](appProfile,appname)
	 return apppath
end

function getApplication()
	return mainapp
end

function getAppName()
	return mainapp._appName
end

function setApplication(app)
	--print("curApp,setApplication now")
	mainapp = app
end

function getScreenHeightUnit()
	if appProfile == nil then
		appProfile = luabridge.bindClass("com.netease.colorui.AppProfile")
	end
	local screenhight  = appProfile["getScreenHeightUnit.()F"](appProfile)
	return appProfile["getScreenHeightUnit.()F"](appProfile)

end

function getScreenWidthUnit()
	if screenWidthUnit == nil then
		if appProfile== nil then
			appProfile = luabridge.bindClass("com.netease.colorui.AppProfile")
		end
		screenWidthUnit = appProfile["getScreenWidthUnit.()F"](appProfile)
	end
	return screenWidthUnit
	-- return appProfile["getScreenWidthUnit.()F"](appProfile)
end