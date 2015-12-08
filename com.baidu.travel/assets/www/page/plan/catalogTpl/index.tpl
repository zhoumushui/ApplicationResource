<script type="text/template" id="catalogTpl">
    <section id="catalog-wrap" style="display: none">
        <section id="catalog-head">
            点击日程可快速跳转
            <div class="arrow"><span></span></div>
        </section>
        <section id="catalog-content">
            <ul>
                <li style="height: 39px;">
                    <div class="dash-wrap" style="top:-4px;"></div>
                </li>
                {@each day_path as day,index}
                <li data-index="${parseInt(index) + 1}">
                    <div class="dot-wrap"></div>
                    <div class="dash-wrap"></div>
                    <div class="content">
                        <span class="day">第${parseInt(index) + 1}天</span>
                        <span class="location">{@if day.poi_list}${day.poi_list}{@else}暂无安排{@/if}</span>
                    </div>
                </li>
                {@/each}
            </ul>
        </section>
    </section>
</script>