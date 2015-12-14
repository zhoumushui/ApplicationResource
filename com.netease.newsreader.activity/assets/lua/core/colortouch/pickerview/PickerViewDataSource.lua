require "stdlib/class/Class"

PickerViewDataSource = Class.Class("PickerViewDataSource",
                                   {
                                      properties={
                                         dataSource=Class.undefined,
                                      }
})

--[[
   {
      {
         "some string",
         ImageView{src="..."} --some view
      },
      {
      }
   }
]]

function PickerViewDataSource.prototype:init(params)
   self._pv = PlatformCTPickerViewDataSource.PlatformCTPickerViewDataSource();
   if params.dataSource ~= nil then
      self:setDataSource(params.dataSource)
   end
end

function PickerViewDataSource.prototype:updateColumn(column, data)
   
   self._dataSource[column+1] = data
   self:onDataSourceChanged("dataSource", nil, self._dataSource)
end

function PickerViewDataSource.prototype:onDataSourceChanged(prop, old, source)
   --暂时仅支持选择项为字符串，如果需要更加丰富的控件，可以这里处理。
   return self._pv:updateDataSource(source)
end

function PickerViewDataSource.prototype:updateColumnHeight(hs)
   return self._pv:updateColumnHeight(hs)
end

function PickerViewDataSource.prototype:updateColumnWidth(ws)
   return self._pv:updateColumnWidth(ws)
end
