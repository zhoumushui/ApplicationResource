module("Globals",package.seeall)

backgroundColor = rgba{244,244,244,1}
cellBackgroundColor = rgba{255,255,255,1}

-- indicator相关
itemIndicatorColor = rgba{0,0,0,0.5}
itemIndicatorHilightColor = rgba{223,48,49,1}
itemIndicatorTotalHeight = 12
itemIndicatorWidth,itemIndicatorHeight = 2.5,2.5
itemHilightIndicatorWidth,itemHilightIndicatorHeight = 5,5
itemIndicatorSpace = 8

responeStorageKey = "responeStorageKey"
getImageArrowImg  = function()
   if platform.isIOS() then
      return "setting_cell_arrow.png"
   else 
      if getApplication():isNightMode() then
         return Resources.getPlatformResource("day_setting_cell_arrow.png")
      else
         return Resources.getPlatformResource("night_setting_cell_arrow.png")
      end
   end
end

getImageBackgroundColor = function()
   if getApplication():isNightMode() then
      return rgba{41,41,41,1}
   else
      return rgba{232,232,232,1}
   end
end

cellWidth = getApplication():getScreenWidthUnit()

scaleFactor = cellWidth / 375

cellTitleLeftMargin = 10
cellTitleFontSize = 14 * scaleFactor

bigImgHeight = 620 / 1080 * cellWidth
adsViewHeight = 110*scaleFactor

function getViewControllerPlatformTabbarHeight()
   if platform.isIOS() then
      return 64
   else
          local ntesService =  getApplication():getServiceMgr():createNTESService()
          if ntesService and ntesService.getAndroidVersion then
              --支持获取appid
              if androidversion == nil then
                  androidversion = ntesService:getAndroidVersion()
              end
              if androidversion > 18 then
                  --4.4以及以上，34dp
                     return 34+44
              else
                  -- 4.4以下，38dp 
                  return 38+44
              end

          else
              return 48+48
          end
   end
end

function getViewControllerPlatformTabberTop()
   if platform.isIOS() then
      return 64
   else
      return 0
   end
end

--右箭头的位置
rightArrowTop, rightArrowRight = 15, 10
arrowWidth, arrowHeight= 7,14

getDefaultImg = function()
   if getApplication():isNightMode() then
      return Resources.getPlatformResource("night_contentview_image_default.png")
   else
      return Resources.getPlatformResource("contentview_imagebg_logo.png")
   end
end

nightMaskColor = rgba{0,0,0,0.5}
dayTimeMaskColor=rgba{0,0,0,0}

getMaskColor = function()
   if getApplication():isNightMode() then
      return nightMaskColor
   else
      return dayTimeMaskColor
   end
end

getBackgroundColor = function()
   if getApplication():isNightMode() then
      return rgba{34,34,34,1}
   else
      return rgba{246,246,246,1}
   end
end

local normalLineBgColor = rgba{231,231,231,1}
getSpacerBackgroundColor = function()
   if getApplication():isNightMode() then
      return rgba{31,31,31,1}
   else
      return normalLineBgColor
   end
end

getTitleFontColor = function()
   if getApplication():isNightMode() then
      return rgba{144,144,144,1}
   else
      return rgba{18,18,18,1}
   end
end

getLineColor = function()
   if getApplication():isNightMode() then
      return rgba{31,31,31,1}
   else
      return rgba{222,222,222,1}
   end
end

getSubTitleFontColor = function()
   if getApplication():isNightMode() then
      return rgba{92,92,92,1}
   else
      return rgba{166,166,166,1}
   end
end

getGoldRedColor = function()
   if getApplication():isNightMode() then
      return rgba{182, 46, 44, 1}
   else
      return rgba{223, 48, 49, 1}
   end
end

local indicatorColor = rgba{255,255,255,0.3}
local indicatorHilightColor = rgba{255,255,255,1}
local nightIndicatorHilightColor = rgba{255,255,255,0.5}
getIndicatorColor = function()
   return indicatorColor
end

getHilightedIndicatorColor = function()
   if getApplication():isNightMode() then
      return nightIndicatorHilightColor
   else
      return indicatorHilightColor
   end
end

applyBtnHilightStyle = function(btn)
     if getApplication():isNightMode() then
         btn:setHilightedBackgroundImage("app://nightmask.png")
      else
         btn:setHilightedBackgroundImage("app://daymask.png")
      end
    if platform.isIOS() then
      btn:setHilightedBackgroundImageEdgeInset(IOS.UIEdgeInsetsMake(1,1,1,1))
   end
end

applyItemBtnHilightStyle = function(btn)
     if getApplication():isNightMode() then
         btn:setHilightedBackgroundImage("app://btn_mask_night.png")
      else
         btn:setHilightedBackgroundImage("app://btn_mask.png")
      end
    if platform.isIOS() then
      btn:setHilightedBackgroundImageEdgeInset(IOS.UIEdgeInsetsMake(1,1,1,1))
   end
end

applyShareBtnHilightStyle = function(btn)
     if getApplication():isNightMode() then
         btn:setHilightedBackgroundImage("app://share_mask_night.png")
      else
         btn:setHilightedBackgroundImage("app://share_mask.png")
      end
    if platform.isIOS() then
      btn:setHilightedBackgroundImageEdgeInset(IOS.UIEdgeInsetsMake(1,1,1,1))
   end
end

applyItemHilightStyle = function(btn)
     if getApplication():isNightMode() then
         btn:setHilightedBackgroundImage("app://item_mask_night.png")
      else
         btn:setHilightedBackgroundImage("app://item_mask.png")
      end
    if platform.isIOS() then
      btn:setHilightedBackgroundImageEdgeInset(IOS.UIEdgeInsetsMake(1,1,1,1))
   end
end

getDividerColor = function()
   if getApplication():isNightMode() then
      return rgba{31,31,31,1} 
   else
      return rgba{232,232,232,1}
   end
end

getBorderColor = function()
   if getApplication():isNightMode() then
      return rgba{31,31,31,1} 
   else
      return rgba{229,229,229,1}
   end
end

getRecommendTitleFontColor = function()
   if getApplication():isNightMode() then
      return rgba{143,143,143,1}
   else
      return rgba{51,51,51,1}
   end
end

getRecommendDescriptionFontColor = function()
   if getApplication():isNightMode() then
      return rgba{92,92,92,1}
   else
      return rgba{153,153,153,1}
   end
end

getItemTitleColor = function()
   if getApplication():isNightMode() then
      return rgba{143,143,143,1}
   else
      return rgba{31,31,31,1}
   end
end

getBtnBorderColor = function()
   if getApplication():isNightMode() then
      return rgba{203,133,133,1}
   else
      return rgba{224,134,136,1}
   end
end

getBtnColor = function()
   if getApplication():isNightMode() then
      return rgba{182,46,44,1}
   else
      return rgba{224,45,50,1}
   end
end

stringSplit = function(str,sep)
   if str==nil or str=='' or sep==nil then
      return nil
   end
   
    local result = {}
    for match in (str..sep):gmatch("(.-)"..sep) do
        table.insert(result, match)
    end
    return result
end

getShareMode = function ()
   -- 0：弹窗让用户选择  201:新浪微博  204：QQ空间  205：易信好友  206：易信朋友圈  207：QQ好友   208：微信好友   209：微信朋友圈 
   -- 字符串形式
   return "0"
end

getShareSrc = function ()
   if getApplication():isNightMode() then
      return "app://share_night.png"
   else
      return "app://share.png"
   end
end
getShareMaskSrc = function ()
   if getApplication():isNightMode() then
      return "app://share_mask_night.png"
   else
      return "app://share_mask.png"
   end
end

local label = Label{}
getLabelHeight = function (size,width,text)
   label:setFontSize(size)
   label:setText(text)
   local table = label:preferredSize({width = width, height = 1000})
   return table.height
end

