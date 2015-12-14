QRView = Class.Class("QRView",
                     {
                        base=Container,
})

--@override
function QRView.prototype:createPlatFormView()
   return PlatformQRView(self)
end


function QRView.prototype:start()
   self._pv:start()
end

function QRView.prototype:stop()
   self._pv:stop()
end