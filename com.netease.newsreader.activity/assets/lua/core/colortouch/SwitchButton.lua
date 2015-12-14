--[[
/**

	@section{SwitchButton概述}
	可滑动的开关控件

	---------------------------------------------------------------

	@iclass[SwitchButton Node]{
		ios风格可滑动的开关控件
	}

	@method[isOn]{

		获取开关控件是否是打开状态

		@class[SwitchButton]
		@param[None]
		@return{
			boolean,
		}
	}

	@method[setOn]{
		设置开关的状态，true打开，false关闭

		@class[SwitchButton]
		@param[b]{
			boolean类型参数，true打开，false关闭
		}
		@return{None}
	}

	@section{安卓独有API}
	@method[addEventListener]{
	
		增加相应的事件监听

		@class[SwitchButton]
		@param[evtName]{
	      evtName:事件名	      
	    }
	    @param[cb]{
	      cb：触发时调用的回调
	    }
	    @return{None}

	    @verbatim|{
	      local switch = SwitchButton{}
	      switch:addEventListener("click",function() ... end)
	    }|
	}

*/
]]

SwitchButton = Class.Class("SwitchButton",
                           {
                              base=Node,
                              properties={
                              }
})

--[[
   support event: valueChanged
]]

--@override
function SwitchButton.prototype:createPlatFormView()
   return PlatformSwitchButton(self)
end

function SwitchButton.prototype:isOn()
   return self._pv:isOn()
end

function SwitchButton.prototype:setOn(b)
   return self._pv:setOn(b)
end
if not platform.isIOS() then
function SwitchButton.prototype:addEventListener(evtName, cb)
   return self._pv:addEventListener(evtName, cb)
end
end
