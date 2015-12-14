PlatformThrowView = createNewPlatformView(View)

--@override
--@platform
function PlatformThrowView:newPlatformView(absView, ...)
	self["type"]="ThrowView"
	print(".........newPlatformView  1")
	if throwViewCls == nil then
		throwViewCls = luabridge.bindClass("com.netease.colorui.view.ColorUIThrowView")
	end
		print(".........newPlatformView  2")
				print(".........newPlatformView  2")

local aa = throwViewCls["newThrowView.()Lcom/netease/colorui/view/ColorUIThrowView;"](throwViewCls)
		print(".........newPlatformView  3")

	return aa
end



function PlatformThrowView:setCardLeft(cardLeft)
	print("ThrowView...............setCardLeft")
	self["handler"]["setCardLeft.(I)V"](self["handler"],SystemInfo:getPX(cardLeft))
end

function PlatformThrowView:setCardTop(cardTop)
	print("ThrowView...............setCardTop",cardTop)
	self["handler"]["setCardTop.(I)V"](self["handler"],SystemInfo:getPX(cardTop))
end


function PlatformThrowView:setCardWidth(cardWidth)
	print("ThrowView...............cardWidth,",cardWidth)
	self["handler"]["setCardWidth.(I)V"](self["handler"],SystemInfo:getPX(cardWidth))
end

function PlatformThrowView:setCardHeight(cardHeight)
	print("ThrowView cardHeight..",cardHeight)
	self["handler"]["setCardHeight.(I)V"](self["handler"],SystemInfo:getPX(cardHeight))
end

function PlatformThrowView:setBCanDrag(canDrag)
	print("TODO")
	--self["handler"]["setCardHeight.(I)V"](self["handler"],cardHeight)
end

function PlatformThrowView:addEventListener(evtName, cb)
   View.addEventListener(self, evtName, cb)

   if evtName =='willThrow' then
  	   local willThrow_cb = {}
  	   function willThrow_cb.onInvoke()
  			cb()
  	   end
	   self.__viewcbs[evtName] = willThrow_cb
	   local willThrowProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.ColorUIInvokeListener',self["uuid"],evtName)
	   self["handler"]["setWillThrowListener.(Lcom/netease/colorui/interfaces/ColorUIInvokeListener;)V"](self["handler"],willThrowProxy)
	elseif evtName =='throwEnded' then
					 
	   local throwEnd_cb = {}
  	   function throwEnd_cb.onInvoke()
  			cb()
  	   end
	   self.__viewcbs[evtName] = throwEnd_cb
	   local throwEndProxy  = luabridge.createSoftProxy('com.netease.colorui.interfaces.ColorUIInvokeListener',self["uuid"],evtName)
	   self["handler"]["setThrowEndListener.(Lcom/netease/colorui/interfaces/ColorUIInvokeListener;)V"](self["handler"],throwEndProxy)		
	end
end
