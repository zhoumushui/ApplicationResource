module("DiscoveryViewController", package.seeall)

require("Globals")
local ActivityIndicator = require "news/ActivityIndicator"
local PlaceHolderLoadingView = require "news/PlaceHolderLoadingView"

require "controller.YXViewController"

local version = require("colortouch/version")
require("colortouch/dialog/AlertView")

local YXViewController = YXViewController.YXViewController

local DiscoveryDataSource = require("DiscoveryDataSource")

DiscoveryViewController = Class.Class("DiscoveryViewController",
                                    {
                                       base=YXViewController,
                                       properties={
                                          bShowBackBtn = false,
                                          bStartFromScreenTop = true,
                                          title="发现",
                                          
                                          loadingIndicator = Class.undefined,
                                          refreshTimer = Class.undefined,
                                          data = Class.undefined,

                                          tableview = Class.undefined,
                                       }
})

function DiscoveryViewController.prototype:init(inlineprops, ...)
   YXViewController.prototype.init(self, inlineprops, ...)

   self:doInit()
   
   self:getView():setBackgroundColor(Globals.getBackgroundColor())

   self:requestData()
end

function DiscoveryViewController.prototype:testCustomNavigationView()
   local btn = Button{
      width=100,height=44,left=20,top=10,
      text="testbtn",
      color=rgba{255,255,255,1},
      borderWidth=1,borderColor=Globals.getBackgroundColor(),
   }

   btn:addEventListener("click",
                        function()
                           AlertView("btn clicked", "", {"确认"}):show()
   end)

   self:setNavigationBarRightView(btn)
end

function DiscoveryViewController.prototype:doInit()
   self:addViews()
   self:addReloadDataWhenTimeExpireEvent()
   
   self:addPlaceHolderLoadingView()
end

function DiscoveryViewController.prototype:addViews()
   local tableView = TableView{
      width="100%",
      top = Globals.getViewControllerPlatformTabberTop(),
      height=getApplication():getScreenHeightUnit()- Globals.getViewControllerPlatformTabbarHeight(), 
      pullRefreshDirection =  RefreshingDirectionNone,
      dataSource = DiscoveryDataSource({vc=self}),
      alwaysBounceVertical = true,
      backgroundColor=Globals.getBackgroundColor(),
   }
   if platform.isIOS() then
      local inset = IOS.UIEdgeInsetsMake(0, 0, NTES.tabbarHeight-1, 0)
      tableView:setContentinset(inset)
      inset = IOS.UIEdgeInsetsMake(0, 0, NTES.tabbarHeight+1, 0)
      tableView:setScrollIndicatorInsets(inset)
      tableView:addEventListener("refresh",function ()   
         tableView:getDataSource():onDataChanged("data")
      end)
   else
      local netsService = getApplication():getServiceMgr():createNTESService()
      if netsService and netsService.share then
         tableView:setIsRefreshable(true)
         tableView:setPullRefreshDirection(RefreshingDirectionTop)
         tableView:addEventListener("refresh",function ()   
          self._refreshTimer =   setTimeout(function ()

            tableView:finishRefreshingDirection(RefreshingDirectionTop)
          end, 1)
         tableView:getDataSource():onDataChanged("data")
        end)
      end
   end

   tableView._dataSource.vc = self
   self._tableview = tableView

   self:getView():addChild(tableView)
end

--支持每20分钟更新一次数据。
function DiscoveryViewController.prototype:addReloadDataWhenTimeExpireEvent()
   local lastReloadTimeKey = "lastReloadTime"
   local reloadTime = 60 * 20 --20分钟
   self:addEventListener("willResume",
                         function()
                            local localStorage = getApplication():getLocalStorage()
                            local time =  localStorage:getItem(lastReloadTimeKey)
                            if time == nil then
                               localStorage:setItem(lastReloadTimeKey, os.time())
                            else
                               if os.time() - time > reloadTime then
                                  self:reloadData()
                                  localStorage:setItem(lastReloadTimeKey, os.time())
                               end
                            end
   end)
end

function DiscoveryViewController.prototype:addLodingIndicator()
   local indicator = nil
   self:addEventListener("willResume",
                         function()
                            if indicator == nil  then
                               indicator = ActivityIndicator()
                               indicator:setLeft(100):setTop(100):setWidth(20):setHeight(20):setBackgroundColor(rgba{0,0,0,0.7})
                               self:getView():addChild(indicator)
                               indicator:startAnimation()
                               
                            end
   end)
end


function DiscoveryViewController.prototype:changeTheme(themeName)
  if self._tableview then
   self._tableview:setBackgroundColor(Globals.getBackgroundColor())
   self._tableview:setDataSource( DiscoveryDataSource({vc=self}))
   if self._data then
    self._tableview:getDataSource():setData(self._data)
   end

   if self._loadingIndicator then
    self._loadingIndicator:setNightMode(getApplication():isNightMode())
   end

  end
end

function DiscoveryViewController.prototype:addPlaceHolderLoadingView()
   local indicator = nil
   local showLoading = function()
      if indicator == nil  then
         indicator = PlaceHolderLoadingView()
         indicator:setLeft(0):setTop(0):setWidth(Globals.cellWidth):setHeight(getApplication():getScreenHeightUnit()- Globals.getViewControllerPlatformTabbarHeight()):setBackgroundColor(Globals.getBackgroundColor())
         self:getView():addChild(indicator)
         indicator:setState(0)
         indicator:setText("点击屏幕 重新加载")
         indicator:addEventListener("reload",
                                    function()
                                       indicator:setState(0)
                                       self:reloadData()
         end)

         if not platform.isIOS() then
            indicator:setNightMode(getApplication():isNightMode())
         end

         self._loadingIndicator = indicator
      end
   end

   if platform.isIOS() then
      self:addEventListener("willResume", showLoading)
   else
      showLoading()
   end
   
end

function DiscoveryViewController.prototype:requestData()
   local app = getApplication()
   local http = app:getHttpComponent()

   if not platform.isIOS() then
      self:requestLocalData(app.url,query)
   end

   http:sendHTTPRequest(app.url,
                        "GET",
                        nil,
                        nil,
                        false,
                        10,
                        function(response, error)
                           if error then
                              self:requestError(error)
                           else
                              local tbresponse = cjson.decode(response)
                              self:requestSuccess(tbresponse)
                              if not platform.isIOS() then
                                 self:storeLocalData(tbresponse,app.url,nil)
                              end
                           end
                        end,
                        0)  
end

function DiscoveryViewController.prototype:storeLocalData(response,url,query)
   local localStorage = getApplication():getLocalStorage()

   local version = getApplication():getVersion()
   local localdata = {}
   localdata.url  = url
   localdata.query = query
   localdata.response   = response
   localdata.version = version
   localStorage:setItem(Globals.responeStorageKey,localdata)
end

function DiscoveryViewController.prototype:requestLocalData(url,query)
   local localStorage = getApplication():getLocalStorage()
   local locatedata  =  localStorage:getItem(Globals.responeStorageKey)
   local version = getApplication():getVersion()

   if locatedata  then
      if locatedata.url==url and locatedata.query == query and locatedata.version == version then
         local localresponse = locatedata.response
         self:requestSuccess(localresponse)
      end
   end
end

function DiscoveryViewController.prototype:reloadData()
   self:requestData()
end

function DiscoveryViewController.prototype:requestError(error)
   if self._data then
      return
   end
   self._loadingIndicator:setState(2)
end

function DiscoveryViewController.prototype:requestSuccess(response)
   self._dataIsReady = true
   if response == nil and self._data== response then
    return
   end

  local id = getApplication():getChannelId()
  if id == "vivo_store2014_news" then
    local temp = {}
    for k,v in pairs(response["stream"]) do
      if v.name == "游戏中心" then
        table.insert(temp, k)
      end
    end

    table.sort(temp,function(d,e)
        return d>e
      end)

    for k,v in pairs(temp) do
      table.remove(response["stream"], v)
    end
  end
   
   self._data =response
   
   self._tableview:getDataSource():setData(self._data)

   if self._loadingIndicator and self._loadingIndicator:getParent() then
      self._loadingIndicator:removeFromParent()
   end

   self:updateContentsDate()

   getApplication():checkRemind()
end

--remind
function DiscoveryViewController.prototype:updateContentsDate()
   local remindMgr = require("RemindMgr")
   local app = getApplication()
   local needFlush = false
   if self._data and self._data.normal then
      for idx, item in ipairs(self._data.normal) do
         if self._data.normal.time then
            remindMgr:updateCategoryContentTime(idx, os.time(), false)
            needFlush = true
         end
      end
      
      if needFlush then
         remindMgr:flush()
      end
   end
end

return DiscoveryViewController
