module("DiscoveryDatasource", package.seeall)

local AdsCell = require("AdsCell")
local RecommendCell = require("RecommendCell")
local SpacerCell = require("SpacerCell")
local ItemCell = require("ItemCell")


function slice(array, start_index, length)
	local sliced_array = {}
	
	start_index = math.max(start_index, 1)
	local end_index = math.min(start_index+length-1, #array)
	for i=start_index, end_index do
		 sliced_array[#sliced_array+1] = array[i]
	end
	return sliced_array
end

DiscoveryDatasource = Class.Class("DiscoveryDatasource",
                                  {
                                     base=TableViewDataSource,

                                     properties = {
                                        dataIsReady = false,
                                        data = Class.undefined,
                                     }
})

function DiscoveryDatasource.prototype:init()
   TableViewDataSource.prototype.init(self)

   if self._data then
      self:onDataChanged("data", nil, self._data)
   end
end

function DiscoveryDatasource.prototype:chooseItemData()
   local data = self._data["stream"]
   for i,v in pairs(data) do
      local index = math.random(#v.context)
      v.btnurl = v.context[index].btnurl
      v.title = v.context[index].title
      v.subtitle = v.context[index].subtitle
      v.btn = v.context[index].btn
      v.subbtn = v.context[index].subbtn
      v.image = v.context[index].image
      v.url = v.context[index].url
      v.context[index].cache = v.context[index].cache or {}
      v.cache = v.context[index].cache
   end
end

function DiscoveryDatasource.prototype:onDataChanged(prop, old, new)
   if self._data then
      self._dataIsReady = true
      self:chooseItemData()
   end

   self:getTableView():reloadData()
end

function DiscoveryDatasource.prototype:numberOfRowsInSection(tableview, section)
   if self._dataIsReady == false then
      return 0
   else

      local count = 3 + #self._data["stream"]
      return count
   end
end

function DiscoveryDatasource.prototype:getCellClass(row)
   if row == 0 then
      return AdsCell
   elseif row == 1 then
      return RecommendCell
   elseif row == 2  then
      return SpacerCell
   else
      return ItemCell
   end
end

function DiscoveryDatasource.prototype:getCellData(row)
   if row == 0 then
      return self._data["banner"]
   elseif row == 1 then
      return self._data["recommend"]
   elseif row == 2  then
      return nil
   else
      return self._data["stream"][row-2]
   end
end

function DiscoveryDatasource.prototype:getReuseIdentifier(tableview, row, section)
   return self:getCellClass(row).className
end

function DiscoveryDatasource.prototype:doReuseContentView(tableiew, contentview, row, section)   
   local data = self:getCellData(row)
   if data then
      if row == self:numberOfRowsInSection(tableview, section) - 1 then
         data.lastOne = true
      else
         data.lastOne = false
      end
      contentview:setData(data,true)
      contentview:layout()
   end
end

function DiscoveryDatasource.prototype:doNewContentView(tableview, row, section)
   local view = self:getCellClass(row)()
   self:doReuseContentView(tableview, view, row, section)
   return view
end


function DiscoveryDatasource.prototype:heightForRow(tableview, row, section)
   local loadMoreView
   if self._tableView then
      loadMoreView = self._tableView._loadMoreView
   end

   if self:_isLoadMoreLabel(tableview, section) then
      if loadMoreView then
         -- print("heightForRow computedHeight=", loadMoreView:computedHeight())
         return loadMoreView:computedHeight()
      else
         -- print("defaultLoadMoreLabelHeight=", defaultLoadMoreLabelHeight)
         return defaultLoadMoreLabelHeight
      end
   end

   if self._delegate and self._delegate.heightForRow then
      return self._delegate.heightForRow(self, tableview, row, section)
   end
   return nil
end



--------------------
--私有内部函数
--------------------
function DiscoveryDatasource.prototype:newContentView(tableview, row, section)
   local contentView
   if self:_isLoadMoreLabel(tableview, section) then
      contentview = self:_getLoadMoreView()
      print("_newContentView loadmoreview=", contentview)
      table.insert(self._cells, contentView)
      return contentview
   else
      contentView = self:doNewContentView(tableview, row, section)
   end
   table.insert(self._cells, contentView)

   --为了让android兼容ios，使用heightForRow接口重新设置contentview的高度，重新设置tableview cell的高度
   -- if not platform.isIOS() then
   --    if contentview then
   --       local newHeight = self:heightForRow(tableview, row, section)
   --       if newHeight ~= nil then
   --          contentview:setHeight(newHeight)
   --       end
   --    end
   -- end

   return contentView
end


function DiscoveryDatasource.prototype:reuseContentView(tableview, contentview, row, section)
   local existed = false
   for _, view in ipairs(self._cells) do
      if view == contentview then
         existed = true
         break
      end
   end

   if false == existed then
      table.insert(self._cells, contentview)
   end

   if self:_tryDoReuseLoadMoreContentView(tableview, contentview, row, section) then
      print("reuse LoadMore View")
      return
   end

   self:doReuseContentView(tableview, contentview, row, section)

   --为了让android兼容ios，使用heightForRow接口重新设置contentview的高度，重新设置tableview cell的高度
   -- if not platform.isIOS() then
   --    if contentview then
   --       local newHeight = self:heightForRow(tableview, row, section)
   --       if newHeight ~= nil then
   --          contentview:setHeight(newHeight)
   --       end
   --    end
   -- end
end





return DiscoveryDatasource
