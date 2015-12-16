local json = require('cjson') 
local rawPrarm='{"activityList":[],"flightInfo":{"adultBusinessBackPrice":-1,"agentName":"春秋航空旗舰店","averageTime":60,"backForceInsure":false,"backForceInsurePrice":0,"backInsPromotionPrice":0,"backQijian":false,"backSupportInsp":false,"backSupportItinerary":false,"cheapFlightText":"随身行李额7KG（乌鲁木齐始发航线为5KG），随身行李额加托运行李额总计15KG，随身行李要求不超过20*30*40厘米，托运行李尺寸不超过40*60*100厘米。行李购买需要提前3小时。\n无免费餐食，在线购买餐食需要提前36小时。","childBusinessBackPrice":-1,"childTicketExtraInstruction":[{"tips":"1.2岁(不含)以下需购买婴儿票，无单独座位，婴儿票不能单独购买（必须要有成人票），票价为全价票的10%，不收取机场建设费与燃油费\n2.婴儿票可直接在机场柜台购买，但每个航班可售婴儿票数量有限，如有需要建议尽快联系航空公司购买\n*阿里旅行·去啊暂不提供婴儿票购买服务\n\n","title":"婴儿票(14天-2岁)"},{"tips":"2岁(含)-12岁(不含)买儿童票。票价为全价票50%，不收取机场建设费，燃油收取成人的50%，购买时需要同时购买成人票，一个成人最多携带两名儿童\n\n","title":"儿童票(2岁-12岁)"},{"tips":"12(含)-18岁(不含)的儿童，需要购买成人票（若有活动时，享受的活动类型也与成人相同）\n","title":"儿童票(12-18岁)"}],"childTicketInstruction":"婴儿票(14天-2岁)\n1.2岁(不含)以下需购买婴儿票，无单独座位，婴儿票不能单独购买（必须要有成人票），票价为全价票的10%，不收取机场建设费与燃油费\n2.婴儿票可直接在机场柜台购买，但每个航班可售婴儿票数量有限，如有需要建议尽快联系航空公司购买\n*阿里旅行·去啊暂不提供婴儿票购买服务\n\n儿童票(2岁-12岁)\n2岁(含)-12岁(不含)买儿童票。票价为全价票50%，不收取机场建设费，燃油收取成人的50%，购买时需要同时购买成人票，一个成人最多携带两名儿童\n\n儿童票(12-18岁)\n12(含)-18岁(不含)的儿童，需要购买成人票（若有活动时，享受的活动类型也与成人相同）\n","childWarmPrompt":"购买2岁(含)-12岁(不含)的儿童票时需要同时购买成人票，一个成人最多携带两名儿童","crossAgent":0,"easyFly":false,"flight":[{"airLineName":"春秋航空","airlineCode":"9C","arrAirportName":"周水子机场","arrCityName":"大连","arrTerm":"","arrTime":"2015-09-23 15:10","cabin":"经济舱","cabinNum":8,"depAirportName":"浦东机场","depCityName":"上海","depTerm":"T2","depTime":"2015-09-23 13:25","flightNo":"9C8977","flightType":"A320","isMeal":false,"isStop":false,"ontimeRate":"87%","planeType":"中型机","segmentNum":"00","segmentType":"去程"}],"flightNewTag":[{"desc":"7×24小时服务","highlight":"false","id":"2","name":"7×24服务"},{"desc":"提交自愿退票后极速退款到账","highlight":"false","id":"5","name":"一键退票"},{"desc":"购买航空公司旗舰店机票，行程单可在乘飞机7日内(含乘机当日)，于起降机场柜台或航空公司售票处免费索取","highlight":"false","id":"4","name":"报销凭证"},{"desc":"产品支持销售退票险，退票成功后自动理赔到账","highlight":"false","id":"7","name":"退票险"}],"forceInsurePrice":0,"futureTicket":false,"hasMixAct":0,"infantWarmPrompt":"阿里旅行·去啊暂不提供婴儿票购买服务，婴儿票可直接在机场柜台购买，但每个航班可售婴儿票数量有限，如有需要建议尽快联系航空公司购买","infoTextList":["随身行李额7KG（乌鲁木齐始发航线为5KG），随身行李额加托运行李额总计15KG，随身行李要求不超过20*30*40厘米，托运行李尺寸不超过40*60*100厘米。行李购买需要提前3小时。\n无免费餐食，在线购买餐食需要提前36小时。"],"insPromotionPrice":2000,"insureRuleText":"航意险须知：本订单可享受“航意险+机票”组合优惠15元/成人的套餐，若退票该优惠将从机票退票款中收回，航意险将全额退回。","isForceInsure":true,"isSupportChild":true,"isSupportInsp":false,"itineraryFee":0,"itineraryInvoiceDetailText":"旗舰店订单不支持行程单邮寄，需要在机场打印","itineraryInvoiceShortTip":"卖家提供行程单","itineraryInvoiceText":"等额行程单","itineraryInvoiceTip":"行程单需要在乘机7日内，于起降机场柜台或航空公司售票处免费索取","itineraryShowInfo":[{"canSelect":"false","disableReason":"不可邮寄","showInfo":"行程单"}],"leaveForceInsure":true,"leaveForceInsurePrice":3000,"leaveInsPromotionPrice":2000,"leaveQijian":true,"leaveSupportInsp":false,"leaveSupportItinerary":false,"maxCanBuyNum":8,"maxLimitNum":9,"mileRatio":0,"minLimitNum":1,"mixActList":[],"needChangeRare2Pinyin":false,"needRegister":0,"nonVipPrice":0,"price":[{"cabin":"经济舱","segmentNum":"00","singleAdultOnlyFee":"5000","singleAdultOnlyTax":"0","singleAdultPrice":"62000","singleAdultTax":"5000","singleChildOnlyFee":"0","singleChildOnlyTax":"0","singleChildPrice":"60000","singleChildTax":"0","type":"去程"}],"promotionDesc":"随身行李额7KG（乌鲁木齐始发航线为5KG），随身行李额加托运行李额总计15KG，随身行李要求不超过20*30*40厘米，托运行李尺寸不超过40*60*100厘米。行李购买需要提前3小时。\n无免费餐食，在线购买餐食需要提前36小时。","promotionTitle":"","qijian":true,"retainText":"","score":"6.7","scoreDetail":[{"diffType":"快","diffValue":"8分钟","name":"出票速度","value":"5"},{"diffType":"低","diffValue":"30.4%","name":"服务响应","value":"3"},{"diffType":"持平","diffValue":"0.0分","name":"服务质量","value":"5"},{"diffType":"慢","diffValue":"110小时","name":"退款时长","value":"0"}],"selectYiwai":"1","showCabinInfo":"经济舱","showReverseInfo":[{"modifyIcon":1,"modifyTextShow":"改签费￥30起","refundIcon":1,"refundTextShow":"退票费￥59起","segmentType":0}],"showTicketPrice":"","singleSendLimit":"50000","supportItinerary":false,"totalPrice":62000,"tripType":0,"tuigaiqian":[{"tuigaiqian":"退票手续费：早于起飞前1天(24小时)59元，起飞前1天(24小时)至起飞前2小时118元，起飞前2小时至起飞177元，晚于起飞590元；改期手续费：早于起飞前1天(24小时)30元，起飞前1天(24小时)至起飞前2小时59元，起飞前2小时至起飞118元，晚于起飞590元；不可签转；不可升舱；","type":"去程"}],"tuigaiqianRule":{"leaveRule":[{"desc":"经济舱","id":"1","name":"舱位"},{"desc":"起飞前1天(24小时)前 59元\n起飞前2小时前 118元\n起飞前2小时后 177元\n起飞后 只退机建和燃油\n","id":"5","name":"退票费"},{"desc":"起飞前1天(24小时)前 30元\n起飞前2小时前 59元\n起飞前2小时后 118元\n起飞后 100%\n不可升舱","id":"7","name":"改期费"},{"desc":"不可签转","id":"9","name":"签转"},{"desc":"退改签规则以航空公司最新规定为准","id":"11","name":"儿童票"}]},"vipProduct":0},"itineraryInfo":{"type":0,"valid":false},"passengerList":[{"certType":0,"insureInfo":[]}]}'
--获取机票的成人及儿童的票面价
function getPriceInfo(flightInfo)
	local priceList = flightInfo['price']
	local adultPrice = 0
	local childPrice = 0
	local adultFeeAndTax = 0
	local childFeeAndTax = 0
  local singleAdultOnlyTax = 0
  local singleAdultOnlyFee = 0
  local singleChildOnlyTax = 0
  local singleChildOnlyFee = 0
	for i,price in ipairs(priceList) do
		adultPrice = adultPrice + tonumber(price['singleAdultPrice'])
		childPrice = childPrice + tonumber(price['singleChildPrice'])
		adultFeeAndTax = adultFeeAndTax + tonumber(price['singleAdultTax'])
		childFeeAndTax = childFeeAndTax + tonumber(price['singleChildTax'])
    singleAdultOnlyTax = singleAdultOnlyTax + tonumber(price['singleAdultOnlyTax'])
    singleAdultOnlyFee = singleAdultOnlyFee + tonumber(price['singleAdultOnlyFee'])
    singleChildOnlyTax = singleChildOnlyTax + tonumber(price['singleChildOnlyTax'])
    singleChildOnlyFee = singleChildOnlyFee + tonumber(price['singleChildOnlyFee'])
	end
	
	return adultPrice, childPrice, adultFeeAndTax, childFeeAndTax, singleAdultOnlyTax, singleAdultOnlyFee, singleChildOnlyTax, singleChildOnlyFee
end

--获取机票的成人及儿童的分润金额
function getInsureFee(insuranceList)
	local insureAdultFee = 0
	local insureChildFee = 0

  if insuranceList then
    for i, insurance in ipairs(insuranceList) do
      if tonumber(insurance['insIndex']) == 1 then
        insureAdultFee = tonumber(insurance['insureAdultFee'])
        insureChildFee = tonumber(insurance['insureChildFee'])
        break
      end
  end
  end 
	return insureAdultFee, insureChildFee
end

function getOrderPrice(param)
	local paramOj = nil
	local result = nil

	if type(param) == 'string' then
		paramOj = json.decode(param)
	else 
		paramOj = param
	end

	local flightInfo = paramOj['flightInfo']
	local activity = paramOj['activityList']
	local insuranceList = paramOj['insuranceList']
	local passengerList = paramOj['passengerList']
  local itineraryInfo = paramOj['itineraryInfo']
	local resultList = updateFlightOrderPrice(flightInfo,passengerList,activity,insuranceList, itineraryInfo)

	if type(param) == 'string' then
		result = json.encode(resultList)
	else 
		result = resultList
	end

	return result
end


--flightinfo            为服务端返回信息
--passengerList         乘客信息
--activityList          活动信息
--insuranceList         保险信息
--itineraryInfo         邮寄信息
function  updateFlightOrderPrice(flightInfo, passengerList, activityList, insuranceList, itineraryInfo)
 
    -- 成人数量
    local  adultCount = 0   
    -- 儿童数量  
    local  childCount = 0    
    --计算得出的机票票面价
	local ticketPrice = 0
    -- 订单总价
    local  totalPrice = 0.0  
    --是否支持保险分润
	local bSupportInsurance = false
  --是否关闭分润
  local bCloseInsurance = false
	--是否选择了意外险
	local bSelectYiwaiType = false
	--里程计算比率
	local mileRatio = 0.0
	--单张机票成人及儿童价格
	local adultPrice = 0
	local childPrice = 0
	--机票税费价格
	local adultFeeAndTax = 0
	local childFeeAndTax = 0
  local singleAdultOnlyTax = 0
  local singleAdultOnlyFee = 0
  local singleChildOnlyTax = 0
  local singleChildOnlyFee = 0
	--机票分润金额
	local insureAdultFee = 0
	local insureChildFee = 0
	--税费价格
	local feeAndTax = 0
  --邮寄费用
  local itineraryFee = 0
	--商旅精选价格
	local adultBusinessBackPrice = 0
	local childBusinessBackPrice = 0 
	--价格明细
	local orderPriceList
	  
	local resultList = {}
	local orderPriceList = {}

	if flightInfo then
    	bSupportInsurance = flightInfo['isSupportInsp']

		adultPrice, childPrice, adultFeeAndTax, childFeeAndTax, singleAdultOnlyTax, singleAdultOnlyFee, singleChildOnlyTax , singleChildOnlyFee= getPriceInfo(flightInfo)

		if flightInfo['isForceInsure'] and flightInfo['isForceInsure'] ~= 0 then
			forceInsurePrice = tonumber(flightInfo['forceInsurePrice'])
		end
    if flightInfo['adultBusinessBackPrice'] then 
        adultBusinessBackPrice = tonumber(flightInfo['adultBusinessBackPrice'])
    end 

    if  flightInfo['childBusinessBackPrice'] then
        childBusinessBackPrice = tonumber(flightInfo['childBusinessBackPrice'])
    end 

    if flightInfo['itineraryFee'] then
       itineraryFee = tonumber(flightInfo['itineraryFee'])
    end		
  end

    --判断是否选择意外险
    if insuranceList then 
      for i, insurance in ipairs(insuranceList) do
      if tonumber(insurance['insType']) == 1 then
        if insurance['total_count'] and tonumber(insurance['total_count']) > 0 then
                 bSelectYiwaiType = true
           break
          end
      end
    end 
	end

    --分润价格
	insureAdultFee, insureChildFee = getInsureFee(insuranceList)

    --计算票面价
  for i,v in ipairs(passengerList) do
		local passenger = v 
         if passenger['certType'] == 0 then   
            ticketPrice = ticketPrice + adultPrice
            feeAndTax = feeAndTax + adultFeeAndTax
            ticketPrice = ticketPrice + adultFeeAndTax
            adultCount = adultCount + 1
  
         elseif passenger['certType']  == 1 then
            ticketPrice = ticketPrice + childPrice
            feeAndTax = feeAndTax + childFeeAndTax
            ticketPrice = ticketPrice + childFeeAndTax  
            childCount = childCount + 1
         end   
		print("step 1 ticketPrice is " .. ticketPrice)
	end

	--判断是否要关闭分润
	local single_activity_price = 0
    if bSupportInsurance and activityList then 
    for i,v in ipairs(activityList) do
			local  activityDic = v
            if activityDic['selected'] and activityDic['selected'] == true and activityDic['actType'] and activityDic['actType'] ~= 2 then
            local actRule = activityDic['actRule']
               if actRule  then 
                  if actRule['canMultiPerf'] and actRule['canMultiPerf'] == true then
                      local personCount = adultCount
                     
                      if actRule['includeChild'] and actRule['includeChild'] == true then
                         personCount = adultCount + childCount
                      end 
                     if personCount > 0 then
                     	local temp = actRule['activityPrice']
                     	single_activity_price = single_activity_price + temp / personCount
                     end
                  else 
                     local  maxOrderPerfNum = tonumber(actRule['maxOrderPerfNum'])
                     local temp = actRule['activityPrice']
                     if maxOrderPerfNum > 0 then
                        single_activity_price = single_activity_price + temp / maxOrderPerfNum
                     else
                        single_activity_price = single_activity_price + temp
                     end 	
                  end
               end 
		  end    
	   end

	   if single_activity_price + insureAdultFee * 100 >= adultPrice then
          bCloseInsurance = true
          bSupportInsurance = false
	   end
    end 

    --减去分润价格
	if bSupportInsurance and bSelectYiwaiType then 
       ticketPrice = ticketPrice - insureAdultFee * 100 * adultCount
       ticketPrice = ticketPrice - insureChildFee * 100 * childCount
	end 

	--计算保险价格
	
  if insuranceList then 
     for i, insuranceInfo in ipairs(insuranceList) do
     if insuranceInfo['total_count'] and tonumber(insuranceInfo['total_count']) > 0 then
       if insuranceInfo['insPrice'] then
          local insurePrice = tonumber(insuranceInfo['insPrice']) * 100

           print("step 1 insurePrice is " .. insurePrice)
           ticketPrice = ticketPrice + insurePrice * tonumber(insuranceInfo['total_count'])
    
           local insDetail = {}
           insDetail['title'] = insuranceInfo['insName']
           insDetail['price'] = string.format("¥%d", tonumber(insuranceInfo['insPrice'])) 
           insDetail['count'] = string.format("x%d份", tonumber(insuranceInfo['total_count'])) 
           insDetail['type']  = 1
           
            --保险信息
            if insDetail then
               table.insert(orderPriceList, insDetail)
            end
       end
    end
   end
  end 
	
    --计算邮寄价格
    if itineraryInfo then
      local iterary_type  = tonumber(itineraryInfo['type'])    -- ios 是 1和3 的时候表示选择了行程单
      if itineraryInfo['valid'] and itineraryInfo['valid'] == true then
        if iterary_type == 1 or iterary_type == 3 then
             if adultCount + childCount > 0 then
                print("step 3 itineraryFee is " .. itineraryFee)
                if itineraryFee >= 0 then
                   ticketPrice = ticketPrice + itineraryFee
                   --邮寄明细
                   local itineraryDetail = {} 
                   itineraryDetail['title'] = "邮寄费用"
                   itineraryDetail['price'] = string.format("¥%d", itineraryFee / 100) 
                   itineraryDetail['type']  = 1

                   if itineraryDetail then
                      table.insert(orderPriceList, itineraryDetail)
                   end 
                end  
             end 
          end
      end
    end 
   
    --计算优惠价格  
    local  activityPrice = 0
    local  realActivityPrice = 0
    local  tempTotalPrice = ticketPrice
    --是否已优惠到1元
    local  bBestActivity = false   
  
    if adultCount + childCount > 0 and activityList then
    for i,v in ipairs(activityList) do
			local  activityDic = v
            print("activityDic is" .. json.encode(activityDic))
            if activityDic['selected'] and activityDic['selected'] == true and activityDic['actType'] and activityDic['actType'] ~= 2 
             and activityDic['actId'] and activityDic['actId'] ~= -1 then
                local actRule = activityDic['actRule'] 
                if actRule then 
                    if bBestActivity then 
                       actRule['realActivityPrice'] = 0
                    else 
                       activityPrice = activityPrice + tonumber(actRule['activityPrice'])
                       if activityPrice > adultPrice * adultCount then 
                          bBestActivity = true
                          ticketPrice = tempTotalPrice - (adultPrice-100)*adultCount 
                          --判断是否拆分  暂时先不判断
                          local oldActivityPrice = activityPrice - tonumber(actRule['activityPrice'])
                          actRule['realActivityPrice'] = (adultPrice-100)*adultCount-oldActivityPrice
                          realActivityPrice = realActivityPrice + (adultPrice-100)*adultCount-oldActivityPrice
                       else
                          ticketPrice = ticketPrice - tonumber(actRule['activityPrice'])
                          actRule['realActivityPrice'] = tonumber(actRule['activityPrice'])
                          realActivityPrice = realActivityPrice + tonumber(actRule['activityPrice'])
                       end	
                    end
                end 
		       end    
	    end	  
    end 
    
    --优惠的金额价格商务精选的优惠
    if adultBusinessBackPrice > 0 then
       realActivityPrice = realActivityPrice + adultBusinessBackPrice * adultCount
    end

    if childBusinessBackPrice > 0 then
       realActivityPrice = realActivityPrice + childBusinessBackPrice * childCount
    end   

    --拼接价格明细
    --成人价格明细
    local adultDetail = {}
    local adult_price = adultPrice
    adultDetail['title'] = "成人票"
    if bSupportInsurance and bSelectYiwaiType then
      adult_price =  adultPrice - insureAdultFee * 100
    end
    
    if adultBusinessBackPrice > 0 then 
       adult_price = adult_price + adultBusinessBackPrice
    end 
    adultDetail['price'] = string.format("¥%d" , adult_price / 100)
    adultDetail['count'] = string.format("x%d人", adultCount)
    adultDetail['type']  = 0

    if flightInfo['isForceInsure'] and flightInfo['isForceInsure'] == true then 
       adultDetail['desp'] = string.format("含意外险¥%d", forceInsurePrice / 100)
    else 
       if bSupportInsurance == true and bSelectYiwaiType == false then
          adultDetail['desp'] = "无航空意外险"
       end   
    end

    --成人基建燃油
    local adultFee = {}
    adultFee['title'] = "机建+燃油"
    if adultFeeAndTax == 0 then
       adultFee['price'] = "¥0"
    else
       adultFee['price'] = string.format("¥%d+¥%d", singleAdultOnlyFee / 100, singleAdultOnlyTax / 100) 
    end 
    
    adultFee['count'] = string.format("x%d人", adultCount)
    adultFee['type']  = 0
    
    if adultCount > 0 then 
         table.insert(orderPriceList, adultDetail)  
         table.insert(orderPriceList, adultFee)
    end 
   
    --儿童价格明细
    local  childDetail = {}
    local child_price = childPrice
    childDetail['title'] = "儿童票"
    if bSupportInsurance and bSelectYiwaiType then 
       child_price = childPrice - insureChildFee * 100
    end
    if childBusinessBackPrice > 0 then 
       child_price = child_price + childBusinessBackPrice
    end 

    childDetail['price'] = string.format("¥%d", child_price / 100)
    childDetail['count'] = string.format("x%d人", childCount)
    childDetail['type']    = 0
    if flightInfo['isForceInsure'] and flightInfo['isForceInsure'] == true then 
       childDetail['desp'] = string.format("含意外险¥%d", forceInsurePrice / 100)
    end 

    --儿童基建燃油
    local childFee = {}
    childFee['title'] = "机建+燃油"

    if childFeeAndTax == 0 then
       childFee['price'] = "¥0"
    else
       childFee['price'] = string.format("¥%d+¥%d", singleChildOnlyFee / 100, singleChildOnlyTax / 100)
    end

    childFee['count'] = string.format("x%d人", childCount)
    childFee['type']  = 0

    if childCount > 0 then
       table.insert(orderPriceList, childDetail)
       table.insert(orderPriceList, childFee)
    end 

    --优惠明细
    if activityList then
       for i,v in ipairs(activityList) do
      local  activityDic = v
            if activityDic['selected'] and activityDic['selected'] == true and activityDic['actId'] and activityDic['actId'] ~= -1 then 
                local actRule = activityDic['actRule'] 
                local activity_price 
                if  actRule['realActivityPrice'] then
                    activity_price = tonumber(actRule['realActivityPrice'])
                else
                    activity_price = tonumber(actRule['activityPrice'])
                end 
                if actRule['canMultiPerf'] and actRule['canMultiPerf'] == true then
                   local personCount = adultCount
                   
                   if actRule['includeChild'] and actRule['includeChild'] == true then
                      personCount = personCount + childCount
                   end

                   if personCount > 0 then
                      activity_price = activity_price / personCount
                   end
                end
                local  activityDetail = {}
                if activityDic['actType'] and activityDic['actType'] == 2 then
                     activityDetail['title'] =  activityDic['actName']
                else
                     local actInfo = actRule['actInfo']
                     if actInfo and actInfo['isCashVoucher'] and actInfo['isCashVoucher'] == true then
                         activityDetail['title'] =  "淘里程抵现"
                     else
                         activityDetail['title'] =  activityDic['typeName']
                     end 
                     activityDetail['price'] =  string.format("-¥%d" , activity_price / 100)
                     if actRule['canMultiPerf'] and actRule['canMultiPerf'] == true then
                        local personCount = adultCount 
                        if actRule['includeChild'] and actRule['includeChild'] == true then
                            personCount = personCount + childCount
                        end 
                        activityDetail['count'] = string.format("x%d人", personCount)
                     end
                     activityDetail['type']  =  2
                end 

                if activityDetail then
                table.insert(orderPriceList, activityDetail)
                end
            end
          end        
    end 
      --商旅精选明细
    local businessPrice = 0
    local businessCount = 0
    if adultBusinessBackPrice > 0 then
       businessPrice = adultBusinessBackPrice
       businessCount = adultCount
    end 

    if childBusinessBackPrice > 0 then
       businessPrice = businessPrice + childBusinessBackPrice
       businessCount = businessCount + childCount  
    end

    if businessPrice > 0 then
          local businessDetail = {}
          businessDetail['title'] = "商务精选立返"
          businessDetail['price'] = string.format("-¥%d", businessPrice / 100)
          businessDetail['count'] = string.format("x%d人", businessCount) 
          businessDetail['type']  =  2
          table.insert(orderPriceList, businessDetail)
    end 
 
    --返回结果
    resultList['totalPrice'] = ticketPrice / 100
    resultList['realActivityPrice'] = realActivityPrice / 100
    resultList['closeInsureProfit'] = bCloseInsurance
    resultList['orderPriceList'] = orderPriceList
    print("step 3 ticketPrice is " .. ticketPrice)
    
    return resultList		
end

local price = getOrderPrice(rawPrarm)
print("price is " .. json.encode(price)) 