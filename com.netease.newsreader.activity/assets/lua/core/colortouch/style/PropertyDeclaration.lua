require "stdlib/table"
module("PropertyDeclaration", package.seeall)

extends = function(d1, d2)
   local newone = table.shallowcopy(d1)
   for key, val in pairs(d2) do
      newone[key] = val
   end

   return newone
end

filter = function(d, filter)
   return table.filter(d, filter)
end

--widgetName -- widgetUI -- properties
styles = {}

registeUI = function(widgetName, ui, d)
   local widgetUIs = styles[widgetName]
   if widgetUIs == nil then
      widgetUIs = {}
      styles[widgetName] = widgetUIs
   end

   widgetUIs[ui] = d
end

getPropertyDeclaration = function(widgetName, ui)
   local uis = styles[widgetName]
   if nil ~= uis then
      return uis[ui]
   end

   return nil
end
