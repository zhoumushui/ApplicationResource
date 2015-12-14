MultipleSelectedView = Class.Class("MultipleSelectedView",
                                   {
                                      base = Node,
                                      properties = {
                                         sources = Class.undefined,
                                         --初始化的时候需要默认选中的
                                         initSelectedItems = Class.undefined,
                                      }
});

function MultipleSelectedView.prototype:createPlatFormView()
   return PlatformMultipleSelectedView(self)
end

function MultipleSelectedView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)

   if self._sources then
      self:onSourcesChanged("sources", nil, self._sources)
   end

   if self._initSelectedItems then
      self:onInitSelectedItemsChanged("initSelectedItems", nil, self._initSelectedItems)
   end
end

function MultipleSelectedView.prototype:onInitSelectedItemsChanged(prop, old, new)
   if new then
      for _, idx in ipairs(new) do
         self:setSelected(idx)
      end
   end
end


function MultipleSelectedView.prototype:onSourcesChanged(prop, old, new)
   return self._pv:setSource(new)
end

function MultipleSelectedView.prototype:selectedItems()
   return self._pv:selectedItems();
end

function MultipleSelectedView.prototype:setSelected(idx)
   return self._pv:setSelected(idx)
end
