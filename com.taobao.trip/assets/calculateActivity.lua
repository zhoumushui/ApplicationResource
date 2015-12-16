local json = require('cjson')
local rawParam='{"actList":[{"actId":"2_35","actName":"直减50元","actRule":{"actInfo":{"id":"35","isCashVoucher":false,"isCheckSMRZ":false,"label":"国航旗舰店独享，优惠券HB22，下单自动直减50元","name":"直减50元","perfType":"PERF_DIRECT","subType":"PERF_DIRECT_1"},"actTicketTotalPrice":"{adultTicketNums}*{adultTicketPrice}","activityPrice":0,"allowSplit":false,"canMultiPerf":true,"closeInsureProfit":false,"condition":"{totalTicketNums}>=1&&{adultTicketNums}>=0&&{adultTicketNums}*{adultTicketPrice}+{childTicketNums}*{childTicketPrice}>=0","includeAdult":true,"includeBaby":false,"includeBigChild":true,"includeChild":false,"includeOld":true,"maxBenefitPassenger":9,"maxOrderPerfNum":0,"minOrderPassenger":1,"minOrderPerfNum":0,"multiAdultTicketNum":0,"perfMoneyFormula":"(({adultTicketPrice}-100)>5000?5000:({adultTicketPrice}-100))*{adultTicketNums}"},"actType":"1","mixType":"2","multiSelectInGroup":false,"orderText":"国航旗舰店独享，优惠券HB22，下单自动直减50元","selected":false,"typeName":"优惠券"}],"ffaInfo":{"alipayCertifiedUserName":"刘天一","allowActiveUser":0,"isActive":1,"name":"","pinYinNames":["刘天一","LIU/TIAN/YI","刘TIANYI","刘天YI","刘天一"],"point":18},"orderInfo":{"adultNum":1,"adultPrice":130000,"babyNum":0,"childNum":0,"childPrice":0,"oldNum":0},"passengerList":[{"certList":[{"birthday":"1981-02-25","certNumber":"350602198102250214","certType":"0","defaultTag":"true","firstName":"","lastName":"","name":"测试","pinyin":""}],"displayName":"测试","feature":"0","passengerId":"230876419"}]}'
function processJSExpression(expression, orderInfo)
	expression = string.gsub(expression, '({totalTicketNums})', tostring(orderInfo['adultNum'] + orderInfo['childNum']))
	expression = string.gsub(expression, '({adultTicketNums})', tostring(orderInfo['adultNum']))
	expression = string.gsub(expression, '({childTicketNums})', tostring(orderInfo['childNum']))
	expression = string.gsub(expression, '({adultTicketPrice})', tostring(orderInfo['adultPrice']))
	expression = string.gsub(expression, '({childTicketPrice})', tostring(orderInfo['childPrice']))		
	expression = string.gsub(expression, '(&&)', ' and ')
	expression = string.gsub(expression, '(||)', ' or ')
	expression = string.gsub(expression, '(?)', ' and ')
	expression = string.gsub(expression, '(:)', ' or ')
	expression = string.gsub(expression, '(!=)', '~=')	
	expression = string.gsub(expression, 'parseInt', 'math.floor')
	return loadstring('return ' .. expression)
end

function caculateActivityPrice(actRule, orderInfo)
	local activityPrice = processJSExpression(actRule['perfMoneyFormula'], orderInfo)()
	local actTicketTotalPrice = processJSExpression(actRule['actTicketTotalPrice'], orderInfo)()

	actRule['perfMoneyFormula'] = nil
	actRule['actTicketTotalPrice'] = nil

	local multiAdultTicketNum = tonumber(actRule['multiAdultTicketNum'])
    multiAdultTicketNum = multiAdultTicketNum == 0 and 1 or multiAdultTicketNum
    local activityNums = math.floor(orderInfo['adultNum'] / tonumber(actRule['multiAdultTicketNum']))
    local maxOrderPerfNum = tonumber(actRule['maxOrderPerfNum'])
	local orderPerfNum = (activityNums < maxOrderPerfNum) and activityNums or maxOrderPerfNum
-- 单张或单组向上取整
	local activitySinglePrice = math.ceil(activityPrice / orderPerfNum / 100) * 100
-- 多人成行活动情况,后端没有给出活动票总金额，需要自己判断
	if multiAdultTicketNum > 1 then
		actTicketTotalPrice = orderInfo['adultPrice'] * multiAdultTicketNum * orderPerfNum
	end

	if activityPrice >= actTicketTotalPrice then
		activityPrice = actTicketTotalPrice - 10000 * orderPerfNum
	end

-- 向上取整
	activityPrice = math.ceil(activityPrice / 100) * 100
	actRule['activityPrice'] = activityPrice

-- 判断保险分润是否支持
	activityPrice = activityPrice / (multiAdultTicketNum * orderPerfNum)
	local singleAdultPrice = orderInfo['adultPrice'] - activityPrice

	local insureMinPrice = 2100 --actRule['insureMinPrice'] and actRule['insureMinPrice'] or 0

	if singleAdultPrice < insureMinPrice then
		actRule['closeInsureProfit'] = true
	else
		actRule['closeInsureProfit'] = false
	end
end

function filterName(name)
   name = string.lower(name)
   name = string.gsub(name,' ','')
   name = string.gsub(name,'/','')
   name = string.gsub(name,',','')
   name = string.gsub(name,'-','')
   return name
end

function filterActivityList(rawParam)
	local param = json.decode(rawParam)
	local actList = param['actList']
	local orderInfo = param['orderInfo']
	local passengerList = param['passengerList']
	local ffaInfo = param['ffaInfo']
	local vouList=param['vouList']
  local couList=param['couList']
	local validList = {}	
	for i,v in ipairs(actList) do
		local actRule = v['actRule']
		if processJSExpression(actRule['condition'], orderInfo)() then			
			if actRule['actInfo']['isCashVoucher'] ~= nil and 
				actRule['actInfo']['isCashVoucher'] == true and ffaInfo ~=nil then
				local flag = false
				local pinyinNames = ffaInfo['pinYinNames']
				for i,passenger in ipairs(passengerList) do
                   for i,pinyin in ipairs(pinyinNames) do
                      local certList = passenger['certList']
                      print(json.encode(certList))
                      for i, cert in ipairs(certList) do
					  if cert['name'] ~= nil and
						pinyin ~= nil then
						local passengername = filterName(cert['name'])
                        local pinyinname = filterName(pinyin)
                      if passengername == pinyinname then
                         flag = true
                      end
                      end
                  end
                end
            end

				if flag then
					actRule['condition'] = nil
					table.insert(validList, v)
				end
            elseif actRule['actInfo']['isCheckSMRZ'] == true and ffaInfo ~= nil then
            local flag = false
            local alipayName = ffaInfo['alipayCertifiedUserName']
            for k,passenger_cert in ipairs(passengerList) do
              local certList_alipay = passenger_cert['certList']
              for v,cert_alipay in ipairs(certList_alipay) do
                local passengername_alipay = filterName(cert_alipay['name'])
                if passengername_alipay == alipayName then
                  flag = true
                end
              end  
            end

          if flag then
          actRule['condition'] = nil
          table.insert(validList, v)
          end

			else
				actRule['condition'] = nil
				table.insert(validList, v)
			end
		end
	end
	--过滤,如果isCashVoucher=true则放在下面,false放在上面
	local cash = {}
    	local nocash = {}
    	local sortList = {}
    
    for i,v in ipairs(validList) do
         local actRule = v['actRule']
         if actRule['actInfo']['isCashVoucher'] ~= nil and 
				actRule['actInfo']['isCashVoucher'] == true then
                table.insert(cash,v)
            else
                table.insert(nocash,v)
            end
         end
    for i,v in ipairs(nocash) do
            table.insert(sortList,v)
        end
    for i,v in ipairs(cash) do
            table.insert(sortList,v)
        end
	local resultList = {}
	for i,v in ipairs(sortList) do
		local actRule = v['actRule']
		caculateActivityPrice(actRule, orderInfo)
-- 过滤掉优惠金额<0的活动
		if actRule['activityPrice'] >= 0 and actRule['actInfo']['subType'] ~= "PERF_AFTER_7"  then
            table.insert(resultList, v)
        end 
	end
print(json.encode(resultList))
	local result = json.encode(resultList)
	return result
end

function filterList(list,passengerList,ffaInfo)
  local validList = {}
  for i,v in ipairs (list) do
      local flag = true
      local identifyType = tonumber(v['identifyType'])
      local benefitType  = tonumber(v['benefitType'])
       if benefitType ~= 1 then
              flag = false
       end
         if  identifyType == 1 and ffaInfo ~= nil then
             if isZhifubaoPassenger(passengerList, ffaInfo) == false then
              flag = false
             end   
        end

        if  identifyType == 2 and ffaInfo ~= nil  then
           if passengerNum > 1 then
            flag = false
           end
            
             if isZhifubaoPassenger(passengerList, ffaInfo) == false then
              flag = false
             end 
        end

        if flag then
          table.insert(validList,v)
        end   
  end
return validList
end



function filterCouponActivityList(couponList,orderInfo, passengerList,ffaInfo)
	local passengerNum = table.getn(passengerList)
	local validList = {}
	for i,v in ipairs(couponList) do
		local flag = true
		local maxBenefitPassenger = tonumber(v['maxBenefitPassenger'])
		local minOrderPassenger   = tonumber(v['minOrderPassenger'])
		local identifyType        = tonumber(v['identifyType'])
    local benefitType         = tonumber(v['benefitType'])
		local includeAdult        = v['includeAdult']
		local includeChild        = v['includeChild']
		local includeBaby         = v['includeBaby']
		local includeOld          = v['includeOld']

        if benefitType ~= 1 then
              flag = false
        end

        if passengerNum < minOrderPassenger then
        	  flag = false
        end

        if passengerNum > maxBenefitPassenger then
        	  flag = false
        end

        if  identifyType == 1 and ffaInfo ~= nil then
             if isFFaPassenger(passengerList, ffaInfo) == false then
             	flag = false
             end   
        end

        if  identifyType == 2 and ffaInfo ~= nil  then
        	 if passengerNum > 1 then
        	 	flag = false
        	 end
            
             if isFFaPassenger(passengerList, ffaInfo) == false then
             	flag = false
             end 
        end

        if includeAdult == false then
             local adultNum =orderInfo['adultNum']
             if adultNum > 0 then
              flag=false
             end
        end

        if includeChild == false then
             local childNum =orderInfo['childNum']
             if childNum > 0 then
              flag=false
             end
        end

        if includeBaby == false then
             local babyNum =orderInfo['babyNum']
             if babyNum > 0 then
              flag=false
             end   
        end

        if includeOld == false then
             local oldNum =orderInfo['oldNum']
             if oldNum > 0 then
              flag=false
             end     
        end

        if flag then
        	table.insert(validList,v)
        end	  
	end
	return validList
end

function  isFFaPassenger(passengerList, ffaInfo)
	if ffaInfo == nil then
	   return true 
    end

	local pinyinNames = ffaInfo['pinYinNames']
    local passengerFlag = false

    for i,passenger in ipairs(passengerList) do
              for i,pinyin in ipairs(pinyinNames) do
                   local certList = passenger['certList']
                    for i, cert in ipairs(certList) do
					  if cert['name'] ~= nil and
						pinyin ~= nil then
						local passengername = filterName(cert['name'])
                        local pinyinname = filterName(pinyin)
                      if passengername == pinyinname then
                         passengerFlag = true
                      end
                      end
                    end
              end      
     end
     return passengerFlag

end
function  isZhifubaoPassenger(passengerList, ffaInfo)
  if ffaInfo ==nil then
    return true
  end
  local alipayName = ffaInfo['alipayCertifiedUserName']
  local passengerFlag = false
            for k,passenger_cert in ipairs(passengerList) do
              local certList_alipay = passenger_cert['certList']
              for v,cert_alipay in ipairs(certList_alipay) do
                if cert_alipay['name']~=nil and alipayName~=nil then
                local passengername_alipay = filterName(cert_alipay['name'])
                if passengername_alipay == alipayName then
                  passengerFlag = true
                end
              end  
            end
          end
    return passengerFlag
end
local actList=filterActivityList(rawParam)
print(json.encode(actList))