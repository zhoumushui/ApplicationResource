function isNodeCanCopy(key) 
	local node= getNodeRef(key) 
	local copy = MenuProp.isRootCopy(node) 
	return copy 
end


function  getCopyContent(key) 
	local node= getNodeRef(key) 	
	local copycontent = MenuProp.getRootCopyContent(node)  
	return copycontent  
end