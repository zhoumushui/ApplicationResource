require "colortouch/Node"
require "stdlib/class/Class"

--[[

/**
   @section{Container概述}
   可以容纳其他控件（也包括Container类型）作为子对象的控件控件对象

   ---------------------------------------------------------------
   
   @iclass[Container Node]{
      可容纳其他控件，作为自己的子控件的容器控件。
      对于子控件而言，这就是父容器。
   }

   @method[onLayoutComplete]{

      在布局结束之后收到"onLayoutComplete"事件之后的处理逻辑

      @class[Container]
      @param[None]
      @return{None}
     
   }

   @method[onLayoutChanged]{
      
      layout属性改变之后收到"onLayoutChanged"事件执行的处理逻辑

      @class[Container]
      @param[name]{
         属性名字，即layout
      }
      @param[oldLayoutName]{
         之前layout的属性值
      }
      @param[newLayoutName]{
         新设置的layout的属性值
      }
      @return{None}
   }

   @method[onDirChanged]{
   
      dir属性改变之后收到"onDirChanged"事件执行的处理逻辑

      @class[Container]
      @param[name]{
         属性名字，即dir
      }
      @param[old]{
         之前dir的属性值
      }
      @param[new]{
         新设置的dir属性值
      }
      @return{None}
   }

   @method[getBackgroundImageView]{
   
      获取当前Container对象的背景ImageView对象，同样width、height的ImageView对象

      @class[Container]
      @param[None]
      @return{None}
   }

   @method[onBackgroundImageChanged]{
      
      backgroundImage属性改变之后收到"onBackgroundImageChanged"事件执行的处理逻辑

      @class[Container]
      @param[prop]{
         属性名字，即backgroundImage
      }
      @param[old]{
         之前backgroundImage属性值
      }
      @param[new]{
         新设置的backgroundImage属性值
      }
   }

   @method[onBackgroundEdgeInsetChanged]{
      
      backgroundEdgeInsetChanged属性改变之后收到"onBackgroundEdgeInsetChagned"事件执行的处理逻辑

      @class[Container]
       @param[prop]{
         属性名字，即onBackgroundEdgeInsetChanged
      }
      @param[old]{
         之前onBackgroundEdgeInsetChanged属性值
      }
      @param[new]{
         新设置的onBackgroundEdgeInsetChanged属性值
      }
   }

   @property[items]{
      @class[Container]

      用于容纳所有子控件的table
   }
   @property[layout]{
      @class[Container]

      同Node的layout属性，
      设置布局方式：参数为"flex"则为自动布局，不设置则为固定布局。
      PS：如果customLayout被设置则会覆盖 flex布局
   }
   @property[backgroundImage]{
      @class[Container]

      设置背景图片资源路径
   }
   @property[backgroundEdgeInset]{
      @class[Container]

      对backgroundImage设置edgeInset属性，
      edgeInset这个参数的格式是(top,left,bottom,right)，从上、左、下、右分别在图片上画了一道线，这样就给一个图片加了一个框
     只有在框里面的部分才会被拉伸，而框外面的部分则不会改变
   }

   @property[dir]{
      @class[Container]
      
      同Node的dir属性。
      指定容器内部子控件布局的方向，HBox为水平布局，VBox为垂直布局，
      即决定控件是垂直方向排版还是水平方向排版
   }
*/

]]

Container = Class.Class("Container",
                        {
                           base=Node,

                           properties={
                              items={},
                              layout=Class.undefined,

                              backgroundImage = Class.undefined,
                              backgroundImageView = Class.undefined,
                              backgroundEdgeInset = Class.undefined,

                              dir = Class.undefined,
                           }
                        }
)

function Container.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)

   if self["_backgroundImage"] then
      self:onBackgroundImageChanged("backgroundImage", nil, self["_backgroundImage"])
   end

   if self["_backgroundEdgeInset"] then
      self:onBackgroundEdgeInsetChanged("backgroundEdgeInset", nil, self["_backgroundEdgeInset"])
   end
end

function Container.prototype:onLayoutComplete()
   Node.prototype.onLayoutComplete(self)

   local robj = self._renderObject
   local rstyle = robj:getRenderStyle()

   local l = rstyle.left
   local t = rstyle.top
   local w = rstyle.width
   local h = rstyle.height

   --判断是否需要通知到backgroundImageView
   if self._backgroundImageView then
      --print("container layout complete, set background image w:" .. w .. "h:" .. h)
      --self._backgroundImageView:getPV():setFrame(l, t, w, h)
      --print(tostring(self._backgroundImageView:getRenderObject():getRenderStyle()))
--[[
      self._backgroundImageView:setWidth(w)
      self._backgroundImageView:setHeight(h)
      
      self._backgroundImageView:setNeedsLayout(false)
      self._renderObject:setNeedsLayout(false)
]]
   end
end

function Container.prototype:createPlatFormView()

   if platform:isIOS() then
      return Node.prototype.createPlatFormView(self)
   else
      if PlatformLayout ~= nil then
         return PlatformLayout(self)
      else
         return Node.prototype.createPlatFormView(self)
      end
   end
end


function Container.prototype:createRenderObject()
   return ContainerRenderObject(self)
end

function Container.prototype:onLayoutChanged(name, oldLayoutName, newLayoutName)
   if self:isIniting() then
      return 
   end
   
   nodeLog("%s on layout changed, old:%s, new:%s", self:shortDesc(),
           tostring(oldLayoutName), tostring(newLayoutName))

   local robj = self._renderObject

   if robj then
      robj:removeFromParent()
   end

   self:initRenderObject()
   self:setNeedsLayout()
end

function Container.prototype:onDirChanged(name, old, new)
   self:setNeedsLayout(true)
end

--support background image
function Container.prototype:getBackgroundImageView()
   if self._backgroundImageView then
      return self._backgroundImageView
   end

   self._backgroundImageView = ImageView{
      left=0,
      top=0,
      width="100%",
      height="100%",
   }

   self:insertBelow(self._backgroundImageView, table.first(self:getChildren()))

   return self._backgroundImageView;
end

function Container.prototype:onBackgroundImageChanged(prop, old, new)
   nodeLog("%s update backgroundImage", self:shortDesc())
 	 if platform.isIOS() then
 	  	local bgView = self:getBackgroundImageView()
 			bgView:setSrc(new)
 	 else
         -- local tempnew = string.lower(new)
         -- if string.starts(tempnew,'http://') or string.starts(tempnew,'https://') then
         --    local bgView = self:getBackgroundImageView()
         --    bgView:setSrc(new)
         -- else 
            self._pv:setBackgroundImage(new)
         -- end
 	 end
end

function Container.prototype:onBackgroundEdgeInsetChanged(prop, old, new)
 	 if platform.isIOS() then
		 self:getBackgroundImageView():setEdgeInset(new)
	end
end
