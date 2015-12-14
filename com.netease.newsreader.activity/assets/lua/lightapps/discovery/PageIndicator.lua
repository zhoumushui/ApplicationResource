module("PageIndicator", package.seeall)

local PageIndicator = Class.Class("PageIndicator",
                         {
                            base=Container,

                            properties={
                               numberOfPages = 0,--共有多少页
                               currentPage = 1,
                               
                               indicatorColor = rgba{102,102,102,1},--普通indicator的color
                               activeIndicatorColor = rgba{0,186,255,1},--当前indicator的color

                               indicatorSize = 0,--普通indicator的大小
                               activeIndicatorSize = 0,--当前indicator的大小

                               distance = 0, --两个相邻点之间的距离，从圆心到圆心

                               bShowIfOnlyOne = false,--只有一张图片的时候，是否显示

                               indicators = Class.undefined,
                            }
                         }
)

function PageIndicator.prototype:init(inlineprops, ...)
	Container.prototype.init(self, inlineprops, ...)
	self:doInit()
end

function PageIndicator.prototype:onLayoutComplete()
   	Node.prototype.onLayoutComplete(self)
end

function PageIndicator.prototype:doInit()
	if self._numberOfPages <= 0 then 
		return
	end
	if self._numberOfPages == 1 and not self._bShowIfOnlyOne then
		return
	end
	self._indicators = {}
	local top = (self._activeIndicatorSize - self._indicatorSize)/2
	local space = (self._distance - self._activeIndicatorSize)/2
	for i=1, self._numberOfPages do
		local indicator = ImageView {
			left = space + (i-1)*self._distance,top = top,
			width = self._indicatorSize, height=self._indicatorSize,
			backgroundColor = self._indicatorColor,
			src = self._indicatorSrc,
			contentMode = "aspectFit",
		}
		self._indicators[i] = indicator
		self:addChild(indicator)
	end  
end

function PageIndicator.prototype:onCurrentPageChanged(prop, old, new)
	if self._numberOfPages == 1 and not self._bShowIfOnlyOne then
		return
	end
	local top = (self._activeIndicatorSize - self._indicatorSize)/2 
	for i, indicator in ipairs(self._indicators) do
		indicator:setBackgroundColor(self._indicatorColor)
		indicator:setWidth(self._indicatorSize)
		indicator:setHeight(self._indicatorSize)
		indicator:setBorderRadius(self._indicatorSize/2)
		indicator:setTop(top)
	end

	self._indicators[new]:setBackgroundColor(self._activeIndicatorColor)
	self._indicators[new]:setWidth(self._activeIndicatorSize)
	self._indicators[new]:setHeight(self._activeIndicatorSize)
	self._indicators[new]:setBorderRadius(self._activeIndicatorSize/2)
	self._indicators[new]:setTop(0)
end

return PageIndicator

