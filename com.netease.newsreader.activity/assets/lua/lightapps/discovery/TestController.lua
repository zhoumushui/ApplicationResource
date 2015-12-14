module("ScrollViewController",  package.seeall)

require "controller.YXViewController"
local YXViewController = YXViewController.YXViewController

ScrollViewController = Class.Class("ScrollViewController",
                                    {
                                       base=YXViewController,
                                       properties={
                                          backButtonStyle = "gray",
                                          bShowBackBtn = true,
                                          bShowNaviBar = true,
                                          bStartFromScreenTop = true,
                                          navigationBarBgColor = rgba{247,247,247,1},

                                          title="测试ScrollView",
                                          titleColor=rgba{0,0,0,1},
                                       }
})

function ScrollViewController.prototype:init(inlineprops, ...)
   YXViewController.prototype.init(self, inlineprops, ...)

   self:doInit()
   
   self:getView():setBackgroundColor(rgba{255,255,255,1})
end

function ScrollViewController.prototype:doInit()
   self:addViews()
   self:initNavigationBar()
   self:testDrag()
end

function ScrollViewController.prototype:addViews()
   local c = Container{
      layout='flex', dir=VBox,
      borderWidth=1,borderColor=rgba{255,0,0,1},
      clipsToBounds = true,

      items={
         Button{
            width='50%', height=50,
            color=rgba{255,0,0,1},
            text='测试Tableview',
            id='btn1'
         },

         Button{
            width='50%', height=50,
color=rgba{255,0,0,1},
            text='测试动画'
         },

         Label{
            width="50%", height=50,
            text="test drag",
            id="label1",
            userInteractionEnabled=true,
            borderWidth=1,borderColor=rgba{255,0,0,1},
         }
      }
   }

   c:query("btn1"):addEventListener("click",
                                    function()
                                       print("btn1 clicked")
                                       if true then
                                          local vc = ScrollViewController()
                                          self:pushViewController(vc)
                                          return
                                       end
                                   end)
                                     

   c:setWidth(300):setHeight(200):setLeft(10):setTop(50)
   self:getView():addChild(c)
   self:getView():layout()
end

function ScrollViewController.prototype:testDrag()
   local label = self:getView():query("label1")
   
   label:addEventListener("dragstart",
                          function()
   end)

   label:addEventListener("dragstart",
                          function(evt)
                             print("dragstart")
                             print(evt.x)
                             print(evt.y)
                             print(evt.target)
   end)

   label:addEventListener("dragging",
                          function(evt)
                             print("dragging")
                             print(evt.x)
                             print(evt.y)
                             print(evt.target)
   end)

   label:addEventListener("dragend",
                          function(evt)
                             print("dragend")
                             print(evt.x)
                             print(evt.y)
                             print(evt.target)
   end)

   label:addEventListener("longpressed",
                          function()
                             print("long pressed")
   end)

   label:addEventListener("doubletap",
                          function()
                             print("double tap")
   end)
   
   label:removeEventAllListener("longpressed")
end

function ScrollViewController.prototype:initNavigationBar()
   local btn = Button{
      text="后退",
      color=rgba{255,0,255,1},
   }
   btn:addEventListener("click",
                        function()
                           self:pop(true)
   end)

   self:setNavigationBarLeftView(btn)
end

function ScrollViewController.prototype:goTableViewController()

end

return ScrollViewController
