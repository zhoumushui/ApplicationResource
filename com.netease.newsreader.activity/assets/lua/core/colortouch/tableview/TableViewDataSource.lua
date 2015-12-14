require "colortouch.tableview.TableViewDataSourceDelegate"

local defaultLoadMoreLabelHeight = 25


TableViewDataSource = Class.Class("TableViewDataSource",
                                  {
                                     properties={
                                        data = Class.undefined,
                                        cells = Class.undefined,

                                        tableView = Class.undefined,
                                        delegate = tableViewDataSourceDelegate,

                                        --private members
                                        numberOfSection = Class.undefined,
                                        numberOfRows = {},
                                     }
})

--[[
/**
  @section{tabviewdatasource是tableview的数据源}
  @property[data]{
    @class[table]
    真正的数据源
  }
  @method[numberOfRowsInSection]{
      tableview item个数
      @param[tableview]{
        tabledatasource绑定的tableview
      }
      @param[section]{
          预留为未来的参数，目前该参数无效，固定值为1
      }
  }

  @method[getReuseIdentifier]{
       获取item的id，colortouch根据该值确定不同的item类型
       @return[
          item id
       ]
  }
  @method[doReuseContentView]{
      复用已有的item视图，为视图关联数据
      @param[tableview]{
        关联的tableview
      }
      @param[contentview]{
        待复用的视图
      }
      @param[row]{
        当前行数
      }
      @param[section]{
        section
      }
  }

  @method[doNewContentView]{
    新建item视图
    @param[tableview]{关联的tableview}
    @param[row]{当前行数}
    @param[section]{selction}
    @return[View]{
      item视图
    }
  }

  @method[numberOfSectionsInTableView]{
       预留为未来的参数，目前该方法不可继承，固定返回为1 
  }
  @method[heightForRow]{
    每一个item的高度,此参数只对ios有效，android会自动计算item高度
    @return[int] 
  }

*/

]]

function TableViewDataSource.prototype:init(data)
   self._data = data
   self._cells = {}

   if platform.isIOS() then
      self._pv = IOS.CTTableViewDatasourceAndDelegate_Proxy()
      ----print(self)
      --print(self._pv)
      self._pv:updateLuaState()
      bindObjcInstanceToWeakLuaObj(self._pv:getImpl(), self);
   else
      self['_pv'] =  luajava.newInstance('com.netease.colorui.view.model.TableViewDataSource',self)
       --     print('now tableviewdatasouce protype init')
        --    print("selfpv is :\t"..tostring(self['_pv']))
   end
end

function TableViewDataSource.prototype:doNewContentView(tableview, row, section)
   if self._delegate and self._delegate.doNewContentView then
      return self._delegate.doNewContentView(self, tableview, row, section)
   end
   return Node{}
end

--[[
-- 不再提供，colortouch内部设置
function TableViewDataSource.prototype:reuseTypeCount()
   return 100
end
]]

function TableViewDataSource.prototype:refresh(tableview)
   if self._delegate and self._delegate.refresh then
      self._delegate.refresh(self, tableview)
   end
end

function TableViewDataSource.prototype:loadMore(tableview)
   if self._delegate and self._delegate.loadMore then
      self._delegate.loadMore(self, tableview)
   end
end

function TableViewDataSource.prototype:shouldShowLoadMore()
   if self._delegate and self._delegate.shouldShowLoadMore then
      return self._delegate.shouldShowLoadMore(self)
   end
   return false
end

function TableViewDataSource.prototype:heightForRow(tableview, row, section)
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
   return 40
end

function TableViewDataSource.prototype:getReuseIdentifier(tableview, row, section)
   if self:_isLoadMoreLabel(tableview, section) then
      return "__Load_More_Cell"
   elseif self._delegate and self._delegate.getReuseIdentifier then
      return self._delegate.getReuseIdentifier(self, tableview, row, section)
   end

   return ""
end

function TableViewDataSource.prototype:reuseContentView(tableview, contentview, row, section)
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
   if not platform.isIOS() then
      if contentview then
         local newHeight = self:heightForRow(tableview, row, section)
         contentview:setHeight(newHeight)
      end
   end
end

function TableViewDataSource.prototype:numberOfSectionsInTableView(tableview)
   local number = self:doNumberOfSectionInTableView(tableview)

   if self:_shouldShowLoadMoreView() then
      number = number + 1
   end

   if self._numberOfSection == nil then
      self._numberOfSection = number
   end
   if self._numberOfSection ~= number and self._tableView ~= nil then
      self._tableView:_notifyToReloadData()
   end

   return number
end

function TableViewDataSource.prototype:numberOfRowsInSection(tableview, section)
   local result = 1
   if self:_isLoadMoreLabel(tableview, section) then
      result = 1
   else
      result = self:doNumberOfRowsInSection(tableview, section)
   end
   
   if self._numberOfRows[section] == nil then
      self._numberOfRows[section] = result
   end
   if self._numberOfRows[section] ~= result and self._tableView ~= nil then
      self._tableView:_notifyToReloadData()
   end

   return result
end

function TableViewDataSource.prototype:reuseTypeCount()
   return 100
end


--------------------
--私有内部函数
--------------------
function TableViewDataSource.prototype:newContentView(tableview, row, section)
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
   if not platform.isIOS() then
      if contentview then
         local newHeight = self:heightForRow(tableview, row, section)
         contentview:setHeight(newHeight)
      end
   end

   return contentView
end

function TableViewDataSource.prototype:doNumberOfSectionInTableView(tableview)
   local number = 1
   if self._delegate and self._delegate.numberOfSectionsInTableView then
      number = self._delegate.numberOfSectionsInTableView(self, tableview)
   end
   return number
end

function TableViewDataSource.prototype:doNumberOfRowsInSection(tableview, section)
   local result = 0
   if self._delegate and self._delegate.numberOfRowsInSection then
      result = self._delegate.numberOfRowsInSection(self, tableview, section)
   end
   return result
end

function TableViewDataSource.prototype:_isLoadMoreLabel(tableview, section)
   if section == self:doNumberOfSectionInTableView(tableview) then
      if self:_shouldShowLoadMoreView() then
         return true
      end
   end

   return false
end

function TableViewDataSource.prototype:_shouldShowLoadMoreView()
   if self._tableView and self._tableView._isLoadMorable then
      -- print("shouldShowLoadMore =", self:shouldShowLoadMore())
      return self:shouldShowLoadMore()
   end
   return false
end

function TableViewDataSource.prototype:_getLoadMoreView()
   print("_getLoadMoreView")

   local loadMoreContent = self:_getLoadMoreViewContent()
   local height = defaultLoadMoreLabelHeight
   if loadMoreContent:getHeight() then
      height = loadMoreContent:getHeight()
   end
   return Container{
      left=0, top=0,
      width=320, height=height,
      layout="flex", dir=HBox,
      align=Center, pack=Center,
      backgroundColor=rgba{255,255,255,0},
      items={
         loadMoreContent,
      },
   }
end

function TableViewDataSource.prototype:_getLoadMoreViewContent()
   if self._tableView and self._tableView._loadMoreView then
      return self._tableView._loadMoreView
   end

   local loadMoreLabel = Label {
      id = "__loadMoreLabel",
      width=80, height=defaultLoadMoreLabelHeight,
      backgroundColor=rgba{255,255,255,0},
      text="加载更多...",
   }
   return Container {
      id = "__loadMoreCell",
      left=0,top=0,
      width=320, height=defaultLoadMoreLabelHeight,
      layout='flex',
      dir=HBox, align=Center,
      clipsToBounds = true,
      items={
         loadMoreLabel,
      }
   }
end

function TableViewDataSource.prototype:_tryDoReuseLoadMoreContentView(tableview, cell, row, section)
   if self:_isLoadMoreLabel(tableview, section) then
      print("loadmore cell's section=", section)
      cell:removeAllChildren()
      local cellContent = self:_getLoadMoreViewContent()
      cell:addChild(cellContent)
      return true
   end
    
   return false
end
