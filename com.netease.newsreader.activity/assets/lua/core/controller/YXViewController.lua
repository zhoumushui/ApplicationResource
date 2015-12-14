module("YXViewController", package.seeall)

require "stdlib/class/Class"
require "stdlib/mixins/observable"
require "colortouch/Container"
require "colortouch/animation/Animator"

--[[
   support event:
   * willPush
   * pushed
   * willPop
   * popped
   * willPause,
   * paused
   * willResume
   * resumed
]]
--[[
/**
  @section{YXViewController概述}
  
  ViewController是用来呈现和管理不同层级视图的UI框架
  --------------------------------------------------

  @method[getApp]{
    获取VC对应的app对象

    @class[YXViewController]
    @param[None]
    @return{
      返回对应的application对象或nil
    }
  }

  @method[isShown]{
    判断当前VC是否被显示过

    @class[YXViewController]
    @param[None]
    @return{
      boolean,当前VC是否被显示过
    }
  }

  @method[isVisible]{
    判断当前VC是否可见

    @class[YXViewController]
    @param[None]
    @return{
      boolean,当前VC是否可见
    }
  }

  @method[getScreenHeight]{
    获取当前设备屏幕的高度

    @class[YXViewController]
    @param[None]
    @return{
      当前设备的屏幕高度
    }
  }

  @method[getApplicationHeight]{
    获取可以作为应用显示的部分屏幕的高度，即如果状态栏存在的话为屏幕高度-状态栏高度，否则为屏幕高度
    
    @class[YXViewController]
    @param[None]    
    @return{
      可以作为应用显示的部分屏幕的高度  
    }
  }

  @method[loadView]{
    返回高度为屏幕高度减去导航栏高度，宽度为屏幕宽度的容器对象.
    用于容纳其他所有子控件
    
    @class[YXViewController]
    @param[None]
    @return{
      生成的VC上最顶层容器对象
    }
  }

  @method[viewLoaded]{
    VC初始化完毕后抛出"viewLoaded"事件的方法

    @class[YXViewController]
    @param[...]
    @return{None}
  }

  @method[showNavigationBar]{
    在VC上显示导航栏

    @class[YXViewController]
    @param[bAni]{
      显示时是否有动画效果
    }
    @return{None}
  }

  @method[hideNavigationBar]{
    在VC上隐藏其导航栏

    @class[YXViewController]
    @param[bAni]{
      显示时是否有动画效果
    }
    @return{None}
  }

  @method[getNavigationBarHeight]{
      获取导航栏的高度
      
      @class[YXViewController]
      @param[None]
      @return{
        导航栏的高度值
      }
  }

  @method[getStatusBarHeight]{
    获取状态栏的高度

    @class[YXViewController]
    @param[None]
    @return{
      状态栏高度
    }
  }

  @method[pushViewController]{
    将viewController对象压入NavigationViewController的显示栈中，
    即显示压入的新的ViewController

    @class[YXViewController]
    @param[controller]{
      要压入的viewController对象
    }
    @param[animated]{
      切换并显示压入的VC时是否有动画效果
    }
    @return{None}

    @verbatim|{
      local newVC = YXViewController{...}
      nowVC:pushViewController[newVC, true]
    }|
  }

  @method[pop]{
    将NavigationViewController显示栈顶的VC弹出，即切换为显示次栈顶的VC

    @class[YXViewController]
    @param[bAnimate]{
      弹出栈顶VC并切换显示次栈顶VC的过程是否有动画效果
    }
    @return{None}

    @verbatim|{
      nowVC:pop(true)
    }|
  }

  @method[switchViewController]{
    弹出栈顶的VC并压入传入的VC对象，即替换当前栈顶VC为新的VC对象
    
    @class[YXViewController]
    @param[controller]{
      要切换显示的VC对象
    }
    @param[bAni]{
      切换过程是否有动画效果
    }
    @return{None}

    @verbatim|{
      local newVC = YXViewController{...}
      nowVC:switchViewController(newVc, false)
    }
  }

  @method[isStatusBarHidden]{
    判断状态栏当前是否是隐藏状态

    @class[YXViewController]
    @param[None]
    @return{
      boolean,状态栏当前是否是隐藏状态    
    }
  }

  @method[hideStatusBar]{
    隐藏系统状态栏

    @class[YXViewController]
    @param[None]
    @return{None}
  }

  @method[showStatusBar]{
    显示系统状态栏

    @class[YXViewController]
    @param[None]
    @return{None}
  }

  @method[setStatusBarStyle]{
    设置状态栏的样式

    Not supported by native code.
  }

  @method[popAllVC]{
    依次弹出所有NavigationViewController显示栈中的VC

    @class[YXViewController]
    @param[bAnimate]{
      弹出过程是否有动画效果
    }
    @return{None}
  }

  @method[addEventListener]{
    为自身增加事件监听

    @class[YXViewController]
    @param[evtName]{
      evtName:事件名
      
    }
    @param[cb]{
      cb：触发时调用的回调
    }
    @return{None}

    @verbatim|{
      vc:addEventListener("pushed",function() ... end)
    }|
  }

  @method[removeEventListener]{
    移除对应事件的监听

    @class[YXViewController]
    @param[evtName]{
      evtName:事件名
      
    }
    @param[cb]{
      cb：触发时调用的回调
    }
    @return{None}

    @verbatim|{
      vc:removeEventListener("popped",function() ... end)
    }|
  }
  
  @method[showActionSheet]{
    显示ios风格的底部菜单

    @class[YXViewController]
    @param[title]{
      ActionSheet的标题内容
    }
    @param[cancel]{
      触发取消动作的条目其提示文字内容
    }

    @param[destructive]{
      一般是触发删除动作的条目其提示文字内容
    }
    @param[others]{
      其他菜单条目的集合
    }
    @param[cb]{
      设置点击各个条目触发的事件回调方法
    }
    @return{None}

    @verbatim|{
      
      vc:showActionSheet("确定删除","取消","删除",nil,function(idx) ... end)
    }|
  } 

  @method[showMask]{
    在VC上显示遮罩效果，同时会使返回按钮无效

    @class[YXViewController]
    @param[maskColor]{}
      遮罩的背景底色
    }
    @param[maskView]{
      容纳遮罩资源的视图view对象
    }
    @return{None}
  }

  @method[dismissMask]{
    取消遮罩效果，并恢复返回按钮可用

    @class[YXViewController]
    @param[None]
    @return{None}
  }

  @method[showLoading]{
    显示loadingCustomView/loadingLabel/loadingDescLabel/loadingCustomViewAutoRotateView
    等定义的提示加载中的视图view
    
    @class[YXViewController]    
    @param[animated]{
      提示加载过程是否有动画效果
    }
    @return{None}
  }

  @method[hideLoading]{
    隐藏提示加载中的视图view

    @class[YXViewController]
    @param[None]
    @return{None}
  }

  @method[disableBackBtn]{
    使返回按钮无效

    @class[YXViewController]
    @param[None]
    @return{None}
  }

  @method[enableBackBtn]{
    使返回按钮起效
    
    @class[YXViewController]
    @param[None]
    @return{None}
  }

  @property[title]{
    @class[YXViewController]

    VC的标题文字内容
  }

  @property[titleColor]{
    @class[YXViewController]

    VC标题的文字颜色
  }

  @property[titleView]{
    @class[YXViewController]

    可设置的VC标题view对象
  }

  @property[bShowBackBtn]{
    @class[YXViewController]

    是否显示返回按钮
  }

  @property[backButtonStyle]{
    @class[YXViewController]

    返回按钮的样式，"gray"/"white"等
  }

  @property[navigationBarLeftView]{
    @class[YXViewController]

    用户可自定义的导航栏左边的视图view
  }

  @property[navigationbarRightView]{
    @class[YXViewController]

    用户可自定仪的导航栏右边的视图view
  }

  @property[navigationBarBgColor]{
    @class[YXViewController]

    导航栏其背景底色
  }

  @property[navigationBarBgImg]{
    @class[YXViewController]

    导航栏可设置的背景图资源
  }

  @property[navigationBarStyle]{
    @class[YXViewController]

    导航栏可设置的预设样式，如"default","green","white"等
  }

  @property[bPortrait]{
    @class[YXViewController]

    当前屏幕是否处于竖屏状态    
  }

  @property[backgroundColor]{
    @class[YXViewController]

    当前VC整体的背景色  
  }

  @property[slideUpWhenKeyBoardApperaType]{
    @class[YXViewController]

    在点击输入框软键盘弹出的时候，VC如果做出适应的选项，如slideupSelfAdaption, slideupKeyboardHeight, slideupNone等。
    slideupSelfAdaption为自适应，如果输入框不被阻挡则不调整
    slideupKeyboardHeight为不管输入框是否被阻挡都上移软键盘的高度
    slideupNone为不对软键盘弹出做调整

  }

  @property[bShowNaviBar]{
    @class[YXViewController]

    是否显示导航栏
  }

  @property[bStartFromScreenTop]{
    @class[YXViewController]

    是否是从屏幕顶端开始显示应用内容    
  }

  @property[prevViewController]{
    @class[YXViewController]

    当前VC如果是push进栈，之前栈顶的vc即当前vc的prevViewController
  }

  @property[nextViewController]{
    @class[YXViewController]
    
    同上，之前栈顶的VC其nextViewControllr即当前的vc
  }

  @property[loadingCustomView]{
    @class[YXViewController]

    可自定义加载过程中会出现的view，替换默认显示的loading图标
  }

  @property[loadingCustomViewAutoRotate]{
    @class[YXViewController]

    设置自定义的loadingCustomViewAutoRotateView是否会自动旋转
  }

  @property[loadingCustomViewAutoRotateView]{
    @class[YXViewController]

    设置在加载过程中显示的自定义且自动旋转的loadingView
  }

  @property[animator]{
    @class[YXViewController]

    每个VC上都拥有的动画执行器，会在vc popped时候自动停止所有动画
  }
*/

]]

YXViewController = Class.Class("YXViewController", 
                   --init properties
                   {
                      properties={

                         view = Class.undefined,
                         title=Class.undefined,
                         titleColor=Class.undefined,
                         titleView=Class.undefined,
                         bShowBackBtn=true,
                         backButtonStyle = Class.undefined, --"gray", "white"
                         navigationBarLeftView=Class.undefined,
                         navigationBarRightView=Class.undefined,
                         navigationBarBgColor = Class.undefined,
                         navigationBarBgImg = Class.undefined,
                         navigationBarStyle = Class.undefined,--"default","green","white"
                         bPortrait = true,

                         backgroundColor=Class.undefined,
                         slideUpWhenKeyBoardAppearType = Class.undefine, --slideupSelfAdaption, slideupKeyboardHeight, slideupNone

                         bShowNaviBar = true,
                         bStartFromScreenTop = false,
                         bNeedWakeLock =false,
                         prevViewController = Class.undefined,
                         nextViewController = Class.undefined,
                         
                         --mask 属性将被废弃
                         mask = Class.undefined,

                         --for mask
                         loadingLabel = Class.undefined,
                         loadingDescLabel = Class.undefined,
                         loadingBGOpacity = Class.undefined,
                         --可以自定义mask的view。 其中autorate表示让autoRateView永远旋转起来。旋转中心为loadingCustomViewAutoRotateView控件的中心点。
                         --默认情况下显示系统的菊花
                         loadingCustomView = Class.undefined,
                         loadingCustomViewAutoRotate = Class.undefined,
                         loadingCustomViewAutoRotateView = Class.undefined,

                         animator = Class.undefined,
                      },

                      mixins={
                         observable=Observable
                      },
                      
                      statics={
                         processInitProperties = function(cls, obj)
--                         print("class", table.tostring(cls))
--                           print("platformuiviewcontroller", table.tostring(obj))
                           
                            obj._pv = PlatformYXUIViewController.PlatformYXUIViewController(obj)
                         end,
                      }
                   }
)

function YXViewController.prototype:init(inlineprops, ...)
  -- print("YXViewController.prototype:init")

   local view = self:loadView()
   self:setView(view)

   if inlineprops == nil then
      inlineprops = {}
   end

   for k, propMap in pairs(self.class.initProperties) do
      if inlineprops[k] == nil and self[propMap.setterName] and propMap.initV ~= Class.undefined then
         self[propMap.setterName](self, propMap.initV)
      end
   end

   for k, v in pairs(inlineprops) do
      local sn = NameMap[k][3]--self:setterName(k)
      if sn and self[sn] then
         self[sn](self, v)
      else
         error("has unknown prop:" .. k .. " in YXViewController init")
      end
   end

   self._animator = Animator()
   self:addEventListener("popped",
                         function()
                           self._animator:dispose()
                           self:doWhenPopped()
                         end)

   self:viewLoaded(...)



end

function YXViewController.prototype:changeTheme(themeName)
  
end

function YXViewController.prototype:getApp()
   if self.app then
      return self.app
   end

   if self._prevViewController then
      return self._prevViewController:getApp()
   end

   return nil
end

function YXViewController.prototype:isShown()
   return self._pv:isShown()
end

function YXViewController.prototype:isVisible()
  return self._pv:isVisible()
end

function YXViewController.prototype:getScreenHeight()
   return self._pv:getScreenHeight()
end

function YXViewController.prototype:getApplicationHeight()
   return self._pv:getApplicationHeight()
end

function YXViewController.prototype:loadView(...)
   local height = self._pv:getScreenHeight()
   local naviBarHeight = self._pv:getNavigationBarHeight() + self._pv:getStatusBarHeight()
   return Container{
      width=getApplication():getViewportWidth(),
      height=height - naviBarHeight,
      borderWidth=0,
      borderColor=rgba{255,0,0,1},
      backgroundColor=rgba{255,255,255,1},
      clipsToBounds = true,
   }
end

function YXViewController.prototype:viewLoaded(...)
   setTimeout(function()
              self:fireEvent("viewLoaded", self)
           end,
           0)
           
   self:getView().vc = self;
end

function YXViewController.prototype:onViewChanged(prop, old, new)
   self._pv:setRootView(new)
end

function YXViewController.prototype:onTitleChanged(prop, old, new)
   self._pv:setTitle(new)
end

function YXViewController.prototype:onTitleColorChanged(prop, old, new)
   self._pv:setTitleColor(new)
end

function YXViewController.prototype:onBackgroundColorChanged(prop, old, new)
   self._pv:setBackgroundColor(new)
end

function YXViewController.prototype:onSlideUpWhenKeyBoardAppearTypeChanged(prop, old, new)
   self._pv:setSlideUpWhenKeyBoardAppearType(new)
end

function YXViewController.prototype:onTitleViewChanged(prop, old, new)
   print("title:old" .. tostring(old) .. "new:" .. tostring(new))
   self._pv:setTitleView(new)
end

function YXViewController.prototype:onBShowBackBtnChanged(prop, old, new)
   self._pv:setShowBackButton(new)
end
if not platform.isIOS() then
	function YXViewController.prototype:onBNeedWakeLockChanged(prop, old, new)
	   self._pv:setNeedWakeLock(new)
	end

	function YXViewController.prototype:onBPortraitChanged(prop, old, new)
	   self._pv:setPortrait(new)
	end
end
function YXViewController.prototype:showNavigationBar(bAni)
   self._pv:showNavigationBar(bAni)
end

function YXViewController.prototype:hideNavigationBar(bAni)
   self._pv:hideNavigationBar(bAni)
end
function YXViewController.prototype:onNavigationBarRightViewChanged(prop, old, new)
   if new then
      new:layout()
   end

   self._pv:setNavigationBarRightView(new)
end

function YXViewController.prototype:onBackButtonStyleChanged(prop, old, new)
   self._pv:setBackButtonStyle(new)
end

function YXViewController.prototype:onNavigationBarLeftViewChanged(prop, old, new)
   self._pv:setNavigationBarLeftView(new)
   if new then
      new:layout()
   end
end

function YXViewController.prototype:onNavigationBarBgImgChanged(prop, old, new)
   self._pv:setNavigationBarBgImg(new)
end

function YXViewController.prototype:onNavigationBarBgColorChanged(prop, old, new)
   self._pv:setNavigationBarBgColor(new)
end

function YXViewController.prototype:onNavigationBarStyleChanged(prop, old, new)
   self._pv:setNavigationBarStyle(new)
end

function YXViewController.prototype:getNavigationBarHeight()
   return self._pv:getNavigationBarHeight()
end

function YXViewController.prototype:getStatusBarHeight()
   return self._pv:getStatusBarHeight()
end

function YXViewController.prototype:getActualStatusBarHeight()
   if self._bShowStatusBar then
      return self._pv:getStatusBarHeight()
   else
      return 0
   end
end

function YXViewController.prototype:resetRootViewHeight()
   local bStartFromTop = self._bStartFromScreenTop
   local bShowNaviBar = self._bShowNaviBar
   local bShowStatusBar = self._bShowStatusBar

   local screenHeight = self._pv:getScreenHeight()

   --7.0以下透不过状态栏，7.0以上是全屏高度
   --需要注意的是slef:getStatusBarHeight()返回的是根据状态动态变化的高度值
   if bStartFromTop then
      if platform.isIOS() and tonumber(platform.OSVersion) < 7.0 then
          screenHeight = screenHeight - self:getActualStatusBarHeight()
      end
      self:getView():setHeight(screenHeight)

   --只减掉状态栏的高度即可
   elseif not bShowNaviBar then
      screenHeight = screenHeight - self:getActualStatusBarHeight()
      self:getView():setHeight(screenHeight)
   --其他情况要减去导航栏和状态栏高度   
   else
      local naviBarHeight = self._pv:getNavigationBarHeight() + self:getActualStatusBarHeight()
      self:getView():setHeight(screenHeight - naviBarHeight)
--      self:getView():setTop(naviBarHeight)

   end
    if not platform.isIOS() then
      	 self:getView():layout()
      end
end

function YXViewController.prototype:onBShowNaviBarChanged(prop, old, new)
   self._pv:setShowNavigationBar(new)
   self:resetRootViewHeight()
end

function YXViewController.prototype:onBStartFromScreenTopChanged(prop, old, new)
   self._pv:setBStartFromScreenTop(new)
   self:resetRootViewHeight()
end

function YXViewController.prototype:pushViewController(controller, animated)
   if not controller:isKindOf(YXViewController) then
      print("YXViewController Error:push a object:" .. tostring(controller))
   end
   
   print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
   local controllerRootView = controller:getView()
   local r = controllerRootView:getRenderObject()
   print(r)
   
   controller:getView():layout()
   
   self:setNextViewController(controller)
   controller:setPrevViewController(self)

   if animated == nil then
      animated = true
   end
   self._pv:pushViewController(controller, animated)
end

function YXViewController.prototype:doWhenPopped()
   if self._prevViewController then
      self._prevViewController:setNextViewController(nil)
      self._prevViewController = nil
   end
end

function YXViewController.prototype:pop(bAnimate)
    print("..........pop....")
     self._pv:pop(bAnimate)
     self._pv = nil
end

function YXViewController.prototype:switchViewController(controller, bAni)
   if self._prevViewController then
      self._prevViewController:setNextViewController(controller)
   else
      getApplication():setRootViewController(controller)
   end


   
   controller:setPrevViewController(self._prevViewController)

   return self._pv:switchViewController(controller, bAni)
end

function YXViewController.prototype:isStatusBarHidden()
   return self._pv:isStatusBarHidden()
end

function YXViewController.prototype:hideStatusBar()
  if  platform.isIOS()  then
   if self._pv:isStatusBarHidden() then
      return 
   end
 end
   self._pv:hideStatusBar()
   local rootView = self:getView()
  
   if rootView and platform.isIOS() and tonumber(platform.OSVersion) < 7.0 then
      print(" \n ++++++++++++++++++++++++")
      rootView:setHeight(rootView:getHeight() + self:getStatusBarHeight())
      rootView:layout()
   end
  
end

function YXViewController.prototype:showStatusBar()
    if  platform.isIOS()  then
     if not self._pv:isStatusBarHidden() then
        return 
     end
   end
   self._pv:showStatusBar()
   local rootView = self:getView()
   
   if rootView and platform.isIOS() and tonumber(platform.OSVersion) < 7.0 then
      print("\n -------------------------")
      rootView:setHeight(rootView:getHeight() - self:getStatusBarHeight())
      rootView:layout()
   end
   
end

function YXViewController.prototype:setStatusBarStyle(style)
   if platform.isIOS() and style ~= nil then
      self._pv:setStatusBarStyle(style)
   end
end

function YXViewController.prototype:beginEdit(editview)
   self._pv:beginEdit(editview)
end

function YXViewController.prototype:endEdit()
   self._pv:endEdit()
end

function YXViewController.prototype:popAllVC(bAnimate)
   if self:getPrevViewController() then
      local allSubVC = {}
      local nextVC = self:getNextViewController()
      
      while nextVC do
         table.insert(allSubVC, nextVC)
         nextVC = nextVC:getNextViewController()
      end

      print(allSubVC, #allSubVC)

      for i = #allSubVC, 1 do
         print("call view controller pop")
         allSubVC[i]:pop(bAnimate)
      end
   else
      return
   end
end

function YXViewController.prototype:addEventListener(evtName, cb)
   if self._pv == nil then
      print(debug.traceback())
   end
   return self._pv:addEventListener(evtName, cb)
end

function YXViewController.prototype:removeEventListener(evtName, cb)
   return self._pv:removeEventListener(evtName, cb)
end

function YXViewController.prototype:showActionSheet(title, cancel, destructive, others, cb)
 	
	if platform.isIOS() then
 
	   if self._sheet ~= nil then
	      print("cannot show action sheet twice")
	      return
	   end
	else
	   -- if self._sheet ~= nil then
   	--    print("cannot show action sheet twice")
  	 --    return
  	 -- end	
	end
   local sheet = ActionSheet(title, cancel, destructive, others, cb)
   sheet:showInView(self:getView()._pv["handler"])
   
   self._sheet = sheet
	if platform.isIOS() then
   self._sheet:addEventListener("click",
                                function()
                                   print("on sheet click")
                                   self._sheet = nil
   end)
   else
     -- self._sheet:addEventListener("click",
   --                              function()
   --                                 print("on sheet click")
   --                                 self._sheet = nil
   -- end)
   end
end

--Warning：该接口将被废弃
function YXViewController.prototype:showMask(maskColor, maskView)
   local mask = ModalDialog{
      layout="flex",
      dir=VBox,
      pack=Center,
      align=Center,

      backgroundColor=maskColor,

      items={
         maskView
      }
   }

   self._mask = mask

   mask:show()
   
   self:disableBackBtn()
end
--Warning：该接口将被弃废
function YXViewController.prototype:dismissMask()
   if self._mask then
      self._mask:dismiss()
      self._mask = nil
   else
      print("Error: cannot dismiss mask")
   end
   
   self:enableBackBtn()
end

--为保持相关接口与android的一致性，全屏的loading需要在VC上提供。
--IOS将相关属性转发至rootview
if platform.isIOS() then
   function YXViewController.prototype:showLoading(animated)
      local rootView = self:getView()

      rootView:setLoadingCustomView(self._loadingCustomView)
      rootView:setLoadingLabel(self._loadingLabel)
      rootView:setLoadingDescLabel(self._loadingDescLabel)
      rootView:setLoadingBGOpacity(self._loadingBGOpacity)

      rootView:setLoadingCustomViewAutoRotateView(self._loadingCustomViewAutoRotateView)
      rootView:setLoadingCustomViewAutoRotate(self._loadingCustomViewAutoRotate)

      rootView:showLoading(animated)
   end

   function YXViewController.prototype:hideLoading(animated)
      self:getView():hideLoading(animated)
   end
else 
     function YXViewController.prototype:showLoading(animated,cb)
      -- local rootView = self:getView()

      -- rootView:setLoadingCustomView(self._loadingCustomView)
      -- rootView:setLoadingLabel(self._loadingLabel)
      -- rootView:setLoadingDescLabel(self._loadingDescLabel)
      -- rootView:setLoadingBGOpacity(self._loadingBGOpacity)

      -- rootView:setLoadingCustomViewAutoRotateView(self._loadingCustomViewAutoRotateView)
      -- rootView:setLoadingCustomViewAutoRotate(self._loadingCustomViewAutoRotate)
      if self._loadingCustomView == nil then
          self._pv:showDefaultLoading(self._loadingLabel,self._loadingDescLabel,self._loadingBGOpacity)
      else
          self._pv:showCustomLoading(self._loadingCustomView,self._loadingCustomViewAutoRotateView)
      end
   end

   function YXViewController.prototype:hideLoading(animated)
      self._pv:hideLoading(animated)
   end

end

function YXViewController.prototype:disableBackBtn()
   self._pv:disableBackBtn()
end

function YXViewController.prototype:enableBackBtn()
   self._pv:enableBackBtn()
end

if platform.isIOS() then
	function YXViewController.prototype:onBNeedWakeLockChanged(prop, old, new)
	    --iOS改由逻辑控制，不再放在 VC 中
	   if platform.isIOS() then
	   else
	      self._pv:setNeedWakeLock(new)
	   end
	end
else
	function YXViewController.prototype:hideInputMethod(node)
	    self._pv:hideInputMethod(node)
	end
end


return YXViewController
