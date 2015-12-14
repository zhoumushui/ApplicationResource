require "stdlib/class/Class"

module("Store", package.seeall)

--print("-----------init store module----------")

--[[
   store.a.b.c.d=100
   store.a.b.d == nil
]]

Store = Class.Class(
   "Store",
   {      
      properties={
         store = {},
         context=Class.undefined
      }
})

function Store.prototype:init(initStore)
   --print("store init")
   if type(initStore) == "table" then
      self:setStore(initStore)
   end
end

function Store.prototype:get(keyPath)
   local store = self:getStore()

   local val = nil
   for key in string.gmatch(keyPath, "%w+") do
      val = store[key]
      if val == nil then
         return nil
      end

      store = val
   end

   return val
end

function Store.prototype:set(keyPath, val)
   local store = self:getStore()
   
   local lstKey = nil
   local lstStore = store
   for key in string.gmatch(keyPath, "%w+") do
      if store[key] == nil then
         store[key] = {}
      end

      lstStore = store
      store = store[key]
      lstKey = key
   end
   
   lstStore[lstKey] = val
end

function Store.prototype:__tostring()
   return string.escapeQuote("Store.Store(" .. table.tostring(self:getStore()) .. ")")
end

function Store.prototype:save()
--   print("store save")
--   print(tostring(self))
   local ctx = self:getContext()
   if ctx and ctx.save then
      ctx:save(tostring(self))
   end
end


--暂不支持非预定义的属性,支持缓存node排版结果
NodePropStore = Class.Class(
   "NodePropStore",
   {
      properties={
         store=Class.undefined,
         node = Class.undefined,
         doingLayoutRestore = false,
      }
   }
)

function NodePropStore.prototype:init(props)
end

function NodePropStore.prototype:setupOneNode(node, store)
   local storedProps = node:getProperty("store")

   if storedProps and node:getId() == nil then
      print("error:If you want store property, you must sepefic a id property to the node")
      return false
   end
   
   if store == nil or node == nil or storedProps == nil or node:getId() == nil then
      return false
   end
   
   local bNeedSave = false

   for i, key in ipairs(storedProps) do
      local id = node:getId()
      node:on(node:propChangedEvtName(key),
              self.onNodePropChange,
              self,
              id)

      local val = store:get(id .. "." .. key)
      if val ~= nil then
         node[NameMap[key][3]](node, val)
      else
         store:set(id .. "." .. key, node[NameMap[key][2]](node))
         bNeedSave = true
      end
   end

   return bNeedSave
end

function NodePropStore.prototype:setup()
   local dosetup = nil
   dosetup = function(node, store)
      local bNeedSave = self:setupOneNode(node, store)
      
      for i, child in ipairs(node:getChildren()) do
         if dosetup(child, store) then
            bNeedSave = true
         end
      end

      return bNeedSave
   end

   local n = self:getNode()
   local s = self:getStore()
   if n == nil or s == nil then
      print("Error, parameter error, cannot setup")
      return
   end

   n:on("layoutComplete",
        self.onNodeLayoutComplete,
        self)

   if dosetup(n,s) then
      s:save()
   end

   self:restoreLayout()
end

function NodePropStore.prototype:onNodePropChange(id, prop, old, new)
   local store = self:getStore()

   local keyPath = id .. "." .. prop, new
   if store:get(keyPath) == new then
      return
   end

   --print("on node prop changed:" .. tostring(prop) .. " new:" .. tostring(new) .. " old:" .. tostring(old) .. " userdata:" ..  tostring(userData))
   store:set(keyPath, new)
   store:save()
end

function NodePropStore.prototype:onNodeLayoutComplete()
   if self:getDoingLayoutRestore() then
      return
   end

   local store = self._store
   local node = self._node
   
   --[[
      有些消息体不需要restore，因为他的UI每次都是动态构建的，有restore反而造成开发上的负担。这里在root节点上增加 needsLayoutRestore == false
   --]]
   if self._node.needsLayoutRestore == false then
      return
   end
  
   local result = {}

   --print("save on layout complete")
   
   local saveRenderStyle = nil
   saveRenderStyle  = function(node, result, idxInfo)
      local renderObj = node:getRenderObject()
      local renderStyle = renderObj and renderObj:getRenderStyle() or RenderStyle()

      if renderStyle then
--[[
         table.insert(result, {w=renderStyle:getWidth(),
                               h=renderStyle:getHeight(),
                               t=renderStyle:getTop(),
                               l=renderStyle.left})
]]
         result["i" .. tostring(idxInfo.idx)] = {w=renderStyle.width,
                               h=renderStyle.height,
                               t=renderStyle.top,
                               l=renderStyle.left}
      else
         print("error, cannot save render style because cannot get renderstyle fron node")
         return false
      end

      for _, child in pairs(node:getChildren()) do
         idxInfo.idx = idxInfo.idx + 1
         if false == saveRenderStyle(child, result, idxInfo) then
            return false
         end
      end

      return true
   end

   if saveRenderStyle(node, result, {idx=0}) then
      store:set("renderStyles", result)
      store:save()
   end
end

function NodePropStore.prototype:restoreLayout()
   local store = self._store
   local node = self._node

   --print("restore layout")
   
   --[[
      有些消息体不需要restore，因为他的UI每次都是动态构建的，有restore反而造成开发上的负担。这里在root节点上增加 needsLayoutRestore == false
   --]]
   if self._node.needsLayoutRestore == false then
      self._node:layout()
   end
   
   local layoutInfos = store:get("renderStyles")

   local restoreLayoutInfo = nil
   restoreLayoutInfo = function(n, idxInfo, layoutInfos)
      local renderInfo = layoutInfos["i" .. tostring(idxInfo.idx)]
      if renderInfo == nil then
         return
      end

      --print("restore layout info item")

      local renderObject = n:getRenderObject()
      local renderStyle = RenderStyle()
      renderStyle.width = renderInfo.w
      renderStyle.height= renderInfo.h
      renderStyle.top = renderInfo.t
      renderStyle.left = renderInfo.l

      --print(tostring(renderStyle))
      renderObject:setRenderStyle(renderStyle)

      n:getPV():setFrame(renderInfo.l, renderInfo.t, renderInfo.w, renderInfo.h)

      for _, child in pairs(n:getChildren()) do
         idxInfo.idx = idxInfo.idx + 1
         restoreLayoutInfo(child, idxInfo, layoutInfos)
      end
   end

   if layoutInfos then
      self:setDoingLayoutRestore(true)
      restoreLayoutInfo(node, {idx=0}, layoutInfos)

      node:setNeedsLayout(false)
      node:getRenderObject():recursiveNotifyLayoutEvt("layoutComplete")
      
      self:setDoingLayoutRestore(false)
   else
      --print("donot has layout infos")
      if node:getRenderObject():getNeedsLayout() == true then
         --print("donot has layout info")
         --print("do layout")
         node:layout()
      else
         self:onNodeLayoutComplete() 
      end
   end
end
