module ("ViewPagerAdapterDelegate", package.seeall)

require "colortouch.viewpager.ViewPagerConstValues"

genViewPagerAdapterDelegate = function()
   local viewPagerAdapterDelegate = {
      ------------------------------------------
      --以下函数，需要被重写，以提供多viewPager的定制
      --注意避免viewPagerAdapter调用同名的函数，可能造成循环调用
      ------------------------------------------
      numberOfPages = function(viewPagerAdapter)
         return ViewPagerConstValues.defaultNumberOfPages
      end,

      pageAtIndex = function(viewPagerAdapter, pageId)
         return Node{}
      end,
   }
   return viewPagerAdapterDelegate
end