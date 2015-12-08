--引入template.lua
local template = require "template"

--引入json.lua
local json = require "json"

--java读HTML模板文件函数
function rawLoadFile(path)
	pcall(function() nativeLoadFile(path) end)
	return _G['_html_data']
end

--java读图片文件函数
function rawLoadImage(jsonStr)
    pcall(function() nativeLoadImage(json.encode(jsonStr)) end)
    return json.decode(_G['_image_data'])
end

--java读取js、css文件函数
function rawLoadResource(path)
    pcall(function() nativeLoadResource(path) end)
    return _G['_resource_data']
end

--获取表长度
function gettablen(tab)
  if not tab or type(tab)~="table" then return 0 end
  len = 0
  while true do
    index,value = next(tab,index)
    if index then
      len = len + 1
    else
      break
    end
  end
  return len
end

--返回table有效值
function tab(tab)
  if not tab or type(tab)~="table" then return {} end
  return tab
end

--可以循环table为空的table
function iter(t)
  return pairs(tab(t))
end
loop = iter

--转换为数字
function tonum(num)
  if not num or type(num)~="string" or type(num)~="number" then return 0 end
  num = tonumber(num)
  if not num then return 0 end
  return num
end

--url编码
function urldecode(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end

--url解码
function urlencode(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end

--java调用主函数
function html4Android(word)
	local data = word:getJson()
	local json_obj = json.decode(data)
	template.caching(false)
	template.use_global_include(true)
	
	local html_file = "html/tempIndex.html";
	local html = template.render(html_file, json_obj)
	word:setHtml(html)
	return word
end





