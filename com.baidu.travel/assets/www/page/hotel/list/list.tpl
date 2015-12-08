<script id="hotel" type="text/template">
 	{@each list as it,index}
	 	{@if it}
			{@if it.remark_count != 0 || it.price != 0}

				<div class="item">
					{@if add === 0}
						<a href="#" data-name="${it.name}" data-place_uid="${it.place_uid}" data-desc="${it.desc}" data-remark_count="${it.remark_count}" data-score="${it.score}" data-pic_url="${it.pic_url}">
					{@/if}
						<div class="hotel-list-img">
							{@if add === 0}
								<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80"/>
							{@/if}

							{@if add === 1}
		                        <a href="#" class="list-add" data-name="${it.name}" data-place_uid="${it.place_uid}" data-desc="${it.desc}" data-remark_count="${it.remark_count}" data-score="${it.score}" data-pic_url="${it.pic_url}">
		                        
		                        	<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80" style="opacity: 0.8;"/>
		                        	<span class="add-img"></span>
		                        </a>
		                    {@/if}

						</div>
						<div class="list-info-below">
							<span class="hotel-name">${it.name}</span>
							<div class="remark">
								<span class="remark-star">
									<span class="ri-star" style="width: ${(it.score*66/5)}px;"></span>
								</span>

								{@if it.remark_count != 0}
									<span class="remark-count">${it.remark_count}条评语</span>
								{@/if}
								{@if it.remark_count === 0}
									<span class="remark-count">暂无评语</span>
								{@/if}

								{@if it.price != 0}
									<span class="hotel-price">￥
									<em class="price">${it.price}</em>
									<em class="etc">起</em>
									</span>
								{@/if}

							</div>
							<div class="hotel-intro">

								{@if it.level}
								<span class="hotel-intro-keyword">${it.level}</span>
								{@/if}
							
							</div>
						</div>

					{@if add === 0}
						</a>
					{@/if}
				</div>
			{@/if}
		{@/if}
	{@/each}	
</script>

<script id="notes" type="text/template">
	{@each list as it,index}
		{@if it}
			<div class="item">
				<a href="#" data-nid="${it.nid}">
					<div class="note-list-img">
					
						<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80"/>
				
						{@if it.label == "1"}
							<div class="note-word-yellow">优</div>
						{@/if}

						{@if it.label == "2"}
							<div class="note-word-red">精</div>
						{@/if}

						{@if it.label == "3"}
							<div class="note-word-green">实</div>
						{@/if}
					</div>
					<div class="list-info-below">
						<span class="note-name">${it.name}</span>
						<div class="note-intro">
							<span class="note-author">${it.user_nickname}</span>
							<span class="note-date">${it.start_time|formatDate,it.start_time}&nbsp;${it.days}天</span>
						</div>	
					</div>
				</a>
			</div>
		{@/if}
	{@/each}
</script>

<script id="cater" type="text/template">
	{@each list as it,index}
		{@if it}
			{@if it.remark_count != 0 || it.price != 0}

				<div class="item">

				{@if add === 0}
					<a href="#" data-name="${it.name}" data-place_uid="${it.place_uid}" data-desc="${it.desc}" data-remark_count="${it.remark_count}" data-score="${it.score}" data-pic_url="${it.pic_url}" data-recommendation="${it.recommendation}">
			    {@/if}

						<div class="resta-list-img">

							{@if add === 0}
								<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80"/>
		 					{@/if}

		                    {@if add === 1}
								<a href="#" class="list-add" data-name="${it.name}" data-place_uid="${it.place_uid}" data-desc="${it.desc}" data-remark_count="${it.remark_count}" data-score="${it.score}" data-pic_url="${it.pic_url}" data-recommendation="${it.recommendation}">
									<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80" style="opacity: 0.8;"/>
		                            <span class="add-img"></span>
		                        </a>
		                    {@/if}

						</div>
						<div class="list-info-below">
							<span class="resta-name">${it.name}</span>
							<div class="remark">
								<span class="remark-star">
									<span class="ri-star" style="width: ${(it.score*66/5)}px;"></span>
								</span>

								{@if it.remark_count != 0}
									<span class="remark-count">${it.remark_count}条评语</span>
								{@/if}
								{@if it.remark_count === 0}
									<span class="remark-count">暂无评语</span>
								{@/if}

								{@if it.price != 0}
									<span class="hotel-price">￥
									<em class="price">${it.price}</em>
									<em class="etc">起</em>
									</span>
								{@/if}

							</div>
							<div class="restra-intro">
								{@each it.recommendation as recommendation,index} 
									{@if index == 0}
									<span class="color1">${recommendation}</span>
									{@/if}

									{@if index == 1}
									<span class="color2">${recommendation}</span>
									{@/if}

									{@if index == 2}
									<span class="color3">${recommendation}</span>
									{@/if}
								{@/each}	
							</div>
						</div>

					    {@if add === 0}
		                	</a>
		            	{@/if}

				</div>
			{@/if}
		{@/if}
	{@/each}	
</script>

<script id="plan" type="text/template">
	{@each list as it,index}
		{@if it}
			<div class="item">
				<a href="#" data-plid="${it.pl_id}">
					<div class="route-intro">
						<div class="route-list-img">
							<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80"/>
						</div>
						<div class="route-info">
							<p class="route-name">${it.name}</p>
							<p class="route-time">
								{@if it.days != "0"}
									<strong>${it.days}天&nbsp;&nbsp;</strong>
								{@/if}

								{@if it.start_time != "0"}
									<span>${it.start_time|formatDate,it.start_time} 出发</span>
								{@/if}

							</p>
							<p class="route-author">
								{@if it.user_nickname != ""}
									${it.user_nickname}出品
								{@/if}
							</p>
						</div>
					</div>

					{@if it.path.length > 1}
						<div class="route">
							{@each it.path as _path,index} 
							${_path}

							{@if index < it.path.length-1}
							<span class='globel-iconfont arrow-left-slippers'>&#xe626;</span>
							{@/if} 

							{@/each}
						</div>
					{@/if} 

				</a>
			</div>
		{@/if} 
	{@/each}	
</script>

<script id="scene" type="text/template">
	{@each list as it,index}
		{@if it}
			<div class="item">

			  {@if add === 0}
				<a href="#" data-scene_layer="${it.scene_layer}" data-name="${it.name}" data-sid="${it.sid}" data-desc="${it.desc}" data-remark_count="${it.remark_count}" data-score="${it.score}" data-pic_url="${it.pic_url}">
	    	  {@/if}

					<div class="scene-list-img">
						{@if add === 0}
							<img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80"/>
						{@/if}

	                    {@if add === 1}
	                        <a href="#" class="list-add" data-scene_layer="${it.scene_layer}" data-name="${it.name}" data-sid="${it.sid}" data-desc="${it.desc}" data-remark_count="${it.remark_count}" data-score="${it.score}" data-pic_url="${it.pic_url}">
	                            <img src="../../../static/widgets/hotel/list/img/img_default_cover-2-0_5eee978.png" data-lazy-src="${it.pic_url}" width="100%" data-origin="80_80" style="opacity: 0.8;"/>
	                            <span class="add-img"></span>
	                        </a>
	                    {@/if}


					</div>
					<div class="list-info">
						<span class="scene-name">${it.name}</span>
						<div class="remark">
							<span class="remark-star">
								<span class="ri-star" style="width: ${(it.score*66/5)}px;"></span>
							</span>

							{@if it.remark_count != "0"}
								<span class="remark-count">${it.remark_count}条评语</span>
							{@/if}

							{@if it.remark_count === "0"}
								<span class="remark-count">暂无评语</span>
							{@/if}

							
						</div>
						<span class="scene-intro">${it.desc}</span>
					</div>

				{@if add === 0}
	                </a>
	            {@/if}
	            
			</div>
		{@/if}
	{@/each}	
</script>

<script id="noData" type="text/template">
	<div class="error">
		<div class="noData-bear"><span>暂无内容</span></div>
	</div>
</script>

<script id="noNetwork" type="text/template">
	<div class="error">
		<div class="noNetwork-bear"><span>网络异常，请稍候重试</span></div>
	</div>
</script>