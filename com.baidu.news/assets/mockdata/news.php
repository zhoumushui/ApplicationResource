<?php
//$fis_matches 只读，用于获取urlmap的match属性捕获的分组.
//$fis_basedir 只读，用于获取项目根目录.
//$fis_tpl_path 只读，用于获取模板文件路径.

// iphone UA
$ua = 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_3_2 like Mac OS X; en-us) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8H7 Safari/6533.18.5';

$is_post = count(array_keys($_POST)) > 0;
$content =  http_build_query($_POST);

$context = stream_context_create(
    array(
        'http' => array(
            'method' => $is_post ? 'POST' : 'GET',
            'header' => "User-Agent: $ua",
            'content' => $content,
        )
    )    
);


$query_string = $_SERVER["QUERY_STRING"];

// var_dump($query_string);

echo "var json = " . file_get_contents(
        // 'http://tc-apptest-img08.vm.baidu.com:8055/vs_proxy.php?request_url=' .
        'http://m.baidu.com/news?' . $query_string, false, $context
        // 'http://db-news-fe1.vm.baidu.com:8090/news?' . $query_string, false, $context
    );

// @note: 注意缓存
echo "; json.textFont = 1;";
echo "; json.imageMode = 1;";
echo "; json.showRelated = 1;";
// echo "; json.showRelated = 1;";
// echo "; json.tag = [\"小米\", \"阿里巴巴\", \"支付宝\"];";
echo "; json.tag = [\"小米\", \"阿里巴巴\", \"支付宝\", \"互联网\", \"LBS\", \"谷歌\"];";
