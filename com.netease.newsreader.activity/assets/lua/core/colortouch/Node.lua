--[[
   Node：
   1. tree structure
   2. platform view
]]

require "colortouch/layout/SizeModel"
require "stdlib/class/Class"
require "stdlib/mixins/observable"
require "colortouch/layout/RenderObject"
require "colortouch/style/PropertyDeclaration"

--[[
/**
  @section{IOS/Android通用API}
  所有控件要继承或间接继承的父类

---------------------------------------------------------------
  @iclass[Node ]{
    所有单控件类或者容器类都要通过直接或间接方式继承的父类
  }

  @method[addClass]{
    增加class

    @class[Node]
    @param[className]{
      增加的class名称
    }
    @return{None}

    @verbatim|{
      例子：
      local node = Node{}
      node:addClassName("specialNode")
    }|
  }

  @method[removeClass]{
    移除相应class

    @class[Node]
    @param[className]{
      要移除class名称
    }
    @return{None}

    @verbatim|{
      例子：
      node:removeClass("specialNode")
    }|
  }

  @method[hasClass]{
    查询是否拥有对应class

    @class[Node]
    @param[className]{
      用于查询的class名称
    }
    @return{boolean}

    @verbatim|{
      local bHas = node:has("sepcialNode")
    }|
  }

  @method[setClass]{
    直接设置整个class table

    @class[Node]
    @param[class]{
      用空格分隔并包含所有className的字符串
    }
    @return{None}

    @verbatim|{
      node:setClass("specialNode normalNode")
    }|
  }

  @method[getClass]{
    输出所有的className，以空格分隔

    @class[Node]
    @param[None]
    @return{string
      所有className拼接的字符串
    }

    @verbatim|{
      local allClasses = node:getClass()
    }|
  }

  @method[query]{
    根据id查询元素并返回

    @class[Node]
    @param[id]{
      要查询的id
    }
    @return{Node 
      返回是查询到的结果或者nil
    }
    @verbatim|{
    例子：
      local vc = ViewController{...}
      local something = Node{id="something"}
      vc:getView():addChild(something)
      ....
      local node = viewController:query("something")
    }|
  }
  
  @method[queryNodesByTypes]{
    根据类型名查询符合条件的所有子控件

    @class[Node]
    @param[typename]{
      用以查询的类型名
    }
    @return{Node
      返回查询到的结果或者空table
    }
    @verbatim|{
    例子：
      local somethings = viewController:queryNodesByTypes("ImageView")
    }|
  }

  @method[queryNodesByClass]{
    根据类名区查询符合条件的所有子控件

    @class[Node]
    @param[class]{
      用以查询的类名
    }
    @return{Node
      返回查询到的结果或者空table
    }
    @verbatim|{
      local somethings = viewController:queryNodesByClass("specialNode")
    }|
  }

  @method[getRoot]{
    获取当前控件的终极父控件

    @class[Node]
    @param[None]
    @return{Node
      返回最终的父控件，或者自身
    }

    @verbatim|{
      local father = node:getRoot()
    }|
  }

  @method[getVC]{
    获取父控件所在的ViewController

    @class[Node]
    @param[None]
    @return{ViewController
      返回父控件所在VC或者nil
    }
  }

  @method[createRenderObject]{
    创建渲染对象

    @class[Node]
    @param[None]
    @return{RenderObject
      生成的renderObject
    }   
  }

  @method[initRenderObject]{
    创建的RenderObject并赋给Node

    @class[Node]
    @param[None]
    @return{None}
  }

  @method[getChildren]{
    返回所有的子控件集合

    @class[Node]
    @param[None]
    @return{Nodes
      子控件集合table，或者nil
    }
  }

  @method[setProperty]{
    为Node设置属性

    @class[Node]
    @param[name]{
      设置的属性的名字
    }
    @param[val]{
      设置属性名字对应的值
    }
    @return{None}
    @verbatim|{
      例子：
      node:setProperty("owner", node:getParent())
    }|
  }

  @method[isCustomLayout]{
    是否是设置为customLayout，
    当node不需要参与ColorTouch布局，那么他或者他的parent的customLayout为true

    @class[Node]
    @param[None]
    @return{boolean
      自己或者父控件是否设置customLayout为true
    }    
  }

  @method[setFrameWhenCustomLayout]{
    如果是customLayout为true，则设置其frame属性为w/h/l/t

    @class[Node]
    @param[None]
    @return{boolean
      是否设置了customLayout为true
    }
  }

  @method[recursiveSetFrameCustomLayout]{
    对自身及子控件迭代设置frame
    @class[Node]
    @param[None]
    @return{None}
  }

  @method[getProperty]{
    获取对应的属性值

    @class[Node]
    @param[name]{
      属性的名字
    }
    @return{value
      属性的值
    }

    @verbatim|{
      例子：
      local owner = node:getProperty("owner")
    }|
  }

  @method[hasChild]{
    查询该对象是否是当前对象的子控件

    @class[Node]
    @param[c]{
      用来查询的Node对象
    }
    @return{boolean
      查询结果
    }
  }

  @method[insertSubviewAtIndex]{
    在子对象集合的特定位置上插入新对象

    @class[Node]
    @param[c]{
      c:要插入的新对象
      
    }
    @param[idx]{
      idx:在子对象集合中的位置
    }
    @return{None}
  }

  @method[insertBelow]{
    在某对象之后的位置插入新对象

    @class[Node]
    @param[c]{
      c:要插入的新对象      
    }

    @param[siblingNode]{
      siblingNode:在该对象后面插入新对象
    }
    @return{None}
  }
 
  @method[addChild]{
    同 insertBelow

    @class[Node]
    @param[None]
    @return{None}
  }

  @method[removeFromParent]{
    将自身从父容器上移除，解开ownership

    @class[Node]
    @param[None]
    @return{None}
  }

  @method[removeChildrenByClass]{
    将自身子控件中所有符合该class名称的从自身上移除掉

    @class[Node]
    @param[class]{
      要移除的class的名称
    }
    @return{None}

  }
  
  @method[removeChildById]{
    根据id移除对应的子对象
    @class[Node]
    @param[id]{
      要移除的对象其id
    }
    @return{None}
  }

  @method[removeAllChildren]{
    移除自身拥有的所有子控件

    @class[Node]
    @param[None]
    @return{None}
  }

  @method[setNeedsLayout]{
    设置是否需要进行layout

    @class[Node]
    @param[b]{
      是否需要进行layout      
    }
    @return{None}
  }

  @method[layout]{
    触发对自身及所有子对象的布局、排版、渲染

    @class[Node]
    @param[None]
    @return{None}
  }

  @method[rotate]{
    控件旋转接口

    @class[Node]
    @param[angle]{
      angle:旋转的角度
     
    }
    @param[bAni]{
      bAni：是否显示动画--AOS不支持该参数
    }
    @return{None}
    @verbatim|{
      例子：
        img:rotate(180, false)
    }|
  }

  @method[rotate1]{
    控件旋转接口

    @class[Node]
    @param[angle]{
      angle:旋转的角度
      
    }
    @param[pivotX]{
      pivotX:锚点x坐标
    }
    @param[pivotY]{      
      pivotY：锚点y坐标
    }
    @return{None}
    @verbatim|{
      例子：
        img:rotate(180, 0, 0)
    }|
  }

  @method[preferredSize]{
    获取native中preferredSize属性并返回

    @class[Node]
    @param[size]{
      不知道干啥的，native中似乎就没用该参数
    }
    @return{table
      返回preferredSize其width/height
    }
  }

  @method[getParent]{
    获取父容器

    @class[Node]
    @param[None]
    @return{Node
      父容器 ? 父容器 : nil
    }
  }

  @method[addEventListener]{
    为自身增加事件监听

    @class[Node]
    @param[evtName]{
      evtName:事件名
      
    }
    @param[cb]{
      cb：触发时调用的回调
    }
    @return{None}

    @verbatim|{
      btn:addEventListener("click",function() ... end)
    }|
  }

  @method[removeEventListener]{
    移除对应事件的监听

    @class[Node]
    @param[evtName]{
      evtName:事件名
      
    }
    @param[cb]{
      cb：触发时调用的回调
    }
    @return{None}

    @verbatim|{
      btn:removeEventListener("click",function() ... end)
    }|
  }

  @method[removeAllEventListener]{
    移除对该事件的所有监听

    @class[Node]
    @param[evtName]{
      evtName:事件名
    }
    @return{None}
    @verbatim|{
      btn:removeAllEventListener("click")
    }|
  }

  @method[isContainer]{
    判断自己是否是容器类型,该方法可重载

    @class[Node]
    @param[None]
    @return{boolean
      是否是容器
    }
  }

  @method[setPosition]{
      设置锚点坐标，并以此决定其所在控件的坐标。
      该绝对坐标是通过传入的x/y参数（即锚点坐标）与锚点在控件内部的相对坐标（x:0~1,y:0~1)计算得来

      @class[Node]
      @param[x]{
        锚点的x轴坐标，即相对父控件左边缘的left
      }
      @param[y]{
        锚点的y轴坐标，即相对父控件上边缘的top
      }
      @return{None}
      @verbatim|{
        如果使用了setPosition，这left和top将被赋值为数值（非百分比）
      }|
  }

  @method[getPosition]{
    获取锚点的位置坐标

    @class[Node]
    @param[None]
    @return{position table
      容纳锚点相对于父控件左上角的x/y轴坐标的table
    }
  }

  @method[setAnchor]{
    设置锚点

    @class[Node]
    @param[x]{
      是锚点在控件内部的x轴相对坐标，即与控件左边缘的Left为0~width,width为控件宽度
      }
    @param[y]{
      是锚点在控件内部的y轴相对坐标，即与控件上边缘的top为0~height,height为控件宽度
    }
    @return{None}
  }

  @method[setAngle]{
    设置控件内部相对坐标系上锚点的偏移角度，以左上角为原点

    @class[Node]
    @param[angle]{
      要设置的角度值
    }
    @return{None}
  }

  @method[setScale]{
    设置scale值，放大缩小比例，缩放是以锚点为中心进行的

    @class[Node]
    @param[scale]{
      缩放比例
    }
    @return{None}
  }

  @method[resetTransform]{
    重置自身的变换

    @class[Node]
    @param[None]
    @return{None}

  }

  @method[computedWidth]{
    获取最终布局计算得到的width

    @class[Node]
    @param[None]
    @return{width
      返回width
    }    
  }

  @method[computedHeight]{
    获取最终布局计算得到的Height

    @class[Node]
    @param[None]
    @return{Height
      返回Height
    }
  }
  @method[computedTop]{
    获取最终布局计算得到的Top

    @class[Node]
    @param[None]
    @return{Top
      返回Top
    }
  }
  @method[computedLeft]{
    获取最终布局计算得到的Left

    @class[Node]
    @param[None]
    @return{Left
      返回Left
    }
  }

  @method[showLoading]{
    显示设置的表示loading的图片资源

    @class[Node]
    @param[animated]{
      是否是以动画显示，默认为true
    }
    @return{None}
  }

  @method[hideLoading]{
    隐藏表示loadig的图片资源

    @class[Node]
    @param[animated]{
      是否动画方式隐藏，默认为true
    }
    @return{None}
  }

  @method[setLoadingProgress]{
      设置加载进度的数值

      @class[Node]
      @param[percent]{
        进度百分比的数值，100%为1.0
      }
      @return{None}
  }

  @method[tostring]{
    将自身序列化，包括继承关系、自身属性、子对象等

    @class[Node]
    @param[result]{
      result：外面传入的table，以存放序列化得到的字符串     
    }
    @param[notincludeChild]{
       notincludeChild:被排除在序列化过程之外的子对象
    }
    @return{table
      表示序列化结果的table
    }
  }

  @method[shortDesc]{
    返回自身的简要信息

    @class[Node]
    @param[None]
    @return{string
      简要信息的字符串
    }
  }

  @section{安卓独有}

  安卓独有的一些api
  --------------------------
  @method[setVisible]{
    设置自身可见与否，会对所有子对象起效，同时该控件将不接受事件

    @class[Node]
    @param[bVisible]{
      是否可见
    }
    @return{None}
  }

  @method[getFocus]{
    获取焦点？

    @class[Node]
    @param[None]
    @return{None}
  }
  @property[width]{
    @class[Node]

    设置控件的宽度
  }

  @property[minWidth]{
    @class[minWidth]
     
    设置控件的最小宽度    
  }

  @property[maxWidth]{
    @class[maxWidth]
      
    设置控件的最大宽度
  }

  @property[height]{
    @class[Node]

    设置控件的高度
  }

  @property[minHeight]{
    @class[Node]

    设置控件的最小高度
  }

  @property[maxHeight]{
    @class[Node]

    设置控件的最大高度
  }

  @property[left]{
    @class[Node]

    设置控件左边缘与父容器左边缘的距离
  }

  @property[top]{
    @class[Node]

    设置控件上边缘与父容器上边缘的距离
  }

  @property[anchor]{
    @class[Node]

    锚点的坐标，默认{x=0.5,y=0.5}，如下所示
  }

  @property[angle]{
    @class[Node]

    旋转时指定的角度
  }

  @property[scale]{
    @class[Node]

    设置缩放比例
  }

  @property[alpha]{
    @class[Node]

    设置alpha值，即透明度，0~1.0
  }

  @property[borderWidth]{
    @class[Node]

    设置控件的边框线条宽度
  }

  @property[borderColor]{
    @class[Node]

    设置控件的边框线条颜色，rgba类型参数
  }

  @property[clipsToBounds]{
    @class[Node]

    如果控件中有包含图片的话，是否在控件边缘截断显示，即图片显示不超出控件的frame,参数为true/false
  }

  @property[backgroundColor]{
    @class[Node]

    设置控件的背景底色，参数为rgba类型
  }
  @property[id]{
    @class[Node]

    设置控件其唯一的标识符id，不可重复
  }

  @property[Class]{
    @class[Node]

    设置控件对应的Class
  }

  @property[ui]{
    @class[Node]

    设置为预定义的ui样式
  }

  @property[layout]{
    @class[Node]

    设置布局方式：参数为"flex"则为自动布局，不设置则为固定布局。
    PS：如果customLayout被设置则会覆盖 flex布局
  }

  @property[dir]{
    @class[Node]
    指定容器内部子控件布局的方向，HBox为水平布局，VBox为垂直布局，
    即决定控件是垂直方向排版还是水平方向排版
  }

  @property[pack]{
    @class[Node]

    指定在dir指定的方向上控件之间的组织关系，类似css布局，支持参数为Start/End/Center/Justify
    具体含义可以参照  http://msdn.microsoft.com/zh-cn/library/ie/hh673531
  }

  @property[align]{
    @class[Node]

    参数同pack，与其不同之处是align是设置与dir指定方向垂直方向上的控件组织关系
  }

  @property[customLaytou]{
    @class[Node]

    customLayout如果设置为true，则当前控件及其子控件将不参与自动布局，
    但要求一定要设置top/left属性，否则报错
  }

  @property[loadingLabel]{
    @class[Node]

    设置加载过程中出现的提示标签其文字内容
  }

  @property[loadingDescLabel]{
    @class[Node]

    待写……
  }

  @property[loadingBGOpacity]{
    @class[Node]

    待写……不知道干啥的
  }

  @property[loadingCustomView]{
    @class[Node]

    可自定义加载过程中会出现的view，替换默认显示的loading图标
  }

  @property[loadingCustomViewAutoRotate]{
    @class[Node]

    设置自定义的loadingCustomViewAutoRotateView是否会自动旋转
  }

  @property[loadingCustomViewAutoRotateView]{
    @class[Node]

    设置在加载过程中显示的自定义且自动旋转的loadingView
  }

  @property[renderObjecet]{
    @class[Node]

    对真正参与排版渲染的对象(RenderObject类型)的引用
  }

  @property[relativeTop]{
    @class[Node]

    设置参加自动布局并排版结束之后，相对于排版结果top属性的偏移量，
    即显示出来的与父容器上边缘的距离为top+relativeTop两者属性之和
  }

  @property[relativeLeft]{
    @class[Node]

    设置参加自动布局并排版结束之后，相对于排版结果Left属性的偏移量，
    即显示出来的于父容器左边缘的距离为left+relativeLeft两者属性之和
  }
*/
]]


local SizeModel = SizeModel.SizeModel

Node = Class.Class("Node", 
                   --init properties
                   {
                      properties={
                         width=Class.undefined,
                         minWidth=Class.undefined,
                         maxWidth=Class.undefined,
                         height=Class.undefined,
                         minHeight=Class.undefined,
                         maxHeight=Class.undefined,
                         
                         left=Class.undefined,
                         top=Class.undefined,
                         
                         anchor = {x=0.5, y=0.5},
                         angle=Class.undefined,
                         scale=Class.undefined,

                         alpha = Class.undefined,
                         
                         borderWidth=Class.undefined,
                         borderColor=Class.undefined,--rgba{0,0,0,0.2},
                         borderRadius = Class.undefined,
                         
                         clipsToBounds = Class.undefined,

                         backgroundColor=Class.undefined,
                         id=Class.undefined,

                         Class = Class.undefined,

                         ui=Class.undefined,
                         
                         layout=Class.undefined,
                         flex=Class.undefined,
                         dir=Class.undefined,
                         pack=Class.undefined,
                         align=Class.undefined,

                         customLayout = false,

                         userInteractionEnabled = Class.undefined,

                         --for mask
                         loadingLabel = Class.undefined,
                         loadingDescLabel = Class.undefined,
                         loadingBGOpacity = Class.undefined,
                         --默认情况下显示系统的菊花
                         loadingCustomView = Class.undefined,
                         loadingCustomViewAutoRotate = Class.undefined,
                         loadingCustomViewAutoRotateView = Class.undefined,
                         
                         renderObject=Class.undefined,

                         relativeTop = Class.undefined,
                         relativeLeft = Class.undefined,
                      },

                     mixins={
                         observable=Observable
                      },

                      statics={
                         processInitProperties = function(cls, obj)
                            --do nothing, 将init property和构造函数传递进来的property进行merge之后在一次性作用到View上去
                            --[[
                               for k, v in cls.initProperties do
                               obj["_" .. k] = v
                               end
                            ]]
                            obj._children = {}
                            obj._parent = nil
                            obj._pv = obj:createPlatFormView()
                         end,
                      }
                   }
)

--Node = createNewNode("Node", nil)

local function mergeWithInitProperties(obj, inlineProps)
   local props = table.merge({}, inlineProps)

   if obj.class and obj.class.initProperties then
      for k, v in pairs(obj.class.initProperties) do
         if props[k] == nil then
            props[k] = v
         end
      end
   end

   return props
end

--@override
function Node.prototype:init(inlineprops, ...)
   nodeLog("%s init start", self:shortDesc())
   
   if nil == inlineprops then
      inlineprops = {}
   end
   --process properties
--[[
   for k, propMap in pairs(self.class.initProperties) do
      if inlineprops[k] == nil and self[propMap.setterName] and propMap.initV ~= Class.undefined then
         self[propMap.setterName](self, propMap.initV)
      end
   end

   for k, v in pairs(inlineprops) do
      local sn = NameMap[k][3]--self:setterName(k)
      if sn and self[sn] then
         self[sn](self, v)
      else
         self._props[k] = v
      end
   end

   --fixme:这里做的一次性刷新的动作，是不是可以在所有属性更新的地方做一个队列，从而避免多次的跟平台之间的交互？

   --create renderobject
   self:initRenderObject()

   nodeLog("%s init end", self:shortDesc())
]]
   --首先讲所有的属性设置上去
   for k, propMap in pairs(self.class.initProperties) do
      if propMap.initV ~= Class.undefined then
         self[propMap.realPropName] = propMap.initV
      end
   end

   local ui = self._ui or inlineprops["ui"]
   if ui ~= nil then
      local uiProps = PropertyDeclaration.getPropertyDeclaration(self.class.className, ui)
--      print("get proeprty declaration:" .. self.class.className .. " ui:" .. ui)
--      print(table.tostring(uiProps))
      if uiProps then
         for k, v in pairs(uiProps) do
            self[NameMap[k][1]] = v;
         end
      end
   end

   for k, v in pairs(inlineprops) do
      self[NameMap[k][1]] = v
   end

   --一些需要刷新到平台的属性，在这里处理。如果继承类有新的需要刷新到平台的，也再这里处理。
   --这样做的好处是避免通过一致的接口调用（class的setter默认接口），那个接口会调用observers等，但实际上创建对象的适合，不会有监听加进来
   --clipstobounds
   if self["_clipsToBounds"] ~= nil then
      self._pv:setClipsToBounds(self["_clipsToBounds"])
   end
   --bordercolor,borderwidth
   if LAYOUTFRAME == true then
      self._pv:setBorderColor(rgba{255,0,0,1})
   end
   if self["_borderColor"] then
      self._pv:setBorderColor(self["_borderColor"])
   end
   if LAYOUTFRAME == true then
      self._pv:setBorderWidth(0.5)
   end
   if self["_borderWidth"] then
      self._pv:setBorderWidth(self["_borderWidth"])
   end

   if self["_borderRadius"] then
      self._pv:setBorderRadius(self["_borderRadius"])
   end
   --backgroundcolor
   if self["_backgroundColor"] then
      self._pv:setBackgroundColor(self["_backgroundColor"])
   end
   --left, top
   if self["_left"] then
      self:onLeftChanged("left", nil, self["_left"])
   end
   if self["_top"] then
      self:onTopChanged("top", nil, self["_top"])
   end
   if self["_width"] then
     self:onWidthChanged("_width", nil, self["_width"])
   end
   if self["_height"] then
     self:onHeightChanged("_height", nil, self["_height"])
   end
   if self["_alpha"] then
     self:onAlphaChanged("_alpha", nil, self["_alpha"])
   end

   if self["_userInteractionEnabled"] ~= nil then
      self:onUserInteractionEnabledChanged("userInteractionEnabled", nil,
                                           self["_userInteractionEnabled"])
   end
   --items
   if self["_items"] then
      self:onItemsChanged("items", nil, self["_items"])
   end
   --Class
   if self["_class"] ~= nil then
      local class = self._class
      self._class = nil
      self:setClass(class)
   end

   if self._customLayout == true then
      print("recursive set frame layout")
      self:recursiveSetFrameCustomLayout()
   end
end

function Node.prototype:addClass(classname)
   if self._class == nil then
      self._class = {}
   end

   self._class[classname] = true
end

function Node.prototype:removeClass(classname)
   if self._class == nil then
      return
   end

   self._class[classname] = nil
end

function Node.prototype:hasClass(classname)
   if self._class == nil then
      return false
   end
   
   return self._class[classname]
end

function Node.prototype:setClass(class)
   local classtables = {}
   if class == nil then
      self._class = classtables 
      return
   end

   for i in string.gmatch(class, "%S+") do
      classtables[i] = true
   end

   self._class = classtables
end

function Node.prototype:getClass()
   if self._class == nil then
      return ""
   end

   local ret = ""
   for key, _ in pairs(self._class) do
      ret = ret .. " " .. key
   end

   return ret
end

function Node.prototype:query(id)   
   if self:getId() == id then
      return self
   end

   for i, child in ipairs(self:getChildren()) do
      local ret = child:query(id)
      if ret  then
         return ret
      end
   end

   return nil
end

function Node.prototype:queryNodesByTypes(typename)
   local nodes = {}

   local query = nil
   query = function(ret, typename, node)
      if node.class.className == typename then
         table.insert(ret, node)
      end

      for _, child in ipairs(node:getChildren()) do
         query(ret, typename, child)
      end
   end

   query(nodes, typename, self)
   return nodes
end

function Node.prototype:queryNodesByClass(class)
   local nodes = {}
   
   local query = nil
   query = function(ret, class, node)
      if node:hasClass(class) then
         table.insert(ret, node)
      end

      for _, child in ipairs(node:getChildren()) do
         query(ret, class, child)
      end
   end

   query(nodes, class, self)

   return nodes
end

function Node.prototype:getRoot()
   local root = self
   while root and root:getParent() do
      root = root:getParent()
   end
   return root
end

function Node.prototype:getVC()
   local root = self:getRoot()
   return root.vc
end

function Node.prototype:createRenderObject()
   return RenderObject(self)
end

function Node.prototype:initRenderObject()
   nodeLog("%s init renderobject", self:shortDesc())

   if self._renderObject then
      return
   end

   local rObj = self:createRenderObject()
   self:setRenderObject(rObj)
--[[
   for i, child in ipairs(self:getChildren()) do
      rObj:addChild(child._renderObject)
   end
   ]]
end

function Node.prototype:getChildren()
   return self._children
end

function Node.prototype:setProperty(name, val)
--   log("set property:" .. name .. ":" .. val)

   local sn = NameMap[name][3]--self:setterName(name)
   if sn and self[sn] then
      self[sn](self, val)
      return
   end

   self[NameMap[name][1]] = val
end

function Node.prototype:onRenderObjectChanged(prop, old, new)
   if old then
      old:un("layoutComplete", self.onLayoutComplete, self)
   end
   
   if new then
      new:on("layoutComplete", self.onLayoutComplete, self)
   end
end

function Node.prototype:onLayoutComplete()
   local robj = self._renderObject
   local rstyle = robj._renderStyle

   --刷新属性到平台中去
   local l = rstyle.left
   local t = rstyle.top
   local w = rstyle.width
   local h = rstyle.height

   nodeLog("%s layout complete, %s, left:%f, top:%f, width:%f, height:%f", self:shortDesc(), self._pv["handler"], l, t, w, h)

   if self._relativeTop then
      t = t + self._relativeTop
   end
   if self._relativeLeft then
      l = l + self._relativeLeft
   end

   self._pv:setFrame(l, t, w, h)

   self:fireEvent("layoutComplete", self)
end

function Node.prototype:onClipsToBoundsChanged(name, old, new)
   self._pv:setClipsToBounds(new)
end

--[[
   当node不需要参与ColorTouch布局，那么他或者他的parent的customLayout为true
]]
function Node.prototype:isCustomLayout()
   local customLayout = false
   local node = self
   while node do
      if node._customLayout == true then
         customLayout = true
         break
      end

      node = node._parent
   end   

   return customLayout
end

function Node.prototype:setFrameWhenCustomLayout()
   if self:isCustomLayout() == true then
      self._pv:setFrame(self._left,
                        self._top,
                        self._width,
                        self._height)

      return true
   end

   return false
end

function Node.prototype:recursiveSetFrameCustomLayout()
   self._pv:setFrame(self._left,
                     self._top,
                     self._width,
                     self._height)

   for _, child in ipairs(self._children) do
      child:recursiveSetFrameCustomLayout()
   end
end

function Node.prototype:onWidthChanged(prop, old, new)
   if self:setFrameWhenCustomLayout() == true then
      return
   end

   --fixme:当类型变了，譬如从百分比变成了数字值，需要renderobject中的sizemodel重新计算，否则会排版错误
   local robj = self._renderObject
   if robj then
      robj:setNeedsLayout(true)
   end
   if type(new) == "number" then
      self._pv:setWidth(new)
   end
end

function Node.prototype:onHeightChanged(prop, old, new)
   if self:setFrameWhenCustomLayout() == true then
      return
   end

   local robj = self._renderObject
   if robj then 
      robj:setNeedsLayout(true)
   end
   if type(new) == "number" then
      self._pv:setHeight(new)
   end
end

function Node.prototype:onLeftChanged(prop, old, new)
   if self:setFrameWhenCustomLayout() == true then
      return
   end

   local robj = self._renderObject
   if robj then
      robj:setNeedsLayout(true)
   end
   if type(new) == "number" then
      if self._relativeLeft then
         new = new + self._relativeLeft
      end
      self._pv:setLeft(new)
   end
end

function Node.prototype:onTopChanged(prop, old, new)
   if self:setFrameWhenCustomLayout() == true then
      return
   end

   local robj = self._renderObject
   if robj then
      robj:setNeedsLayout(true)
   end
   if type(new) == "number" then
      if self._relativeTop then
         new = new + self._relativetop
      end
      self._pv:setTop(new)
   end
end

function Node.prototype:onFlexChanged(prop, old, new)
   local robj = self._renderObject
   if robj then
      robj:setNeedsLayout(true)
   end
end

function Node.prototype:onBorderColorChanged(prop, old, new)
   self._pv:setBorderColor(new)
end

function Node.prototype:onBorderRadiusChanged(prop, old, new)
   self._pv:setBorderRadius(new)
end

function Node.prototype:onBorderWidthChanged(prop, old, new)
   self._pv:setBorderWidth(new)
end

function Node.prototype:onBackgroundColorChanged(prop, old, new)
   self._pv:setBackgroundColor(new)
end

function Node.prototype:onAlphaChanged(prop, old, new)
   self._pv:setAlpha(new)
end

function Node.prototype:onUserInteractionEnabledChanged(prop, old, new)
   if platform.isIOS() then
      self._pv:setUserInteractionEnabled(new)
   end
end

function Node.prototype:onIdChanged(prop, old, new)
   --now do nothing
end


function Node.prototype:onItemsChanged(prop, old, new)
    if not new then
      print(debug.traceback())
      error("\n\t\t *********** setItems expects a table!! **********\n", 3)
      return
    end

    local length = #new
    local len = 0
    for _,item in pairs(new) do
        len = len + 1
        if type(_) ~= "number" then
           error("\n\t\t *********** setItems or items={...} 中存在类似 \"Label={...}\"错误用法 **********\n", 3)
        end
        
        if not item:isKindOf(Node) then
           error("\n\t\t *********** setItems expects a table in which all items must inherits from Node!! **********\n", 3)
           return
        end
        
    end
    if len ~= length then        
        error("\n\t\t *********** setItems expects a table without nil!! **********\n", 3)
        return
    end


   self:removeAllChildren()
   
   if new then
      for _, item in ipairs(new) do
         self:addChild(item)
      end
   end
end

function Node.prototype:getProperty(name)
--[[
   local gn = self:getterName(name)
   local gm = self[gn]--getter method
   if gm then
      return gm(self)
   else
      return self._props[name]
   end
]]
   local rn = NameMap[name][1]

   --Warning:为了性能考虑通过getProperty获取的Node class申明的属性，不会调用getter函数，减少一次函数调用
   if self[rn] then
      return self[rn]
   end

   local gn = NameMap[name][2]
   local gm = self[gn]
   
   if gm then
      return gm(self)
   end

   return nil
end

--@override
function Node.prototype:createPlatFormView()
   return View(self)
end

function Node.prototype:getPV()
   return self._pv
end

function Node.prototype:hasChild(c)
   return table.aindexOf(self._children, c) ~= nil
end      

function Node.prototype:insertSubviewAtIndex(c, idx)
   c:removeFromParent()

   c:onBeforeAddToParent(self)
   c:fireEvent("onBeforeAddToParent",
               c,
               self)

   --lua中index从1开始！
   table.insert(self._children, idx+1, c)

   c._parent = self
   self._pv:insertSubviewAtIndex(c:getPV(), idx)
   
   self:initRenderObject()
   c:initRenderObject()
   local robj = self._renderObject
   --update renderobject tree
   if robj and c._renderObject then
      robj:insertAtIndex(c._renderObject, idx)
   end
   c:setNeedsLayout(true)

   self:onChildrenChanged(c, true)
   self:fireEvent("onChildrenChanged", self, c, true)

   c:onAfterAddToParent(self)
   c:fireEvent("onAfterAddToParent",
               c,
               self)

   if self:isCustomLayout() then
      self:recursiveSetFrameCustomLayout()
   end
end

function Node.prototype:insertBelow(c, siblingNode)
   local children = self:getChildren()
   local idx = -1

   if siblingNode == nil then
      idx = #children+1
   else
      idx = table.aindexOf(children, siblingNode)
      if idx == nil then
         nodeError("%s insert node parameter error, sibling node %s is not a child of self", self:shortDesc(), siblingNode:shortDesc())
      end
   end

   if c == nil then
      print(debug.traceback())
   end
   if c.removeFromParent == nil then
--      print(c.class.className)
      print(debug.traceback())
   end

   if c._parent == self then
      error("Cannot insert or add duplicate child")
   end

   c:removeFromParent()
   
   nodeLog("%s insert child:%s", self:shortDesc(), c:shortDesc())

   c:onBeforeAddToParent(self)
   c:fireEvent("onBeforeAddToParent",
                  c,
                  self)

--   print("total:" .. tostring(#self._children) .. " index:" .. tostring(idx))
   table.insert(self._children, idx, c)

   c._parent = self

   if siblingNode then
      self._pv:insertSubViewBelowSubView(c:getPV(), siblingNode:getPV())
   else
      self._pv:addSubView(c._pv)
   end

   self:initRenderObject()
   c:initRenderObject()
   local robj = self._renderObject
   --update renderobject tree
   if robj and c._renderObject then
      robj:insertBelow(c._renderObject, siblingNode and siblingNode._renderObject or nil)
   end
   c:setNeedsLayout(true)

   self:onChildrenChanged(c, true)
   self:fireEvent("onChildrenChanged", self, c, true)

   c:onAfterAddToParent(self)
   c:fireEvent("onAfterAddToParent",
               c,
               self)

   if self:isCustomLayout() then
      self:recursiveSetFrameCustomLayout()
   end
end

function Node.prototype:addChild(c)
--[[
   if c:parent() then
      c:removeFromParent()
   end

   if table.indexOf(self._children, c) ~= nil then
      nodeError("%s add exist child:%s", self:shortDesc(), c:shortDesc())
   end

   local robj = self._renderObject
   
   nodeLog("%s add child:%s", self:shortDesc(), c:shortDesc())

   c:onBeforeAddToParent(self)
   c:fireEvent("onBeforeAddToParent",
                  c,
                  self)

   table.insert(self._children, c)
   c._parent = self
   
   self._pv:addSubView(c._pv)

   --update renderobject tree
   if robj and c._renderObject then
      robj:addChild(c._renderObject)
   end
   c:setNeedsLayout(true)

   self:onChildrenChanged(c, true)
   self:fireEvent("onChildrenChanged", self, c, true)

   c:onAfterAddToParent(self)
   c:fireEvent("onAfterAddToParent",
               c,
               self)
]]
   self:insertBelow(c)
end

function Node.prototype:removeFromParent()
   local parent = self._parent
   if (parent) then
      nodeLog("remove %s from %s", self:shortDesc(), parent:shortDesc())

      self:onBeforeRemoveFromParent(parent)

      self:fireEvent("onBeforeRemoveFromParent",
                     self,
                     parent)

      table.removeValue(parent._children, self)
      self._parent = nil
      self._pv:removeFromParent()

      if self._renderObject then
         self._renderObject:removeFromParent()
      end
      if parent._renderObject then
         parent._renderObject:setNeedsLayout(true)
      end
      
      parent:onChildrenChanged(self, false)
      parent:fireEvent("onChildrenChanged", parent, self, false)

      self:onAfterRemoveFromParent(parent)
      self:fireEvent("onAfterRemoveFromParent",
                     self,
                     parent)
      return
   end
   nodeLog("remove view from parent nil")
end

function Node.prototype:removeChildrenByClass(class)
   local items = self:queryNodesByClass(class)
   if items == nil or #items == 0 then
      return
   end

   for _, item in ipairs(items) do
      item:removeFromParent()
   end
end

function Node.prototype:removeChildById(id)
   local child = self:query(id)
   if child then 
      child:removeFromParent()
   end
end

function Node.prototype:removeAllChildren()
   local children = {}
   for _, child in ipairs(self:getChildren()) do
      table.insert(children, child)
   end

   for _, child in ipairs(children) do
      child:removeFromParent()
   end
end

function Node.prototype:setNeedsLayout(b)
   local robj = self._renderObject
   if robj then
      robj:setNeedsLayout(b)
   else
      self:initRenderObject()
      self:setNeedsLayout(b)
   end
end

function Node.prototype:layout()
   local robj = self._renderObject
   if robj == nil then
      self:initRenderObject()
      self:setNeedsLayout(true)
      self:layout()
      return
   end

   nodeLog("%s force layout", self:shortDesc())
   
   robj:layoutIfNeeded()
end

function Node.prototype:onChildrenChanged(child, bAdd)
end

function Node.prototype:onBeforeAddToParent(parent)
end

function Node.prototype:onAfterAddToParent(parent)
end

function Node.prototype:onBeforeRemoveFromParent(parent)
end

function Node.prototype:onAfterRemoveFromParent(parent)
end

if platform.isIOS() then
function Node.prototype:rotate(angle, bAni)
   self._pv:rotate(angle, bAni)
end
else
function Node.prototype:rotate(angle)
  local height1 = self:getHeight()/2
  print("node ...rotate height ...is;\t"..height1)
   self._pv:rotate1(angle,height1,height1)
end

function Node.prototype:rotate1(angle,pivotX,pivotY)
   self._pv:rotate1(angle,pivotX,pivotY)
end
end

function Node.prototype:preferredSize(size)
   return self._pv:preferredSize(size);
end

function Node.prototype:getParent()
   return self._parent
end

function Node.prototype:addEventListener(evtName, cb)
   return self._pv:addEventListener(evtName, cb,self)
end

function Node.prototype:removeEventListener(evtName, cb)
   return self._pv:removeEventListener(evtName, cb)
end

function Node.prototype:removeEventAllListener(evtName)
  return self._pv:removeEventAllListener(evtName)
end

--@override
function Node.prototype:isContainer()
   return false
end

function Node.prototype:setPosition(x,y)
   local position = self:getPosition()
   local xDiff = x - position.x
   local yDiff = y - position.y

   local left = self:computedLeft()
   local top = self:computedTop()
   if self._relativeLeft then
      left = left - self._relativeLeft
   end
   if self._relativeTop then
      top = top - self._relativeTop
   end

   self:setLeft(left+xDiff)
   self:setTop(top+yDiff)

   --self._pv:setPosition(x,y)
end

function Node.prototype:getPosition()
   local left = self:computedLeft()
   local top = self:computedTop()
   local width = self:computedWidth()
   local height = self:computedHeight()
   local anchor = self:getAnchor()

   return {x=left+anchor.x*width, y=top+anchor.y*height}

   --return self._pv:getPosition()
end

function Node.prototype:setAnchor(x,y)
   self._anchor.x = x
   self._anchor.y = y
   self._pv:setAnchor(x,y)
end

function Node.prototype:setAngle(angle)
   self._pv:setAngle(angle)
end

function Node.prototype:setScale(scale)
   self._pv:setScale(scale)
end

function Node.prototype:resetTransform()
   self._pv:resetTransform()
end

--for calculated property
function Node.prototype:computedWidth()
   self:getRoot():layout()
   
   return self._renderObject:getRenderStyle().width
end

function Node.prototype:computedHeight()
   self:getRoot():layout()
   
   return self._renderObject:getRenderStyle().height
end

function Node.prototype:computedLeft()
   self:getRoot():layout()
   
   return self._renderObject:getRenderStyle().left + (self._relativeLeft and self._relativeLeft or 0)
end

function Node.prototype:computedTop()
   self:getRoot():layout()
   
   return self._renderObject:getRenderStyle().top + (self._relativeTop and self._relativeTop or 0)
end

--for mask
function Node.prototype:showLoading(animated)
   if animated == nil then
      animated = true
   end

   if self._loadingCustomView then
      self._loadingCustomView:layout()
   end

   self._pv:showLoading(self._loadingLabel, self._loadingDescLabel, self._loadingCustomView, animated)
   if nil ~= self._loadingBGOpacity then
      self._pv:setLoadingProgressBGOpacity(self._loadingBGOpacity)
   end
   
   if self._loadingCustomViewAutoRotate == true then
      
      if platform.isIOS() then
        self._loadingCustomViewAutoRotateView:layout()
      end
      self._loadingCustomViewAutoRotateView:setAsLoadingIndicator()
   end
end

function Node.prototype:hideLoading(animated)
   if animated == nil then
      animated = true
   end

   self._pv:hideLoading(animated)
end

function Node.prototype:setLoadingProgress(percent)
   self._pv:setLoadingProgress(percent)
end

--@override
function Node.prototype:tostring(result, notincludeChild)
   print(debug.traceback())
--   error("")

   result = result or {}
   table.insert(result, "{\n  ")

   table.insert(result, "pv:" .. tostring(self._pv["handler"]) .. ",\n")
   table.insert(result, "properties:")

   if not notincludeChild and #self._children > 0 then
      table.insert(result, ",\n")
      table.insert(result, "items:[\n")
      for k, child in pairs(self._children) do
         child:tostring(result)
         table.insert(result, "\n,")
      end
      table.insert(result, "\n]\n")
   end

   table.insert(result, "\n}\n")
   return table.concat(result, "")
end

--@override
function Node.prototype:shortDesc()
   if DEBUG == false then
      return ""
   end

   local clsName = self.class.className
   local name = self:getProperty("id")
   if name then
      return string.format("%s(%s), name:%s", clsName, self:address(), name)
   else
      return string.format("%s(%s)", clsName, self:address())
   end
end

--ios也支持setVisible接口
function Node.prototype:setVisible(bVisible)
  self._pv:setVisible(bVisible)  
end

if not platform.isIOS() then
  function Node.prototype:getFocus()
    self._pv:getFocus()  
  end

  function Node.prototype:hidekeyboard()
    self._pv:hidekeyboard()  
  end
end
