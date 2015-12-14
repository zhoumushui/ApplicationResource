--[[
/**
   @section{概述}
   标签控件。
   
   ---------------------------------------------------------------

   @iclass[Spacer Node]{
      空白控件。
      其余所有控件共有的属性和方法，详见Node类定义
   }
   @italic{一般用于在flex布局中提供空白控件}
   @verbatim|{
   例子：
   local container = Container{
      left=0, top=0,
      width="100%", height="100%",
      layout="flex", dir=HBox,
      items={
         Button{width="40%",height="100%",},
         Spacer{width="20%",},
         Button{width="40%",height="100%",},
      }
   }
   }|
*/
]]

require "colortouch/Node"
require "stdlib/class/Class"

Spacer = Class.Class("Spacer",
                     {
                        base=Node
                     }
)

