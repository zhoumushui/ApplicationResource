module("NavigationController", package.seeall)

require "stdlib/class/Class"
require "colortouch/controller/RootController"
require "colortouch/NavigationView"

local RootController = RootController.RootController

NavigationController = Class.Class("NavigationController",
                             {
                                base=RootController,

                                {
                                   properties = {
                                      viewControllers = Class.undefined
                                   }
                                }
                             }
)

function NavigationController.prototype:init(...)
   self._viewControllers = {}

   RootController.prototype.init(self, ...)
end

function NavigationController.prototype:loadView(...)
   local view = NavigationView{
      width="100%",
      height="100%",
      backgroundColor=rgba{255,255,255,1},
   }

   print("========== do navigation view setneedslayout================")
   view:setNeedsLayout()
   
   return view
end

function NavigationController.prototype:pushViewController(vc)
   if table.indexOf(self._viewControllers, vc) ~= nil then
      logError("push a controller exist in stack")
   end

   vc:fireEvent("willPushIntoViewController", self)
   
   table.insert(self._viewControllers, vc)
   vc:setNavigationViewController(self)

   local rootView = self:getView()
   print("========navi get view")
   print(self:getView())
   local vcView = vc:getView()
   vcView:setTop(rootView:navigationbarSize().height)
   rootView:push(vcView)
   
   local title = vc:getTitle()
   if title then
      rootView:setCurTitle(title)
   end

   vc:fireEvent("didPushIntoViewController", self)
end

function NavigationController.prototype:popViewController()
   local vcs = self._viewControllers

   if #vcs <= 1 then
      logError("empty view controller stack")
   end

   local vc = table.last(vcs)
   vc:fireEvent("willPopFromViewController",
                self)

   table.removeValue(vc)
   vc:setNavigationViewController(nil)
   
   self:getView():pop(true)

   vc:fireEvent("didPopFromViewController",
                self);
end

package.loaded["colortouch/controller/NavigationController"] = NavigationController