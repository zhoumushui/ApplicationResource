require "stdlib/class/Class"

--[[
   DatePicker{
     startTime:"19800123",
     endTime:"20131012",
     curTime:"20121001"
   }
]]

DatePicker = Class.Class("DatePicker",
                         {
                            base = Node,
                            properties = {
                               startTime=os.date('%Y%m%dT%H:%M:%S'),
                               endTime=os.date('%Y%m%dT%H:%M:%S'),
                               curTime=os.date('%Y%m%dT%H:%M:%S'),
                               
                               --[[dateandtime, date, time]]
                               mode="dateandtime",
                            }
});

--@override
function DatePicker.prototype:createPlatFormView()
   return PlatformDatePicker(self)
end


function DatePicker.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)
--[[
   local startTime,endTime = nil,nil
   if self._mode == "dateandtime" then
      startTime = os.date('%Y%m%d')
      endTime = os.date('%Y%m%d')
   else if self._mode == "date" then
      startTime = os.date('%Y0101')
      endTime = os.date('%Y1230')
   else
      startTime = os.date('%Y%m%d')
      endTime = os.date('%Y%m%d')
   end
]]

   self:onStartTimeChanged("startTime", nil, self._startTime)
   self:onEndTimeChanged("endTime", nil, self._endTime)
   self:onCurTimeChanged("curTime", nil, self._curTime)
end

function DatePicker.prototype:onStartTimeChanged(prop, old, new)
   self._pv:setStartTime(new)
end

function DatePicker.prototype:onEndTimeChanged(prop, old, new)
   self._pv:setEndTime(new)
end

function DatePicker.prototype:onCurTimeChanged(prop, old, new)
   self._pv:setCurTime(new)
end

function DatePicker.prototype:onModeChanged(prop, old, new)
   self._pv:setMode(new)
end

function DatePicker.prototype:getCurTime()
   return self._pv:getCurTime()
end
