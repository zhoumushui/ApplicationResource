PlatformIToast = createNewPlatformView(View)

--@override
--@platform
function PlatformIToast:newPlatformView(absView, ...)
	if ToastCls == nil then
			ToastCls = luabridge.bindClass("com.netease.colorui.view.ColorUIToast")
	end
	return ToastCls["newToast.()Lcom/netease/colorui/view/ColorUIToast;"](ToastCls)
end

--设置文本
function PlatformIToast:setText(text)
   self["handler"]["setText.(Ljava/lang/String;)V"](self["handler"],text)
end

--设置toast显示区域左上角相对于屏幕坐标的x，y。默认情况下colortouch不会调用该接口
--各平台自由决定当colortouch没有设置的时候，toast显示的位置
function PlatformIToast:setPosition(x, y)
	   self["handler"]["setPosition.(II)V"](self["handler"],SystemInfo:getPX(x), SystemInfo:getPX(y))
end

--toast显示的时间。默认情况下colortouch不会调用改接口
--各平台自由决定当colortouch没有调用该接口的时候，toast显示持续的时间
function PlatformIToast:setDuration(duration)
   self["handler"]["setDuration.(I)V"](self["handler"],duration)
end

--显示toast
function PlatformIToast:show()
   self["handler"]["show.()V"]( self["handler"])
end
