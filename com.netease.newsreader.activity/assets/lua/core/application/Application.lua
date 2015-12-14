module("Application", package.seeall)

require "stdlib"
require "store/LocalStorage"

local YXViewController = require("controller.YXViewController")

--[[
   support observable event:
   onAppEnter, onAppExit,
   onReceiveMsg
]]


--[[
/**
  @section{应用程序}
  ----------------------------------------
  @iclass{
   轻应用
  }


  @method[init]{
      初始化函数
      @larger{}
      @param[appName]{
         轻应用标识名
      }
      @param[displayName]{
         轻应用显示名称
      }
      @param[version]{
          轻应用版本
      }
      @param[coreVersion]{
        轻应用核心包版本
      }
    }
    
    @property[localStorge]{
      app关联的轻量级的key-value存储器,详见LocalStorage
    }

    @property[ServiceMgr]{
        基础服务器管理器,详见YXServiceMgr
    }

    @property[commonService]{
      通用服务接口，开发者可以通过该类获取易信基础功能，详见CommonService
    }

    @property[locationService]{
      定位服务
    }

    @method[enter]{轻应用入口函数
      @param[...]{
          变参，开发者可以覆盖方法实现，自行处理任意的参数类型
      }
    }

    @method[exit]{
        轻应用出口函数回调
        @param[..]{
          变参
        }
    }

    @method[receiveMessage]{
        轻应用消息入口，轻应用收到消息后将在此回调
        @param[msg]{
          轻应用消息体
        }
    }

    @method[createRootViewController]{
        轻应用入口ViewController，会被轻应用作为首屏展示
        @retrun{ViewController}
    }
    

    @method[onEnterBackground]{
        轻应用切换到后台的回调，轻应用会转发一个全局onEnterBackground消息
    }

    @method[onEnterForeground]{
        轻应用切换到前台的回调，轻应用会转发一个全局onEnterBackground消息
    }



 
]]

Application = Class.Class("Application", 
                    --init properties
                    {
                       properties={
                          appName=Class.undefined,
                          version=Class.undefined,
                          coreVersion = Class.undefined,
                          displayName=Class.undefined,
                          localStorage = Class.undefined,

                          rootViewController=Class.undefined,
                          serviceMgr = Class.undefined,
                          commonService = Class.undefined,
                          locationService = Class.undefined,
                          stringUtils = Class.undefined,
                          tracker = Class.undefined,

                          orientation = Class.undefined,

                          viewportWidth = 320,
                       },

                       mixins={
                          observable=Observable
                       }
})

function Application.prototype:init(appName, displayName, version, coreVersion)
   self._appName, self._version, self._displayName = appName, version, displayName

   self._coreVersion = coreVersion

   self._localStorage = LocalStorage.LocalStorage(appName)
end

--应用重载这个方法，每次进入应用都会调用到，返回值为一个viewcontroller
function Application.prototype:enter(...)
   local rootVC = self:createRootViewController(...)
   self:setRootViewController(rootVC)

   self:fireEvent("onAppEnter", self)
   
   return rootVC
end

--每次从轻应用退出，会调用到该方法。可以做一些清理的动作。
function Application.prototype:exit(...)
   print("on App Exit")
   --默认情况下会通知viewcontroller应用退出了，该清理的清理，如果需要重新定义这个行为，需要重载该方法
   self:fireEvent("onAppExit", self)
setContext(nil)
   self:setRootViewController(nil)
   collectgarbage("collect")
end

--应用接收到服务器推送的消息的时候调用
function Application.prototype:receiveMessage(msg)
   self:fireEvent("onReceiveMsg", msg)
end

function Application.prototype:changeTheme(themeName)
  self:fireEvent("onChangeTheme",themeName)
end

function Application.prototype:createRootViewController(...)
   print("cannot be here", debug.traceback())
   return YXViewController()
end

function Application.prototype:onRootViewControllerChanged(prop, old, new)
   if old then
      old.app = nil
   end

   if new then
      new.app = self
   end
end

function Application.prototype:onEnterBackground()
   self:fireEvent("onEnterBackground", self)
end

function Application.prototype:onEnterForeground()
   self:fireEvent("onEnterForeground", self)
end

--获取屏幕的真实逻辑尺寸单位
function Application.prototype:getScreenWidthUnit()
   -- if platform.isIOS() then
      return getScreenWidthUnit()
   -- else
   --    return 320
   -- end
end

--获取屏幕的真实逻辑尺寸单位
function Application.prototype:getScreenHeightUnit()
   -- if platform.isIOS() then
      return getScreenHeightUnit()
   -- else
      -- return 480
   -- end
end

return Application
