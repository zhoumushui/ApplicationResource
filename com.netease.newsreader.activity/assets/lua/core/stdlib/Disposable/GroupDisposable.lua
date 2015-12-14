module("GroupDisposable", package.seeall)

GroupDisposable = function()
  local groupDisposable = {
  	_disposables = {},
  }
  
  groupDisposable.dispose = function()
     for i, v in ipairs(groupDisposable._disposables) do
       v:dispose()
     end
     
     groupDisposable._disposables = {}
  end
  
  groupDisposable.addDisposable = function(disposable)
  	if (disposable ~= nil) then
  		table.insert(groupDisposable._disposables, disposable)
  	end
  end

  return groupDisposable
end

return GroupDisposable