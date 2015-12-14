require "stdlib/class/Class"

--[[
   PickerView{
     dataSource = {
       {
          "some string",
          ImageView{
            src="http://....png"
          }
       }
     }
   }

]]

PickerView = Class.Class("PickerView",
                         {
                            base = Node,
                            properties = {
                               dataSource = Class.undefined,
                               data = Class.undefined
                            }
});

function PickerView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)

   if self._data ~= nil then
      self:onDataChanged("data", nil, self._data)
   end
end

function PickerView.prototype:onDataChanged(prop, old, new)
   local dataSource = PickerViewDataSource({
                                              dataSource=new
   })
   self:setDataSource(dataSource)
end

function PickerView.prototype:onDataSourceChanged(prop, old, new)
   self._pv:setDataSource(new._pv)
end

function PickerView.prototype:updateColumn(column, data)
   self._dataSource:updateColumn(column, data)
   self._pv:reloadComponent(column)
end

function PickerView.prototype:reloadComponent(c)
   self._pv:reloadComponent(c)
end

function PickerView.prototype:reloadAllComponents()
   self._pv:reloadAllComponents()
end

--调用这个接口不会回调itemclick
function PickerView.prototype:selectRowInComponent(r, c, bAni)
   self._pv:selectRowInComponent(r, c, bAni)
end

function PickerView.prototype:selectedRowInComponent(c)
   return self._pv:selectedRowInComponent(c)
end

--@override
function PickerView.prototype:createPlatFormView()
   return PlatformPickerView(self)
end
