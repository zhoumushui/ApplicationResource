tableViewDataSourceDelegate = {
   ------------------------------------------
   --以下函数，需要被重写，以提供多tableview的定制
   --注意避免dataSource调用同名的函数，可能造成循环调用
   ------------------------------------------
   numberOfRowsInSection = function(dataSource, tableview, section)
      if dataSource._data then
         return #(dataSource._data)
      else
         return 0
      end
   end,

   getReuseIdentifier = function(dataSource, tableview, row, section)
      return nil
   end,

   doNewContentView = function(dataSource, tableview, row, section)
      return Node{}
   end,

   numberOfSectionsInTableView = function(dataSource, tableview)
      return 1
   end,

   heightForRow = function(dataSource, tableview, row, section)
      return 40
   end,

   --[[
   -- 不再提供，colortouch内部设置
   reuseTypeCount = function(dataSource)
      return 100
   end,
   ]]

   refresh = function(dataSource, tableview)
      print("TableViewDataSource refresh")
   end,

   loadMore = function(dataSource, tableview)
      print("TableViewDataSource loadMore")
   end,

   shouldShowLoadMore = function(dataSource)
      return false
   end,
}