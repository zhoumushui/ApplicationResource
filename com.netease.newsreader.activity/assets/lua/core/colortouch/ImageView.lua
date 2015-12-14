--[[
/**
   @section{概述}
   图片控件。
   
   ---------------------------------------------------------------

   @iclass[ImageView Node]{
      用于显示网络或者本地图片。
      其余所有控件共有的属性和方法，详见Node类定义
   }

   @method[blured]{
      毛玻璃效果。设置之后，之后切换了图片，还是会作用上毛玻璃效果。
      @verbatim|{
      适用平台：iOS
      }|
      @;@larger{这里是方法的描述，随便写}
      @class[ImageView]
      @param[bBlured]{
      是否作用上毛玻璃效果, true为作用上模糊效果，false为不作用模糊效果
      }
      @return{无}
      @verbatim|{
      例子：
      --创建ImageView的实例
      local imgView = ImageView{src="app://1.png",}
      --对图片进行模糊处理
      imgView:blured()
      }|
   }

   @method[setAsLoadingIndicator]{
      设置当前图片为下载时的图标，即图片能自动旋转。
      @verbatim|{
      适用平台：iOS, Android
      }|
      @italic{注意：图片只有加入到视图的场景树下时才有效}
      @;@larger{这里是方法的描述，随便写}
      @class[ImageView]
      @return{无}
      @verbatim|{
      例子：
      --创建ImageView的实例
      local imgView = ImageView{src="app://1.png",}
      --将图片控件加入到场景树中
      vc:getView():addChild(imgView)
      --设置图片能自动旋转
      imgView:setAsLoadingIndicator()
      }|
   }

   @method[stopLoadingIndicator]{
      撤销当前图片为下载时的图标，即图片不再旋转
      @verbatim|{
      适用平台：iOS, Android
      }|
      @;@larger{这里是方法的描述，随便写}
      @class[ImageView]
      @return{无}
      @verbatim|{
      例子：
      --创建ImageView的实例
      local imgView = ImageView{src="app://1.png",}
      --将图片控件加入到场景树中
      vc:getView():addChild(imgView)
      --设置图片能自动旋转
      imgView:setAsLoadingIndicator()
      --取消图片的自动旋转
      imgView:stopLoadingIndicator()
      }|
   }

   @property[src]{
      @verbatim|{
      适用平台：iOS, Android
      }|
      @italic{不设置时，默认效果为无图片
      @class[ImageView]
      @verbatim|{
      设置图片的地址
      1. app://1.png
         iOS: colortouch脚本app目录下images/目录下的图片
         Android: colortouch脚本app目录下images/drawable-mdpi和images/drawable-xhdpi目录下的图片
      2. 1.png
         native应用本地图片
      3. http://1.png
         网络上的图片
      }|

      @verbatim|{
      例子：
      --创建显示1.png图片的ImageView的实例
      local imgView = ImageView{src="app://1.png",}
      }|
   }

   @property[edgeInset]{
      @verbatim|{
      适用平台：iOS
      }|
      @italic{注意：在contentMode为"center"时,无效}
      @italic{不设置时，默认效果为edgeInset{0,0,0,0}}
      @class[ImageView]
      @verbatim|{
      edgeInset这个参数的格式是edgeInset{top,left,bottom,right}
      为图片控件设置内嵌frame，正值为向内缩放的frame，负值为向外扩张的frame
      1. 在contentMode为scaleToFill、aspectFit、aspectFill的情况下，当width、height大于图片本身的长宽的时候，图片阵列排布显示。
         正值时，图片重叠排列，重叠程度由正值大小决定；非正值时，图片正常排列
      2. 在contentMode为center的情况下，edgeInset无效

      ／／／／／／／／
      从上、左、下、右分别在图片上画了一道线，这样就给一个图片加了一个框
      只有在框里面的部分才会被拉伸，而框外面的部分则不会改变
      ／／／／／／／／
      }|
      @verbatim|{
      例子：
      --创建ImageView的实例imgView，长宽均为320，contentMode为"scaleToFill"
      --edgeInset的top,left,bottom,right均为正值
      --假设图片真实大小小于320，图片重叠排列
      local imgView = ImageView{
         src="app://1.png",
         left=0, top=0,
         width=320, height=320,
         contentMode="scaleToFill",
         edgeInset=edgeInset{5,5,5,5},
      }
      }|
   }

   @property[contentMode]{
      @verbatim|{
      适用平台：iOS, Android
      }|
      @italic{不设置时，默认效果为scaleToFill}
      @class[ImageView]
      @verbatim|{
      设置图片显示的模式
      可选的值有：
      center：图片保持尺寸，居中显示，可导致edgeInset参数无效
      scaleToFill：在指定方框范围内，图片拉伸显示
      aspectFit：在指定方框范围内，图片按原长宽比缩放至，方框范围恰好包含图片
      aspectFill：在指定方框范围内，图片按原长宽比缩放至，图片恰好包含方框范围
      }|
   }

   @property[placeHolder]{
      @verbatim|{
      适用平台：iOS
      }|
      @italic{注意：仅能设置native图片，app://XXX.png, http://XXX.png均不合法}
      @italic{不设置时，默认效果为src图片加载成功之前，不显示图片}
      @class[ImageView]
      @verbatim|{
      设置src对应的图片显示之前，预先显示的图片地址
      尤其当属性src设置的是一个网络链接，当图片下载成功并显示之前，会有一个相对较长的时间间隔，这里先显示placeHolder对应的图片内容
      }|
      @verbatim|{
      例子：
      --创建ImageView的实例imgView，src为网络地址, placeHolder为本地图片
      --在src的图片加载成功之前，显示placeHolder指定的图片
      local imgView = ImageView{
         src="http://1.png",
         placeHolder = "2.png",
         placeHolder = "scaleToFill",
      }
      }|
   }

   @property[placeHolderContentMode]{
      @verbatim|{
      适用平台：iOS, Android
      }|
      @italic{注意：仅当placeHolder不为nil时，有效}
      @italic{不设置时，默认效果为scaleToFill}
      @class[ImageView]
      @verbatim|{
      设置src对应的图片显示之前，预先显示的图片的显示模式
      显示模式详见contentMode属性
      }|
      @verbatim|{
      例：见placeHolder例
      }|
   }

   @property[errorImg]{
      @italic{暂时未实现}
      @class[ImageView]
      @verbatim|{
      设置若src对应的图片下载失败之后，显示的图片
      }|
   }

   @property[errorImgContentMode]{
      @italic{暂时未实现}
      @class[ImageView]
      @verbatim|{
      设置若src对应的图片下载失败之后，显示的图片的显示模式
      显示模式详见contentMode属性
      }|
   }

   @larger{私有属性，用户不可修改，仅可通过get函数读取}
   @property[isLoading]{
      @verbatim|{
      适用平台：iOS, Android
      }|

      @class[ImageView]
      @verbatim|{
      判断图片是否是加载成功，只读变量
      }|
      @verbatim|{
      例子：
      --创建ImageView的实例imgView，src为网络地址
      local imgView = ImageView{
         src="http://1.png",
      }
      --将imgView添加进场景树中
      vc:getView():addChild(imgView)
      --获取信息，imgView的图片是否加载成功
      local isLoadComplete = (imgView:getIsLoading() == false)
      }|
   }
*/
]]

require "stdlib/class/Class"

ImageView = Class.Class("ImageView",
                     {
                        base=Node,
                        properties={
                           src=Class.undefined,
                           edgeInset = Class.undefined,
                           --center,scaleToFill,aspectFit,aspectFill
                           contentMode = Class.undefined,
                           
                           placeHolder = Class.undefined,
                           placeHolderContentMode = Class.undefined, --默认的图可能跟实际的图的placeHoler不一样
                           
                           errorImg = Class.undefined,
                           errorImgContentMode = Class.undefined, --当实际图片加载失败的是现实errorImg
                           cornerRadius = Class.undefined,

                           --私有变量
                           isLoading = false,
                        }
                     }
)

--@override
function ImageView.prototype:createPlatFormView()
   return PlatformImageView(self)
end

function ImageView.prototype:init(inlineprops, ...)
   Node.prototype.init(self, inlineprops, ...)

   if self._placeHolder then
      self:onPlaceHolderChanged("placeHolder", nil, self._placeHolder)
   end

   if self._src then
      self:onSrcChanged("src", nil, self._src)
   end

   if self._edgeInset then
      self:onEdgeInsetChanged("edgeInset", nil, self._edgeInset)
   end
   
   if self._contentMode then
      self:onContentModeChanged("contentMode", nil, self._contentMode)
   end

   if self._cornerRadius then
      self:onCornerRadiusChanged("cornerRadius", nil, self._cornerRadius)
   end
   self:addEventListener("load", 
                         function(evt)

                           self:setIsLoading(false)
                           self:setContentMode(self._contentMode)

                            self:fireEvent("load", evt)
                            if not self:getWidth() or not self:getHeight() then
                               --fixme:判断下是否宽高发生了变化，如果没有也没必要排版
                               --print("@@@@@@@@@@@@@@@@image load re layout@@@@@@@@@@@@@@")
                               --self:setNeedsLayout(true)
                            end
   end)

   self:addEventListener("error", 
                         function(evt)
                                                    
                           self:setIsLoading(false)

                            self:fireEvent("error", evt)
                            if not self:getWidth() or not self:getHeight() then
                               --print("@@@@@@@@@@@@@@@@image error re layout@@@@@@@@@@@@@@")
                               --self:setNeedsLayout(true)
                            end
   end)
end

function ImageView.prototype:onSrcChanged(prop, old, new)
   self:setIsLoading(true)

   self._pv:setSrc(new)
   
   if self._placeHolder and self._placeHolderContentMode then
      self._pv:setContentMode(self._placeHolderContentMode)
   end

   if self:getEdgeInset() and self:getSrc() then
      self._pv:setEdgeInset(self:getEdgeInset())
   end

   if not (type(self:getWidth()) == "number" and type(self:getHeight()) == "number") then
      --print("~~~~~~~~~~~~src changed, needs layout")
      self:setNeedsLayout(true)
   end
end

function ImageView.prototype:onEdgeInsetChanged(prop, old, new)
	if platform.isIOS() then
      if nil == new then
         new = edgeInset(0,0,0,0)
      end

      self._pv:setEdgeInset(new)
   end
end

function ImageView.prototype:onPlaceHolderChanged(prop, old, new)
	if platform.isIOS() then
      self._pv:setPlaceHolder(new)
   end
end

function ImageView.prototype:setAsLoadingIndicator()
   self._pv:setAsLoadingIndicator()
end

function ImageView.prototype:stopLoadingIndicator()
  self._pv:stopLoadingIndicator()
end

function ImageView.prototype:onContentModeChanged(prop, old, new)
   self._pv:setContentMode(new)
end

function ImageView.prototype:onCornerRadiusChanged(prop,old,new)
      if not platform.isIOS() then
      self._pv:setCornerRadius(new)
   end

end
function ImageView.prototype:blured()
   self._pv:blured()
end