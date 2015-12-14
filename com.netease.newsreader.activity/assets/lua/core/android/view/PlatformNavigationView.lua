PlatformNavigationView = createNewPlatformView(View)

--@override
--@platform
function PlatformNavigationView:newPlatformView(absView, ...)
   local view = IOS.NavigationView_Proxy()
   return view
end

--@override
--@platform
function PlatformNavigationView:pushViewWithTitleView(contentView, 
                                                      titleView,
                                                      backView,
                                                      rightView)
   local titleViewHdl = nil
   if titleView then
      titleViewHdl = titleView["handler"]
   end
   local backViewHdl = nil
   if backView then 
      backViewHdl = backView["handler"]
   end
   local rightViewHdl = nil
   if rightViewHdl then
      rightViewHdl = rightView["handler"]
   end

   print("===========push title view ===========")
   print(table.tostring(titleViewHdl))
   
   self["handler"]:pushViewWithTitleView(contentView["handler"],
                                         titleViewHdl,
                                         backViewHdl,
                                         rightViewHdl)
end

function PlatformNavigationView:push(contentView)
   self["handler"]:push(contentView["handler"])
end

function PlatformNavigationView:pushViewWithTitleString(contentView, title, back, rightView)
   local rightViewHdl = nil
   if rightViewHdl then
      rightViewHdl = rightView["handler"]
   end

   self["handler"]:pushViewWithTitleString(contentView["handler"],
                                           title,
                                           back,
                                           rightViewHdl)
end

function PlatformNavigationView:pop(bAnimated)
   self["handler"]:pop(bAnimated)
end

function PlatformNavigationView:setToolbar(toobarView)
   self["handler"]:setToolbar(toolbarView["handler"])
end

function PlatformNavigationView:setNavibarBackgroundColor(c)
   self["handler"]:setNavibarBackgroundColor(c)
end

function PlatformNavigationView:setNavibarBackgroundImage(img)
   self["handler"]:setNavibarBackgroundImage(img)
end

function PlatformNavigationView:setToolbarBackgroundColor(c)
   self["handler"]:setToolbarBackgroundColor(c)
end 

function PlatformNavigationView:setToolbarBackgroundImage(img)
   self["handler"]:setToolbarBackgroundImage(img)
end

function PlatformNavigationView:setHiddenToolbar(b)
   self["handler"]:setHiddenToolbar(b)
end

function PlatformNavigationView:navigationbarSize()
   local retSize = self["handler"]:navigationbarSize()
   return {width=retSize.width,height=retSize.height};
end

function PlatformNavigationView:toolbarSize()
   local retSize = self["handler"]:toolbarSize()
   return {width=retSize.width,height=retSize.height};
end

function PlatformNavigationView:contentViewSize()
   local retSize = self["handler"]:contentViewSize()
   return {width=retSize.width,height=retSize.height};
end

function PlatformNavigationView:setCurTitle(title)
   self['handler']:setCurTitle(title)
end

function PlatformNavigationView:setCurTitleView(titleView)
   self['handler']:setCurTitleView(titleView['handler'])
end

function PlatformNavigationView:setCurBack(back)
   self['handler']:setCurBack(back)
end

function PlatformNavigationView:setCurBackView(backView)
   self['handler']:setCurBackView(backView['handler'])
end

function PlatformNavigationView:setCurRightView(rightView)
   self['handler']:setCurRightView(rightView['handler'])
end

function PlatformNavigationView:contentViewRect()
   return self['handler']:contentViewRect()
end
