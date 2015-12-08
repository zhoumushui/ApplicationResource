
--[[
RYTL Lua Library v1.0.1
Copyright 2011
--]]


-- 建立库类结构
RYTL = {};

-- 动画展示速率(curve)控制集合:linear(线性),  ease_in(先慢后快), ease_out(先快后慢), ease_inout(先慢再快再慢)
curve = {linear=0,ease_in=1,ease_out=2,ease_inout=3};

-- 页面切换动画种类集合: 0,1,2,3分别为 翻转效果，从左侧翻转，翻转效果，从右侧翻转，页面卷曲效果，向上卷曲，页面卷曲效果，向下卷曲
transitionType = {flipFromLeft=0,flipFromRight=1,curlUp=2,curlDown=3,slideFromLeft=4,slideFromRight=5,slideFromUp=6,slideFromDown=7};

-- 构造函数，返回一个RYTL对象
function RYTL:new(o)
	o = o or {};      -- create table if users does not provide one
    setmetatable(o, self);
    self.__index = self;
    return o;
end
----------------


-- get方法，根据参数的不同及传入的值
function RYTL:get(...)
	if 1 == arg.n then
        if type(arg[1]) == "table" then
            local _elements = document:getElementsByProperty(arg[1]);
            elements = {};
            for i, c in ipairs(_elements) do
                elements[i] = Control:new{control=c};
            end
            return elements;
        end
    end
end
----------------



-- 联动相关方法
--visible、invisible、enable、disable在checkbox不选择中时要执行相反功能。而radio/select则不需要，他们只需执行新选择的radio/option对应的功能；
--参数长度任意,每个参数为控件的name,参数之间用逗号分隔,如RYTVisiable("",userName,password),当多个控件有相同的name时同等处理；
--调用此方法后，请调用screen:reflash()；
--第一个参数为引起控件本身的name值,checkbox必需填值,其它控件可选,也可传空值("")。
function RYTL:visiable(name, ...)
	for i, v in ipairs(arg) do
		local vars = document:getElementsByProperty{name=v};
		for j, c in ipairs(vars) do
            if self:needDoReverse(name) == true then
                c:setStyleByName("display", "none");
			else
				c:setStyleByName("display", "block");
			end
		end
	end
end

function RYTL:invisiable(name, ...)
	for i, v in ipairs(arg) do
		local vars = document:getElementsByProperty{name=v};
		for j, c in ipairs(vars) do
			if self:needDoReverse(name) == true then
				c:setStyleByName("display", "block");
			else
				c:setStyleByName("display", "none");
			end
		end
	end
end

function RYTL:enable(name, ...)
	for i, v in ipairs(arg) do
		local vars = document:getElementsByProperty{name=v};
		for j, c in ipairs(vars) do
			if self:needDoReverse(name) == true then
				c:setStyleByName("enable", "false");
			else
				c:setStyleByName("enable", "true");
			end			
		end
	end
end

function RYTL:disable(name, ...)
	for i, v in ipairs(arg) do
		local vars = document:getElementsByProperty{name=v};
		for j, c in ipairs(vars) do
			if self:needDoReverse(name) == true then
				c:setStyleByName("enable", "true");
			else
				c:setStyleByName("enable", "false");
			end
		end
	end
end

-- 当为checkbox并且不选择中时返回true.
function RYTL:needDoReverse(name)
    if name then
        local var = document:getElementsByName(name);
        local tagName = var[1]:getAttribute("name");
        local vType = var[1]:getAttribute("type");
        if (tagName == "input" and vType == "checkbox" and var[1].getPropertyByName("checked") == "NO") then
            return true;
        else
            return false;
        end
    end
end
-------------


-- 数据库相关方法
function RYTL:getData(key)
    return database:getData(key);
end

function RYTL:addData(key, value)
    return database:addData(key, value);
end

function RYTL:updateData(key, value)
    return database:updateData(key, value);
end

function RYTL:insertData(key, value)
    return database:insertData(key, value);
end

function RYTL:deleteData(key)
    return database:deleteData(key);
end
---------------


-- window相关方法
function RYTL:close()
    window:close();
end

function RYTL:alert(info)
    window:alert(info);
end

function RYTL:open(param)
    window:open(param);
end

function RYTL:show(param, tag, isContent,transitionType)
    if isContent == true then
        window:showContent(param, tag,transitionType);
    else
        local vars = document:getElementsByName(param);
        if vars and #vars > 0 then
            window:showControl(vars[1], tag,transitionType);
        end
    end
end

function RYTL:hide(id,transitionType)
    window:hide(id,transitionType);
end

---------------



-- location相关方法

function RYTL:replace(data)
    location:replace(data);
end

function RYTL:reload(force)
    location:reload(force);
end

---------------

-- history相关方法

local historyContent = nil; -- 得到的报文。
local historyRequest = 0; -- back键点击次数。

function RYTL:back()
    if historyRequest > 0 then
        return;
    else
        historyRequest = historyRequest + 1;
        historyContent = history:get(-1);
        if historyContent then
            window:replaceWithProgress(historyContent);
        end
    end
end

function RYTL:go(number)
    if historyRequest > 0 then
        return;
    else
        historyRequest = historyRequest + 1;
        historyContent = history:get(number);
        if historyContent then
            window:replaceWithProgress(historyContent);
        end
    end
end

function RYTL:add(content)
    history:add(content);
end

---------------

-- 相关工具方法
function RYTL:trim(string)
    return utility:trim(string);
end

function RYTL:base64(string)
    return utility:base64(string);
end

function RYTL:escapeURI(string)
    return utility:escapeURI(string);
end

function RYTL:escapeURL(string)
    return utility:escapeURL(string);
end
---------------

-- 定时器
-- interval:时间间隔（秒） repeats:true重复/false不重复  run:循环调用function   parameters:传入run方法的参数(table类型)
function RYTL:setInterval(interval, repeats, run, parameters)
    return timer:startTimer(interval, repeats, run, parameters);
end

function RYTL:clearInterval(timerobj)
    timer:stopTimer(timerobj);
end

---------------

-- 网络请求
-- header:HTTP头  url:请求地址  body:上传body  callback:请求结束后回到函数(function)  parameters:需要回调函数传入的参数table synchronous:是否为同步请求
function RYTL:post(header, url, body, callback, parameters, synchronous, flag)
   if synchronous==true then -- 同步网络请求
       local responseData = http:postSyn(header, url, body);
       if callback==nil then -- 如果没有回调函数直接返回响应报文
           return responseData;
       else
           local temp = {responseBody=responseData};
           if parameters and type(parameters)=="table" then
               for k,v in pairs(parameters) do 
                   temp[k] = v;
               end
           end
           callback(temp);
       end
   else -- 异步网络请求。
       if flag == true then -- 异步请求带dialog。 
           http:postAsyn(header, url, body, callback, parameters);
       else -- 异步请求不带dailog。
           http:postAsynWithoutDialog(header, url, body, callback, parameters);
       end
   end
end

---------------



------------------------------------------------------

-- 建立控件类结构  这里有问题
Control = {control};

function Control:new(c)
    c = c or {};      -- create table if users does not provide one
    setmetatable(c, self);
    self.__index = self;
    return c;
end

function Control:parent()
    return self.control:getParent();
end

function Control:children()
    return self.control:getChildren();
end

function Control:css(...)
    if 1 == arg.n then
        local name = arg[1];
        if type(name) ~= "string" then
            name = tostring(name);
        end;
        return self.control:getStyleByName(name);
    elseif 2 == arg.n then
        local name = arg[1];
        local value = arg[2];
        if type(name) ~= "string" then
            name = tostring(name);
        end;
        if type(value) ~= "string" then
            value = tostring(value);
        end;
        self.control:setStyleByName(name, value);
    end
end


function Control:html(content)
    self.control:setInnerHTML(content);
end


function Control:property(...)

    if 1 == arg.n then -- 返回当前控件属性值
        local name = arg[1];
        if type(name) ~= "string" then
            name = tostring(name);
        end;
        return self.control:getPropertyByName(name);
    elseif 2 == arg.n then
        local name = arg[1];
        local value = arg[2];
        if type(name) ~= "string" then
            name = tostring(name);
        end;
        if type(value) ~= "string" then
            value = tostring(value);
        end;
        self.control:setPropertyByName(name, value);
    end

end

-- 当控件更新时是否展示菊花动画
function Control:loading(start)
    if start == true then
        self.control:showLoading();
    else
        self.control:stopLoading();
    end
end

---------------------

local function matrixMultiply(matrix1, matrix1)
    
    newMatrix = {m11=nil, m12=nil, m13=nil, m21=nil, m22=nil, m23=nil, m31=nil, m32=nil, m33=nil};
    
    if table.getn(matrix1)==table.getn(matrix2) then
        newMatrix.m11 = matrix1.m11*matrix2.m11 + matrix1.m12*matrix2.m21 + matrix1.m13*matrix2.m31;
        newMatrix.m12 = matrix1.m11*matrix2.m12 + matrix1.m12*matrix2.m22 + matrix1.m13*matrix2.m32;
        newMatrix.m13 = matrix1.m11*matrix2.m13 + matrix1.m12*matrix2.m23 + matrix1.m13*matrix2.m33;
        
        newMatrix.m21 = matrix1.m21*matrix2.m11 + matrix1.m22*matrix2.m21 + matrix1.m23*matrix2.m31;
        newMatrix.m22 = matrix1.m21*matrix2.m12 + matrix1.m22*matrix2.m22 + matrix1.m23*matrix2.m32;
        newMatrix.m23 = matrix1.m21*matrix2.m13 + matrix1.m22*matrix2.m23 + matrix1.m23*matrix2.m33;
        
        newMatrix.m31 = matrix1.m31*matrix2.m11 + matrix1.m32*matrix2.m21 + matrix1.m33*matrix2.m31;
        newMatrix.m32 = matrix1.m31*matrix2.m12 + matrix1.m32*matrix2.m22 + matrix1.m33*matrix2.m32;
        newMatrix.m33 = matrix1.m31*matrix2.m13 + matrix1.m32*matrix2.m23 + matrix1.m33*matrix2.m33;
        
        return newMatrix;
    end
    
end

-- 控件动画(matrix)
local startAngle;
local ctimer;
local function run(parameters)

    local control = parameters[1];
    local style = parameters[2];   
    local endAngle;
    local sin;
    local cos;
    
    local matrix = control:getMatrix();
    local m11 = matrix["m11"];
    local m12 = matrix["m12"];
    local m13 = matrix["m13"];
    local m21 = matrix["m21"];
    local m22 = matrix["m22"];
    local m23 = matrix["m23"];
    local m31 = matrix["m31"];
    local m32 = matrix["m32"];
    local m33 = matrix["m33"];
    local offsetm11;
    local offsetm12;
    local offsetm13;
    local offsetm21;
    local offsetm22;
    local offsetm23;
    local offsetm31;
    local offsetm32;
    local offsetm33;
    local newm11;
    local newm12;
    local newm13;
    local newm21;
    local newm22;
    local newm23;
    local newm31;
    local newm32;
    local newm33;
    
    local modulus;
    
    
    if style~="scale" and style~="shearX" and style~="shearY" then
        endAngle = parameters[3];
    
        startAngle = startAngle + 2;
        
        if startAngle>=endAngle then
            startAngle = endAngle
        end
        
        sin = math.sin(math.rad(startAngle));
        cos = math.cos(math.rad(startAngle));
        if startAngle==0 or startAngle==180 or startAngle==360 then
            sin = 0;
        end
        if startAngle==90 or startAngle==270 then
            cos = 0;
        end
    end
    
    
    if style=="scale" then
        
        offsetm11 = parameters[3];
        newm11 = parameters[4];
        offsetm22 = parameters[5];
        newm22 = parameters[6];
        
        m11 = m11 + offsetm11;
        m22 = m22 + offsetm22;
        
        
        if m11>=newm11 then
            m11 = newm11;
        end
        if m22>=newm22 then
            m22 = newm22;
        end
        
        control:setMatrix{m11=m11,m22=m22};
        
    elseif style=="shearX" then
        
        offsetm21 = parameters[3];
        modulus = parameters[4];
        
        m21 = m21 + offsetm21;
        
        if offsetm21>0 then
            if m21>=modulus then
                m21 = modulus;
                timer:stopTimer(atimer);
                atimer = nil;
            end
        else
            if m21<=modulus then
                m21 = modulus;
                timer:stopTimer(atimer);
                atimer = nil;
            end
        end
        
        control:setMatrix{m21=m21};
        
    elseif style=="shearY" then
        offsetm12 = parameters[3];
        modulus = parameters[4];
        
        m12 = m12 + offsetm12;
        
        if offsetm12>0 then
            if m12>=modulus then
                m12 = modulus;
                timer:stopTimer(atimer);
                atimer = nil;
            end
        else
            if m12<=modulus then
                m12 = modulus;
                timer:stopTimer(atimer);
                atimer = nil;
            end
        end
        
        control:setMatrix{m12=m12};
        
    elseif style=="rotateY" then
        
        control:setMatrix{m11=cos,m13=-sin,m31=sin,m33=cos};
        
    elseif style=="rotateZClockwise" then
        
        control:setMatrix{m11=cos, m12=sin, m21=-sin, m22=cos};
        
    elseif style=="rotateZAntiClockwise" then
        
        control:setMatrix{m11=cos, m12=-sin, m21=sin, m22=cos};
        
    elseif style=="rotateX" then
        
        control:setMatrix{m22=cos, m23=sin, m32=-sin, m33=cos};
        
    end
    
    
    if style=="scale" then
        if m11==newm11 and m22==newm22 then
            timer:stopTimer(atimer);
            atimer = nil;
        end
    else
        if startAngle == endAngle then
            timer:stopTimer(atimer);
            atimer = nil;
        end
    end
    
end

-- 缩放
function Control:scale(scaleWidthTimes, scaleHeightTimes, animationInterval)
    
    if animationInterval>0 then
        
        local matrix = self.control:getMatrix();
        local m11 = matrix["m11"];
        local m22 = matrix["m22"];
        
        local offsetm11 = (scaleWidthTimes - m11)/10.0;
        local offsetm22 = (scaleHeightTimes - m22)/10.0;
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "scale", offsetm11, scaleWidthTimes, offsetm22, scaleHeightTimes});
    else
        self.control:setMatrix{m11=scaleWidthTimes, m22=scaleHeightTimes};
    end
end

-- 2D平面旋转（围绕z轴顺时针旋转）
function Control:rotateZClockwise(angle, animationInterval)

    startAngle = 0.0;
    
    local sin = math.sin(math.rad(angle));
    local cos = math.cos(math.rad(angle));
    
    if degree==0 or degree==180 or degree==360 then
        sin = 0;
    end
    
    if degree==90 or degree==270 then
        cos = 0;
    end
    
    if animationInterval > 0 then
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "rotateZClockwise", angle});
    else
        self.control:setMatrix{m11=cos, m12=sin, m21=-sin, m22=cos};
    end
    
end

-- 2D平面旋转（围绕z轴逆时针旋转）
function Control:rotateZAntiClockwise(angle, animationInterval)

    startAngle = 0.0;
    
    local sin = math.sin(math.rad(angle));
    local cos = math.cos(math.rad(angle));
    
    if angle==0 or angle==180 or angle==360 then
        sin = 0;
    end
    
    if angle==90 or angle==270 then
        cos = 0;
    end
    
    if animationInterval>0 then
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "rotateZAntiClockwise", angle});
    else
        self.control:setMatrix{m11=cos, m12=-sin, m21=sin, m22=cos};
    end
    
end


-- 水平翻转（以y轴为轴旋转）
function Control:rotateY(angle, animationInterval)

    startAngle = 0.0;
    
    local sin = math.sin(math.rad(angle));
    local cos = math.cos(math.rad(angle));
    
    if angle==0 or angle==180 or angle==360 then
        sin = 0;
    end
    
    if angle==90 or angle==270 then
        cos = 0;
    end
    
    if animationInterval>0 then
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "rotateY", angle});
    else
        self.control:setMatrix{m11=cos,m13=sin,m31=-sin,m33=cos};
    end
    
end

-- 垂直翻转（以x轴为轴旋转）。（当angle为180度时，变为镜像）
function Control:rotateX(angle, animationInterval)
    
    startAngle = 0.0;
    
    local sin = math.sin(math.rad(angle));
    local cos = math.cos(math.rad(angle));
    
    if angle==0 or angle==180 or angle==360 then
        sin = 0;
    end
    
    if angle==90 or angle==270 then
        cos = 0;
    end
    
    if animationInterval>0 then
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "rotateX", angle});
    else
        self.control:setMatrix{m22=cos,m23=sin,m32=-sin,m33=cos};
    end
    
end

-- x轴错切（Y轴坐标不变，X坐标随初值及变换系数M21做线性变化，M21>0沿+X方向错切，M21<0沿-X方向错切）
function Control:shearX(modulus, animationInterval)

    local matrix = self.control:getMatrix();
    local m21 = matrix["m21"];
        
    local offsetm21 = (modulus - m21)/10.0;
    
    if animationInterval>0 then
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "shearX", offsetm21, modulus});
    else
        self.control:setMatrix{m21=modulus};
    end
    
end

-- y轴错切（X轴坐标不变，Y坐标随初值及变换系数M12做线性变化，M12>0沿+Y方向错切，M12<0沿-Y方向错切）
function Control:shearY(modulus, animationInterval)

    local matrix = self.control:getMatrix();
    local m12 = matrix["m12"];
        
    local offsetm12 = (modulus - m12)/10.0;
    
    if animationInterval>0 then
        ctimer = timer:startTimer(animationInterval, true, run, {self.control, "shearY", offsetm12, modulus});
    else
        self.control:setMatrix{m12=modulus};
    end
    
end
---------------------



