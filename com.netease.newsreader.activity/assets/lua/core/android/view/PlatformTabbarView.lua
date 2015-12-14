PlatformTabbarView = createNewPlatformView(View)

--@override
--@platform
function PlatformTabbarView:newPlatformView(absView, ...)
   print('PlatformTabbarView not support')
   --local view = IOS.TabbarView_Proxy()
   --return view
end

function PlatformTabbarView:setViews_animated(tabviews, bAnimate)
   print(table.tostring(tabviews))
   self["handler"]:setViews_animated(tabviews, bAnimate)
end
--[[
   **  {text, img, selectedImg, color, selectedColor} ...
]]
function PlatformTabbarView:setTabbarItems(tabbarItems)
   self["handler"]:setTabbarItems(tabbarItems);
end

function PlatformTabbarView:setTabbarBgImg(bgImg)   
   self["handler"]:setTabbarBgImg(bgImg);
end

function PlatformTabbarView:setTabbarSelectionIndicatorImage(img)
   self["handler"]:setTabbarSelectionIndicatorImage(img);
end

function PlatformTabbarView:selectedIndex()   
   return self["handler"]:selectedIndex()
end

function PlatformTabbarView:setSelectedView(view)   
   self["handler"]:setSelectedView(view)
end

function PlatformTabbarView:setBadgeValue(idx, v)
   self["handler"]:setBadgeIndex_value(idx, v)
end

--Size
function PlatformTabbarView:getTabbarSize()
   local retSize = self["handler"]:getTabbarSize();
   return {width=retSize.width,height=retSize.height};
end

function PlatformTabbarView:disableItem(idx)
   return self["handler"]:disableItem(idx)
end

function PlatformTabbarView:enableItem(idx)
   return self["handler"]:enableItem(idx)
end

function PlatformTabbarView:isDisabled(idx)
   return self["handler"]:isDisabled(idx)
end

function PlatformTabbarView:hideTabbar()
   self["handler"]:hideTabbar()
end

function PlatformTabbarView:showTabbar()
   self["handler"]:showTabbar()
end

function PlatformTabbarView:contentViewRect()
   return self["handler"]:contentViewRect()
end
