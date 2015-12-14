require "colortouch.viewpager.ViewPagerConstValues"

ViewPagerAdapter = Class.Class("ViewPagerAdapter",
                                  {
                                     properties={
                                        viewPager = Class.undefined,
                                        delegate = Class.undefined,
                                        -- private members
                                        oldNumberOfPages = Class.undefined,
                                     }
})

function ViewPagerAdapter.prototype:init(inlineprops, ...)
   if nil == inlineprops then
      inlineprops = {}
   end

   for k, v in pairs(inlineprops) do
      local realPropName = "_" .. k
      self[realPropName] = v
   end

   if platform.isIOS() then
      self._pv = IOS.CTViewPagerAdapter_Proxy()
      self._pv:updateLuaState()
      bindObjcInstanceToWeakLuaObj(self._pv:getImpl(), self);
   else
      self['_pv'] = luajava.newInstance('com.netease.colorui.view.model.ColorUIPageAdapter', self)
   end
end

function ViewPagerAdapter.prototype:numberOfPages()
   local result = ViewPagerConstValues.defaultNumberOfPages
   if self._delegate and self._delegate.numberOfPages then
      result = self._delegate.numberOfPages(self)
   end

   if self._oldNumberOfPages ~= result and result ~= nil then
      if self._viewPager then
         self._viewPager:onNumberOfPagesChanged("numberOfPages", self._oldNumberOfPages, result)
         self._oldNumberOfPages = result
      end
   end

   return result
end

function ViewPagerAdapter.prototype:pageAtIndex(pageId)
   if self._delegate and self._delegate.pageAtIndex then
      return self._delegate.pageAtIndex(self, pageId)
   end
   return Node{}
end
