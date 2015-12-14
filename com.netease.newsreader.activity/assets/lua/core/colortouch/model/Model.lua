-----------------------------------

--Model机制实现。主要包括了普通Model和ListModel的实现逻辑，


--Change Log:
--2015.02.06
--针对问一问特殊的服务器接口（为"/index/flows/$offset/$limit"形式）做扩展，支持interface中$offset/$limit通配符得使用
--[[
	MainPageListModel = Class.Class("MainPageListModel",
				{
					base = ListModel,
					properties={
						httpClient = createHttpClient(getApplication().url),
						
						dataGetter = {
							method = "GET",
							interface = "/index/flows/$offset/$limit/hot/$keyword",
							body={
								keyword
							},
						},

						dataMapping = {
							questionList = {
								modelClass = QuestionModel,
								jsonField = "#data",
							},
						},
					},
				})
]]


--2015.02.08
--抽离出httpResponseProcess preprocessDataGetter两个可重用方法，简化数据请求、数据保存接口逻辑
--在问一问项目中调试通过

--2015.02.09
--部分可复用逻辑抽离成单独方法，精简逻辑

--2015.02.10
--relation扩展支持用户自定义方法

--2015.02.11
--支持Model的被普通Model复用时的数据获取机制
--支持上述情况下relatin中自定义func的数据获取
--Model对url中用户自定义通配符的支持
-----------------------------------

function ErrorAlert(msg)
	if not msg then
	 	return 
	 end

	local msgStr = tostring(msg)
	if type(msgStr) ~= "string" then
		return 
	end
	error("\n\t\t ***************** " .. msgStr .. " ***************** \n", 2)
end

-- table 深拷贝
function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end  -- if
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end  -- for
        return setmetatable(new_table, getmetatable(object))
    end  -- function _copy

    return _copy(object) and _copy(object) or {}
end  -- function deepcopy

function createHttpClient(serverUrl)
	local app = getApplication()
	local httpComponent = app:getHttpComponent()
	if not httpComponent or not serverUrl then
		ErrorAlert(" createHttpClient Error!! Params can't be nil!!")
		return
	end

	local httpClient = {}
	httpClient._httpComponent = httpComponent
	httpClient._serverUrl = serverUrl
	return httpClient
end


--Model的全局定义
local supportedHttpMethods = {GET = true, POST = true, PUT = true, }

local defaultRequestLimit = 10



------------------------------------------------------------------------
--和TableView中每个实际cell（也就是会被循环重用的cell）一一关联的IntermediateModel定义
--其内部容纳了真正的Model对象
IntermediateModel = Class.Class("IntermediateModel",
		{
			properties={
				model = Class.undefined,	--真正容纳数据的Model

				bLoadingComplete = false,	--复用普通Model的事件机制去触发data-->view的push
			},
			mixins={
				observable = Observable,
			},
		})



--每次有新的Model赋给IntermediateModel的时候，要建立其与实际Model的变化监听
--同时释放与旧的Model的变化监听
local cb = function(scope, userdata, prop, old, new)
	scope:setBLoadingComplete(true)
end

function IntermediateModel.prototype:onModelChanged(prop, old, new)
	--斩断旧的Model与cellView之间的DataBinding
	if old then
		old:uns("onBLoadingCompleteChanged")
	end
end

function IntermediateModel.prototype:isLoadingComplete()
	return self._model and self._model:isLoadingComplete()
end
------------------------------------------------------------------------
--Http Cache选项
HttpCachePolicy = {
	IgnoreCache = 0,
	UseCacheIfExisted = 1,
}

Model = Class.Class("Model",
		{
			properties = {
				httpClient = Class.undefined, 	 --http协议支持组件

				rawData = Class.undefined,		 --容纳收到来自服务器返回的(json)
				data = Class.undefined,      	 --容纳收到来自服务器返回的(json)并经过dataMapping解析过后的数据

				dataGetter = Class.undefined,    --支持传入table，或者用户自定义的function
				dataMapping = Class.undefined, 	 --用于指定服务器返回的json数据结构与Model自身数据结构之间的映射
				dataSetter = Class.undefined,    --支持传入table，或者用户自定义的function
				dataToSave = Class.undefined,	 --记录要向服务器同步的数据字段有哪些

				wildcards = Class.undefined,	 --某些接口中需要填充数据而使用通配符，此处即容纳所有发送请求是需要去替换通配符的数据

				cachePolicy = Class.undefined,   --Http Component的缓存使用策略
				bUsedAsContainment = false,	     --是否被其他Model所包容,这种情况下数据请求由其宿主完成并传递给当前model
				
				bLoadingData = false,			 --数据请求过程中得各种标志位如下
				bLoadingComplete = false,
				bLoadingFailed = false,
				bAllLoadingFinished = false,     --是否已请求完所有数据，即loadMore(如果存在)不再可能请求到数据

				bUploadingData = false,			 --数据上传过程中得各种标志位如下
				bUploadingComplete = false,
				bUploadingFailed = false,

				bDataChanged = false,			--数据被改变的时候也会抛出事件触发Data Binding执行

				p_bOffsetSpecifiedInUrl = false,--部分服务器要求以url方式传递offset时，此选项为true
				p_bLimitSpecifiedInUrl = false,	--部分服务器要求以url方式传递limit时，此选项为true
			},
			mixins={
	            observable=Observable,
	         }
		})

--[[

MyModel = Class.Class("MyModel",
	{
		base = Model,
		properties={
			dataGetter = {
				method="GET", 				--http method类型
				interface="/getMainInfo",	--服务器查询的借口
				requestHeader = {			--http header定义
					os="ios",			
					....
				},
				body={						--http body定义
					--userToken可以在Model实例化时指定
					--userToken = 12345,
					....
				},					
			},
			--或者getter可以用自定义的方法替代,如
			--getter = function(model) .... end,	
			
			dataSetter = {
				method="POST",
				interface = "/setMainInfo",
				requestHeader = {
					os="ios",
					...
				},
				body={
					--userToken可以在Model实例化时指定
					--userToken = 12345,
					.....
				},
			},
			--跟getter一样，setter可以用自定义的方法替代,如
			--setter = function(model) .... end,
			
			dataMapping	 ...,
	})


--commonProperties代表的是dataGetter和DataSetter中都会在body中带上的属性
local model = MyModel({commonProperties={userToken=12345,} cachePolicy = "FirstCacheThenRequest",},--cachePolicy指定缓存策略
	                    function(model) ...end,
	                    function(error) ...end)



]]

function Model.prototype:init(inlineprops, responseCheckCb, successCb, errorCb)
	ctLog("\n ++++++++++++++++++++++++++++++++++  ModelName:", self.class.className, " inlineprops: ", table.tostring(inlineprops))
	if not inlineprops then
		inlineprops = {}
	end

	for k, propMap in pairs(self.class.initProperties) do
		if propMap.initV ~= Class.undefined then
			self[propMap.realPropName] = propMap.initV
		end
	end

	for k,v in pairs(inlineprops) do
		local realPropName = "_" .. k
		self[realPropName] = v
	end

	ctLog("\n ------> httpClient: ", table.tostring(self._httpClient))

	if not self._httpClient and not self._bUsedAsContainment then
		ctLog(debug.traceback())
		ErrorAlert(" Model Initing HttpClient Error!!")
		return	
	end
	

	if self._dataGetter and type(self._dataGetter) ~= "function" and type(self._dataGetter) ~= "table" then
		if not self._bUsedAsContainment then
			ErrorAlert(" Model Initing DataGetter Error!!")
			return
		end
	elseif self._dataGetter then
		self:initDataGetter()
	end


	--optional
	if self._dataSetter and type(self._dataSetter) ~= "function" and type(self._dataSetter) ~= "table" then
		if not self._bUsedAsContainment then
			ErrorAlert(" Model Initing DataSetter Error!!")
			return
		end
	elseif self._dataSetter then		
		self:initDataSetter()	
	end

	if not self._data then
		self._data = {} 
	end

	--分别对返回数据进行检查、网络请求成功、网络请求失败三种情况下地回调
	self._responseCheckCb = responseCheckCb
	self._successCb = successCb
	self._errorCb = errorCb
	self:initDataMapping()	
end


--处理所有可能在URL接口中出现的通配符，如$offset/$limit/....
function Model.prototype:processAllWildcards( )
	
end

--对dataGetter进行预处理，主要是针对要根据 offset/limit去定制interface的情况，如问一问
--offset/limit在interface中通配符为 $offset / $limit
--处理完后将返回修正过的 requestBody, url
function Model.prototype:preprocessDataGetter(configBody, bRefresh)
	if not bRefresh then
		bRefresh = false
	end
	--拷贝出body
	local requestBody = deepcopy(configBody)
	--commonProperties平坦到http body中去
	if self._commonProperties then				
		for propName, prop in pairs(self._commonProperties) do
			requestBody[propName] = prop
		end
	end

	local serverUrl = self._httpClient._serverUrl
	local interface = self._dataGetter.interface
	ctLog("\n ==========> preprocessDataGetter get param url: ", serverUrl, "  interface:",interface)
	--记录最终的url
	local url	

	--检查URL规则中是否存在通配符$offset/$limit
	local bOffset = string.find(interface,"$offset")
	if bOffset then
		self._p_bOffsetSpecifiedInUrl = true
	end
	local bLimit = string.find(interface, "$limit")
	if bLimit then
		self._p_bLimitSpecifiedInUrl = true
	end


	--处理其他与Model数据获取无关，但用户关心的通配符，如$keyword/$id等
	if self._wildcards then
		for name, value in next ,self._wildcards do
			repeat
				if type(name) ~= "string" then
					break
				end
				local wildcardName = "$"..name
				local bHere = string.find(interface, wildcardName)
				if bHere then
					ctLog("\n  -----------> wildcard", name, "in url is: ", value)
					interface = string.gsub(interface, wildcardName, tostring(value), 1)
				end

			until true
		end
	end

	
	--只对tableView起效
	if self:isKindOf(ListModel) then
		local offset = self:getDataSize()
		local limit = requestBody.limit and requestBody.limit or defaultRequestLimit

		if self._p_bOffsetSpecifiedInUrl then
			--针对数据reload情况特殊处理一下
			if bRefresh then
				offset = 0
			end

			ctLog("\n  -----------> wildcard offset in url is: ",offset)
			interface = string.gsub(interface, "$offset", tostring(offset), 1)
			--清除offset，等于清除requestBody中得offset
			offset = nil
		end
		requestBody.offset = offset

		if self._p_bLimitSpecifiedInUrl then			
			
			ctLog("\n  -----------> wildcard limit in url is: ",offset)
			interface = string.gsub(interface, "$limit", tostring(limit), 1)
			limit = nil
		end			
		requestBody.limit = limit

		url = self._httpClient._serverUrl .. interface	
		
	else --普通Model
		url = self._httpClient._serverUrl .. self._dataGetter.interface		
	end
	ctLog("\n--------------------------------------------------")
	ctLog("	===========> preprocessDataGetter finial url : ", url)
	ctLog(" ===========> preprocessDataGetter final requestBody:",table.tostring(requestBody))
	
	return (requestBody and requestBody or {}), url 
end

function Model.prototype:httpResponseProcess(responseData, error)
	self._bLoadingData = false
	if error then
		ctLog("\n  ----------> DataGetter function error:", error)
		self:setBLoadingFailed(true)
		IToast{text="网络出错啦，请稍后重试"}:show()
		
		if self._errorCb and type(self._errorCb) == "function" then self._errorCb(error) end
		return
	end

	if not responseData then
		ctLog("\n  ----------> DataGetter function no responseData:")
		self:setBLoadingFailed(true)
		IToast{text="网络出错啦，请稍后重试"}:show()
		
		if self._errorCb and type(self._errorCb) == "function" then self._errorCb(" No responseData!!") end
		return
	end

	local body = cjson.decode(responseData)
	--增加对返回response的检查逻辑
	if self._responseCheckCb then
		local bCorrect = self._responseCheckCb(body)
		if not bCorrect then
			self:setBLoadingFailed(true)							
			return
		end
	end

	--[[
	if body.code ~= 200 then
		self:setBLoadingFailed(true)
		IToast{text="网络出错啦，请稍后重试"}:show()		

		if self._errorCb and type(self._errorCb) == "function" then self._errorCb(" ret body.code ~= 200") end				
		return
	end
	]]

	if self._successCb and type(self._successCb) == "function" then self._successCb(body) end		
	return body
end

function Model.prototype:initDataGetter()
	--用户自定义方法去获取数据
	if type(self._dataGetter) == "function" then
		self._realDataGetter = {}
		self._realDataGetter._initialRequestFunc = self._dataGetter

		self._realDataGetter._initialRequestFunc()
		return
	end

	--交给Model本身去请求数据
	local config = self._dataGetter
	
	if not config.interface or type(config.interface) ~= "string"
		or not config.method or not supportedHttpMethods[config.method] then 
		if not self._bUsedAsContainment then
			ErrorAlert(" Model DataGetter Config Error!!")
		end
	end
	
	self._realDataGetter = {}
	self._realDataGetter._initialRequestFunc = function(refreshEndFunc)
	ctLog("\n ================================     Model   Init/Refresh =====")
			if self:isLoadingData() then
				return
			end

			--重新请求数据，则所有数据已加载完毕的flag要清掉
			self._bAllLoadingFinished = false
			self._bLoadingData = true
			self._bLoadingComplete = false
			self._bLoadingFailed = false

			--抽离出去统一处理
			local requestBody,url = self:preprocessDataGetter(config.body, true)
			
			self._httpClient._httpComponent:sendHTTPRequest(url,
				config.method,
				config.requestHeader,
				cjson.encode(requestBody),
				false,
				10,
				function(responseData, error)
					self._bLoadingData = false

					local responseBody = self:httpResponseProcess(responseData, error)

					-- DataMapping执行
					self:processDataMapping(responseBody, refreshEndFunc)
					--ctLog("\n\n -----> Model Get Parsed Data: ", table.tostring(self._data))

					self:setBLoadingComplete(true)		
					ctLog("\n ---------> Model Get Data Ret: dataLoadingComplete!!")

					if refreshEndFunc then refreshEndFunc() end
				end)
		end

	self._realDataGetter._initialRequestFunc()
end

function Model.prototype:initDataSetter()

	local config = self._dataSetter

	if not config.interface or type(config.interface) ~= "string"
		or not config.method or not supportedHttpMethods[config.method] then 
		if not self._bUsedAsContainment then
			ErrorAlert(" Model DataSetter Config Error!!")
		end
	end

	self._bUploadingData = true
	self._bUploadingComplete = false
	self._bUploadingFailed = false


	self._realDataSetter = {}
	self._realDataSetter._uploadingRequestFunc =
		function()			
			local url = self._httpClient._serverUrl .. self._dataSetter.interface


			--要合并config.body(userToken ...)以及当前Model中需要同步到服务器的数据进去
			local requestBody = deepcopy(config.body)

			--commonProperties平坦到http body中去
			if self._commonProperties then				
				for propName, prop in pairs(self._commonProperties) do
					requestBody[propName] = prop
				end
			end

			ctLog("\n +++++++++++++++++++++++  DataToSave: ", table.tostring(self._dataToSave))
			for field,_ in pairs(self._dataToSave) do
				local value = self._data[field] 
				if value ~= nil then
					requestBody[field] = value
				end
			end

			ctLog("\n ****************** DataSetter RequestBody: ", table.tostring(requestBody))

			self._httpClient._httpComponent:sendHTTPRequest(url,
				config.method,
				config.requestHeader,
				cjson.encode(requestBody),
				false,
				10,
				function(responseData, error)
					self._bUploadingData = false

					--通常不需要关心setter执行得到的responseBody，所以不使用httpResponseProcess返回值
					self:httpResponseProcess(responseData, error)
				
					self:setBUploadingComplete(true)					
					ctLog("\n ---------> Model Set Data Ret: dataUploadingComplete!!")

					if self._successCb and type(self._successCb) == "function" then self._successCb(self) end					
				end)
		end

end

function Model.prototype:saveToServer()
	self._realDataSetter._uploadingRequestFunc()
end

function Model.prototype:parseJsonData(jsonData)
end


--[[
--  1. 普通Model 
	dataMapping={		
		userId="userToken",
		deviceId="deviceInfo.deviceId",
		deviceName="deviceInfo.deviceName",
		deviceStatus="deviceInfo.status",	
	},

--  2. 普通Model复用其他Model
DeviceModel:
	dataMapping = {
		deviceId = "deviceId",
		deviceName = "deviceName"	,
		deviceStatus = "status",
	}

	--使用示例
	dataMapping = {
			userId="userToken",
			subModel = 						  	--与普通的字段映射区分开来,"subModel"即最终在生成的对象中映射出的对象名,
												--该名字可自定义,但最好明确是model相关,且不要与普通的映射名冲突, 重要！！！
												--根据json数据的结构，类似的定义可以有多个
				{
					modelClass = DeviceModel,	--设置要复用的Model类为 DeviceModel
					jsonField = "deviceInfo",  --设置复用的Model类对应json中的数据段
				},
		}

--  3. ListModel复用其他Model
DeviceModel:

	dataMapping = {
		deviceId = "deviceId",
		deviceName = "deviceName",
		snapshot = "snapshot",
		deviceStatus = "status",
		ownerId = "ownerId",
	}
	--使用示例
	dataMapping={
		cellModel = 						--与普通Model类似，cellModel即要复用的DataMapping的key，
											--不同的是通常ListModel只会嵌套一种其他Model的DataMapping，
											--换言之，cellModel通常只有一种
			{
				modelClass = DeviceModel,
				jsonField = "#deviceInfo",	--用#号标明是list结构,可以快速识别json中的list结构
			}
	},


]]

function createJsonDataRecursionParseFunc(jsonPath)
	local rawString = string.trim(jsonPath)

	return 
		function(jsonData)			
			local t = nil
			for path,_ in string.gmatch(rawString, "%w+") do
				t = jsonData[path]

				if not t or not type(t) == "table" then
					return nil
				end
				jsonData = t
			end
			return t
		end 
end

function Model.prototype:initDataMapping()
	
	self._dataMappingq = {}
	self._dataMappingq._originValue = self._dataMapping;
	if not self._dataMapping or type(self._dataMapping) ~= "table" then
		return
	end
	ctLog("\n -------------------------------------------- initDataMapping ")
	local parsedDataMapping = {}
	--k一定要为字符串，v可能是字符串（jsonField）或者table（复用其他Model DataMapping）
	for k,v in pairs(self._dataMapping) do		
		if type(k) ~= "string" then 
			ErrorAlert(" Model Initing DataMapping Error!!")
			return
		end

		if type(v) == "string" then
			local parseFunc = createJsonDataRecursionParseFunc(v)

			--将v转换成function
			parsedDataMapping[k] = parseFunc
		elseif type(v) == "table" then
			-- k 可能是 subModel 之类的自定义name或者 cellModel
			--必须带的两个字段 modelClass/ jsonField
			ctLog(v.modelClass)
			--local a = v.modelClass
			ctLog(v.modelClass:isKindOf(Model))
			ctLog(v.jsonField)
			if v.modelClass --[[and v.modelClass:isKindOf(Model)]] and v.jsonField and type(v.jsonField) == "string" then
				--区分 ListModel的复用 和 普通Model的复用 
				local parseFunc
				local s,e = string.find(v.jsonField, "#")
				if s and s == e then
					--这里取到dataMapping中的cellModel对应的key，
					--用在getCellModelByIndex()中
					self._cellModelsName = k

					self._realJsonField = string.sub(v.jsonField, e+1, -1)
					ctLog("\n *********   realJsonField: ", self._realJsonField)

					parseFunc = function(jsonData)
						local models = {}

						--迭代地去解析json数据
						local jsonProcessFunc = createJsonDataRecursionParseFunc(self._realJsonField)
					
						local rawData = jsonProcessFunc(jsonData)

						--确定返回的List数据结构中是否数据，如果没有，代表已经全部请求完毕
						if not rawData or not next(rawData) then
							self._bAllLoadingFinished = true
						end

						for num, singleData in ipairs(rawData) do
							--实例化cellModel
							local model = v.modelClass{bUsedAsContainment = true}
							model:processDataMapping(singleData, nil)
							model:setBLoadingComplete(true)
							models[num] = model
							ctLog("\n --------------->  CellModel index: ", num ,", modelClass: ", model.class.className)							
						end
						return models
					end
				else
					parseFunc = function(jsonData)
						local model = v.modelClass{bUsedAsContainment = true}
						model.data = model:processDataMapping(jsonData[v.jsonField])
						return model
					end
				end
				
				--将v转换成function
				parsedDataMapping[k] = parseFunc
				ctLog("\n ----------------> parsedDataMapping: ", k, parseFunc)
			end
		end
	end

	self._parsedDataMapping = parsedDataMapping
	--ctLog("\n ------------> generated parsedDataMapping: ", table.tostring(parsedDataMapping))

end

--根据DataMapping去解析jsonData（filtering）,如果未指定dataMapping属性则将直接存储raw data 
--bIncremental 参数用于指定是否是增量更新，即解析出的数据集合是完全替换，还是增量插入原数据集合
function Model.prototype:processDataMapping(jsonData, endFunc, bIncremental)
	if not bIncremental then
		bIncremental = false
	end

	if not jsonData or type(jsonData) ~= "table" then
		ctLog("\n ***************** Error!! HttpResponse is nil !!")		
		if endFunc and type(endFunc) == "function" then
			ctLog("\n ************  endFunc!!", endFunc)
			endFunc()
		end
		self:setBLoadingFailed(true)
		self:setBAllLoadingFinished(true)
		return 
	end

	--缓存一份原始数据
	self._rawData = jsonData

	if not self._parsedDataMapping or type(self._parsedDataMapping) ~= "table" then	
		self._data = jsonData
		ctLog("\n ******* parsedDataMapping: ",table.tostring(self._parsedDataMapping))				
		return
	end

	local parsedData = {}
	for k, parseFunc in next, self._parsedDataMapping do
		parsedData[k] = parseFunc(jsonData)
		--TODO  这里要考虑下如何让用户拿到 自定义的Model复用得到的数据

		--参照张大神意见，数据平坦到self上
		
		local realPropName = "_" .. k
		if not self.realPropName then
			self.realPropName = parsedData[k]
		end

		function getTrueData(t)
			while t and type(t) == "table" and t.isKindOf and t:isKindOf(Model) do
				t = t._data
			end
			return t
		end

		ctLog("\n ********* parsedData: ", getTrueData(parsedData[k]))			
	end

	

	--bIncremental为true，一定是ListModel在执行LoadMore操作，这时候要注意parsedData = {cellModel = {...}}结构
	if bIncremental then
		for k,v in pairs(parsedData) do
			if k == self._cellModelsName then
				if not self._data[self._cellModelsName] then
					self._data[self._cellModelsName] = {}
				end
				for _, cellModel in ipairs(v) do
					ctLog("\n  ***********  cellModelsName: ", self._cellModelsName)
					ctLog("\n  ***********  Inserting idx: ",_ , " cellModel: ",cellModel.class.className)
					table.insert(self._data[self._cellModelsName], cellModel)
				end

			else
				self._data[k] = v
			end
		end
		parsedData = nil
	else
		self._data = parsedData
	end
end

function Model.prototype:isLoadingData()
	return self._bLoadingData 
end

function Model.prototype:isLoadingComplete()
	return self._data and self._bLoadingComplete
end

function Model.prototype:isLoadingFailed() 
	return self._bLoadingFailed
end

function Model.prototype:isAllLoadingFinished()
	return self._bAllLoadingFinished
end

---------------------------------------------------------------------

ListModel = Class.Class("ListModel",
			{
				base = Model,
				properties = {
					cellModelsName = Class.undefined,	--这个是用户在dataMapping之后得到的数据table，在_data中的key

					realJsonField = Class.undefined,	--对应到json数据中的数组结构，也就是tableView所展示的数据来源集合

					bSupportLoadMore = true,			--该ListModel是否支持加载更多的请求方式，默认为true，即支持ListModelTableAdapter调用
					bSupportRefresh = true,				--该ListModel是否支持刷新数据的请求方式，默认为true，即支持ListModelTableAdapter调用

				}			
			})

function ListModel.prototype:init(inlineprops, successCb, errorCb)
	Model.prototype.init(self, inlineprops, successCb, errorCb)
end

function ListModel.prototype:getCellModelByIndex(index)
	--[[
	if not self:isLoadingComplete() then
		return nil
	end
	]]


	--这里index+1是为了兼容 从0开始的row计数和从1开始数据计数
	if self._cellModelsName then
		return self._data[self._cellModelsName][index+1]
	else
		return self._data[index+1]
	end
end

function ListModel.prototype:getDataSize()
	--[[ 有没有必要拦掉？？？
	if not self:isLoadingComplete() then
		return 0
	end
	]]

	if self._cellModelsName then
		if not self._data then
			return 0
		end
		return  self._data[self._cellModelsName] and #(self._data[self._cellModelsName]) or 0
	else
		return self._data and #(self._data) or 0
	end
end



function ListModel.prototype:initDataGetter()
	ctLog("\n ******************************   ListModel  InitDataGetter  ")

	--Model只生产了初始化请求数据的方法
	Model.prototype.initDataGetter(self)

	--ListModel还要处理LoadMore和Refresh
	if self._bSupportLoadMore then
		self._realDataGetter._loadMoreRequestFunc = function(loadMoreEndFunc)
			ctLog("\n ================================     Model   LoadMore =====")
			if self:isLoadingData() or self:isAllLoadingFinished() then
				return
			end

			self._bLoadingData = true
			self._bLoadingComplete = false
			self._bLoadingFailed = false

			local config = self._dataGetter
			--抽离出去统一处理
			local requestBody,url = self:preprocessDataGetter(config.body)

			self._httpClient._httpComponent:sendHTTPRequest(url,
				config.method,
				config.requestHeader,
				cjson.encode(requestBody),
				false,
				10,
				function(responseData, error)					
					self._bLoadingData = false

					local responseBody = self:httpResponseProcess(responseData, error)

					-- DataMapping执行
					self:processDataMapping(responseBody,loadMoreEndFunc, true)
					--ctLog("\n\n -----> Model Get Parsed Data: ", table.tostring(self._data))

					self:setBLoadingComplete(true)	
					ctLog("\n ---------> Model Get Data Ret: dataLoadingComplete!!")

					if loadMoreEndFunc then loadMoreEndFunc() end
				end)
		end
	end

	if self._bSupportRefresh then
		--处理refresh请求的方法和initial请求方法实际是一样的
		self._realDataGetter = self._realDataGetter and self._realDataGetter or {}
		self._realDataGetter._refreshRequestFunc = self._realDataGetter._initialRequestFunc
	end
end