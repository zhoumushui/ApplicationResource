require "stdlib/class/Class"

DateInput = Class.Class("DateInput",
                     {
                        base=Container,
                        properties={
                           defaultValue=os.date('%Y%m%dT%H:%M:%S'),
                           color=Class.undefined,
                           fontSize=15,
                           indent = {x=10,y=0},
                           startTime=Class.undefined,
                           endTime=Class.undefined,
                           curTime=Class.undefined,
                           mode = Class.undefined,

                           --从日期控件获取了时间值之后19890201T12:33,如何显示出来，由这个adaptor来决定
                           valueLabelAdaptor = Class.undefined,

                           --private
                           valueLabel = Class.undefined,
                           datePickerContainer = Class.undefined,
                           pickerDialog = Class.undefined,
                        }
})

function DateInput.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:addChild(self:getValueLabel())
   
   print("date input init")

   if self._defaultValue ~= nil then
      self:getValueLabel():setText(self._defaultValue)
   end

   if self._color ~= nil then
      self:onColorChanged("color", nil, self._color)
   end
   if self._fontSize ~= nil then
      self:onFontSizeChanged("fontSize", nil, self._fontSize)
   end
   if self._indent ~= nil then
      self:onIndentChanged("indent", nil, self._indent)
   end

   print("date input init")
   if self._startTime ~= nil then
      self:onStartTimeChanged("startTime", nil, self._startTime)
   end
   if self._endTime ~= nil then
      self:onEndTimeChanged("endTime", nil, self._endTime)
   end
   if self._curTime ~= nil then
      self:onCurTimeChanged("curTime", nil, self._curTime)
   end
   if self._mode ~= nil then
      self:onModeChanged("mode", nil, self._mode)
   end
   
   print("date input init")

   self:initEvents()
end

function DateInput.prototype:getPickerDialog()
   if self._pickerDialog then
      return self._pickerDialog
   end

   self._pickerDialog = ModalDialog{
      layout="flex",
      dir=VBox,
      pack=End,

      bgAlpha = 0,

      items={
         self:getDatePickerContainer()
      }
   }

   self._pickerDialog:addEventListener("startshow",
                                       function()
                                          local pickerContainer = self:getDatePickerContainer()
                                          local dialogSize = self._pickerDialog:getPreferredSize({width=0,height=0})
                                          local hiddenSize = {x=0,y=dialogSize.height}
                                          
                                          self._pickerDialog:layout()

                                          if self._startTime ~= nil then
                                             self:getDatePicker():setStartTime(self._startTime)
                                          end
                                          if self._endTime ~= nil then
                                             self:getDatePicker():setEndTime(self._endTime)
                                          end
                                          if self._curTime ~= nil then
                                             self:getDatePicker():setCurTime(self._curTime)
                                          end
                                          local y = pickerContainer._renderObject._renderStyle.top
					  if platform.isIOS() then
                                          pickerContainer._pv:moveToByAni(hiddenSize, {x=0,y=y}, 0.25, 'linear', function() end);
   					 end
   end)

   self._pickerDialog:addEventListener("startdismiss",
                                       function()
                                          local pickerContainer = self:getDatePickerContainer()
                                          local dialogSize = self._pickerDialog:getPreferredSize({width=0,height=0})
                                          local hiddenSize = {x=0,y=dialogSize.height}
                                          local y = pickerContainer._renderObject._renderStyle.top
                                        if platform.isIOS() then
				          pickerContainer._pv:moveToByAni({x=0,y=y}, hiddenSize, 0.25, 'linear', function() end)
					end
   end)

   return self._pickerDialog
end

function DateInput.prototype:updateDatePicker()
   local picker = self:getDatePickerContainer()
   local datePicker = picker:query("_datepicker")

   self:getPickerDialog():show()
   if self._curTime ~= nil then
      datePicker:setCurTime(self._curTime)
   end
end

function DateInput.prototype:initEvents()
   local evtName = "touchesEnded"
   if platform.isIOS() then
      evtName = "tap"
   end

   self:addEventListener(evtName,
                         function()
                            print("input clicked")
                            self:updateDatePicker()
   end)



   
end

function DateInput.prototype:getDatePickerContainer()
   if self._datePickerContainer then
      return self._datePickerContainer
   end

   --create datepicker
   local datePicker = DatePicker{
      id="_datepicker",
      width="100%",
      height=162,

      backgroundColor=rgba{255,255,255,1},
      -- borderColor=rgba{255,0,0,1},
      -- borderWidth=1,
   }
   if self._startTime ~= nil then
      datePicker:setStartTime(self._startTime)
   end
   if self._endTime ~= nil then
      
   end
   if self._curTime ~= nil then
      
   end

   local confirmBtn = Button{
      id='_confirmBtn',
      text="确定",
      width="100%",
      height=30,

      
      backgroundColor=rgba{255,255,255,1},

      states={
         normal={
            color=rgba{0,0,0,1},
         },
         
         hilighted={
            color=rgba{150,150,150,1},
         }
      }
   }
   
   local dateContainer = Container{
      width='100%',
      layout='flex',
      dir=VBox,

      -- borderColor=rgba{255,0,0,1},
      -- borderWidth=1,
      
      items={
         confirmBtn,
         datePicker
      }
   }

   local valueLabel = self:getValueLabel()
   
   confirmBtn:addEventListener("click",
                               function()
                                  self:getPickerDialog():dismiss()
                                  local time = datePicker:getCurTime()
                                  
                                  print("date picker cur time:" .. tostring(time))

	if platform.isIOS() then
                                  local labelText = time
                                  if self._valueLabelAdaptor ~= nil then
                                     labelText = self._valueLabelAdaptor(time)
                                  end
                                  --[[
                                  local y,m,d,h,min,s = string.match(time, "(%d%d%d%d)(%d%d)(%d%d)T(%d%d):(%d%d):(%d%d)")
                                 print("text:" .. h .. ":" .. min)
                                  valueLabel:setText(h .. ":" .. min)
                                  ]]
                                  valueLabel:setText(labelText)
				  else
				        local y,m,d,h,min,s = string.match(time, "(%d%d%d%d)(%d%d)(%d%d)T(%d%d):(%d%d):(%d%d)")
                                 print("text:" .. h .. ":" .. min)
                                  valueLabel:setText(h .. ":" .. min)
                                  
				  end
                                 

   end)

   self._datePickerContainer = dateContainer

   return self._datePickerContainer
end

function DateInput.prototype:getDatePicker()
   local c = self:getDatePickerContainer()
   return c:query("_datepicker")
end

function DateInput.prototype:getValueLabel()
   if self._valueLabel then
      return self._valueLabel
   end

   local l = Label{
      id="_valuelabel",

      left=0,
      top=0,
      width='100%',
      height='100%',

      -- borderColor=rgba{255,0,0,1},
      -- borderWidth=0,

      text="",

      -- borderWidth=1,
      -- borderColor=rgba{255,255,0,1},
   }

   self._valueLabel = l
   return l
end

function DateInput.prototype:onColorChanged(prop, old, new)
   self:getValueLabel():setColor(new)
end

function DateInput.prototype:onFontSizeChanged(prop, old, new)
   self:getValueLabel():setFontSize(new)
end

function DateInput.prototype:onIndentChanged(prop, old, new)
   self:getValueLabel():setLeft(new.x)
   self:getValueLabel():setTop(new.y)
end

function DateInput.prototype:onStartTimeChanged(prop, old, new)
   self:getDatePicker():setStartTime(new)
end

function DateInput.prototype:onEndTimeChanged(prop, old, new)
   self:getDatePicker():setEndTime(new)
end

function DateInput.prototype:onCurTimeChanged(prop, old, new)
   self:getDatePicker():setCurTime(new)
end

function DateInput.prototype:onModeChanged(prop, old, new)
   self:getDatePicker():setMode(new)
end
