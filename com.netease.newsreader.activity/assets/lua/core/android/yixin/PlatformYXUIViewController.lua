module("PlatformYXUIViewController", package.seeall)

PlatformYXUIViewController = {}
PlatformYXUIViewController.__index = PlatformYXUIViewController

setmetatable(PlatformYXUIViewController,
   {__call = function(caller, instance)
               if yixinViewControllClass == nil then
                     yixinViewControllClass = luabridge.bindClass("com.netease.colorui.lightapp.v2.YXViewControllerFactory")
               end
               local newObj = setmetatable({}, PlatformYXUIViewController)
           --    print("appName   is..\t"..lightappInfo.appName)
               newObj["handler"] = yixinViewControllClass["newController.(Ljava/lang/String;)Lcom/netease/colorui/lightapp/v2/YXViewController;"](yixinViewControllClass,lightappInfo.appName)
               local refuuid = addNodeRef(instance)
               newObj["_refid"]=refuuid
            --   print("init refidis "..refuuid)
               -- local refuuid  = uuid()
               newObj["handler"]["setUUID.(Ljava/lang/String;)V"](newObj["handler"],refuuid)
               newObj.__listeners = {}
               return newObj
             end
   })

function PlatformYXUIViewController:setTitle(title)
   self["handler"]['setTitleText.(Ljava/lang/String;)V'](self["handler"],title)
end

function PlatformYXUIViewController:setTitleColor(c)
   self["handler"]['setTitleTextColor.(I)V'](self["handler"],c)
end

function PlatformYXUIViewController:setUUID(refuuid)
       self["handler"]["setUUID.(Ljava/lang/String;)V"](self["handler"],refuuid)
end

function PlatformYXUIViewController:setTitleView(titleV)
        if titleV == nil then
            self["handler"]["setTitleView.(Landroid/view/View;)V"](self["handler"],nil)
        else
           self["handler"]["setTitleView.(Landroid/view/View;)V"](self["handler"],titleV._pv["handler"])
        end
end
  
--configure navationbar
function PlatformYXUIViewController:setShowBackButton(bShow)
            --  print("now setShowBackButton.....")

     self["handler"]['setShowBackButton.(Z)V'](self["handler"],bShow)
end

function PlatformYXUIViewController:setShowNavigationBar(bShow)
  self["handler"]['setShowNavigationBar.(Z)V'](self["handler"],bShow)
end

function PlatformYXUIViewController:setBStartFromScreenTop(b)
  
      self["handler"]["setStartFromScreenTop.(Z)V"]( self["handler"],b)
   --self["handler"]:setStartFromScreenTop(b)
end
function PlatformYXUIViewController:setPortrait(new)
      self["handler"]["setPortrait.(Z)V"](self["handler"],new)
end

function PlatformYXUIViewController:setNavigationBarRightView(v)
    self._navigationBarRightView = v
          if v == nil then
              self["handler"]['setNavigationBarRightView.(Landroid/view/View;)V'](self["handler"],nil)       
          else 
              self["handler"]['setNavigationBarRightView.(Landroid/view/View;)V'](self["handler"],v._pv["handler"])       
          end
end

function PlatformYXUIViewController:setNavigationBarLeftView(v)
        self._navigationBarLeftView = v
      self["handler"]['setNavigationBarLeftView.(Landroid/view/View;)V'](self["handler"],v._pv["handler"])
end
   
function PlatformYXUIViewController:setNavigationBarBgColor(c)

      self["handler"]['setNavigationBarBgColor.(I)V'](self["handler"],c)
   end
function PlatformYXUIViewController:setNavigationBarBgImg(src)
   --self["handler"]:setNavigationBarBgImg(src)
end
function PlatformYXUIViewController:setNavigationBarStyle(style)
    self["handler"]["setNavigationBarStyle.(Ljava/lang/String;)V"]( self["handler"],style)
end

function PlatformYXUIViewController:getNavigationBarHeight()

      local height =  self["handler"]['getNavBarHeight.()D'](self["handler"])
   return height;
   --return self["handler"]:getNavigationBarHeight()
end
function PlatformYXUIViewController:getStatusBarHeight()
--   return self["handler"]['getStatusBarHeight.()I'](self["handler"])
return 0;
end

function PlatformYXUIViewController:getScreenHeight()
      return self["handler"]['getScreenHeight.()D'](self["handler"])
end


function PlatformYXUIViewController:getApplicationHeight()
    return self:getScreenHeight()
      --return self["handler"]['getApplicationHeight.()I'](self["handler"])
end
   
function PlatformYXUIViewController:setRootView(v)
   return self["handler"]['setRootView.(Landroid/view/View;)V'](self["handler"],v._pv["handler"])
end

function PlatformYXUIViewController:beginEdit(editview)
--   self["handler"]:beginEdit(editview)
end

function PlatformYXUIViewController:endEdit()
  -- self["handler"]:endEdit()
end
   
function PlatformYXUIViewController:pushViewController(controller)
   return self["handler"]['pushViewController.(Lcom/netease/colorui/lightapp/v2/YXViewController;)V'](self["handler"],controller._pv["handler"])
end
function PlatformYXUIViewController:pop(bAnimate)
      unNodeRef(self._refid)
   if bAnimate == nil then
      bAnimate = true
   end
   self["handler"]['pop.(Z)V'](self["handler"],bAnimate)
end

function PlatformYXUIViewController:switchViewController(controller, bAni)
    print("......now switchViewController")
      unNodeRef(self._refid)
   self["handler"]["switchViewController.(Lcom/netease/colorui/lightapp/v2/YXViewController;Z)V"](self["handler"],controller._pv["handler"], bAni)
end

function PlatformYXUIViewController:hideStatusBar()
  -- self["handler"]:hideStatusBar()
end

function PlatformYXUIViewController:showStatusBar()
   --self["handler"]:showStatusBar()
end

function PlatformYXUIViewController:setStatusBarStyle(style)
   --self["handler"]:setStatusBarStyle(style)
end

function PlatformYXUIViewController:setBackButtonStyle(style)
    self["handler"]["setBackButtonStyle.(Ljava/lang/String;)V"](self["handler"],style)
   --self["handler"]:setBackButtonStyle(style)
end
function PlatformYXUIViewController:setNeedWakeLock(new)
  self["handler"]["setNeedWakeLock.(Z)V"](self["handler"],new)
end

function PlatformYXUIViewController.showNavigationBar(bAni)
 --  self._pv:showNavigationBar(bAni)
end

function PlatformYXUIViewController.hideNavigationBar(bAni)
   --self._pv:hideNavigationBar(bAni)
end


function PlatformYXUIViewController:initUUIDCallback()
   if self.__vccbs == nil then
       self.__vccbs = {}
       self["uuid"]= uuid()
       Callbacks[self["uuid"]] =    self.__vccbs
   end
end

function PlatformYXUIViewController:isShown()
   return self["handler"]["isShown.()Z"](self["handler"])
end



function PlatformYXUIViewController:addEventListener(evtName, cb)
     PlatformYXUIViewController.initUUIDCallback(self)
   if evtName == "pushed"  then
     local vc_cb={}
     function vc_cb.pushed(v)
         cb(v) 
     end
      self.__vccbs[evtName] = vc_cb
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerPushedListener',self["uuid"],evtName)    
      self["handler"]["setPushedListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerPushedListener;)V"]( self["handler"],listenerProxy)   
    elseif evtName == "willPush" then
      local vc_cb={}
      function vc_cb.willPush()
         cb(v) 
      end
      self.__vccbs[evtName] = vc_cb
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerWillPushListener',self["uuid"],evtName)    
      self["handler"]["setWillPushListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerWillPushListener;)V"]( self["handler"],listenerProxy)   
   elseif evtName == "willPop"  then  
       if  self.__vccbs[evtName] ==nil then
        local vc_cb={}
        vc_cb.willPop = {}
        self.__vccbs[evtName] =vc_cb
      end
      table.insert(self.__vccbs[evtName]["willPop"],cb)
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerWillPopListener',self["uuid"],evtName)    
      self["handler"]["setWillPopListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerWillPopListener;)V"]( self["handler"],listenerProxy)   
   elseif evtName == "popped"  then
      if  self.__vccbs[evtName] ==nil then
        local vc_cb={}
        vc_cb.popped = {}
        self.__vccbs[evtName] =vc_cb
      end
      table.insert(self.__vccbs[evtName]["popped"],cb)
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerPopedListener',self["uuid"],evtName)    
      self["handler"]["setPopedListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerPopedListener;)V"]( self["handler"],listenerProxy)   
 
   elseif evtName =="paused"  then
      local vc_cb={}
      function vc_cb.paused()
          cb()
      end
      self.__vccbs[evtName] = vc_cb
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerPausedListener',self["uuid"],evtName)    
      self["handler"]["setViewControllerPausedListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerPausedListener;)V"]( self["handler"],listenerProxy)   

   elseif evtName =="willPause" then
    --   * willPause,
--   * paused
  -- * willResume
  -- * resumed
      local vc_cb={}
      function vc_cb.willPause()
          cb()
      end
      self.__vccbs[evtName] = vc_cb
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerWillPauseListener',self["uuid"],evtName)    
      self["handler"]["setViewControllerWillPauseListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerWillPauseListener;)V"]( self["handler"],listenerProxy)   
  elseif evtName =="resumed"  then
      local vc_cb={}
      function vc_cb.resumed()
          cb()
      end
      self.__vccbs[evtName] = vc_cb
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerResumedListener',self["uuid"],evtName)    
      self["handler"]["setViewControllerResumedListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerResumedListener;)V"]( self["handler"],listenerProxy)   
   elseif evtName =="willResume" then

    --   * willPause,
--   * paused
  -- * willResume
  -- * resumed

      local vc_cb={}
      function vc_cb.willResume()
          cb()
      end
      self.__vccbs[evtName] = vc_cb
      local listenerProxy  = luabridge.createSoftProxy('com.netease.colorui.lightapp.v2.YXViewController$ViewControllerWillResumeListener',self["uuid"],evtName)    
      self["handler"]["setViewControllerWillResumeListener.(Lcom/netease/colorui/lightapp/v2/YXViewController$ViewControllerWillResumeListener;)V"]( self["handler"],listenerProxy)   
  end
   

end

function PlatformYXUIViewController:removeEventListener(evtName, cb)
   -- local listeners = self.__listeners[evtName]
   -- if listeners and listeners[cb] then
   --    listeners[cb] = nil
   -- end

   -- self["handler"]:removeEventListener_cb(evtName, cb)
end

function PlatformYXUIViewController:setBackgroundColor(c)
   self["handler"]['setBackgroundColor.(I)V'](self["handler"],c)
end
  


function PlatformYXUIViewController:setSlideUpWhenKeyBoardAppearType(new)

    -- self["handler"]:setSlideUpWhenKeyBoardAppearType(style)  
end

function PlatformYXUIViewController:disableBackBtn()
 self["handler"]["disableBackButton.()V"](self["handler"])
 end

function PlatformYXUIViewController:enableBackBtn()
                   self["handler"]["enableBackButton.()V"](self["handler"])
                  
  --  self["handler"]:disableBackBtn()
 end

function PlatformYXUIViewController:showDefaultLoading(loadingLabel,loadingDesc,bgOpacity)
  self["handler"]["showDefaultLoading.(Ljava/lang/String;Ljava/lang/String;F)V"](self["handler"],loadingLabel,loadingDesc,bgOpacity)
end

function PlatformYXUIViewController:showCustomLoading(customView1,rotateView)
  if rotateView == nil then
        self["handler"]["showCustomLoading.(Landroid/view/View;Landroid/view/View;)V"](self["handler"],customView1._pv["handler"],nil)
  else
      self["handler"]["showCustomLoading.(Landroid/view/View;Landroid/view/View;)V"](self["handler"],customView1._pv["handler"],rotateView._pv["handler"])
  end
end

function PlatformYXUIViewController:hideLoading()
  self["handler"]["hideLoading.()V"](self["handler"])
end

function PlatformYXUIViewController:hideInputMethod(node)
  self["handler"]["hideInputMethod.(Landroid/view/View;)V"](self["handler"],node._pv["handler"])
end


 