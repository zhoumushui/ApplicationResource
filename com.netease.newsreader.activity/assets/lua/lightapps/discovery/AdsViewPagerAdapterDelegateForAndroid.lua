module ("AdsViewPagerAdapterDelegateForAndroid", package.seeall)

local genAdsViewPagerAdapterDelegateFunc = function(cellWidth,cellHeight)
   local delegate = nil
   delegate = {
      pages = nil,
      data = nil,
      
      ------------------------------------------
      --以下函数，需要被重写，以提供多viewPager的定制
      --注意避免viewPagerAdapter调用同名的函数，可能造成循环调用
      ------------------------------------------
      numberOfPages = function(viewPagerAdapter)

            if delegate.data ==nil then
               return 0
            else
               return #delegate.data
            end
      end,

      -- pageId从0开始
      pageAtIndex = function(viewPagerAdapter, pageId)
         return delegate.pages[pageId+1]
      end,
   }
   return delegate
end

return genAdsViewPagerAdapterDelegateFunc