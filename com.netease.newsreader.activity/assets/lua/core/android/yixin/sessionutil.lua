function setRtLabelContext(root, context)
   if root:isKindOf(HTMLLabel) then
      root._pv["handler"]:setDelegate(context)
   end

   for _, child in ipairs(root:getChildren()) do
      setRtLabelContext(child, context)
   end
end

function observeLayoutComplete(root, context)
   root:on("layoutComplete", 
            function()
               context:updateCellHeight()
            end)
end