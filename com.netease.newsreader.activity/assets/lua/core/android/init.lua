--[[
setmetatable(_G, {

	__index = function(self, key)
    local class = wax.class[key]
    if class then self[key] = class end -- cache it for future use

    if not class and key:match("^[A-Z][A-Z][A-Z][^A-Z]") then -- looks like they were trying to use an objective-c obj
      print("WARNING: No object named '" .. key .. "' found.")
    end

    return class
  end
  
})
]]
require "android/compatiapi"
require "android/enums"
require "android/platform"
require "android/luabridge"
require 'android/SystemInfo'
require 'android/ViewOwner'
require "android/Callbacks"
require "android/view/View"
require "android/view/PlatformButton"
require "android/view/PlatformLayout"
require "android/view/PlatformLabel"
require "android/view/PlatformEditText"
require "android/view/PlatformHTMLLabel"
require "android/view/PlatformSpacer"
require "android/view/PlatformImageView"
require "android/view/PlatformGifImageView"

require "android/view/PlatformScrollView"
require "android/view/PlatformHorizontalScrollView"
require "android/view/PlatformViewPager"


require "android/view/PlatformHorizontalScrollView"
require "android/view/PlatformPickerView"
require "android/view/PlatformCTPickerViewDataSource"
require "android/view/dialog/PlatformModalDialog"
require "android/view/PlatformGuaguaKa"
require "android/view/PlatformTableView"
require "android/view/PlatformSwitchButton"
require "android/view/PlatformWebview"
require "android/view/PlatformVedioPlayView"
require "android/view/PlatformTextField"
require "android/view/PlatformDatePicker"
require "android/view/PlatformActionSheet"
require "android/view/PlatformAVQueuePlayer"
--require "android/view/PlatformQRView"
require "android/view/PlatformAlertView"
require "android/view/PlatformIToast"
require "android/view/PlatformMultipleSelectedView"
require "android/view/PlatformThrowView"
require "android/yixin/PlatformYXUIViewController"
--require "android/yixin/PlatformYXPortraitView"
require "android/NodeRefTable"
require "android/Timer"
require "android/style/androidviewstyle"
require "android/Context"
require "android/CopyMenu"
require "android/service/EventTrackerService"
require "android/animation/AndroidAnimation"
require "android/animation/AnimaTimeFunctionCallbacks"
--[[
require "android/animation/PlatformAnimation"
require "android/animation/PlatformAlphaAnimation"
require "android/animation/PlatformTranslateAnimation"
require "android/animation/PlatformScaleAnimation"
require "android/animation/PlatformRotateAnimation"
require "android/animation/PlatformGroupAnimation"
]]
require "android/service/CommonService"
require "android/service/YXCommonService"
require "android/service/EventTrackerService"
require "android/service/CTNTESCommonService"
require "android/service/NetworkStateService"
require "android/YXServiceMgr"
require "android/HTTPComponent"
require "android/service/LocationService"
require "android/http/HttpDownloadDisposable"
require "android/http/HttpRequestDisposable"
require "android/NTES"
