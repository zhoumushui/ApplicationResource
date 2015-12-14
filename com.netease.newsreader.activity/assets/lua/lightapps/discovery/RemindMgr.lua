module("RemindMgr", package.seeall)

local dataKey = "remindContents"

local contentDateKey = "content"
local contentReadDateKey = "read"
--[[
   每个红点的位置都是一个content，需要持久化用户最近一次点击content的时间。
]]
local localStorage = getApplication():getLocalStorage()

RemindMgr = Class.Class("RemindMgr",
                        {
                           properties={
                           }
})

function RemindMgr.prototype:getContentData(contentKey)
   local data = localStorage:getItem(dataKey)
   if data == nil then
      data = {}
      localStorage:setItem(dataKey, data)
   end

   if data[contentKey] == nil then
      data[contentKey] = {}
      data[contentKey][contentDateKey] = 0
      data[contentKey][contentReadDateKey] = 0
   end

   return data[contentKey]
end

function RemindMgr.prototype:updateContentDate(contentKey, date, flush)
   local data = self:getContentData(contentKey)
  
   if data[contentDateKey] == date then
      return
   end

   data[contentDateKey] = date

   if flush == true then
      localStorage:flush()
   end
end

function RemindMgr.prototype:updateContentReadDate(contentKey, flush)
   local data = self:getContentData(contentKey)
   local date = os.time()

   print("update content Read date:", contentKey)

   if data[contentReadDateKey] == date then
      return
   end

   data[contentReadDateKey] = date

   if flush == true then
      localStorage:flush()
   end

end

function RemindMgr.prototype:isNeedRemindContent(contentKey)
   local data = self:getContentData(contentKey)

   if data and data[contentDateKey] > data[contentReadDateKey] then
      return true
   else
      return false
   end
end

function RemindMgr.prototype:hasNeedRemindContent()
   local data = localStorage:getItem(dataKey)
   if data == nil then
      return false
   end

   for contentKey, contentData in pairs(data) do
      if contentData[contentDateKey] > contentData[contentReadDateKey] then
         return true
      end
   end

   return false
end

function RemindMgr.prototype:flush()
   localStorage:flush()
end

---category remind
function RemindMgr.prototype:getCategoryContentKey(idx)
   return "category_" .. idx
end

function RemindMgr.prototype:updateCategoryReadTime(idx, flush)
   self:updateContentReadDate(self:getCategoryContentKey(idx), flush)
end

function RemindMgr.prototype:updateCategoryContentTime(idx, time, flush)
   return self:updateContentDate(self:getCategoryContentKey(idx), time, flush)
end

function RemindMgr.prototype:isCategoryNeedRemind(idx)
   return self:isNeedRemindContent(self:getCategoryContentKey(idx))
end

return RemindMgr()
