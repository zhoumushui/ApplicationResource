require "colortouch.tableview.ListModelTableViewAdapter"

function defineRelations(relations)
	--检查relations定义是否正确
	if not relations then
		return nil
	end
	for viewId,singleRelation in pairs(relations) do
		if type(viewId) ~= "string" or type(singleRelation) ~= "table" then
			ErrorAlert(" defineRelations Error!! Invalid Relations")
		end
	end
	return relations
end


function defineActions(actions)
	--检查actions定义是否正确
	if not actions then
		return nil
	end
	for viewId,singleAction in pairs(actions) do
		if type(viewId) ~= "string" or type(singleAction) ~= "table" then
			ErrorAlert(" defineActions Error!! Invalid Actions!!")
		end
		return actions
	end
end

---------------------------------------------------------------------------------------------

--[[ relation/saveRelations/actions 的定义示例
local relations = defineRelation({
							--"img"、"label"等为对应view的id，全局唯一索引以确保找得到
							img={
								--这表明会用Model中data的snapshot字段去填充"img" view的src
								src=snapshot,
							}，
							nameLabel = {
								text=name,
							}
						})

applyRelations(self:getView(), model, relations)

--扩展支持自定义方法

local cellRelation = defineRelations{
	questionLabel = {
		function(data, view)  print(" \n hello world!!")  end
	},
}

local saveRelations = defineRelation(
				{
					desc={
						text = "abstractInfo",
					},
					switch={
						on = "switchStatus",
					}
				}
	)

local actions = defineAction{
			btn = {
				click = function(tableView, model, row) ... end
			},	
		}
]]



--根据Actions定义，为某些事件增加相应地回调方法
--暂只支持 TableView和ListModel；普通view和Model可以直接手动addEventListener
--可以保证的是回调到自定义方法时，会传入tableView、listModel以及row这三个参数
--可以据此取出相应地cellModel并通过这影响其他cellView的逻辑表现
function applyActions(tableView, actions)
	ctLog(" \n +++++++++++++ ListModel Actions: ", table.tostring(actions))
	if not tableView or not actions then
		ErrorAlert(" applyRelations Error!! Not Valid Arguments!!")
		return
	end

	if not tableView:isKindOf(TableView) then
		ErrorAlert(" applyRelations Error!! Not Valid TableView!!")
		return
	end

	local adapter = tableView:getAdapter()
	if not adapter then
		ErrorAlert(" applyActions Error!! You Should Call applyRelations First")
		return
	end
	local listModel = adapter:getModel()
	local relations = adapter:getRelations()
	if not listModel or not relations then
		ErrorAlert(" applyActions Error!! You Should Call applyRelations First")
		return
	end

	adapter:setActions(actions)

	--返回一个可用于销毁已经applied到tableView上之actions的Disposable对象
	return Disposable.Disposable(function()
						print(" 1111111111111111")
						if adapter._appliedActions then
							print("===== ==== ===== ",table.tostring(adapter._appliedActions))
							for num,disposable in pairs(adapter._appliedActions) do
								disposable:dispose()
								print(" ------> num: ", num," disposable:", disposable)
								disposable = nil
							end

							adapter:setAppliedActions(nil)
						end
					end)
end


--现在支持的控件为switchButton、TextField、EditText
local propertyChangedEvent = {on = "valueChanged", text="endEdit",}
local propertyGetterFunc = {on = "isOn", text="getText"}

--普通Model的数据保存关系的定义，会利用dataSetter中得属性
function applySaveRelations(rootView, model, relations)

	if not rootView or not model or not relations then
		ErrorAlert(" applySaveRelations Parameter Error!!")
		return
	end

	if not rootView:isKindOf(Node) then
		ErrorAlert(" applySaveRelations Parameter Type Error!!")
		return
	end
	
	local disposableSet = {}

	local applySaveRelationsFunc = function()
		ctLog("\n ******************************   Executing Relations  ******* ", table.tostring(relations))
		--如果是IntermediateModel，要以其包容的实际Model为数据来源
		if model:isInstanceOf(IntermediateModel) then
			model = model._model
		end

		ctLog(" model data: ", table.tostring(model._data))

		model._dataToSave = model._dataToSave and model._dataToSave or {}
		--viewId为控件的id， singleRelation为data映射关系
		for viewId,singleRelation in pairs(relations) do			
			repeat
				--取得id标示的控件对象
				local view = rootView:query(viewId)				
				if not view then
					break
				end
				if type(singleRelation) ~= "table" then
					ErrorAlert(" applySaveRelations Error! Mapping Definition Error!!")
				end
				--property为控件属性，value为data中字段名
				--记录下所有需要同步到服务器的数据字段
				for property, value in pairs(singleRelation) do
					model._dataToSave[value] = true
				end
				print("\n +++++++++++++++++++++++ Gen DataToSave: ", table.tostring(model._dataToSave))
				for property, value in pairs(singleRelation) do
					repeat
						--获取当前控件上得属性值
						local propertyGetter = propertyGetterFunc[property]
						if not propertyGetter then
							ErrorAlert(" applySaveRelations Error! Mapping Execution Error!!")
							break
						end
						local propertyValue = view[propertyGetter](view)
						if not propertyValue then
							ErrorAlert(" applySaveRelations Error! Mapping Execution Error!!")
							break
						end
						local evtName = propertyChangedEvent[property]
						if not evtName then
							ErrorAlert(" applySaveRelations Error! Mapping Execution Error!!")
							break
						end
						--如果当前控件上得值比较新，那么更新到model中去
						if propertyValue ~= model._data[value] then
							model._data[value] = propertyValue
						end

						local disposable = view:addEventListener(evtName, 
									function()
										 local currentValue = view[propertyGetter](view)

										 print("\n++++++++++++++   View Value Changing To : ", currentValue)
										 if model._data[value] ~= currentValue then
										 	model._data[value] = currentValue
										 end
										 -- 这里先不要触发 model 的 setBLoadingComplete(true)	
										 -- 因为当前ScreenState数据已为最新
										 model:setBLoadingComplete(true)

										 model:saveToServer()
									end)
						table.insert(disposableSet, disposable)
					until true
				end				
			until true
		end
	end

	--执行该方法
	applySaveRelationsFunc()

	return Disposable.Disposable(function() 
					for num, singleDisposable in pairs(disposableSet) do
						singleDisposable:dispose()
						singleDisposable = nil
					end

					disposableSet = nil
				end )
end

function parseRelationPath(index, content)
	local rawString = string.trim(index)
	ctLog("\n **** param index: ",rawString and rawString or "nil")

	local set = content
	local leftPath
	for path,_ in string.gmatch(rawString, "%w+") do
		if type(set) ~= "table" then
			ErrorAlert(" parseRelationPath Error!! content is not a table!! content:", tostring(content))
			return
		end

		--可能嵌套了一个Model对象
		if set.isKindOf and set:isKindOf(Model) then
			set = set._data
		end
		
		ctLog("\n **** Parsing single path: ", path)
		set = set[path]
		--local firstLen = string.len(path)
		--leftPath = string.sub(index, firstLen+2, -1)
		--return t, leftPath		
	end
	return set
end

--面向普通Model
function applyRelations(rootView, model, relations)

	if not rootView or not model or not relations then
		ErrorAlert(" applyRelations Parameter Error!!")
	end

	if not rootView:isKindOf(Node) then
		ErrorAlert(" applyRelations Parameter Type Error!!")
	end

	--此种情况下实际调用的是 applyRelationsWithDelegate
	--达到普通view和tableView使用形式上的统一
	if model:isKindOf(ListModel) and rootView:isKindOf(TableView) then
		applyRelationsWithDelegate(rootView, model, relations)
		return
	end
	
	local applyRelationsFunc = function()
		ctLog("\n ******************************   Executing Relations  ******* ", table.tostring(relations))
		--如果是IntermediateModel，要以其包容的实际Model为数据来源
		if model:isInstanceOf(IntermediateModel) then
			model = model._model
		end

		--ctLog(" model data: ", table.tostring(model._data))

		for viewId,singleRelation in pairs(relations) do
			
			repeat
				--取得id标示的控件对象
				local view = rootView:query(viewId)
				
				if not view then
					break
				end
				if type(singleRelation) ~= "table" then
					ErrorAlert(" applyRelations Error2 !!")
				end

				--扩展支持自定义方法在relation中使用

				for property, index in pairs(singleRelation) do
					repeat
						--从data中取出某字段数据，设置到view的某个属性上
						if type(property) == "string" then
						
							local data = parseRelationPath(index, model._data)
							
							ctLog("\n ++++++++++++  DataBinding, set property:",property," of Value: ", data)
							local propertyFunc = view[string.setterName(property)]
							if not data or not propertyFunc then
								ErrorAlert(" applyRelations Error3 !! ")
							end
							--设置view属性值
							propertyFunc(view, data)

						--该情况为针对view用户自定义的方法，需要手动取数据并设置属性等
						elseif type(property) == "number" and type(index) == "function" then
							index(model._rawData, view)
						end

					until true
				end

				--view:layout()
			until true
		end
	end

	ctLog("\n ******  Model _data", model._data, "  bLoadingComplete: ",model._bLoadingComplete, " className:",model.class.className)
	if model:isLoadingComplete() then		
		applyRelationsFunc()
	else
		model:on("onBLoadingCompleteChanged", applyRelationsFunc)
	end

	return Disposable.Disposable(function() model:uns("onBLoadingCompleteChanged") end)
end

---------------------------------------------------------------------------------------------
--[[

	local relation1 = defineRelation(     --针对类型为 "normalCell"的可重用cell,
					{
						"img" = {
							src=snapshot,
						},
						"label" = {
							text=words,
						}
					})
	local relation2 = defineRelation(     --针对类型为 "biggerCell"的可重用cell
					{
						"img" = {
							src=snapshot,
						},
						"label" = {
							text=words,
						}
					})
					
	--将各种cell的映射关系合并
	local relations = {normalCell=relation1, biggerCell=relation2}

	--某种程度上，可以把adapter看做是MVP中的P(Presenter)
	applyRelationsWithDelegate(self:getView():query("tableView"), model, relations)


	--defineAction 去定义关联到控件上的行为
]]


--面向ListModel
function applyRelationsWithDelegate(tableView, model, relations, delegate)
	ctLog(" \n +++++++++++++ ListModel relations: ", table.tostring(relations))
	if not tableView or not model or not relations or not delegate then
		ErrorAlert(" applyRelations Error!! Not Valid Arguments!!")
	end

	if not tableView:isKindOf(TableView) then
		ErrorAlert(" applyRelations Error!! Not Valid TableView!!")
	end

	--创建TableView要关联的adapter示例
	local adapter = ListModelTableViewAdapter{model = model, relations = relations, delegate = delegate}
	tableView:setAdapter(adapter)

	--可以利用disposable机制销毁已执行的relations
	local disposable = Disposable.Disposable(function() 
												adapter:setRelations(nil)
								  			end)
	return disposable
end

-- 该接口可以使已应用的relation无效化

------------------  有问题需要重写 ----------------
function discardRelation(view, model)
	if not view or not model then
		ErrorAlert(" discardRelation Error!! Not Valid Arguments!!")
		return 
	end
	if view:isKindOf(TableView) and model:isKindOf(ListModel) then

		local adapter = tableView:getAdaptor()
		if adapter then
			adapter:setRelations(nil)
		end
	elseif model:isKindOf(Model) then
		

	end
end