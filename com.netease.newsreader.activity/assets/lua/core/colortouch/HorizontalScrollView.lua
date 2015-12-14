require "colortouch/Container"
require "stdlib/class/Class"

HorizontalScrollView = Class.Class("HorizontalScrollView",
                         {
                            base=Container,

                            properties={
                               --contentSize默认为scrollView的size
                               contentSize = Class.undefined,
                               pagingEnabled = Class.undefined,
                               contentinset = Class.undefined,
                               showsVerticalScrollIndicator = true,
                               showsHorizontalScrollIndicator = true
                            }
                         }
)

function HorizontalScrollView.prototype:onLayoutComplete()
   Container.prototype.onLayoutComplete(self)

   if self._contentSize == nil then
      --孩子中最大的宽高
      local robj = self._renderObject
      local rstyle = robj:getRenderStyle()
      
      local maxw, maxh = rstyle:getWidth(), rstyle:getHeight()
      
      for _, child in ipairs(self._children) do
         robj = child._renderObject
         rstyle = robj:getRenderStyle()

         local w = rstyle:getLeft() + rstyle:getWidth()
         local h = rstyle:getTop() + rstyle:getHeight()

         if w > maxw then
            maxw = w
         end
         
         if h > maxh then
            maxh = h
         end
      end

      self:getPV():setContentSize({maxw,maxh})
   end

--   self:getPV()['handler']:setClipsToBounds(false)
--   self:getPV()['handler']:setPagingEnabled(true)
--      self:getPV():setPagingEnabled(true)
end

function HorizontalScrollView.prototype:onContentinsetChanged(name, old, new)
   print("on content inset changed")
   print(tostring(new))
   self:getPV():setContentinset(new)
end

function HorizontalScrollView.prototype:onContentSizeChanged(name, old, new)
   self:getPV():setContentSize(new)
end

function HorizontalScrollView.prototype:onPagingEnabledChanged(name, old, new)
   self:getPV():setPagingEnabled(new)
end

function HorizontalScrollView.prototype:createPlatFormView()
   local pv = PlatformHorizontalScrollView(self)
   print("!!!!!!!!!!!!!!!")
   --print(pv)
   return pv
end

function HorizontalScrollView.prototype:onShowsVerticalScrollIndicator(name, old, new)
   self:getPV():setShowsVerticalScrollIndicator(new)
end

function HorizontalScrollView.prototype:onShowsHorizontalScrollIndicator(name, old, new)
   self:getPV():setShowsHorizontalScrollIndicator(new)
end

function HorizontalScrollView.prototype:setContentOffset(offset, bAnim)
   self:getPV():setContentOffset(offset.x,0,bAnim)
end

function HorizontalScrollView.prototype:getContentOffset()
   return self:getPV():getContentOffset()
end