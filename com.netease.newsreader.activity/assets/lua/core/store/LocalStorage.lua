require "stdlib/class/Class"

module("LocalStorage", package.seeall)

local function loadLuaFile(name)
   local ftables,err = loadfile( name )
   if err then print(tostring(err)); return nil,err end
   local tables = ftables()
   if err then
      print("err:" .. tostring(err))
   end

   if tables == nil then
      return nil, {error=true}
   end


 --  print("load lua data:" .. table.tostring(tables))

   for idx = 1,#tables do
      local tolinki = {}
      for i,v in pairs( tables[idx] ) do
         if type( v ) == "table" then
            tables[idx][i] = tables[v[1]]
         end
         if type( i ) == "table" and tables[i[1]] then
            table.insert( tolinki,{ i,tables[i[1]] } )
         end
      end
      -- link indices
      for _,v in ipairs( tolinki ) do
         tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
      end
   end
   return tables[1]
end

local function exportstring( s )
   return string.format("%q", s)
end

local function saveTableToFile(tbl, filename)
   local charS,charE = "   ","\n"
   local file,err = io.open( filename, "wb" )
   if err then return err end

   -- initiate variables for save procedure
   local tables,lookup = { tbl },{ [tbl] = 1 }
   file:write( "return {"..charE )

   for idx,t in ipairs( tables ) do
      file:write( "-- Table: {"..idx.."}"..charE )
      file:write( "{"..charE )
      local thandled = {}

      for i,v in ipairs( t ) do
         thandled[i] = true
         local stype = type( v )
         -- only handle value
         if stype == "table" then
            if not lookup[v] then
               table.insert( tables, v )
               lookup[v] = #tables
            end
            file:write( charS.."{"..lookup[v].."},"..charE )
         elseif stype == "string" then
            file:write(  charS..exportstring( v )..","..charE )
         elseif stype == "number" then
            file:write(  charS..tostring( v )..","..charE )
         end
      end

      for i,v in pairs( t ) do
         -- escape handled values
         if (not thandled[i]) then
            
            local str = ""
            local stype = type( i )
            -- handle index
            if stype == "table" then
               if not lookup[i] then
                  table.insert( tables,i )
                  lookup[i] = #tables
               end
               str = charS.."[{"..lookup[i].."}]="
            elseif stype == "string" then
               str = charS.."["..exportstring( i ).."]="
            elseif stype == "number" then
               str = charS.."["..tostring( i ).."]="
            end
            
            if str ~= "" then
               stype = type( v )
               -- handle value
               if stype == "table" then
                  if not lookup[v] then
                     table.insert( tables,v )
                     lookup[v] = #tables
                  end
                  file:write( str.."{"..lookup[v].."},"..charE )
               elseif stype == "string" then
                  file:write( str..exportstring( v )..","..charE )
               elseif stype == "number" then
                  file:write( str..tostring( v )..","..charE )
               end
            end
         end
      end
      file:write( "},"..charE )
   end
   file:write( "}" )
   file:close()   
end

--[[
   LocalStorage 禁止针对单个app创建多个LocalStorage：这样做会导致数据不一致。
   这件事情由App管理者去负责。
]]
LocalStorage = Class.Class(
   "LocalStorage",
   {      
      properties={
         appName=Class.undefined,
         appRootDataPath=Class.undefined,
         data=Class.undefined,
      }
})

function LocalStorage.prototype:init(appName)
   local rootAppDir = getRootAppDir(appName)
   local rootAppDataFilePath = rootAppDir .. "applocalstorage.txt"
   
 --  print("=========load lua file==========")
   local data, err = loadLuaFile(rootAppDataFilePath)
   if err or data == nil then
      data = {}
   end

   self:setData(data)
   self:setAppName(appName)
   self:setAppRootDataPath(rootAppDataFilePath)
end

function LocalStorage.prototype:setItem(key, val, notFlush)
   local store = self:getData()
   
   local lstKey = nil
   local lstStore = store
   for key in string.gmatch(key, "%w+") do
      if store[key] == nil then
         store[key] = {}
      end
      
      lstStore = store
      store = store[key]
      lstKey = key
   end
   
   lstStore[lstKey] = val

   if not notFlush  then
      -- print("save data to file")
      -- print(table.tostring(self._data))
      saveTableToFile(self:getData(), self._appRootDataPath)
   end
end

function LocalStorage.prototype:getItem(key)
   local store = self:getData()
   if store == nil then
      return nil
   end

--   print("get Item:" .. table.tostring(store))

   local val = nil
   local paths = string.gmatch(key, "%w+")
   for key in paths do
      val = store[key]
      if val == nil then
         return nil
      end

      store = val
   end

   return val
end

function LocalStorage.prototype:flush()
   saveTableToFile(self._data, self._appRootDataPath)
end
