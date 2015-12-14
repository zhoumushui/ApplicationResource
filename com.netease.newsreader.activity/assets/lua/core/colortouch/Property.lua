require "stdlib/class/Class"

module("Property", package.seeall)

local getRootByNode = function(n)
   log("%s", n)
   local parent = n
   while parent and parent:getParent() do
      parent = parent:getParent()
   end

   return parent
end

--property("id", propName)
local getPropertyVal = function(root, property)
   local rightNode = root:query(property:getId())
   if rightNode == nil then
      log("Error:property id is error, cannot find node %s", tostring(property))
      return
   end

   local val = rightNode:getProperty(property:getPropName())
   
   return val
end

local processProperty = function(n, leftPropName, property)
   local root = getRootByNode(n)
   if root == nil then
      log("Error: process property failed\n")
      return
   end

   local val = getPropertyVal(root, property)
   print("set Proeprty val:1")
   n:setProperty(leftPropName, val)
end

--[[
        events={
           click={
             request = {
                url="http://...",
                type="webview",
   
                params={
                   field1="...",
                   field2=property("id1", val)
                }
               --webview返回的数据可以是json，然后这里描述返回的json和input之间的数据传递
                response = {
                  input2="param1",
                  input1="param2"
                }

             }
           }
        }
]]

local getParams = function(node, context, params)
   if params == nil or type(params) ~= "table" then
      return nil
   end

   local paramsTable = table.map(params,
                                 function(val, k)
                                    print("get params:" .. k)
                                    if type(val) == "table" and val.isKindOf and val:isKindOf(Property) then
                                       print("---------get request header by node property")
                                       local val = getPropertyVal(getRootByNode(node), val)
                                       return val
                                    elseif type(val) == "number" then
                                       return val
                                    else
                                       return tostring(val)
                                    end
                                       
   end)

   return paramsTable
end

local processResponse = function(node, context, responseConfig, responseStr)
   if responseConfig == nil or responseStr == nil or type(responseStr) ~= "string" then
      return
   end

   local response = cjson.decode(responseStr)
   if response == nil or type(response) ~= "table" then
      print("Error:response error, cannot convert to json object")
      return
   end

   local root = getRootByNode(node)
   if root == nil then
      return
   end

   for k, v in pairs(responseConfig) do
      local n = root:query(k)
      if n and type(v) == "string" and response[v] ~= nil then
         if n.setText then
            print("do response id:" .. k .. " val:" .. tostring(response[v]))
            n:setText(tostring(response[v]))
         end
      end
   end
end


Property = Class.Class(
   "Property",
   {
      properties={
         id=Class.undefined,
         propName = Class.undefined
      }
})

function Property.prototype:init(id, propName)
   if id == nil or propName == nil or 
      type(id) ~= "string" or type(propName) ~= "string" then
      log("Property parameter is error")
   end

   self:setId(id)
   self:setPropName(propName)
end


function Property.prototype:__tostring()
   return "Property(" .. self:address() .. "):{\n   " .. "id:" .. tostring(self:getId()) .. ",\n   propName:" .. tostring(self:getPropName() .. "\n}\n")
end
