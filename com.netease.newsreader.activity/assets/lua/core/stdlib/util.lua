function deepcopyTable(t)
   if type(t) ~= 'table' then return t end
   local mt = getmetatable(t)
   local res = {}
   for k,v in pairs(t) do
      if type(v) == 'table' then
         v = deepcopyTable(v)
      end
      res[k] = v
   end
   setmetatable(res,mt)
   return res
end

function printTable(t)
   local print = print
   local tconcat = table.concat
   local tinsert = table.insert
   local srep = string.rep
   local type = type
   local pairs = pairs
   local tostring = tostring
   local next = next
   
   function print_r(root)
      local cache = {  [root] = "." }
      local function _dump(t,space,name)
         local temp = {}
         for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
               tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
               local new_key = name .. "." .. key
               cache[v] = new_key
               tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
            else
               tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
         end
         return tconcat(temp,"\n"..space)
      end
      print(_dump(root, "",""))
   end

   print_r(t)
end

