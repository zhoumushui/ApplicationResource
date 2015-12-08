<!--ICON表格模板-->
<script id="iconsTpl" type="text/template">
 	{@each list as it,index}
 		{@if index%3===0}
		<div class="row-wrap">
			<div class="flex-row ">
		{@/if}		
			<div class="cell" data-icon="${it.icon}" data-ek="iconItemBtn">
				<div class="icon-wrap">
					{@if it.desc}
					<span class="${it.cls}">${it.desc}</span>
					{@/if}
				</div>
			</div>
		{@if index>=2 && (index+1)%3===0}				
			</div>
		</div>
		{@/if}	
	{@/each}	
</script>

<!-- 广告 -->
<script id="adTpl" type="text/template">
	<div class="dest-ad-title nowrap">
		<h3>${name}</h3>
		<div>${title}</div>
	</div>
	<div class="dest-ad-img">
		<img src="${pic}" width="50">
	</div>
	<a href="${url}"></a>
</script>

<!--经典行程模板-->
<script id="planTpl" type="text/template">
	<header class="title" data-ek="morePlanBtn">
		<h1 class="tc">${title}</h1>
		<div class="arrow-wrap" >
			<span class="arrow-right"></span>			
		</div>
	</header>
	<div class="wrap clearfix ">
		<div class="inner-wrap clearfix jsScrollWrap" style="width: ${(list.length+1)*100}%;">
			{@each list as it,index}
			<div class="travel-item" style="width: ${conentWidth}px;">
				<div class="travel-info" data-ek="detailPlanBtn" data-planId="${it.pl_id}">
					<div class="info-img">
					    <img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" data-lazy-src="${it.pic_url}" alt="${it.pl_name}" width="100%" data-origin="310_177"/>
					    <div class="info-img-mask"></div>
					</div>
					{@if index>0 }
					<div class="arrow-left-wrap" data-ek="prevPlanBtn" data-index="${+index+1}">
						<span class="arrow-left"></span>
					</div>
					{@/if}
					{@if index<list.length-1}
					<div class="arrow-right-wrap" data-ek="nextPlanBtn" data-index="${+index+1}">
						<span class="arrow-right"></span>
					</div>
					{@/if}
					<div class="travel-days">$${it.title.replace(/(天)/, '<small>$1</small>')}</div>
					<div class="travel-title">${it.pl_name}</div>
				</div>
				<div class="travel-line nowrap">$${it.tripDest}</div>
			</div>	
			{@/each}
		</div>
	</div>
</script>

<!-- 这是备份 -->
<script id="subPlanBak" type="text/template">
	<div class="travel-tags">
		<span>${timeTypeList[it.ext_info.time_type]}</span>
		<span>${it.ext_info.departure_month}月出发</span>
		<span>人均消费${it.ext_info.avg_cost}元</span>
	</div>
</script>

<!--热门目的地-->
<script id="topDestTpl" type="text/template">
	<header class="title" data-ek="moreDestBtn">
		<h1 class="tc">${title}</h1>
		<div class="arrow-wrap">
			<span class="arrow-right"></span>			
		</div>
	</header>
	<div class="wrap clearfix">
		{@each list as it,index}
		<div class="hot-dest-item" data-ek="detailDestBtn" data-sid="${it.sid}" data-sname="${it.sname}" data-surl="${it.surl}">
			<div class="dest-item-imgwrap">
				<img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" data-lazy-src="${it.pic_url}" alt="${it.sname}" width="100%" data-origin="157_137"/>
				<div class="info-img-mask"></div>
			</div>
			<div class="hot-dest-name">
				<h1>${it.sname}</h1>
				<h2>${it.surl.toUpperCase()}</h2>
			</div>
		</div>
		{@/each}
	</div>
</script>

<!--热门住宿区推荐模板-->
<script id="hotelTpl" type="text/template">
	<header class="title" data-ek="moreHotelBtn">
		<h1 class="tc">${title}</h1>
		<div class="arrow-wrap">
			<span class="arrow-right"></span>
		</div>
	</header>
	<div class="hotel-content">
		{@each list as it,index}
		<div class="hotel-item" data-ek="filterHotelBtn" data-name="${it.name}">
			<div class="divimg"></div>
			<p class="hotel-body">
				<span class="hotel-name">${it.name}</span>
				<span class="hotel-count">${it.total}家酒店</span>
			</p>
		</div>
		{@/each}
	</div>
</script>
<!--热销门票-->
<script id="topSceneTpl" type="text/template">
	<header class="title" data-ek="moreTopSceneBtn">
		<h1 class="tc">${title}</h1>
		<div class="arrow-wrap">
			<span class="arrow-right"></span>
		</div>
	</header>
	<div class="wrap clearfix">
		{@each list as it,index}
		<div class="ticket-item" data-ek="detailTopSceneBtn" data-name="${it.sname}" data-sid="${it.sid}">
			<div class="item-img">
				<img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="146_120"/>
			</div>
			<div class="ticket-info">
				<h1 class="nowrap">${it.sname}</h1>
				<div class="ticket-price">&yen;${it.lower_price}</div>
			</div>
		</div>
		{@/each}
	</div>
</script>


<!-- 特价门票 -->
<script id="ticketTpl" type="text/template">
	<header class="title" data-ek="moreTicketsBtn">
		<h1 class="tc">特价门票</h1>
		<div class="arrow-wrap">
			<span class="arrow-right"></span>
		</div>
	</header>
	<div class="wrap clearfix">
		{@each list as it,index}
		<div class="ticket-item">
			<div class="ticket-left" data-tid="${it.tid}" data-ek="noticeBtn">
				<h1>${it.title}</h1>
				<div class="tips">
					{@each it.ota.tips as tip}
					<span>${tip}</span>
					{@/each}
				</div>
				<span class="book-notice">预订须知</span>
			</div>
			<div class="ticket-right" data-ek="bookingBtn" data-tid="${it.tid}">
				<div class="ticket-price">&yen;${it.ota.price}</div>
				<div class="ticket-book">预订</div>
				<div class="ticket-pay-type">${it.ota.pay_mode}</div>
			</div>
		</div>
		{@/each}
	</div>
</script>

<!-- 预订须知 -->
<script id="noticeTpl" type="text/template">
	<div class="notice-wrap styleguide">
		<header>预订须知</header>
		<div class="wrap">
		<article class="jsSrcollWrap">
			<h1>${title}</h1>
			<div class="tips-wrap">
				{@each ota.tips as tip}
					<span>${tip}</span>
				{@/each}
			</div>
			{@each ota.remark as rm}
			<section>
				<h2>${rm.title}</h2>
				<p>${rm.content}</p>
			</section>
			{@/each}
		</article>
		</div>
		<footer>
			<span class="price">&yen;${ota.price}</span>
			<span class="pay-mode">${ota.pay_mode}</span>
			<div class="pay-btn" data-ek="bookingBtn" data-tid="${tid}">立即支付</div>
		</footer>
	</div>
</script>
	
<!--精品画册-->
<script id="pictravelTpl" type="text/template">
	<header class="title" data-ek="morePictravelBtn">
		<h1 class="tc">${title}</h1>
		<div class="arrow-wrap">
			<span class="arrow-right"></span>
		</div>
	</header>
	<div class="wrap">
		{@each list as it,index}
		<div class="pictravel-item" data-ek="detailPictravelBtn" data-ptid="${it.ptid}">
			<div class="item-img-wrap">
				<img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="310_150"/>
				<div class="info-img-mask"></div>
			</div>
			<div class="pictravel-num">${it.pic_count}</div>
			<div class="pictravel-user">
				<span>${it.user.uname}</span>
				<div class="user-head" style="background: url(${it.user.avatar}) no-repeat center center; background-size: 100% 100%;"></div>
			</div>
			<div class="pictravel-info">
				<h1 class="nowrap">${it.title}</h1>
				<p>${it.view_count}人看过<s></s>&nbsp;&nbsp;&nbsp;&nbsp;${it.time}</p>
			</div>
		</div>
		{@/each}
	</div>
</script>

<!--精彩游记-->
<script id="notesTpl" type="text/template">
	<header class="title" data-ek="moreNotesBtn">
		<h1 class="tc">${title}</h1>
		<div class="arrow-wrap">
			<span class="arrow-right"></span>
		</div>
	</header>
	<div class="wrap">
		{@each list as it,index}
		<div class="note-item" data-ek="detailNotesBtn" data-sid="${it.nid}">
			<div class="item-img">
				<img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="110_80"/>
			</div>
			<div class="note-info">
				<h1>${it.title}</h1>
				<div class="note-user">${it.user.uname}</div>
				<div class="note-tips">
					<span class="note-love">${it.view_count}</span>
					<!--<span class="note-answer">${it.reply_count}</span>-->
					<span class="note-time">${it.time}</span>
				</div>
			</div>
		</div>
		{@/each}
	</div>
</script>

<!-- 此刻/分享此刻 -->
<script id="liveTpl" type="text/template">
	<header class="title" data-ek="moreLiveBtn">
		<h1 class="tc">此刻<strong class="dot">&middot;</strong>${sname}</h1>
		<div class="arrow-wrap" data-title="此刻&middot;${sname}">
			<span class="arrow-right"></span>
		</div>
	</header>
	<div class="wrap">
		<div class="dest-live-imgs clearfix">
			{@each list as it,index}
			<div class="img-item" data-ek="singleLiveBtn" data-itemid="${it.id}">
				<img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" data-lazy-src="${it.pics[0].pic_url}" width="100%" data-origin="105_100"/>
			</div>
			{@/each}
		</div>
		<div class="share-btn-wrap">
			<div class="btn share-btn" data-ek="liveShareBtn">分享此刻</div>
		</div>
	</div>
</script>

<!-- 度假 -->
<script id="vacationTpl" type="text/template">
	<header class="title" data-ek="moreVacationBtn">   
		<h1 class="tc">折扣线路</h1>   
		<div class="arrow-wrap" data-title="折扣线路">    
			<span class="arrow-right"></span>   
		</div>  
	</header>
	<div class="dest-vacation-items">
		{@each list as it,index}
		<div class="dest-vacation-item" data-url="${it.url}" data-ek="vacationDetail">
			<img src="../../../static/widgets/destination/img/image_default_middle@2x_08d26ef.png" width="100%" data-origin="149_110" data-lazy-src="${it.image}">
			<div class="content">
				<p class="content-title">${it.title_all}</p>
				<p class="content-price">
					<span class="current-price"><em>￥${it.price}</em><em>起/人</em></span>
				</p>
			</div>
		</div>
		{@/each}
	</div>
</script>

<!-- 伴游 -->
<script type="text/template" id="tourisTpl">
	<header class="title" data-ek="moreWithTourisBtn">   
		<h1 class="tc">当地向导<span class="subtitle"></span></h1>   
		<div class="arrow-wrap" data-title="当地向导">    
			<span class="arrow-right"></span>   
		</div>  
	</header>
	<div class="dest-with-tourism-items">
		{@each list as it,index}
		<div class="dest-with-tourism-item" data-cpid="${it.cp_id}" data-ek="withTourisDetailBtn">
			<img src="http://hiphotos.baidu.com/lvpics/pic/item/9c66db2ccffc1e178f987c8d4a90f603728de945.jpg" width="100%" data-origin="60_60" data-lazy-src="${it.person.avatar}">
			<p><span>${it.companion_user.realname}</span><em class="ext_icon {@if it.companion_user.sex==0}girl{@else}boy{@/if}"></em></p>
		</div>
		{@/each}
	</div>
</script>

<!-- 简介 -->
<script id="absTpl" type="text/template">
	<header class="title" data-ek="moreIntroduceBtn">   
		<h1 class="tc">${title}<span class="subtitle"></span></h1>   
		<div class="arrow-wrap">    
			<span class="arrow-right"></span>   
		</div>  
	</header>
	<div class="wrap">
		<p>${info.desc}</p>
		<p>${info.opening_hours}</p>
	</div>
</script>

<!-- 如何到达 -->
<script id="arrivalTpl" type="text/template">
	<header class="title" data-ek="moreReachBtn">   
		<h1 class="tc">如何到达<span class="subtitle"></span></h1>   
		<div class="arrow-wrap">    
			<span class="arrow-right"></span>   
		</div>  
	</header>
	<div class="wrap">
		<div class="map" data-ek="goReachBtn"></div>
		<div class="info">
			{@each list as it,index}
			<p>${it.name}:${it.desc}</p>
			{@/each}
		</div>
	</div>
</script>

<!-- 点评 -->
<script id="remarkTpl" type="text/template">
	<header class="title" data-ek="moreCommentBtn">   
		<h1 class="tc">点评<span class="subtitle"></span></h1>   
		<div class="arrow-wrap">    
			<span class="arrow-right"></span>   
		</div>  
	</header>
	<div class="wrap">
		{@each list as it,index}
		<div class="dest-comment-item">
			<div class="mod">
				<div class="item-left">
					<div class="pic"><img src="http://hiphotos.baidu.com/lvpics/pic/item/9c66db2ccffc1e178f987c8d4a90f603728de945.jpg" width="100%" data-origin="52_52" data-lazy-src="${it.user.avatar_pic}"></div>
					<div class="cont">
						<h4>${it.user.nickname}</h4>     
						<div class="scores">
							<span style="width:${it.score/5*100}%;"></span>
						</div>
					</div>
				</div>
				<div class="item-right">
					<span>${it.time}</span>
				</div>
			</div>
			<p>${it.content}</p>
		</div>
		{@/each}
		<div class="comment-btn-wrap">    
			<div class="btn comment-btn" data-ek="remarkBtn">写点评，赢大奖</div>   
		</div>
	</div>
</script>

<!-- 伴游 -->
<script id="guideTpl" type="text/template">
	<header class="title" data-ek="moreWithGuideBtn">   
		<h1 class="tc">百度向导<span class="subtitle"></span></h1>   
		<div class="arrow-wrap">    
			<span class="arrow-right"></span>   
		</div>  
	</header>
	<div class="dest-with-guide-items">
		{@each list as it,index}
		<div class="dest-with-guide-item">
			<div class="scope-left-cont" data-cpid="${it.cp_id}" data-ek="GuideDetailBtn">
				<div class="pic"><img src="http://hiphotos.baidu.com/lvpics/pic/item/9c66db2ccffc1e178f987c8d4a90f603728de945.jpg" data-origin="63_63" width="100%" data-lazy-src="${it.person.avatar}"></div>
				<div class="info">
					<h3><b>${it.companion_user.realname}</b>
					{@if it.companion_user.sex*1}
					<i class="boy">&nbsp;</i>
					{@else}
					<i class="girl">&nbsp;</i>
					{@/if}
					</h3>
					<p>${it.title}</p>
					<p>服务${it.sale_count}次{@if it.remark_grade_sum}<b>|</b>${it.remark_grade_sum}分{@/if}</p>
				</div>
			</div>
			<div class="scope-right-cont" data-cpid="${it.cp_id}" data-ek="GuideBooklBtn">
				<div class="scope-right-wrap">
					<div class="scope-price-cont">
						<span class="scope-unit">¥</span>
						<span class="scope-price">${it.struct_ext.costdesc.content}</span>
						<i>${it.struct_ext.costunit.content}</i>
					</div>
					<div class="scope-book-btn">预订</div>
				</div>
			</div>
		</div>
		{@/each}
	</div>
</script>
