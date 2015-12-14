module("Class", package.seeall)

require "stdlib.class.NameMap"

function logClassStyle(format, ...)
--   print(string.format(format, ...))
end

nameId = 0
undefined = {}
--print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@undefine:" .. tostring(undefined))
--print(debug.traceback())

function setmetatableAndCopyMetaMethods(t, mt)
   setmetatable(t, mt)
   t.__tostring = mt.__tostring
end

ObjectProto = {}
ObjectProto.__index = ObjectProto

--instance methods
function ObjectProto:address()
   --这个函数性能是个问题。。。暂时注释掉。
   if not DEBUG then
      return ""
   end

   local addr = rawget(self, "___address")
   if addr then
      return addr
   end

   addr = table.address(self)
   rawset(self, "___address", addr)
   return addr
end

function ObjectProto:init(...)
end

function ObjectProto:__tostring()
--[[   if self.class == nil then
      print(debug.traceback())
      print(self:address())
   end
]]
   if not DEBUG then
      return ""
   end

   if self.class then
      return self.class.className .. ":" .. self:address()
   else
      --is a prototype
      return self.constructor.className .. ".prototype:" .. self:address()
   end
end

function ObjectProto:tostring()

end

function ObjectProto:isKindOf(cls)
   if cls == nil then
      return false
   end

   local objcClass = self.class
   while objcClass do
      if objcClass == cls then
         return true
      else
         objcClass = objcClass.superclass
      end
   end
   
   return false
end

function ObjectProto:isInstanceOf(cls)
   if cls == nil then
      return false
   end

   return cls == self.class
end

function ObjectProto:getPropMap(key)
   return self.class.initProperties[key]
end

function ObjectProto:getterName(key)
   print("######################")
   print("getkey:" .. key)
   if key == nil then
      error("cannot recognize " .. key .. " getter name");
   end

   local propMap = self.class.initProperties[key]
   if propMap then
      return propMap.getterName
   else
      return nil
   end

   return nil
end

function ObjectProto:setterName(key)
   if key == nil then
      error("cannot recognize " .. key .. " setter name");
   end

   local propMap = self.class.initProperties[key]
   if propMap then
      return propMap.setterName
   else
      return nil
   end

   return nil
end

function ObjectProto:realPropName(key)
   if key == nil then
      error("cannot recognize " .. key .. " real name");
   end

   local propMap = self.class.initProperties[key]
   if propMap then
      return propMap.realPropName
   else
      return nil
   end

   return nil
end

function ObjectProto:propChangedEvtName(key)
   if key == nil then
      error("cannot recognize " .. key .. " prop changed evt name")
   end

   local propMap = self.class.initProperties[key]
   if propMap then
      return propMap.changedEvtName
   else
      return nil
   end

   return nil
end


--All Class's base class
Object = {}
Object.prototype = ObjectProto
ObjectProto.constructor = Object
Object.className = "Object"

--MetaObjectProto
MetaObjectProto = {}
MetaObjectProto.__index = MetaObjectProto

function MetaObjectProto:override(methodName, method)
   self.prototype[methodName] = method
end

--object constructor
local initMixins = function(obj, cls)
   if cls.__mixins then
      local mixins = {}
      obj.mixins = mixins

      for key, mixin in pairs(cls.__mixins) do
         mixins[key] = mixin(obj)
      end
   else
      obj.mixins = {}
   end
   --[[
   obj.mixins = table.map(cls.__mixins,
                          function(mixin, key)
                             local m = mixin(obj)
                             return m
   end)
]]
end

local doSetter = function(obj, setterName, val)
   obj[setterName](obj, val)
end

local processInitializedProperties = function(cls, obj)
   local initProperties = nil
   
   if not cls.initProperties then return end

   for i, propMap in pairs(cls.initProperties) do
      local val = propMap.initV
      if val ~= undefined then 
         if propMap.needCopy then
            local newVal = {}
            for key, v in pairs(val) do
               newVal[key] = v
            end
            
            doSetter(obj, propMap.setterName, newVal)
            --obj[propMap.setterName](obj, newVal)
         else
            doSetter(obj, propMap.setterName, val)
--            obj[propMap.setterName](obj, val)
         end
      end
   end
end

local notF = function()
   return false
end

local yesF = function()
   return true
end

MetaObjectProto.__call = function(cls, ...)
   local self = setmetatable({}, cls.prototype)
   
   self.class = cls

   initMixins(self, cls)

   self.isIniting = yesF
   self.isBeforeInit = yesF

   if cls.processInitProperties then
      cls.processInitProperties(cls, self)
   else
      processInitializedProperties(cls, self)
   end

   self.isBeforeInit = notF

   if cls.init then
         self:init(...)
   end

   self.isIniting = notF

   return self
end

--MetaObject
MetaObject = {}
MetaObject.className = "MetaObject"
MetaObject.prototype = MetaObjectProto
MetaObjectProto.constructor = MetaObject

Object.class = MetaObject
setmetatable(Object, MetaObjectProto)

--MetaObject继承自Object
setmetatableAndCopyMetaMethods(MetaObjectProto, ObjectProto)
MetaObject.superclass = Object


--MetametaClass
MetaClassProto = {}
MetaClassProto.__index = MetaClassProto

function processMixins(cls, mixins)
   --1. collection all mixins
   local superCls = cls.superclass
   local allmixins = table.shallowcopy(mixins)

   while superCls do
      if superCls.__mixins then
         for k, v in pairs(superCls.__mixins) do
            if allmixins[k] == nil then
               allmixins[k] = v
            end
         end
      end

      superCls = superCls.superCls
   end

   --2. 将mixins中所有导出的方法平坦到cls.prototype中，superclass的mixins不需要平坦
   table.each(allmixins, 
              function(mixin, name)
                 local methods = mixin:methods()
                 table.each(methods,
                            function(method)
                               cls.prototype[method] = function(obj, ...)
                                  local mixin = obj.mixins[name]
                                  return mixin[method](mixin, ...)
                               end
                 end)
   end)

   cls.__mixins = allmixins
end

function createClass(base,clsName)
   --construct new class
   local newClsProto = {}
   local newCls = {}
   newClsProto.constructor = newCls
   newCls.prototype = newClsProto
   newClsProto.__index = newClsProto
   
   --derive from base
   newCls.superclass = base
   setmetatableAndCopyMetaMethods(newClsProto, base.prototype)
  
   --metaclass
   local newMetacls = {}
   local newMetaclsProto = {}
   newMetacls.className = "Meta" ..  clsName
   newMetacls.prototype = newMetaclsProto
   newMetaclsProto.constructor = newMetacls
   newMetaclsProto.__index = newMetaclsProto
   
   --newcls需要构造函数，这在lua中必须设置其metacls protype的__call字段
   newMetaclsProto.__call = base.class.prototype.__call

   --metaclass is derive from base's metaclass
   newMetacls.superclass = base.class
   setmetatableAndCopyMetaMethods(newMetaclsProto, base.class.prototype)

   --newmetaclass's class is metaclass
   newMetacls.class = MetaClass
   setmetatable(newMetacls, MetaClass.prototype)

   newCls.class = newMetacls
   setmetatable(newCls, newMetaclsProto)

   return newCls, newClsProto
end

local processClassProperties = function(cls, props)
--   logClassStyle("process properties:%s", table.tostring(props))

   local propertyMaps = {}
   for k, v in pairs(props) do
      propertyMaps[k] = {
         propName = k,
         realPropName = NameMap[k][1],--"_" .. k,
         getterName = NameMap[k][2],--string.getterName(k),
         setterName = NameMap[k][3],--string.setterName(k),
         changedEvtName = NameMap[k][4],--string.propChangeEvtName(k),
         applyName = NameMap[k][5],--string.applyName(k),
         initV = v,
         needCopy = getmetatable(v) == nil and type(v) == 'table',
      }
   end

   for key, propMap in pairs(propertyMaps) do
      cls.prototype[propMap.getterName] = function(self, errorArg)
         if errorArg ~= nil then
            error("getter do not need more than one params");
         end

         return self[propMap.realPropName]
      end

      cls.prototype[propMap.setterName] = function(self, newVal, bAlwaysFireEvent)
         local oldVal = self[propMap.realPropName]
         local applier = self[propMap.applyName]

         if applier then
            newVal = applier(self, oldVal, newVal)
         end
         
         if oldVal == newVal and bAlwaysFireEvent ~= true then
            return self
         end
         
         self[propMap.realPropName] = newVal

         --需要派发属性修改事件给self
         local evtName = propMap.changedEvtName
         local selfListener = self[evtName]
         if selfListener then
            selfListener(self, propMap.propName, oldVal, newVal)
         end

         if propMap.propName == "orientation" then
            print("orientation changed", newVal)
         end
         --看下是否需要派发事件给observer
         local fireEvent = self["fireEvent"]
         if fireEvent then
            fireEvent(self, evtName, propMap.propName, oldVal, newVal)
         end

         return self
      end
   end
   
   --need merge initproperties, 省的每次初始化都要遍历整个class链
   local mergeProeprties = nil
   mergeProeprties = function(cls)
      if cls.initProperties then
         for k, v in pairs(cls.initProperties) do
            if propertyMaps[k] == nil then
               propertyMaps[k] = v
            end
         end
      end

      if cls.superclass then
         mergeProeprties(cls.superclass)
      end
   end
   
   if cls.superclass then
      mergeProeprties(cls.superclass)
   end

   cls.initProperties = propertyMaps

   return true
end

function processMethods(cls, methods)
   local proto = cls.prototype
   if methods then
      for key, v in pairs(methods) do
         proto[key] = v
      end
   end
end

function processStaticMethods(cls, methods)
   local metacls = cls.class.prototype
   if not methods then 
      return
   end

   for k, v in pairs(methods) do
      metacls[k] = v
   end
end

MetaClassProto.__call = function(self, name, config)
   config = config and config or {}
   local base = config.base and config.base  or Object
   local properties = config.properties and config.properties or {}
   local mixins = config.mixins and config.mixins or {}
   local statics = config.statics
   local methods = config.methods

   logClassStyle("create class, base:%s", base:address())

   local newCls, newClsProto = createClass(base, name)
   logClassStyle("newed class:%s, classproto:%s", newCls:address(), newCls.prototype:address())
   newCls.className = name

   --process mixins
   processMixins(newCls, mixins)

   --process properties
   processClassProperties(newCls, properties)

   --process methods
   processMethods(newCls, methods)
   
   --process static methods
   processStaticMethods(newCls, statics)

   return newCls
end

function MetaClassProto:override(methodName, method)
   self.prototype[methodName] = method
end

MetaClass = {}
MetaClass.className = "MetaClass"
MetaClass.prototype = MetaClassProto
MetaClassProto.constructor = MetaClass

--MetaClass继承自Object
MetaClass.superclass = Object
setmetatableAndCopyMetaMethods(MetaClassProto, Object.prototype)

--MetaClass' class is MetaClass
MetaClass.class = MetaClass
setmetatable(MetaClass, MetaClassProto)

--MetaClass is MetaObject's class
MetaObject.class = MetaClass
setmetatable(MetaObject, MetaClassProto)


Class = function(name, config)
   if name == nil then
      name = "Anonymous" .. nameId
      nameId = nameId + 1
   end

   return MetaClass(name, config)
end



logClassStyle("Object:" .. Object:address())
logClassStyle("ObjectProto:" .. Object.prototype:address())

logClassStyle("MetaObject:" .. MetaObject:address())
logClassStyle("MetaObjectProto:" .. MetaObject.prototype:address())

logClassStyle("MetaClass:" .. MetaClass:address())
logClassStyle("MetaClassProto:" .. MetaClass.prototype:address())

