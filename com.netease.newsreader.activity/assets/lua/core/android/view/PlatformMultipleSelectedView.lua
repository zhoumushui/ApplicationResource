PlatformMultipleSelectedView = createNewPlatformView(View)

--@override
--@platform
function PlatformMultipleSelectedView:newPlatformView(absView, ...)
   self["type"]="MultipleSelectedView"
   return  ViewOwner:createView("MultipleSelectedView",currentContext)
end

function PlatformMultipleSelectedView:setSource(sources)
   local jsonsource = cjson.encode(sources)
   self["handler"]["setSource.(Ljava/lang/String;)V"](self["handler"],jsonsource)
end

function PlatformMultipleSelectedView:selectedItems()
   local stritems = self["handler"]["getSeletedItems.()Ljava/lang/String;"](self["handler"]);

   local items = cjson.decode(stritems)
   local itemsSize =   #items
	print('the size is.'..itemsSize)
   
   local retItems = {}
   for i = 1, itemsSize do
      table.insert(retItems, items[i])
   end
   print(table.tostring(retItems))
   return retItems
end

