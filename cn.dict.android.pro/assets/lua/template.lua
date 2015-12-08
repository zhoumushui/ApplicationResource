local setmetatable = setmetatable
local tostring = tostring
local setfenv = setfenv
local concat = table.concat
local assert = assert
local open = io.open
local load = load
local type = type

local HTML_ENTITIES = {
    ["&"] = "&amp;",
    ["<"] = "&lt;",
    [">"] = "&gt;",
    ['"'] = "&quot;",
    ["'"] = "&#39;",
    ["/"] = "&#47;"
}

local CODE_ENTITIES = {
    ["{"] = "&#123;",
    ["}"] = "&#125;"
}

local caching, ngx_var, ngx_capture, ngx_null = true
local template = { cache = {}, concat = concat }
local var_use_global_include = true

local function read_file(path)
	return rawLoadFile(path)
end


local function load_lua(path)
    return read_file(path) or path
end


template.print = print
template.load  = load_lua


local context = setmetatable({ context = {}, template = template }, {
    __index = function(t, k)
        return t.context[k] or t.template[k] or _G[k]
    end
})

local load_chunk

if _VERSION == "Lua 5.1" and type(jit) ~= "table" then
    load_chunk = function(view)
        local func = assert(loadstring(view))
        setfenv(func, context)
        return func
    end
else
    load_chunk = function(view)
        return assert(load(view, nil, "tb", context))
    end
end

--增加include对环境变量的支持
function template.use_global_include(enable)
  var_use_global_include = enable
end
function template.global_include(html)
  loop_depth = 0
  while string.match(html,"(%{%((.-)%)%})") do
    for tag,file in string.gmatch(html, "(%{%((.-)%)%})") do
      tag = string.gsub(tag, "[{()}]", "%%%1")
      file = string.gsub(read_file(file), "%%", "%%%%")
      html = string.gsub(html, tag, file)
    end
    loop_depth = loop_depth + 1
    if loop_depth > 10 then break end
  end
  return html
end

function template.caching(enable)
    if enable ~= nil then caching = enable == true end
    return caching
end

function template.output(s)
    if s == nil or s == ngx_null then return "" end
    if type(s) == "function" then return template.output(s()) end
    return tostring(s)
end

function template.escape(s, c)
    if type(s) == "string" then
        if c then s = s:gsub("[}{]", CODE_ENTITIES) end
        return s:gsub("[\">/<'&]", HTML_ENTITIES)
    end
    return template.output(s)
end

function template.new(view, layout)
    assert(view, "view was not provided for template.new(view, layout).")
    local render, compile = template.render, template.compile
    if layout then
        return setmetatable({ render = function(self, context)
            local context = context or self
            context.view = compile(view)(context)
            render(layout, context)
        end }, { __tostring = function(self)
            local context = context or self
            context.view = compile(view)(context)
            return compile(layout)(context)
        end })
    end
    return setmetatable({ render = function(self, context)
        render(view, context or self)
    end }, { __tostring = function(self)
        return compile(view)(context or self)
    end })
end

function template.precompile(view, path, strip)
    local chunk = string.dump(template.compile(view), strip ~= false)
    if path then
        local file = io.open(path, "wb")
        file:write(chunk)
        file:close()
    end
    return chunk
end

function template.compile(view, key)
    assert(view, "view was not provided for template.compile(view, key).")
    key = key or view
    local cache = template.cache
    if cache[key] then return cache[key], true end
    local view_data = template.parse(view)
    local func = load_chunk(view_data)
    if caching then cache[key] = func end
    return func, false
end

function template.parse(view)
    assert(view, "view was not provided for template.parse(view).")
    view = template.load(view)
    if var_use_global_include then
       view = template.global_include(view)
    end
    if view:sub(1, 1):byte() == 27 then return view end
    local c = {
        "context=... or {}",
        "local ___={}"
    }
    local i, j, s, e = 0, 0, view:find("{", 1, true)
    while s do
        local t = view:sub(s, e + 1)
        if t == "{{" then
            local x, y = view:find("}}", e + 2, true)
            if x then
                if j ~= s then c[#c+1] = "___[#___+1]=[=[" .. view:sub(j, s - 1) .. "]=]" end
                c[#c+1] = "___[#___+1]=template.output(" .. view:sub(e + 2, x - 1) .. ")"
                i, j = y, y + 1
            end
        elseif t == "{*" then
            local x, y = view:find("*}", e + 2, true)
            if x then
                if j ~= s then c[#c+1] = "___[#___+1]=[=[" .. view:sub(j, s - 1) .. "]=]" end
                c[#c+1] = "___[#___+1]=template.escape(" .. view:sub(e + 2, x - 1) .. ")"
                i, j = y, y + 1
            end
        elseif t == "{%" then
            local x, y = view:find("%}", e + 2, true)
            if x then
                if j ~= s then c[#c+1] = "___[#___+1]=[=[" .. view:sub(j, s - 1) .. "]=]" end
                c[#c+1] = view:sub(e + 2, x - 1)
                if view:sub(y + 1, y + 1) == "\n" then
                    i, j = y + 1, y + 2
                else
                    i, j = y, y + 1
                end
            end
        elseif t == "{(" then
            local x, y = view:find(")}", e + 2, true)
            if x then
                if j ~= s then c[#c+1] = "___[#___+1]=[=[" .. view:sub(j, s - 1) .. "]=]" end
                c[#c+1] = '___[#___+1]=template.compile([=[' .. view:sub(e + 2, x - 1) .. ']=])(context)'
                i, j = y, y + 1
            end
        end
        i = i + 1
        s, e = view:find("{", i, true)
    end
    c[#c+1] = "___[#___+1]=[=[" .. view:sub(j) .. "]=]"
    c[#c+1] = "return template.concat(___)"
    return concat(c, "\n")
end

local json = require "json"
function template.render(view, context, key)
    assert(view, "view was not provided for template.render(view, context, key).")
    local func = template.compile(view, key)
    local html = func(context)
    return html
end

return template
