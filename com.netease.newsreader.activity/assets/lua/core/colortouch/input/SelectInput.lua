require "stdlib/class/Class"

SelectInput = Class.Class("SelectInput",
                     {
                        base=Container,
                        properties={
                           defaultValue=Class.undefined,
                           color=Class.undefined,
                           fontSize=15,
                           indent = {x=10,y=0},
                           data = Class.undefined,
                           --private
                           valueLabel = Class.undefined,
                           pickerContainer = Class.undefined,
                           pickerDialog = Class.undefined,
                        }
})

function SelectInput.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:addChild(self:getValueLabel())

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
   
   self:initEvents()
end

function SelectInput.prototype:getPickerDialog()
   if self._pickerDialog then
      return self._pickerDialog
   end

   self._pickerDialog = ModalDialog{
      layout="flex",
      dir=VBox,
      pack=End,

      bgAlpha = 0,

      items={
         self:getPickerContainer()
      }
   }

   self._pickerDialog:addEventListener("startshow",
                                       function()
                                          if platform.isIOS() then
                                             local pickerContainer = self:getPickerContainer()
                                             local dialogSize = self._pickerDialog:getPreferredSize({width=0,height=0})
                                             local hiddenSize = {x=0,y=dialogSize.height}
                                          
                                             self:getPicker():setData(self._data)

                                             self._pickerDialog:layout()

                                             local y = pickerContainer._renderObject._renderStyle.top
                                             pickerContainer._pv:moveToByAni(hiddenSize, {x=0,y=y}, 0.25, 'linear', function() end);
                                          else
                                             self:getPicker():setData(self._data)
                                          end
   end)

   self._pickerDialog:addEventListener("startdismiss",
                                       function()
				                              if platform.isIOS() then
                                             local pickerContainer = self:getPickerContainer()
                                             local dialogSize = self._pickerDialog:getPreferredSize({width=0,height=0})
                                             local hiddenSize = {x=0,y=dialogSize.height}
                                             local y = pickerContainer._renderObject._renderStyle.top
                                              pickerContainer._pv:moveToByAni({x=0,y=y}, hiddenSize, 0.25, 'linear', function() end)
  				                              end
   end)

   return self._pickerDialog
end

function SelectInput.prototype:updatePicker()
   local picker = self:getPickerContainer()
   local picker = picker:query("_picker")
   --print("updatePicker set data ....")
     --  picker:setData(self._data)

   self:getPickerDialog():show()
end

function SelectInput.prototype:initEvents()
   local evtName = "touchesEnded"
   if platform.isIOS() then
      evtName = "tap"
   end
   self:addEventListener(evtName,
                         function()
                            self:updatePicker()
   end)   
end

function SelectInput.prototype:getPickerContainer()
   if self._pickerContainer then
      return self._pickerContainer
   end

   --create picker
   local picker = PickerView{
      id="_picker",
      width="100%",

      backgroundColor=rgba{255,255,255,1},
      --borderColor=rgba{255,0,0,1},
      --borderWidth=1,

      data = self._data
   }

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
   local pickerContainer=nil 
    if platform.isIOS() then
         pickerContainer = Container{
         width='100%',
         layout='flex',
         dir=VBox,      
         items={
            confirmBtn,
            picker
         }
      }
   else
      pickerContainer = Container{
         width='100%',
         layout='flex',
         dir=VBox,

         -- borderColor=rgba{255,0,0,1},
         -- borderWidth=1,
         
         items={
       --     confirmBtn,
            picker
         }
      }
   end
   

   local valueLabel = self:getValueLabel()
   
   if platform.isIOS() then
      confirmBtn:addEventListener("click",
                                 function()
                                    self:getPickerDialog():dismiss()
                                    local idx = picker:selectedRowInComponent(0)

                                    valueLabel:setText(self._data[1][idx+1])
                                    if self['__onselected'] ~=nil  then
                                       self['__onselected'](self,idx)
                                    end

      end)
   else
      picker:addEventListener("itemclick",
		 function()
                       self:getPickerDialog():dismiss()
                       local idx = picker:selectedRowInComponent(0)
                       print(table.tostring(self._data))
						        valueLabel:setText(self._data[1][idx+1])
                       if self['__onselected'] ~=nil  then
                           self['__onselected'](self,idx)
                       end
            end)
   end
   self._pickerContainer = pickerContainer
   self._pickerContainer._picker = picker

   return self._pickerContainer
end

function SelectInput.prototype:getPicker()
   local c = self:getPickerContainer()
   return c:query("_picker")
end

function SelectInput.prototype:getValueLabel()
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

function SelectInput.prototype:onColorChanged(prop, old, new)
   self:getValueLabel():setColor(new)
end

function SelectInput.prototype:onFontSizeChanged(prop, old, new)
   self:getValueLabel():setFontSize(new)
end

function SelectInput.prototype:onIndentChanged(prop, old, new)
   self:getValueLabel():setLeft(new.x)
   self:getValueLabel():setTop(new.y)
end

function SelectInput.prototype:onDataChanged(prop, old, new)
   if platform.isIOS() then
      --self:getPicker():setData(new)
   else
      self:getPicker():setData(new)
   end
end
