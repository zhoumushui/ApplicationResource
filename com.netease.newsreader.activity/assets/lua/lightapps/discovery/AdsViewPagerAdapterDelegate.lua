module ("AdsViewPagerAdapterDelegate", package.seeall)

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
         -- local btn = delegate.pages[pageId+1]

         local adsCellContainer = delegate.pages[pageId+1]
         local btnClick   = adsCellContainer:query("btnClick")
        local oldImage = adsCellContainer:query("adsCellImageView")
         local url =  oldImage:getSrc()
         local imageView = ImageView{
           id="adsCellImageView",
           width="100%", height="100%",
           src=url,
            contentMode="scaleToFill",
         }
        local btn = Button{
           top=0, left=0, width="100%", height="100%",
        }
        if btnClick and btnClick._clickFunc then
            btn:addEventListener("click", btnClick._clickFunc)
        end
        local nightMask = Node{
           left=0, top=0, width="100%", height="100%",
           backgroundColor= Globals.getMaskColor(),
        }


        local c = Container{
           class="ImageView",
            width=cellWidth,height=cellHeight,
           layout="flex", dir="HBox",
           items={
              imageView,
              nightMask,
              btn,
           }
        }
        return c
      end,
   }
   return delegate
end

return genAdsViewPagerAdapterDelegateFunc