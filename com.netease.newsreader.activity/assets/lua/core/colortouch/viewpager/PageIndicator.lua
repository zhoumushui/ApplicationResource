require "stdlib/class/Class"

PageIndicator = Class.Class("PageIndicator",
                         {
                            base=Container,

                            properties={
                               numberOfPages = 1,
                               currentPage = 1, --从1开始

                               indicatorSrc = Class.undefined,
                               activeIndicatorSrc = Class.undefined,
                               
                               indicatorColor = rgba{102,102,102,1},
                               activeIndicatorColor = rgba{0,186,255,1},

                               -- 参数格式{w=w, h=h}
                               -- 如果没有定义，则按照PageIndicator的cell容器的高度(HBox)或宽度(VBox)的"66%"来定义
                               indicatorSize = {w="66%", h="66%"},
                               -- 如果没有定义，则按照PageIndicator父容器的高度(HBox)或宽度(VBox)来定义
                               activeIndicatorSize = {w="100%", h="100%"},

                               isRecycleEnabled = false,

                               -- private members, please donot use
                               cells = Class.undefined,
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
   if self._numberOfPages < 1 then
      error("numberOfPages must greater than 0")
   end
   if self._currentPage < 1 or self._currentPage > self._numberOfPages then
      error("invalid currentPage index")
   end

   self:initCellsAndIndicators()

   -- if self._activeIndicatorSrc then
   --    self:onActiveIndicatorSrcChanged("activeIndicatorSrc", nil, self._activeIndicatorSrc)
   -- end

   -- if self._activeIndicatorColor then
   --    self:onActiveIndicatorColorChanged("activeIndicatorColor", nil, self._activeIndicatorColor)
   -- end

   -- if self._activeIndicatorSize then
   --    self:onActiveIndicatorSizeChanged("activeIndicatorSize", nil, self._activeIndicatorSize)
   -- end

   
end

function PageIndicator.prototype:pageToPrev()
   local oldPage = self._currentPage
   local newPage = oldPage - 1
   if newPage < 1 then
      if self._isRecycleEnabled then
         newPage = self._numberOfPages
      else
         print("warn running: PageIndicator PageToPrev error when currentPage is 1")
         return
      end
   end
   
   self:setCurrentPage(newPage)
end

function PageIndicator.prototype:pageToNext()
   local oldPage = self._currentPage
   local newPage = oldPage + 1
   if newPage > self._numberOfPages then
      if self._isRecycleEnabled then
         newPage = 1
      else
         print("warn running: PageIndicator PageToNext error when currentPage is the last one")
         return
      end
   end
   
   self:setCurrentPage(newPage)
end

---------------------------------------------
-- private functions
---------------------------------------------

function PageIndicator.prototype:initCellsAndIndicators()
   local indicatorWidth = self._indicatorSize.w
   local indicatorHeight = self._indicatorSize.h

   self._cells = {}
   self._indicators = {}
   for i=1, self._numberOfPages do
      local cell = Container{
         layout = "flex", dir = HBox,
         align = Center, pack = Center,
         backgroundColor = rgba{0,0,0,0},
      }
      self._cells[i] = cell
  
      local indicator = ImageView {
         width = indicatorWidth, height=indicatorHeight,
         backgroundColor = self._indicatorColor,
         src = self._indicatorSrc,
         contentMode = "aspectFit",
      }
      self._indicators[i] = indicator

      cell:setItems{indicator}
   end

   self:setLayout("flex")
   if self._dir == VBox then
      self:setDir(VBox)
      local subHeight = self:getDevidedValue(self:getHeight(), self._numberOfPages)
      for _, cell in ipairs(self._cells) do
         cell:setHeight(subHeight)
         cell:setWidth("100%")
      end
   else
      self:setDir(HBox)
      local subWidth = self:getDevidedValue(self:getWidth(), self._numberOfPages)
      for _, cell in ipairs(self._cells) do
         cell:setWidth(subWidth)
         cell:setHeight("100%")
      end
   end

   self:setItems(self._cells)

   if self._currentPage then
      self:onCurrentPageChanged("currentPage", nil, self._currentPage)
   end

   self:layout()
end

function PageIndicator.prototype:setNumberOfPages(new)
   if new < 1 then error("numberOfPages must greater than 0") end
   if new == self._numberOfPages then return end
   self._numberOfPages = new

   self:initCellsAndIndicators()
end

-- function PageIndicator.prototype:onNumberOfPagesChanged(prop, old, new)
--    print("PageIndicator onNumberOfPagesChanged new =", new, "old=", old)
--    if new < 1 then error("numberOfPages must greater than 0") end
--    if new == self._numberOfPages then return end
   
--    self:initCellsAndIndicators()
-- end

function PageIndicator.prototype:onCurrentPageChanged(prop, old, new)
   for i, indicator in ipairs(self._indicators) do
      indicator:setBackgroundColor(self._indicatorColor)
      indicator:setSrc(self._indicatorSrc)
      indicator:setWidth(self._indicatorSize.w)
      indicator:setHeight(self._indicatorSize.h)
   end
   self._currentPage = new

   self._indicators[new]:setBackgroundColor(self._activeIndicatorColor)
   self._indicators[new]:setSrc(self._activeIndicatorSrc)
   self._indicators[new]:setWidth(self._activeIndicatorSize.w)
   self._indicators[new]:setHeight(self._activeIndicatorSize.h)

   -- self:layout()
end

function PageIndicator.prototype:onIndicatorSrcChanged(prop, old, new)
   self._indicatorSrc = new
   for i, indicator in ipairs(self._indicators) do
      if i ~= self._currentPage then
         indicator:setSrc(new)
      end
   end
end

function PageIndicator.prototype:onActiveIndicatorSrcChanged(prop, old, new)
   self._activeIndicatorSrc = new
   self._indicators[self._currentPage]:setSrc(new)
end

function PageIndicator.prototype:onIndicatorColorChanged(prop, old, new)
   self._indicatorColor = new
   for i, indicator in ipairs(self._indicators) do
      if i ~= self._currentPage then
         indicator:setBackgroundColor(new)
      end
   end
end

function PageIndicator.prototype:onActiveIndicatorColorChanged(prop, old, new)
   self._activeIndicatorColor = new
   self._indicators[self._currentPage]:setBackgroundColor(new)
end

function PageIndicator.prototype:onIndicatorSizeChanged(prop, old, new)
   if new == nil then error("indicator size cannot be nil") end
   self._indicatorSize = new
   for i, indicator in ipairs(self._indicators) do
      if i ~= self._currentPage then
         indicator:setWidth(new.w)
         indicator:setHeight(new.h)
      end
   end
end

function PageIndicator.prototype:onActiveIndicatorSizeChanged(prop, old, new)
   if new == nil then error("indicator size cannot be nil") end
   self._activeIndicatorSize = new
   local activeIdicator = self._indicators[self._currentPage]
   activeIdicator:setWidth(new.w)
   activeIdicator:setHeight(new.h)
end

function PageIndicator.prototype:getDevidedValue(value, count)
   if type(value) == "string" then
      local str = string.gsub(value, "%%", "")
      local numValue = tonumber(str)
      numValue = numValue/count
      local strValue = tostring(numValue) .. "%"
      return strValue
   elseif type(value) == "number" then
      return value/count
   end

   return nil
end
