SystemInfo={
}

--from Colortouch to android native
function SystemInfo:getPX(dp)
	return dp
	--return SystemInfo['screenRadio'] * ç
end

--from android native to Colortouch
function SystemInfo:getDP(px)
	return px / SystemInfo['screenRadio']
end

function setProp(radio,scale)
	SystemInfo['screenRadio'] = radio
	SystemInfo['screenScale'] = scale
end

