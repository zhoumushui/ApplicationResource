ActionSheet = Class.Class("ActionSheet",
                     {
                        base=Node
})

function ActionSheet.prototype:init(title, cancel, desctruction, others, cb)
   Node.prototype.init(self, {})
   
   self._pv:setButtons(title, cancel, desctruction, others)

   if cb then
         self:addEventListener("click",
                              function(idx)
                                 cb(idx)
         end)
   end
end

--@override
function ActionSheet.prototype:createPlatFormView()
   return PlatformActionSheet(self)
end

function ActionSheet.prototype:showInView(v)
   self._pv:showInView(v)
end
