--[[
	key值:控件uuid
	value:回调函数表
]]
NodeRefTable = {}


function addNodeRef(value)

	 	local key = tostring(uuid())
	 	NodeRefTable[key] = value
		return key
end

function unNodeRef(key)
		print("unnoderef")
	NodeRefTable[key] = nil
	
end

function getNodeRef(key)

	return NodeRefTable[key]
end

function clearNodes()		
	print("clearNodes")

 	for i, v in pairs(NodeRefTable) do 	
		NodeRefTable[i] = nil
	 end
end


function printNode()
	for i, v in pairs(NodeRefTable) do 	
		print("node  "..i)
	 end
end
