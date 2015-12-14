
module("Controller", package.seeall)

require "stdlib/class/Class"
require "stdlib/mixins/observable"
require "colortouch/Container"

Controller = Class.Class("Controller", 
                   --init properties
                   {
                      properties={
                         view = Class.undefined,
                         presentedViewController = Class.undefined,
                         navigationViewController = Class.undefined
                      },

                      mixins={
                         observable=Observable
                      },
                   }
)

function Controller.prototype:init(...)
   local view = self:loadView(...)
   self:setView(view)

   self:viewLoaded(...)
end

function Controller.prototype:loadView(...)
   return Container{
      width="100%",
      height="100%",
      backgroundColor=rgba{255,255,255,1}
   }
end

function Controller.prototype:viewLoaded(...)
   setTimeout(function()
              self:fireEvent("viewLoaded", this)
           end,
           0)
end

function Controller.prototype:dismissViewController()
   local presentedViewController = self._presentedViewController
   if presentedViewController == nil then
      logError("Cannot dismiss view controller")
   end

   presentedViewController:dismissPresentingViewController()
end

package.loaded["colortouch/controller/Controller"] = Controller
