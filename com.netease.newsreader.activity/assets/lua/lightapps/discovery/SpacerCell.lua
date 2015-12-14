module("SpacerCell", package.seeall)

local cellHeight = 6

local width = getApplication():getScreenWidthUnit()

local Globals = require("Globals")

local SpacerCell = Class.Class("SpacerCell",
                                 {
                                    base = Container,
                                    properties = {
                                       width=width,height=cellHeight,
                                       data = Class.undefined,
                                    }
})

function SpacerCell.prototype:init(inlineprops, ...)
   Container.prototype.init(self, inlineprops, ...)
   
   self:setBackgroundColor(Globals.getSpacerBackgroundColor())
   self:initSubViews()
end

function SpacerCell.prototype:initSubViews()
   local topline = Node{
      width=width, height=0.5,left=0,top=0.1,
      backgroundColor=Globals.getSpacerBackgroundColor()
   }

   local bottomline = Node{
      width=width, height=0.5,left=0,top=cellHeight-0.5,
      backgroundColor=Globals.getSpacerBackgroundColor()
   }

   self:addChild(topline)
   self:addChild(bottomline)
end

SpacerCell.cellHeight = cellHeight

function SpacerCell.class.prototype:getCellHeight(data)
   return cellHeight
end

return SpacerCell
