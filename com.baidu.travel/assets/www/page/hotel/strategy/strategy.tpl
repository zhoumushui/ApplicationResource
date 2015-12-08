<script id="cityTpl" type="text/template">
	<div class="stra-name">${data.scene_info.sname}</div>
	<div class="stra-intro">$${data.area.desc}</div>
</script>
<script id="contentTpl" type="text/template">

    {@each data.area.list as it,index}

    <section class="stra-content">

        <div clsss="item">

            <div class="item-icon">${+index+1}</div>

            <span class="item-name">${it.name}

            {@if index == 0 || index == 1 || index == 2}

            <span class="item-hot">Hot</span> 

            {@/if}

            </span>

        </div>

        <div class="choose">

            <span class="choose-num">${it.rating}%</span><span class="choose-info">的游客选择住这里</span>

        </div>

        <div class="feature">

            <p class="icon-wrap">

                <span class="icon-strategy"></span>

            </p>

            <p class="feature-all clearfix">

                <strong>特色</strong>

                <span id="more" class="container">

                <span id="content1-${+index}">:&nbsp;&nbsp;${it.desc|cutDesc}

                {@if it.desc.length >= 100}

                    <span>...</span> 

                {@/if}

                </span>

                <span id="content2-${+index}" style="display:none">:&nbsp;&nbsp;${it.desc}</span>

                </span>

                {@if it.desc.length >= 100}

                <a name="button" data-idx="${+index}" id="button-${+index}" class="button" data-isopen="false">展开</a>

                {@/if}

            </p>

        </div>

        <div class="spot rel">

            <p class="icon-wrap">

                <span class="icon-spot"></span>

            </p>

            <p class="spot-all">

                <strong>景点</strong>

                <span>:</span> 

                {@each it.scene as scene,index} 

                    {@if index < 10} 

                    <span>${scene.sname}</span>

                    {@/if} 

                {@/each}

            </p>

        </div>

        <div class="available clearfix" data-ek="availBtn" data-name="${it.name}">

            <span>${it.number}家酒店可预订</span>

            <span class="icon-arrow"></span>

        </div>

        <div style="width:100%;height:1px;margin:0px auto;padding:0px;background-color:#D5D5D5;overflow:hidden;"></div>

    </section>

    {@/each}

</script>


