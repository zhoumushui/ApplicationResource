require "stdlib.mixins.Mixin"


Observable = Class.Class("Observable",
                         {
                            base=Mixin,
                            properties={
                               observers={}
                            },

                            statics={
                               methods=function()
                                  return {"on", "un", "fireEvent"}
                               end
                            }
                         }

)

function Observable.prototype:init(owner)
   Mixin.prototype.init(self, owner)
   
   self:setObservers({})
end

function Observable.prototype:_getEvtObservers(evtName)
   local observersMap = self._observers

   local observers = observersMap[evtName]
   if observers == nil then
      observers = {}
      observersMap[evtName] = observers
   end
   
   return observers
end

function Observable.prototype:on(evtName, cb, scope, userData)
   local observers = self:_getEvtObservers(evtName)

   local observerIdx = table.aindexOf(observers, 
                                     function(observer)
                                        return observer.cb == cb and observer.scope == scope and observer.userData == userData
   end)
   
   if observerIdx ~= nil then
      return
   end

   table.insert(observers, {cb=cb, scope=scope, userData=userData})
end

function Observable.prototype:un(evtName, cb, scope, userData)
   if evtName == nil or cb == nil then
      error("parameter error: un event must give evtName and cb");
      return;
   end

   local observers = self:_getEvtObservers(evtName)
   
   table.removeValueByOperator(observers, function(observer)
                                  return observer.cb == cb and observer.scope == scope and observer.userData == userData
   end)
end

function Observable.prototype:uns(evtName)
   if evtName == nil then
      self:setObservers({})
   else
      self:getObservers()[evtName] = {}
   end
end

function Observable.prototype:fireEvent(evtName, a,b,c,d,e,f)
   --mixin也是object，那么他自己对象构建的时候，也会调用到这里来。此时还没有构造好observers
   if self._observers == nil then
      return
   end

   local observers = self._observers[evtName]
   if observers == nil then
      return
   end

   for _, observer in ipairs(observers) do
      observer.cb(observer.scope, observer.userData, a,b,c,d,e,f)
   end
end
