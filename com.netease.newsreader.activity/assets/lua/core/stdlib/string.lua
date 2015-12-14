function string.ispercentstring(s)
   print(debug.traceback())
   return string.match(s, "%d-%.?%d-%%") == s
end

__percentTable = {}

function string.getpercentfromstring(s)
--   return tonumber(string.match(s, "%d-%.?%d*")) / 100.0
   local v = __percentTable[s]
   if v ~= nil then
      return v
   else
      v = tonumber(string.sub(s, 0, string.len(s)-1))/100.0
      __percentTable[s] = v
      return v
   end
end


function string.trim(str)
   return str:match "^%s*(.-)%s*$"
end
function string.upperFirstChar(str)
   if type(str) == "number" then
      print(debug.traceback())
   end
   return str:gsub("^%l", string.upper)
end

function string.getterName(propName)
   return "get" .. string.upperFirstChar(propName)
end

function string.setterName(propName)
   return "set" .. string.upperFirstChar(propName)
end

function string.applyName(propName)
   return "apply" .. string.upperFirstChar(propName)
end

function string.propChangeEvtName(propName)
   return "on" .. string.upperFirstChar(propName) .. "Changed"
end

function string.escapeQuote(str)
  return str:gsub('\\', '\\\\'):gsub('"', '\\"')
end

function string.starts(str,Start)
   return string.sub(str,1,string.len(Start))==Start
end
