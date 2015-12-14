require "colortouch/Node"
require "stdlib/class/Class"

NavigationView = Class.Class("NavigationView",
                             {
                                base=Node,
                                properties={
                                   hiddenToolbar=true,
                                   navibarBackgroundColor=Class.undefined,
                                   navibarBackgroundImage=Class.undefined,
                                   toolbarBackgroundColor=Class.undefined,
                                   toolbarBackgroundImage=Class.undefined,
                                   views = Class.undefined,
                                }
})

function NavigationView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
   
   self._views = {}

   if self._navibarBackgroundColor ~= nil then
      self:onNavibarBackgroundColorChanged("navibarBackgroundColorChanged", nil, self._navibarBackgroundColor)
   end
   
   if self._navibarBackgroundImage ~= nil then
      self:onNavibarBackgroundImageChanged("navibarBackgroundImage", nil, self._navibarBackgroundImage)
   end
   
   if self._toolbarBackgroundColor ~= nil then
      self:onToolbarBackgroundColorChanged("toolbarBackgroundColor", nil, self._toolbarBackgroundColor)
   end
   
   if self._toolbarBackgroundImage ~= nil then
      self:onToolbarBackgroundImageChanged("toolbarBackgroundImage", nil, self._toolbarBackgroundImage)
   end
   
   self:on("layoutComplete",
         function()
            self:updateViewsRect()
         end)
end

--@override
function NavigationView.prototype:createPlatFormView()
   return PlatformNavigationView(self)
end

function NavigationView.prototype:onNavibarBackgroundColorChanged(name, old, new)
   self._pv:setNavibarBackgroundColor(new)
end

function NavigationView.prototype:onNavibarBackgroundImageChanged(name, old, new)
   self._pv:setNavibarBackgroundImage(new)
end

function NavigationView.prototype:onToolbarBackgroundColorChanged(name, old, new)
   self._pv:setToolbarBackgroundColor(new)
end

function NavigationView.prototype:onToolbarBackgroundImageChanged(name, old, new)
   self._pv:setToolbarBackgroundImage(new)
end

function NavigationView.prototype:pushViewWithTitleView(contentView, titleView, backView, rightView)
   local pTitleView = nil
   if titleView then
      pTitleView = titleView._pv;
      titleView:setNeedsLayout(true)
   end

   local pbackView = nil
   if backView then
      backView  = backView._pv
      backView:setNeedsLayout(true)
   end

   local prightView = nil
   if rightView then
      prightView = rightView._pv
      rightView:setNeedsLayout(true)
   end
   
   table.insert(self._views, contentView)
   self:applyContentViewRectToView(contentView)

   return self._pv:pushViewWithTitleView(contentView._pv, pTitleView, pbackView, prightView)
end

function NavigationView.prototype:push(contentView)
   table.insert(self._views, contentView)
   
   self:applyContentViewRectToView(contentView)
   self._pv:push(contentView._pv)
end

function NavigationView.prototype:pushViewWithTitleString(contentView, title, back, rightView)
   local prightView = nil
   if rightView then
      prightView = rightView._pv
      rightView:setNeedsLayout(true)
   end

   table.insert(self._views, contentView)
   self:applyContentViewRectToView(contentView)

   return self._pv:pushViewWithTitleString(contentView._pv, title, back, prightView)
end

function NavigationView.prototype:pop(bAnimated)
   table.remove(self._views)

   return self._pv:pop(bAnimated)
end


function NavigationView.prototype:setToolbar(toobarView)
   self._pv:setToolbar(toolbarView._pv)
   toobarView:setNeedsLayout(true)
end

function NavigationView.prototype:navigationbarSize()
   return self._pv:navigationbarSize()
end

function NavigationView.prototype:toolbarSize()
   return self._pv:toolbarSize()
end

function NavigationView.prototype:contentViewSize()
   return self._pv:contentViewSize()
end

function NavigationView.prototype:setCurTitle(title)
   self._pv:setCurTitle(title)
end

function NavigationView.prototype:setCurTitleView(titleView)
   self._pv:setCurTitleView(titleView._pv)
end

function NavigationView.prototype:setCurBack(back)
   self._pv:setCurBack(back)
end

function NavigationView.prototype:setCurBackView(backView)
   self._pv:setCurBackView(backView._pv)
end

function NavigationView.prototype:setCurRightView(rightView)
   self._pv:setCurRightView(rightView._pv)
end

function NavigationView.prototype:applyContentViewRectToView(view)
   local rect = self._pv:contentViewRect()
   view:setLeft(rect.origin.x)
   view:setTop(rect.origin.y)
   view:setWidth(rect.size.width)
   view:setHeight(rect.size.height)
   view:setNeedsLayout(true)
end

function NavigationView.prototype:updateViewsRect()
   local rect = self._pv:contentViewRect()

   for _, v in ipairs(self._views) do
      v:setLeft(rect.origin.x)
      v:setTop(rect.origin.y)
      v:setWidth(rect.size.width)
      v:setHeight(rect.size.height)
   end
end