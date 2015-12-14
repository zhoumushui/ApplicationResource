LoadingIndicator = Class.Class("LoadingIndicator",
                         {
                            base=Mixin,
                            properties={
                               --for mask
                               loadingLabel = Class.undefined,
                               loadingDescLabel = Class.undefined,
                               --默认情况下显示系统的菊花
                               loadingCustomView = Class.undefined,

                               showInView = Class.undefined,
                               loadingView = Class.undefined,
                            },

                            statics={
                               methods=function()
                                  return {"showLoading", "hideLoading", "setLoadingProgress",
                                          "","", "","", "",""}
                               end
                            }
                         }

)

function LoadingIndicator.prototype:init(owner)
   Mixin.prototype.init(self, owner)
end


function LoadingIndicator.prototype:showLoading()
   if self._loadingView then
      print("ColorTouch Error: cannot show loading view twice")
      return
   end
   self._loadingView = LoadingView.showLoadingInView(self._showInView, self._loadingLabel, self._loadingDescLabel, self._loadingCustomView)
end

function LoadingIndicator.prototype:hideLoading()
   LoadingView.hideLoadingView()
   self._loadingView = nil
end

function LoadingIndicator.prototype:setLoadingProgress(percent)
   self._loadingView:setProgress(percent)
end
