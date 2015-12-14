module("PlatformCTPickerViewDataSource", package.seeall)

PlatformCTPickerViewDataSourceMt = {
   __tostring = function()
      return "datasource"
   end,

   __index = {
      updateDataSource = function(self, datasource)
       --  print("TODO updateDataSource")
    --  	print(table.tostring(datasource))
      	--这里android只取第一列

          -- print(' PlatformCTPickerViewDataSourceMt updateDataSource')

      	if datasource[1] ~=nil and type(datasource[1])=='table' then
       		return self["handler"]["updateDataSource.(Ljava/lang/String;)V"](self["handler"],table.concat(datasource[1],";"))
       	end
      end,

      updateColumnHeight = function(self, hs)
         -- return self["handler"]:updateColumnHeight(hs)
      end,

      updateColumnWidth = function(self, ws)
      	 print("TODO updateColumnWidth")
         --return self["handler"]:updateColumnWidth(ws)
      end
   }
}

PlatformCTPickerViewDataSource = function()
    local s = setmetatable({}, PlatformCTPickerViewDataSourceMt);
 	local bindDataSourceClass =   luabridge.bindClass("com.netease.colorui.view.model.PickerViewDataSource")
    s["handler"]  = bindDataSourceClass["newDataSource.(Landroid/content/Context;)Lcom/netease/colorui/view/model/PickerViewDataSource;"](bindDataSourceClass,currentContext)
	return s
end
