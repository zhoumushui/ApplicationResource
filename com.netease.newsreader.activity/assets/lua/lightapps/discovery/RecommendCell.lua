module("RecommendCell",package.seeall)

require "Globals"
local TabView = require "TabView"

local cellWidth = Globals.cellWidth
local scaleFactor = Globals.scaleFactor

local maxNumOfCellsInRow = 4
local borderWeight = 0.5
local tabHeight = TabView:getTabHeight()

local borderColor = rgba{217,217,217,1}
local dividerColor = rgba{231,231,231,1}

RecommendCell = Class.Class("RecommendCell",{
				base = Container,
				properties = {
					width = cellWidth,
					height = tabHeight,
					data = Class.undefined,
					p_tabView = Class.undefined,
					p_bordersContainer = Class.undefined,
				}
			})



function RecommendCell.prototype:init(inlineprop, ... )
	Container.prototype.init(self, inlineprop, ...)
	self:setBackgroundColor(Globals.getBackgroundColor())


	self._p_tabView = self._p_tabView or {}
	self._p_bordersContainer = self._p_bordersContainer or {}


	--直接新建4个，通过visible显示和隐藏
	for i=1, maxNumOfCellsInRow do
		local tabView = TabView{}
		tabView:setVisible(false)
		self:addChild(tabView)
		table.insert(self._p_tabView,tabView)
	end


	for i=1, maxNumOfCellsInRow - 1 do
		local borderContainer = Container{
			height = tabHeight,
			width = borderWeight,
			backgroundColor = Globals.getDividerColor(),
		}
		borderContainer:setVisible(false)
		self:addChild(borderContainer)
		table.insert(self._p_bordersContainer,borderContainer)
	end


	if self._data then
		self:onDataChanged("data",nil,self._data)
	end
end

function RecommendCell.prototype:onDataChanged(prop, old, new)

	if self._data and #(self._data) > 0 then 

		--苹果审核期内不显示
		local dataForDisplay = {}
		for i=1,#(self._data) do
			if getApplication():getStoreChecking() == false or string.len(self._data[i].disappear) == 0 then 
				if self._data[i].title == "游戏中心" then
					local id = getApplication():getChannelId()
					if id ~= "vivo_store2014_news" then
						table.insert(dataForDisplay,self._data[i])
					end
				else
					table.insert(dataForDisplay,self._data[i])
				end
			end
		end 

		--得到实际显示的行数，如果超过4个，只显示4个
		local numOfCellsInRow = #(dataForDisplay) < maxNumOfCellsInRow and #(dataForDisplay) or maxNumOfCellsInRow

		local tabWidth = cellWidth / numOfCellsInRow

		--设置tabview
		for i=1,maxNumOfCellsInRow do
			if i <= numOfCellsInRow then
				self._p_tabView[i]:setData(dataForDisplay[i])
				self._p_tabView[i]:setWidth(tabWidth)

				local tabLeft = (i - 1) * tabWidth
				self._p_tabView[i]:setLeft(tabLeft)
				self._p_tabView[i]:setVisible(true)
			else
				self._p_tabView[i]:setVisible(false)
			end
		end

		--设置分割线，比内容个数少一个
		for i=1,maxNumOfCellsInRow-1 do
			if i <= numOfCellsInRow - 1 then
				local boardLeft = i * tabWidth
				self._p_bordersContainer[i]:setLeft(boardLeft)
				self._p_bordersContainer[i]:setVisible(true)
			else
				self._p_bordersContainer[i]:setVisible(false)
			end
		end
	end
end

RecommendCell.cellHeight = tabHeight

function RecommendCell.class.prototype:getCellHeight(data)
   return tabHeight
end

return RecommendCell

