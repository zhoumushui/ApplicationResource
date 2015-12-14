module("ItemCell", package.seeall)
-- require "Globals"
ItemViewPager = require "ItemViewPager"

-- 屏幕缩放比例
local scale = Globals.scaleFactor
-- 整个cell的宽高
local cellWidth = Globals.cellWidth
-- buttom
local buttomHeight = 120
--image
local imageHeight = Globals.bigImgHeight
-- upperSpacer
local upperSpacer = 42
local cellHeight = upperSpacer + buttomHeight + imageHeight
-- 左侧间隙
local leftMargin = 15
-- background
local cellBackgroundColor = Globals.getBackgroundColor()

local lineHeight = 1
local lineColor = Globals.getDividerColor()

--icon
local iconHeight = 45
local iconWidth = 45
local iconLeft = 15
local iconTop = 18
-- columnName
local columnNameLeft = 70
local columnNameTop = 20
local columnNameSize = 14 * scale
local columnNameColor = Globals.getItemTitleColor()
local columnNameHeight = columnNameSize
--title
local titleTop = 20
local titleWidth = cellWidth - leftMargin*2
local titleSize = 18 * scale
local titleColor = Globals.getItemTitleColor()
local titleHeight = titleSize
--subtitle
local subtitleTop = 40
local subtitleSize = 14 * scale
local subtitleColor = Globals.getRecommendDescriptionFontColor()
local subtitleHeight = subtitleSize
-- btn
local btnTop = 68
local btnWidth = 110
local btnSize = 15 * scale
local btnHeight = 35
local btnColor = Globals.getBtnColor()
local btnBorderColor = Globals.getBtnBorderColor()

--subbtn
local subbtnSize = 13 * scale
local subbtnHeight = subbtnSize
local subbtnTop = (btnHeight - subbtnHeight)/2
local subbtnLeft = 137
--sharebtn
local sharebtnHeight = btnHeight
local sharebtnLeft = cellWidth - 50
local sharebtnTop = btnTop

-- 底部的四个间隙
local space1,space2,space3,space4 = 20,5,13,20
local totalSpace = space1+space2+space3+space4



local ItemCell = Class.Class("ItemCell",
								{
									base = Container,
									properties = {
										width = cellWidth,
										height = cellHeight,
										vc = Class.undefined,

										icon = Class.undefined,
										columnName = Class.undefined,
										viewPager = Class.undefined,
										title = Class.undefined,
										subtitle = Class.undefined,
										btn = Class.undefined,
										btnLabel = Class.undefined,
										subbtn1 = Class.undefined,
										deleteLine = Class.undefined,
										subbtn2 = Class.undefined,
										sharebtn = Class.undefined,
										btnContainer = Class.undefined,

										data = Class.undefined,
										viewPagerData = Class.undefined,
										viewPager = Class.undefined,
                              			clipsToBounds = true,
									},
})

function ItemCell.prototype:init(inlineprops, ...)
	Container.prototype.init(self, inlineprops, ...)
	self:doInit()
end

function ItemCell.prototype:doInit()
	self:addViews()
	self:addEventListeners()
end

function ItemCell.prototype:addViews()
	self:setWidth(cellWidth)
	self:setHeight(cellHeight)
	self:setBackgroundColor(Globals.getBackgroundColor())
	
	-- 先加广告栏，否则会挡住icon
	local viewPager = self:genViewPager()
	self:addChild(viewPager)

	local icon = ImageView{
		left = iconLeft, top = iconTop,
		width = iconWidth, height = iconHeight,
	}
	icon:setUserInteractionEnabled(true)
	local cover = ImageView{
		left = iconLeft, top = iconTop,
		width = iconWidth, height = iconHeight,
		src = "app://cover.png",
	}
	self:addChild(icon)
	self._icon = icon
	if getApplication():isNightMode() then
		self:addChild(cover)
	end

	-- 底部Container
	local buttom = self:createButtomContainer()
	self:addChild(buttom)
	self.buttom = buttom

	local columnName = Label{
		left = columnNameLeft, top = columnNameTop,
		fontSize = columnNameSize,
		color = Globals.getItemTitleColor(),
	}
	self:addChild(columnName)
	self._columName = columnName

	-- 底部的一条线
	local buttomLine = Container{
		width = cellWidth, height = lineHeight,
		left = 0, top = cellHeight - lineHeight,
		backgroundColor = Globals.getBorderColor(),
	}
	self:addChild(buttomLine)
	self.line = buttomLine

end 

function ItemCell.prototype:genViewPager()

	self:getViewPagerData()

	local viewPager = ItemViewPager{
		data = self._viewPagerData,
		width = cellWidth,
		height = imageHeight,
	}
	self._viewPager = viewPager
	return Container{
		left = 0, top = upperSpacer,
		width = cellWidth, height = imageHeight,
		items = {
			viewPager
		}
	}
end

function ItemCell.prototype:createButtomContainer()
	local title = Label{
		left = leftMargin, top = titleTop,
		width = titleWidth, 
		text = "",
		color = Globals.getItemTitleColor(),
		fontSize = titleSize,
		maxLines = 2,
	}
	self._title = title
	local subtitle = Label{
		left = leftMargin, top = subtitleTop,
		width = titleWidth, 
		text = "",
		color = Globals.getRecommendDescriptionFontColor(),
		fontSize = subtitleSize,
		maxLines = 3,
	}
	self._subtitle = subtitle

	local btnLabel = Label{
		left = leftMargin, top = 0,
		width = btnWidth, height = btnHeight,
		gravity = "center",
		text = "",
		color = Globals.getBtnColor(),
		fontSize = btnSize,
	}
	self._btnLabel = btnLabel

	local src
	if getApplication():isNightMode() then
		src = "app://btn_night.png"
	else
		src = "app://btn.png"
	end
	local btnImage = ImageView{
		left = leftMargin, top = 0,
		width = btnWidth,height = btnHeight,
		src = src,
		contentMode = "scaleToFill",
	}
	local btn = Button{
		left = leftMargin,top = 0,
		width = btnWidth, height = btnHeight,
	}
	Globals.applyItemBtnHilightStyle(btn)
	self._btn = btn

	local subbtn1 = Label{
		left = subbtnLeft,top = subbtnTop,
		fontSize = subbtnSize,

		color = Globals.getRecommendDescriptionFontColor(),
	}
	self._subbtn1 = subbtn1
	local subbtn2 = Label{
		left = subbtnLeft,top = subbtnTop,
		fontSize = subbtnSize,
		color = Globals.getBtnColor(),
	}
	self._subbtn2 = subbtn2

	local deleteLine = Container{
		left = subbtnLeft, top = btnHeight / 2 + 1,
		height = 0.5,
		backgroundColor = Globals.getRecommendDescriptionFontColor(),
	}
	self._deleteLine = deleteLine

	local shareSrc = Globals.getShareSrc()
	local sharebtn = ImageView{
		left = sharebtnLeft, top = 0,
		width = sharebtnHeight, height = sharebtnHeight,
		src = shareSrc
	}
	-- sharebtn:setUserInteractionEnabled(true)
	self._sharebtn = sharebtn
	local shareRealBtn = Button{
		left = sharebtnLeft, top = 0,
		width = sharebtnHeight, height = sharebtnHeight,
	}
	self._shareRealBtn = shareRealBtn
	Globals.applyShareBtnHilightStyle(shareRealBtn)

	local btnContainer = Container{
		left = 0,top = space1 + space2 + space3 + titleSize + subtitleHeight,
		width = cellHeight,height = btnHeight,
		items = {
			btn,
			btnImage,
			btnLabel,
			subbtn1,
			deleteLine,
			-- subbtn2,
			sharebtn,
			shareRealBtn
		}
	}
	self._btnContainer = btnContainer

	local c = Container{
		left = 0,top = cellHeight - buttomHeight,
		width = cellWidth, height = buttomHeight - lineHeight,
		items = {
			title,
			subtitle,
			btnContainer
		}
	}
	return c
end

function ItemCell.prototype:addEventListeners()
	if platform.isIOS() then
		self._icon:addEventListener("tap", function()
				getApplication():openUrl(self._data.jumpUrl)
			end)
	else
		self._icon:addEventListener("click", function()
				getApplication():openUrl(self._data.jumpUrl)
			end)
	end
	self._btn:addEventListener("click", function()
			getApplication():openUrl(self._data.btnurl)
		end)	
	self._shareRealBtn:addEventListener("click", function()
			self:openShareMode()
		end)
end


function ItemCell.prototype:openShareMode()
	local netsService = getApplication():getServiceMgr():createNTESService()
	if netsService and netsService.share then
		netsService:share(self._data.url, self._data.title, self._data.subtitle,self._viewPagerData[1].image,nil,Globals.getShareMode())
	end
end

function ItemCell.prototype:btnChanged()
	local text = self._data.btn
	if self._data.type == "电商" then
		text = "购 ¥" .. text
		if self._data.fontSize then
			self._btnLabel:setText(text)
			self._btnLabel:setFontSize(self._data.fontSize)
		else
			self._btnLabel:setWidth(nil)
			self._btnLabel:setText(text)
			self._btnLabel:setFontSize(btnSize)
			while (self._btnLabel:computedWidth() >= btnWidth) do
				self._btnLabel:setFontSize(self._btnLabel:getFontSize() - 1)
			end
			self._btnLabel:setWidth(btnWidth)
			self._data.fontSize = self._btnLabel:getFontSize()
		end
		return
	end

	self._btnLabel:setText(text)
	self._btnLabel:setFontSize(btnSize)	
end

function ItemCell.prototype:subbtnChanged()
	-- 判断第二个Label需不需要显示
	-- if self._data.type == "应用" then
	-- 	self._subbtn2:setVisible(true)
	-- 	self._deleteLine:setWidth(0)
	-- 	local index = string.find(self._data.subbtn, "%d")
	-- 	if index > 0 then
	-- 		self._subbtn1:setText(string.sub(self._data.subbtn, 1, index-1))
	-- 		if not self._data.subbtn1Width then
	-- 			self._data.subbtn1Width = self._subbtn1:computedWidth()
	-- 		end
	-- 		self._subbtn2:setLeft(self._subbtn1:getLeft() + self._data.subbtn1Width)
	-- 		self._subbtn2:setText(string.sub(self._data.subbtn, index, -1))
	-- 	end
	-- else
	-- 	-- 第二个Label不需要显示,不知visible是否可用
	-- 	self._subbtn2:setVisible(false)
	-- 	-- 第一个Label的文本		
	-- 	local text = self._data.subbtn 
	-- 	-- 判断是否需要加删除线
	-- 	if self._data.type == "电商" then
	-- 		text = "¥" .. text
	-- 		self._subbtn1:setText(text)
	-- 		if not self._data.subbtn1Width then
	-- 			self._data.subbtn1Width = self._subbtn1:computedWidth()
	-- 		end
	-- 		self._deleteLine:setWidth(self._data.subbtn1Width)
	-- 	else
	-- 		self._subbtn1:setText(text)
	-- 		self._deleteLine:setWidth(0)
	-- 	end
	-- end

	local text = self._data.subbtn

	if self._data.type == "电商" then
		text = "¥" .. text
		self._subbtn1:setText(text)
		if not self._data.subbtn1Width then
			self._data.subbtn1Width = self._subbtn1:computedWidth()
		end
		self._deleteLine:setWidth(self._data.subbtn1Width)
	else
		self._subbtn1:setText(text)
		self._deleteLine:setWidth(0)
	end

end

function ItemCell.prototype:sharebtnChanged()
	local netsService = getApplication():getServiceMgr():createNTESService()
	if netsService and netsService.share then
		self._sharebtn:setVisible(true)
	else
		self._sharebtn:setVisible(false)
	end
end

function ItemCell.prototype:getViewPagerData()
	if self._data then 
		self._viewPagerData = Globals.stringSplit(self._data.image, ";")
	end
	if self._viewPagerData then
		for i,v in pairs(self._viewPagerData) do
			self._viewPagerData[i] = {image = v, url = self._data.url}
		end
	end
end

function ItemCell.prototype:viewPagerChanged()

	self:getViewPagerData()
	self._viewPager:setData(self._viewPagerData)
end


-- for android
function ItemCell.prototype:onDataChanged()
	if self._data then
		if not self._data.cache.height then
			ItemCell:getCellHeight(self._data)
		end
		self.buttom:setHeight(self._data.cache.height - upperSpacer - imageHeight)
		self:setHeight(self._data.cache.height)

		self._icon:setSrc(self._data.icon)
		self._columName:setText(self._data.name)
		self._title:setText(self._data.title)
		self._subtitle:setText(self._data.subtitle)
		
		self._subtitle:setTop(space1+self._data.cache.titleHeight+space2)
		self._btnContainer:setTop(space1+space2+space3+self._data.cache.titleHeight+self._data.cache.subtitleHeight)

		self:btnChanged()
		self:subbtnChanged()
		self:sharebtnChanged()
		self:viewPagerChanged()
		self.line:setTop(self:getHeight() - lineHeight)
		self.line:setVisible(not self._data.lastOne)
		-- self:layout()
	end
end

-- function ItemCell.prototype:onDataChanged()
-- 	if self._data then
-- 		self._icon:setSrc(self._data.icon)
-- 		self._columName:setText(self._data.name)
-- 		self._title:setText(self._data.title)
-- 		self._subtitle:setText(self._data.subtitle)
-- 		-- self._
-- 		self:btnChanged()
-- 		self:subbtnChanged()
-- 		self:sharebtnChanged()
-- 		self:viewPagerChanged()
-- 		self.line:setVisible(not self._data.lastOne)
-- 	end
-- end


function ItemCell.class.prototype:getCellHeight(data)

	if data and data.cache then
		if data.cache.height then 
			return data.cache.height
		else
			local titleHeight = Globals.getLabelHeight(titleSize,titleWidth,data.title)
			if titleHeight >= 2*titleSize then
				titleHeight = 2*titleSize + 6
			end
			data.cache.titleHeight = titleHeight
			local subtitleHeight = Globals.getLabelHeight(subtitleSize,titleWidth,data.subtitle)
			if subtitleHeight > 3*subtitleSize then
				subtitleHeight = 3*subtitleSize+6
			elseif subtitleHeight > 2*subtitleSize then
				subtitleHeight = 2*subtitleSize+4
			end
			data.cache.subtitleHeight = subtitleHeight
			local height = upperSpacer + imageHeight + totalSpace + titleHeight + subtitleHeight + btnHeight
			data.cache.height = height
			return height
		end
	else
		return 0
	end
end

return ItemCell




