
viewContructor = function(cls, absView, ...)
   local self = setmetatable({}, cls)
--   self["owner"] = absView
   self["handler"] = self:newPlatformView(absView, ...)
   self:init(absView, ...)
   return self   
end

createNewPlatformView = function(base)
   local newC = {}
   newC.__index = newC
   setmetatable(newC, {
                   __index = base,
                   __call = viewContructor,
   })
   return newC
end

--[[
   1. abstraction view
   2. platformview
   3. handler

   View(absView, param1, param2, ...)
]]

View = createNewPlatformView(nil)

--@override
--@platform
function View:newPlatformView(absView, ...)
	self['type']="View"
	return ViewOwner:createView("View",currentContext)
end

--may be override
function View:init(absView, ...)
--   self["absView"] = absView;
   self["height"] = 0
   self["width"] = 0
   self["left"] = 0
   self["right"] = 0
   self["top"] = 0
   self["bottom"] = 0
      return self
end

--@platform
function View:setFrame(l, t, w, h)  
   self["left"] = l
   self["right"]= l+w
   self["bottom"] = t+h
   self["top"] = t
   self["width"] = w
   self["height"] = h

	ViewOwner['View']["setFrame.(Landroid/view/View;FFFF)V"](ViewOwner['View'],
	self['handler'],SystemInfo:getPX(self["left"]),SystemInfo:getPX(self["top"]),SystemInfo:getPX(self["width"]),SystemInfo:getPX(self["height"]))
	
	if self['text']~=nil then
			ViewOwner['View']["setText.(Landroid/view/View;Ljava/lang/String;)V"](ViewOwner['View'],self['handler'],self['text'])
	end
		
end

--@platform
function View:setRight(r)
 self["right"]= r
end

--@platform
function View:setLeft(l)
  self["left"] = l
end

--@platform
function View:setTop(t)
   self["top"]=t
end

--@platform
function View:setBottom(b)
   self["bottom"]=b
end


--@platform
function View:setWidth(w)
	self["width"] = w
	self["right"]  = self["left"]+w
end

--@platform
function View:setHeight(h)
	self["height"] =h
	self["bottom"]  = self["top"]+ h
end

--@platform
function View:preferedSize(h)
   local handler = o["handler"]   
end

--@platform
function View:tostring()
   return tostring(self["handler"])
end

--@platform
function View:setBackgroundImage(url)
	local imgurl = url
	if string.starts(url,"app://") then
			local appName = lightappInfo.appName	
			imgurl =  string.gsub(url,"app://","app://"..appName.."/")
	end

	ViewOwner['View']["setBackgroundImage.(Landroid/view/View;Ljava/lang/String;)V"](ViewOwner['View'],self['handler'],imgurl)
end

--@platform
function View:setBorderWidth(w)
--   return self["handler"]:setBorderWidth(w)
end

--@platform
function View:setBorderColor(c)
--   return self["handler"]:setBorderColor(c)
end

--@platform
function View:setBackgroundColor(c)
	ViewOwner['View']["setBackgroundColor.(Landroid/view/View;I)V"](ViewOwner['View'],self['handler'],c)
end

--@platform
--@android uncompatibility

--@platform
function View:removeFromParent()
	ViewOwner['View']["removeFromParent.(Landroid/view/View;)V"](ViewOwner['View'],self['handler'])
end


function View:preferredSize(size)
--	print(debug.traceback())
	if self['type'] == 'TextView' or self['type']=='ImageView' or self['type']=='HtmlTextView' or self['type'] == 'Button' or self['type']=='SwitchButton' then
		local swidth = size.width
		local sheight = size.height
		local rect = ViewOwner['View']["getViewSize.(Landroid/view/View;FF)Ljava/lang/String;"]( ViewOwner['View'],self['handler'],sheight,swidth);
		local _,index = string.find(rect,'_')	
		local rectwidth =tonumber( string.sub(rect,1,index-1))
		local rectheight =tonumber( string.sub(rect,index+1))
  		return {width=rectwidth,height=rectheight};
	else 
		return {width=self['width'],height=self['height']};	
	end 
end

function View:initUUIDCallback(evtName, methodName)
   if self.__viewcbs == nil then
     	self.__viewcbs = {}
	 	self["uuid"]= uuid()
	 	Callbacks[self["uuid"]] = self.__viewcbs
   end
   if evtName and self.__viewcbs[evtName]==nil then
   	self.__viewcbs[evtName] = {}
 	end
 	if evtName and methodName and self.__viewcbs[evtName][methodName]==nil then
 		self.__viewcbs[evtName][methodName] = {}
 	end
end

function View:insertUUIDCallback(evtName, methodName, cb)
	if evtName == nil or methodName == nil or cb == nil then
		error("insertUUIDCallback: evtName == nil or methodName == nil or cb == nil")
	end
   self:initUUIDCallback(evtName, methodName)
   table.insert(self.__viewcbs[evtName][methodName], cb)
end

function View:removeEventAllListener(evtName)
		self.__viewcbs[evtName] = viewtouch_cb
end



function View:addEventListener(evtName, cb,target)
	View.initUUIDCallback(self)

   if evtName == "click" or evtName =="tap" then
  
   	  if  self.__viewcbs[evtName] ==nil then
        local vc_cb={}
        vc_cb.onClick = {}


        self.__viewcbs[evtName] =vc_cb
      end
	    
	  if target ~=nil then
	    local cbwrap  = function()
	    		local evt ={}
	    		evt.target = target
	    		cb(evt)
	    end
	   	table.insert(self.__viewcbs[evtName]["onClick"],cbwrap)
	  else
	  	table.insert(self.__viewcbs[evtName]["onClick"],cb)
	  end



  	--   local viewclick_cb={}
	  -- function viewclick_cb.onClick(v)
			-- cb(v)	
	  -- end
	   local listenerProxy  = luabridge.createSoftProxy('android.view.View$OnClickListener',self["uuid"],evtName)	   
	   self["handler"]["setOnClickListener.(Landroid/view/View$OnClickListener;)V"]( self["handler"],listenerProxy)   

  	 elseif evtName == "touchesEnded" or evtName =="touchesBegin" then
  		local viewtouch_cb={}
		function viewtouch_cb.onTouch(v,event)		
			cb(event)				
			return true
		end
		self.__viewcbs[evtName] = viewtouch_cb
	   local touchProxy  = luabridge.createSoftProxy('android.view.View$OnTouchListener',self["uuid"],evtName)
	   self["handler"]["setOnTouchListener.(Landroid/view/View$OnTouchListener;)V"](self["handler"],touchProxy)
  	elseif evtName == "normal" or evtName=="hilighted"  then
  		local viewtouch_cb={}
		function viewtouch_cb.onTouch(v,event)	
			cb(event)				
			return false
		end
		self.__viewcbs[evtName] = viewtouch_cb
	   local touchProxy  = luabridge.createSoftProxy('OnButtonStateListenerProxy',self["uuid"],evtName)
	   self["handler"]["setOnTouchListener.(Landroid/view/View$OnTouchListener;)V"](self["handler"],touchProxy)
  	elseif evtName =='guagua' then
  		local viewguagua_cb = {}
  		function viewguagua_cb.onGuagua()
  			cb()
  		end
		self.__viewcbs[evtName] = viewguagua_cb
	   local touchProxy  = luabridge.createSoftProxy('com.netease.colorui.view.GuaguaKaView$GuaguaListener',self["uuid"],evtName)
	   self["handler"]["setGuaListener.(Lcom/netease/colorui/view/GuaguaKaView$GuaguaListener;)V"](self["handler"],touchProxy)
	end
end


function View:removeEventListener(evtName, cb)
	
end

function View:setClipsToBounds(s)
--   self['handler']:setClipsToBounds(s)
end

function View:rotate(rotation)
	print("view rotate self witdh is "..self["width"])
	print("view rotate self height is "..self["height"])
-- self["width"] = w
--    self["height"] = h

	-- ViewOwner['View']["rotate.(Landroid/view/View;I)V"](ViewOwner['View'],self['handler'],rotation)
	ViewOwner['View']["rotate.(Landroid/view/View;III)V"](ViewOwner['View'],self['handler'],rotation,SystemInfo:getPX( self["height"]/2),SystemInfo:getPX( self["height"]/2))
end

function View:rotate1(rotation,pivotX,pivotY)
	ViewOwner['View']["rotate.(Landroid/view/View;III)V"](ViewOwner['View'],self['handler'],rotation,SystemInfo:getPX(pivotX),SystemInfo:getPX(pivotY))
end


function View:moveToByAni(start, to, duration, options, cb)
   View.initUUIDCallback(self)
   local _cbs={}

   function _cbs.onAnimationEnd()
   	      self.__viewcbs["animation"] = nil
      cb()
   end
   self.__viewcbs["animation"] = _cbs

  local listenerProxy  = luabridge.createSoftProxy('android.view.animation.Animation$AnimationListener',self["uuid"],"animation")    
  ViewOwner['View']["moveToByAni.(Landroid/view/View;IIIIILandroid/view/animation/Animation$AnimationListener;)V"](ViewOwner['View'],self['handler'],SystemInfo:getPX(start.x-self["left"]),SystemInfo:getPX(start.y-self["top"]),SystemInfo:getPX(to.x-self["left"]),SystemInfo:getPX(to.y-self["top"]),duration,listenerProxy)
end



function View:changeFrameToByAni(start, to, duration, options, cb)
   View.initUUIDCallback(self)
   local _cbs={}

   function _cbs.onAnimationEnd()
      cb()
      self.__viewcbs["animation"] = nil
   end
   self.__viewcbs["animation"] = _cbs


  local listenerProxy  = luabridge.createSoftProxy('android.view.animation.Animation$AnimationListener',self["uuid"],"animation")    

  ViewOwner['View']["changeFrameToByAni.(Landroid/view/View;IIFFIIFFILandroid/view/animation/Animation$AnimationListener;)V"](ViewOwner['View'],self['handler'],
  	SystemInfo:getPX(start.x-self["left"]),SystemInfo:getPX(start.y-self["top"]),
  	start.width/self["width"],start.height/self["height"],SystemInfo:getPX(to.x-self["left"]),
  	SystemInfo:getPX(to.y-self["top"]),to.width/self["width"],to.height/self["height"],duration,listenerProxy)
end


function View:startAnimation(animation)
	self['handler']['startAnimation.(Landroid/view/animation/Animation;)V'](self['handler'],animation['handler'])
end

function View:setAlpha(c)


  if c < 0.02 then
    self:setVisible(false)
  else 
    self:setVisible(true)
  end



	ViewOwner['View']["setAlpha.(Landroid/view/View;F)V"](ViewOwner['View'],self["handler"],c)
    --self["handler"]["setAlpha.(F)V"](self["handler"],c)
end


function View:showLoading(label, descLabel, customView, animated)
		local customPV = nil
	if customView then
		print("loading is not nil")
		customPV = customView._pv["handler"]
	else
		print("loading customview is nil")
	end
	ViewOwner['View']["showLoading.(Landroid/view/View;Landroid/view/View;II)V"](ViewOwner['View'],self["handler"],customPV,SystemInfo:getPX(customView["_width"]),SystemInfo:getPX(customView["_height"]))
end

function View:hideLoading(animated)
		ViewOwner['View']["hideLoading.(Landroid/view/View;)V"](ViewOwner['View'],self["handler"])
--   self['handler']:hideLoading(animated)
end

function View:setLoadingProgress(percent)
	print('android setLoadingProgress not support')
  -- self['handler']:setLoadingProgress(percent)
end

function View:setLoadingProgressBGOpacity(opacity)
	print('android setLoadingProgressBGOpacity not support')
   --self['handler']:setLoadingProgressBGOpacity(opacity)
end


function View:resetTransform()
	ViewOwner['View']["resetTransform.(Landroid/view/View;)V"](ViewOwner['View'],self["handler"])
end

function View:setAnchor(x,y)
end

function View:setVisible(bVisible)
	--INVISIBLE == 4
	--Visible == 0
	if bVisible then
		self["handler"]["setVisibility.(I)V"](self["handler"],0)
	else
		self["handler"]["setVisibility.(I)V"](self["handler"],4)
	end
end

--获取焦点
function View:getFocus()
	print("getFocus")
	ViewOwner['View']["getFocus.(Landroid/view/View;)V"](ViewOwner['View'],self["handler"])
end

--关闭软键盘
function View:hidekeyboard()
	print("hidekeyboard")
	ViewOwner['View']["hidekeyboard.(Landroid/view/View;)V"](ViewOwner['View'],self["handler"])
end
function View:setAnchor(x,y)
	--TODO
end

function View:setAngle(angle)
	--TODO 

end

function View:getAngle()
	return 0
end


function View:resetTransform()
	ViewOwner['View']["resetTransform.(Landroid/view/View;)V"](ViewOwner['View'],self["handler"])
end

function View:setScale(scale)
	ViewOwner['View']["setScale.(Landroid/view/View;F)V"](ViewOwner['View'],self["handler"],scale)
end

function View:getScale()
	return ViewOwner['View']["getScale.(Landroid/view/View;)V"](ViewOwner['View'],self["handler"])
end


function View:setPosition(x,y)
	ViewOwner['View']['setPosition.(Landroid/view/View;II)V'](ViewOwner['View'],self['handler'],SystemInfo:getPX(x),SystemInfo:getPX(y))
end

function View:getPosition()
	local pos = ViewOwner['View']['getPosition.(Landroid/view/View;)Ljava/lang/String;'](ViewOwner['View'],self['handler'])

	local _,index = string.find(pos,',')	
	local x =tonumber( string.sub(pos,1,index-1))
	local y =tonumber( string.sub(pos,index+1))
	return x,y
end

-- 设置view是否可点击
function View:setEnabled(b)
	self["handler"]["setEnabled.(Z)V"](self["handler"],b)
end

function View:setBorderRadius(radius)
	 ViewOwner['View']['setBorderRadius.(Landroid/view/View;F)V'](ViewOwner['View'],self['handler'],SystemInfo:getPX(radius))
end
