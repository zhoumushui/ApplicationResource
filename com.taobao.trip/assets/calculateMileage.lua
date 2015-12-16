local json = require('cjson')

local rawparam='{"activityList":[{"actId":"2_35","actName":"红包测试","actRule":{"actInfo":{"id":"35","isCashVoucher":false,"isCheckSMRZ":false,"label":"国航旗舰店独享，优惠券HB22，下单自动直减50元","name":"直减50元","perfType":"PERF_DIRECT","subType":"PERF_DIRECT_1"},"activityPrice":4900,"allowSplit":false,"canMultiPerf":true,"closeInsureProfit":false,"includeAdult":true,"includeBaby":false,"includeBigChild":true,"includeChild":false,"includeOld":true,"maxOrderPerfNum":9,"minOrderPerfNum":1,"multiAdultTicketNum":0},"actType":"1","mixType":"3","multiSelectInGroup":true,"orderText":"这是个红包","selected":true,"typeName":"红包"}],"flightInfo":{"adultBusinessBackPrice":-1,"agentName":"中国国际航空旗舰店","averageTime":60,"backForceInsure":false,"backForceInsurePrice":0,"backInsPromotionPrice":0,"backQijian":false,"backSupportInsp":false,"backSupportItinerary":false,"cheapFlightText":"","childBusinessBackPrice":-1,"childTicketExtraInstruction":[{"tips":"1.2岁(不含)以下需购买婴儿票，无单独座位，婴儿票不能单独购买（必须要有成人票），票价为全价票的10%，不收取机场建设费与燃油费 2.婴儿票可直接在机场柜台购买，但每个航班可售婴儿票数量有限，如有需要建议尽快联系航空公司购买 *阿里旅行·去啊暂不提供婴儿票购买服务 ","title":"婴儿票(14天-2岁)"},{"tips":"2岁(含)-12岁(不含)买儿童票。票价为全价票50%，不收取机场建设费，燃油收取成人的50%，购买时需要同时购买成人票，一个成人最多携带两名儿童 ","title":"儿童票(2岁-12岁)"},{"tips":"12(含)-18岁(不含)的儿童，需要购买成人票（若有活动时，享受的活动类型也与成人相同） ","title":"儿童票(12-18岁)"}],"childTicketInstruction":"婴儿票(14天-2岁) 1.2岁(不含)以下需购买婴儿票，无单独座位，婴儿票不能单独购买（必须要有成人票），票价为全价票的10%，不收取机场建设费与燃油费 2.婴儿票可直接在机场柜台购买，但每个航班可售婴儿票数量有限，如有需要建议尽快联系航空公司购买 *阿里旅行·去啊暂不提供婴儿票购买服务 儿童票(2岁-12岁) 2岁(含)-12岁(不含)买儿童票。票价为全价票50%，不收取机场建设费，燃油收取成人的50%，购买时需要同时购买成人票，一个成人最多携带两名儿童 儿童票(12-18岁) 12(含)-18岁(不含)的儿童，需要购买成人票（若有活动时，享受的活动类型也与成人相同） ","childWarmPrompt":"购买2岁(含)-12岁(不含)的儿童票时需要同时购买成人票，一个成人最多携带两名儿童","crossAgent":0,"easyFly":false,"flight":[{"airLineName":"中国国航","airlineCode":"CA","arrAirportName":"萧山机场","arrCityName":"杭州","arrTerm":"","arrTime":"2015-09-03 00:10","cabin":"经济舱","cabinNum":8,"depAirportName":"首都机场","depCityName":"北京","depTerm":"T3","depTime":"2015-09-02 22:00","flightNo":"CA1708","flightType":"321","isMeal":true,"isStop":false,"ontimeRate":"80%","planeType":"中型机","segmentNum":"00","segmentType":"去程","shareFlightNo":""}],"flightNewTag":[{"desc":"支付成功后系统自动出票","highlight":"true","id":"1","name":"实时出票"},{"desc":"7×24小时服务","highlight":"false","id":"2","name":"7×24服务"},{"desc":"卖家提供等额行程单 购买航空公司旗舰店机票，行程单可在乘飞机7日内(含乘机当日)，于起降机场柜台或航空公司售票处免费索取","highlight":"false","id":"4","name":"报销凭证"},{"desc":"产品支持销售退票险，退票成功后自动理赔到账","highlight":"false","id":"7","name":"退票险"}],"flightSearchNotice":"去啊APP订机票 首单立享礼包价值","flightSearchPrice":"110","flightSearchUrl":"https://h5.m.taobao.com/trip/lapse-20/index/index.html","forceInsurePrice":0,"futureTicket":false,"hasMixAct":1,"infantWarmPrompt":"阿里旅行·去啊暂不提供婴儿票购买服务，婴儿票可直接在机场柜台购买，但每个航班可售婴儿票数量有限，如有需要建议尽快联系航空公司购买","infoTextList":[],"insPromotionPrice":0,"insureRuleText":"","isForceInsure":false,"isSupportChild":false,"isSupportInsp":false,"itineraryFee":0,"itineraryInvoiceDetailText":"旗舰店订单不支持行程单邮寄，需要在机场打印，航空意外险保费金额合并打印在行程单上","itineraryInvoiceShortTip":"卖家提供行程单","itineraryInvoiceText":"等额行程单","itineraryInvoiceTip":"行程单需要在乘机7日内，于起降机场柜台或航空公司售票处免费索取","itineraryShowInfo":[{"canSelect":"false","disableReason":"不可邮寄","showInfo":"行程单"}],"leaveForceInsure":false,"leaveForceInsurePrice":2000,"leaveInsPromotionPrice":0,"leaveQijian":true,"leaveSupportInsp":false,"leaveSupportItinerary":true,"maxCanBuyNum":8,"maxLimitNum":3,"mileRatio":12,"minLimitNum":1,"mixActList":[{"actId":"1_2042","actName":"2000淘里程抵20元现金","actRule":{"actInfo":{"id":"2042","isCashVoucher":true,"isCheckSMRZ":false,"label":"2000淘里程抵20元现金","name":"2000淘里程抵现金20元1","perfType":"PERF_DIRECT","subType":"PERF_DIRECT_1"},"actTicketTotalPrice":"{adultTicketNums}*{adultTicketPrice}","activityPrice":0,"allowSplit":false,"canMultiPerf":false,"closeInsureProfit":false,"condition":"{totalTicketNums}>=1&&{adultTicketNums}>=0&&{adultTicketNums}*{adultTicketPrice}+{childTicketNums}*{childTicketPrice}>=0","includeAdult":true,"includeBaby":false,"includeBigChild":false,"includeChild":false,"includeOld":false,"maxOrderPerfNum":1,"minOrderPerfNum":0,"multiAdultTicketNum":0,"perfMoneyFormula":"{adultTicketNums}<=1 ? (({adultTicketPrice}-100)>2000?2000:({adultTicketPrice}-100))*{adultTicketNums}:(({adultTicketPrice}-100)>2000?2000:({adultTicketPrice}-100))*1"},"actType":"1","mixType":"1","multiSelectInGroup":false,"orderText":"参加 2000淘里程抵20元现金，仅限您本人乘机使用哦！","selected":false,"typeName":"优惠活动"},{"actId":"2_35","actName":"直减50元","actRule":{"actInfo":{"id":"35","isCashVoucher":false,"isCheckSMRZ":false,"label":"国航旗舰店独享，优惠券HB22，下单自动直减50元","name":"直减50元","perfType":"PERF_DIRECT","subType":"PERF_DIRECT_1"},"actTicketTotalPrice":"{adultTicketNums}*{adultTicketPrice}","activityPrice":0,"allowSplit":false,"canMultiPerf":true,"closeInsureProfit":false,"condition":"{totalTicketNums}>=1&&{adultTicketNums}>=0&&{adultTicketNums}*{adultTicketPrice}+{childTicketNums}*{childTicketPrice}>=0","includeAdult":true,"includeBaby":false,"includeBigChild":true,"includeChild":false,"includeOld":true,"maxOrderPerfNum":9,"minOrderPerfNum":1,"multiAdultTicketNum":0,"perfMoneyFormula":"(({adultTicketPrice}-100)>5000?5000:({adultTicketPrice}-100))*{adultTicketNums}"},"actType":"1","mixType":"2","multiSelectInGroup":false,"orderText":"国航旗舰店独享，优惠券HB22，下单自动直减50元","selected":false,"typeName":"优惠券"},{"actId":"2_35","actName":"红包测试","actRule":{"actInfo":{"id":"35","isCashVoucher":false,"isCheckSMRZ":false,"label":"国航旗舰店独享，优惠券HB22，下单自动直减50元","name":"直减50元","perfType":"PERF_DIRECT","subType":"PERF_DIRECT_1"},"actTicketTotalPrice":"{adultTicketNums}*{adultTicketPrice}","activityPrice":0,"allowSplit":false,"canMultiPerf":true,"closeInsureProfit":false,"condition":"{totalTicketNums}>=1&&{adultTicketNums}>=0&&{adultTicketNums}*{adultTicketPrice}+{childTicketNums}*{childTicketPrice}>=0","includeAdult":true,"includeBaby":false,"includeBigChild":true,"includeChild":false,"includeOld":true,"maxOrderPerfNum":9,"minOrderPerfNum":1,"multiAdultTicketNum":0,"perfMoneyFormula":"(({adultTicketPrice}-100)>5000?5000:({adultTicketPrice}-100))*{adultTicketNums}"},"actType":"1","mixType":"3","multiSelectInGroup":true,"orderText":"这是个红包","selected":false,"typeName":"红包"}],"needChangeRare2Pinyin":true,"needRegister":0,"nonVipPrice":0,"price":[{"cabin":"经济舱","segmentNum":"00","singleAdultOnlyFee":"5000","singleAdultOnlyTax":"0","singleAdultPrice":"5000","singleAdultTax":"5000","singleChildOnlyFee":"0","singleChildOnlyTax":"0","singleChildPrice":"0","singleChildTax":"0","type":"去程"}],"qijian":true,"retainText":"","score":"6.4","scoreDetail":[{"diffType":"快","diffValue":"9分钟","name":"出票速度","value":"5"},{"diffType":"低","diffValue":"45.6%","name":"服务响应","value":"2"},{"diffType":"持平","diffValue":"0.0分","name":"服务质量","value":"5"},{"diffType":"慢","diffValue":"93小时","name":"退款时长","value":"1"}],"selectYiwai":"0","showCabinInfo":"经济舱(Q)","showReverseInfo":[{"modifyIcon":1,"modifyTextShow":"改签费￥112起","refundIcon":1,"refundTextShow":"退票费￥224起","segmentType":0}],"showTicketPrice":"￥1120元(不含税)","singleSendLimit":"50000","supportItinerary":true,"totalPrice":5000,"tripType":0,"tuigaiqian":[{"tuigaiqian":"退票手续费：早于起飞224元，晚于起飞336元；改期手续费：早于起飞112元，晚于起飞224元；不可签转；可升舱；","type":"去程"}],"tuigaiqianRule":{"leaveRule":[{"desc":"经济舱(Q)","id":"1","name":"舱位"},{"desc":"￥1120元(不含税)","id":"3","name":"票面价"},{"desc":"起飞前 20%(224元) 起飞后 30%(336元) ","id":"5","name":"退票费"},{"desc":"起飞前 10%(112元) 起飞后 20%(224元) 可升舱","id":"7","name":"改期费"},{"desc":"不可签转","id":"9","name":"签转"},{"desc":"退改签规则以航空公司最新规定为准","id":"11","name":"儿童票"},{"desc":"改期规定：客票变更时，如产生票价差，需加收差价费用","id":"12","name":"特殊说明"}]},"vipProduct":0},"insuranceList":[{"adultOnly":"0","insCompany":"1005","insCount":"2","insDesc":"飞行有保障，最高赔付100万元 ","insIndex":"1","insKey":"4005","insLink":"https://h5.m.taobao.com/market/trip/yangguangbaoxian.html","insName":"航空意外险","insPrice":"20","insShortName":"意外险","insType":"1","insureAdultFee":"15","insureChildFee":"0","isDisplayMobile":"0"},{"adultOnly":"1","insCount":"1","insDesc":"退票有保障，赔付80%退票损失 ","insIndex":"3","insKey":"4122","insLink":"https://h5.m.taobao.com/market/trip/jptuipiaoxian.html","insName":"机票退票险","insPrice":"18","insShortName":"退票险","insType":"3","insureAdultFee":"0","insureChildFee":"0","isDisplayMobile":"0"}],"passengerList":[{"certType":0,"insureInfo":[]}]}'
--获取机票的成人及儿童的票面价
function getPriceInfo(flightInfo)
	local priceList = flightInfo['price']
	local adultPrice = 0
	local childPrice = 0
	local adultFeeAndTax = 0
	local childFeeAndTax = 0
	for i,price in ipairs(priceList) do
		adultPrice = adultPrice + tonumber(price['singleAdultPrice'])
		childPrice = childPrice + tonumber(price['singleChildPrice'])
		adultFeeAndTax = adultFeeAndTax + tonumber(price['singleAdultTax'])
		childFeeAndTax = childFeeAndTax + tonumber(price['singleChildTax'])
	end
	
	return adultPrice, childPrice, adultFeeAndTax, childFeeAndTax
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

function getMileage(param)
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

	local resultList = getMileageByMultiParam(flightInfo, activity, insuranceList, passengerList)

	if type(param) == 'string' then
		result = json.encode(resultList)
	else 
		result = resultList
	end

	return result
end

function getMileageByMultiParam(flightInfo, activity, insuranceList, passengerList)

	--是否支持保险分润
	local bSupportInsurance = false
	--里程计算比率
	local mileRatio = 0.0
	--单张机票成人及儿童价格
	local adultPrice = 0
	local childPrice = 0
	--机票税费价格
	local adultFeeAndTax = 0
	local childFeeAndTax = 0
	--机票分润金额
	local insureAdultFee = 0
	local insureChildFee = 0
	--税费价格
	local feeAndTax = 0
	--计算得出的机票票面价
	local ticketPrice = 0	
	--最终支付金额
	local totalPrice = 0
	--最终的里程数
	local mileage = 0.0
	--强制保险价格
	local forceInsurePrice = 0.0
    --最大里程
    local singleSendLimit = 0.0
    --乘客数量
    local adultCount = 0
    local childCount = 0
    --优惠券使用规则
    local includeAdult   = true
	local includeChild   = false

    if flightInfo then
    	bSupportInsurance = flightInfo['isSupportInsp']
		mileRatio = flightInfo['mileRatio']
		adultPrice, childPrice, adultFeeAndTax, childFeeAndTax = getPriceInfo(flightInfo)

		if flightInfo['isForceInsure'] and flightInfo['isForceInsure'] ~= 0 then
			forceInsurePrice = tonumber(flightInfo['forceInsurePrice'])
		end
    end

	for i,v in ipairs(passengerList) do
		local passenger = v
		if passenger['certType'] == 0 then  
			ticketPrice = ticketPrice + adultPrice
			feeAndTax = feeAndTax + adultFeeAndTax
			adultCount = adultCount + 1
	
		elseif passenger['certType'] == 1 then
			ticketPrice = ticketPrice + childPrice
			feeAndTax = feeAndTax + childFeeAndTax
			childCount = childCount + 1
		end

		print("step 1 ticketPrice is " .. ticketPrice)

		if bSupportInsurance and insuranceList then
			insureAdultFee, insureChildFee = getInsureFee(insuranceList)
			local insureInfo = passenger['insureInfo']
			
			for i,v in ipairs(insureInfo) do
				local insure  = v
				if insure['insCount'] > 0  then
					if insure['insKey'] == 1 then  --航空意外险
						if passenger['certType'] == 0 then  
							ticketPrice = ticketPrice - insureAdultFee * 100
						elseif passenger['certType'] == 1 then
							ticketPrice = ticketPrice - insureChildFee * 100
						end
					end
				end
			end
		end
	end
	
	local passengerCount = #passengerList

	for i,v in ipairs(activity) do
			local  activityDic = v
            if activityDic['selected'] and activityDic['selected'] == true and activityDic['actType'] and activityDic['actType'] ~= 2 then
            local actRule = activityDic['actRule']
               if actRule and actRule['activityPrice'] then 
                 ticketPrice = ticketPrice - actRule['activityPrice'] 
               end
		end    
	end	    	
	        
    
	print("step 2 ticketPrice is " .. ticketPrice)
	mileage = ( ticketPrice - forceInsurePrice * passengerCount) * mileRatio / 100
	
    singleSendLimit = tonumber(flightInfo['singleSendLimit'])
    
    if singleSendLimit > 0 then
       if mileage > singleSendLimit then
          mileage = singleSendLimit
       end
    end

	--计算当前支付金额
	totalPrice = ticketPrice + feeAndTax

	local resultList = {}
	resultList['mileage'] = mileage
	resultList['price'] = totalPrice

	return resultList
end
local mileage = getMileage(rawparam)
print("mileage is " .. json.encode(mileage))
