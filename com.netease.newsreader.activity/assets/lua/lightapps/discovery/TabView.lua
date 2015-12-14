module("TabView",package.seeall)

require "Globals"

local scaleFactor = Globals.scaleFactor
local tabHeight = 95 * scaleFactor
local titleFontSize = 15 * scaleFactor
local iconSize = 44 * scaleFactor
local iconToTop = 12 * scaleFactor
local iconToTitle = 10 * scaleFactor

local titleColor = rgba{51,51,51,1}

TabView = Class.Class("TabView",{
				base = Container,
				properties = {
					width = Class.undefined,
					height = tabHeight,
					data = Class.undefined,
					p_iconImg = Class.undefined,
					p_titleLabel = Class.undefined,
					p_btn = Class.undefined,
				}
			})

function TabView.prototype:init(inlineprop, ... )
	Container.prototype.init(self, inlineprop, ...)

	self:setBackgroundColor(Globals.getBackgroundColor())
	
	self._p_btn = Button{
		width = "100%",height = "100%",
	}
	--添加夜间模式的样式
	Globals.applyBtnHilightStyle(self._p_btn)

	self._p_iconImg = ImageView{
		width = "100%",
		height = iconSize,
		top = iconToTop,
		contentMode = "aspectFit",
		src = "",
		--图片区分夜间模式
		alpha = getApplication():isNightMode() and 0.5 or 1,
	}

	self._p_titleLabel = Label{
		width = "100%",
		top = iconToTop + iconSize + iconToTitle,
		fontSize = titleFontSize,
		text = "",
		gravity = "center",
		--文字颜色区分夜间模式
		color = Globals.getRecommendTitleFontColor(),
	}
	
	self:addChild(self._p_btn)
	self:addChild(self._p_iconImg)
	self:addChild(self._p_titleLabel)

	if self._data then
		self:onDataChanged("data",nil,self._data)
	end

  self:addEventCBs()
end

function TabView.prototype:tabClicked()
   local serviceMgr = getApplication():getServiceMgr()
   --判断网络状态
   local networkService = serviceMgr:getNetworkStateService()
   if networkService:isReachAble() == true then
      getApplication():openUrl(self._data.url)
   else
      IToast{text="网络出错啦，请稍后再试"}:show()
   end
end

function TabView.prototype:addEventCBs()
   self._p_btn:addEventListener("click", function() self:tabClicked() end)
end

function TabView.prototype:onDataChanged(prop, old, new)
	if self._data then 
		self._p_iconImg:setSrc(self._data.icon)
		self._p_titleLabel:setText(self._data.title)
	end
end

function TabView.class.prototype:getTabHeight()
	return tabHeight
end

return TabView