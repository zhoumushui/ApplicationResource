Scheduler = {}
Scheduler.setTimeout = function(op, time)
   local newitem = {op=op, time=time + }
   local item = Scheduler.firstItem
   local prevItem = item

   while item do
      if item.time < time then
         break
      end

      prevItem = item
      item = item.next
   end

   --insert before item
   newitem.next = item
   if prevItem then
      prevItem.next = newitem
   else
      Scheduler.firstItem = newitem
   end

   if Scheduler.timer == nil then
      Scheduler.timer = setTimeout(function()
                                   end,
                                   Scheduler.firstItem.time)
   end

   return newitem
end

Scheduler.timerFired = function()
   local time = Scheduler.firstItem.time
   local item = Scheduler.firstItem
   while item do
      
   end
end
