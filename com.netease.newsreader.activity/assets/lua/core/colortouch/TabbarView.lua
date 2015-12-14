require "colortouch/Node"
require "stdlib/class/Class"

TabbarView = Class.Class("TabbarView",
                             {
                                base=Node,
                                properties={
                                    views = Class.undefined,
                                }
})

function TabbarView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
   
   self._views = {}
   
   self:on("layoutComplete",
            function()
               self:updateViewsRect()
            end)
end

--@override
function TabbarView.prototype:createPlatFormView()
   return PlatformTabbarView(self)
end

function TabbarView.prototype:setViews_animated(tabviews, bAnimate)
   self._views = tabviews

   local vhs = table.map(tabviews, 
                           function(v) 
                              v:setNeedsLayout(true); 
                              return  v._pv["handler"] 
                           end)

   print(table.tostring(vhs))
   self:updateViewsRect()
   self._pv:setViews_animated(vhs, bAnimate)
end
--[[
   **  {text, img, selectedImg, color, selectedColor} ...
]]
function TabbarView.prototype:setTabbarItems(tabbarItems)
   self._pv:setTabbarItems(tabbarItems);
end

function TabbarView.prototype:setTabbarBgImg(bgImg)   
   self._pv:setTabbarBgImg(bgImg);
end

function TabbarView.prototype:setTabbarSelectionIndicatorImage(img)
   self._pv:setTabbarSelectionIndicatorImage(img);
end

function TabbarView.prototype:selectedIndex()   
   return self._pv:selectedIndex()
end

function TabbarView.prototype:setSelectedView(view)   
   self._pv:setSelectedView(view._pv["handler"])
end

function TabbarView.prototype:setBadgeValue(idx, v)
   self._pv:setBadgeValue(idx, v)
end

--Size
function TabbarView.prototype:getTabbarSize()
   return self._pv:getTabbarSize();
end

function TabbarView.prototype:disableItem(idx)
   return self._pv:disableItem(idx)
end

function TabbarView.prototype:enableItem(idx)
   return self._pv:enableItem(idx)
end

function TabbarView.prototype:isDisabled(idx)
   return self._pv:isDisabled(idx)
end

function TabbarView.prototype:hideTabbar()
   self._pv:hideTabbar()
end

function TabbarView.prototype:showTabbar()
   self._pv:showTabbar()
end

function TabbarView.prototype:updateViewsRect()
   local rect = self._pv:contentViewRect();
   print("...update views rect...")
   print("width:" .. tostring(rect.size.width) .. " height:" .. tostring(rect.size.height))
   for _, view in ipairs(self._views) do
      view:setLeft(rect.origin.x)
      view:setTop(rect.origin.y)
      view:setWidth(rect.size.width)
      view:setHeight(rect.size.height)
   end
end