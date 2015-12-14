module("RootController", package.seeall)

require "stdlib/class/Class"
require "colortouch/controller/Controller"

local Controller = Controller.Controller

RootController = Class.Class("RootController",
                             {
                                base=Controller,

                                properties={
                                   presentingViewController = Class.undefined,
                                   title = Class.undefined
                                }
                             }
)

function RootController.prototype:presentViewController(vc)
   if self._presentingViewController then
      self._presentingViewController:dismissViewController()
   end

   local view = vc:getView()
   local rootView = self:getView()

   rootView:addChild(view)

   self._presentingViewController = vc
   vc:setPresentedViewController(self)
end


function RootController.prototype:dismissPresentingViewController(vc)
   if vc ~= self._presentingViewController and vc ~= nil then
      logError("dismiss un presenting view controller")
   end

   local view = self._presentingViewController:getView();

   view:removeFromParent()
   self._presentingViewController = nil
end
                             
package.loaded["colortouch/controller/RootController"] = RootController