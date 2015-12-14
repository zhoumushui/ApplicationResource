local NameMapMt = {
   __index = function(namemap, propName)
--[[
      print("$$$$$$$$$$$$$$$$$$$$get none exist prop:" .. propName .. "$$$$$$$$$$$$$$$$$$$$$$$")
      print(debug.traceback())
      ]]
      local map = {}
      namemap[propName] = map
      map[1] = "_" .. propName
      map[2] = string.getterName(propName)
      map[3] = string.setterName(propName)
      map[4] = string.propChangeEvtName(propName)
      map[5] = string.applyName(propName)

      --print(table.tostring(map))
      return map
   end
}

NameMap = setmetatable({}, NameMapMt)
NameMap["width"] = {
   "_width", "getWidth","setWidth","onWidthChanged", "applyWidth"
}

NameMap["height"]={
   "_height", "getHeight", "setHeight", "onHeightChanged", "applyHeight"
}

NameMap["maskImage"]={
   "_maskImage", "getMaskImage", "setMaskImage", "onMaskImageChanged", "applyMaskImage"
}

if not platform.isIOS() then
  NameMap["maxLength"]={
     "_maxLength", "getMaxLength", "setMaxLength", "onMaxLengthChanged", "applyMaxLength"
  }
end


NameMap["minWidth"]={
   "_minWidth", "getMinWidth", "setMinWidth", "onMinWidthChanged", "applyMinWidth"
}

NameMap["maxWidth"]={
   "_maxWidth",   "getMaxWidth", "setMaxWidth", "onMaxWidthChanged", "applyMaxWidth"
}

NameMap["minHeight"]={
   "_minHeight", "getMinHeight", "setMinHeight", "onMinHeightChanged", "applyMinHeight"
}

NameMap["maxHeight"]={
   "_maxHeight", "getMaxHeight", "setMaxHeight", "onMaxHeightChanged", "applyMaxHeight"
}

NameMap["left"]={
   "_left", "getLeft", "setLeft", "onLeftChanged", "applyLeft"
}

NameMap["top"]={
   "_top", "getTop", "setTop", "onTopChanged", "applyTop"
}

NameMap["angle"]={
   "_angle", "getAngle", "setAngle", "onAngleChanged", "applyAngle"
}

NameMap["scale"]={
   "_scale", "getScale", "setScale", "onScaleChanged", "applyScale"
}

NameMap["borderWidth"]={
   "_borderWidth", "getBorderWidth", "setBorderWidth", "onBorderWidthChanged", "applyBorderWidth"
}

NameMap["borderColor"]={
   "_borderColor", "getBorderColor", "setBorderColor", "onBorderColorChanged", "applyBorderColor"
}

NameMap["backgroundColor"]={
   "_backgroundColor", "getBackgroundColor", "setBackgroundColor", "onBackgroundColorChanged", "applyBackgroundColor"
}

NameMap["clipsToBounds"]={
   "_clipsToBounds", "getClipsToBounds", "setClipsToBounds", "onClipsToBoundsChanged", "applyClipsToBounds"
}

NameMap["id"]={
   "_id", "getId", "setId", "onIdChanged", "applyId"
}

NameMap["layout"]={
   "_layout", "getLayout", "setLayout", "onLayoutChanged", "applyLayout"
}

NameMap["renderObject"]={
   "_renderObject",  "getRenderObject", "setRenderObject", "onRenderObjectChanged", "applyRenderObject"
}

NameMap["text"]={
   "_text", "getText", "setText", "onTextChanged", "applyText"
}

NameMap["hint"]={
   "_hint", "getHint", "setHint", "onHintChanged", "applyHint"
}

NameMap["hintColor"]={
   "_hintColor", "getHintColor", "setHintColor", "onHintColorChanged", "applyHintColor"
}

NameMap["color"]={
   "_color", "getColor", "setColor", "onColorChanged", "applyColor"
}

NameMap["state"]={
   "_state", "getState", "setState", "onStateChanged", "applyState"
}

NameMap["states"]={
   "_states", "getStates", "setStates", "onStatesChanged", "applyStates"
}

NameMap["enabled"]={
  "_enabled",  "getEnabled", "setEnabled", "onEnabledChanged", "applyEnabled"
}

NameMap["backgroundImage"]={
   "_backgroundImage", "getBackgroundImage", "setBackgroundImage", "onBackgroundImageChanged", "applyBackgroundImage"
}

NameMap["backgroundEdgeInset"]={
   "_backgroundEdgeInset", "getBackgroundEdgeInset", "setBackgroundEdgeInset", "onBackgroundEdgeInsetChanged", "applyBackgroundEdgeInset"
}

NameMap["items"]={
  "_items", "getItems", "setItems", "onItemsChanged", "applyItems"
}

NameMap["backgroundImage"]={
   "_backgroundImage", "getBackgroundImage", "setBackgroundImage", "onBackgroundImageChanged", "applyBackgroundImage"
}

NameMap["backgroundImageView"]={
   "_backgroundImageView", "getBackgroundImageView", "setBackgroundImageView", "onBackgroundImageViewChanged", "applyBackgroundImageView"
}

NameMap["backgroundEdgeInset"]={
   "_backgroundEdgeInset", "getBackgroundEdgeInset", "setBackgroundEdgeInset", "onBackgroundEdgeInsetChanged", "applyBackgroundEdgeInset"
}

NameMap["dir"]={
   "_dir", "getDir", "setDir", "onDirChanged", "applyDir"
}

NameMap["fontSize"]={
   "_fontSize", "getFontSize", "setFontSize", "onFontSizeChanged", "applyFontSize"
}

NameMap["fontStyle"]={
   "_fontStyle", "getFontStyle", "setFontStyle", "onFontStyleChanged", "applyFontStyle"
}

NameMap["lineSpacing"]={
   "_lineSpacing", "getLineSpacing", "setLineSpacing", "onLineSpacingChanged", "applyLineSpacing"
}

NameMap["edgeInset"]={
   "_edgeInset", "getEdgeInset", "setEdgeInset", "onEdgeInsetChanged", "applyEdgeInset"
}

NameMap["contentSize"]={
   "_contentSize", "getContentSize", "setContentSize", "onContentSizeChanged", "applyContentSize"
}

NameMap["pagingEnabled"]={
   "_pagingEnabled", "getPagingEnabled", "setPagingEnabled", "onPagingEnabledChanged", "applyPagingEnabled"
}

NameMap["contentinset"]={
   "_contentinset", "getContentinset", "setContentinset", "onContentinsetChanged", "applyContentinset"
}

NameMap["showsVerticalScrollIndicator"]={
   "_showsVerticalScrollIndicator", "getShowsVerticalScrollIndicator", "setShowsVerticalScrollIndicator", "onShowsVerticalScrollIndicatorChanged", "applyShowsVerticalScrollIndicator"
}

NameMap["showsHorizontalScrollIndicator"]={
   "_showsHorizontalScrollIndicator", "getShowsHorizontalScrollIndicator", "setShowsHorizontalScrollIndicator", "onShowsHorizontalScrollIndicatorChanged", "applyShowsHorizontalScrollIndicator"
}

NameMap["node"]={
   "_node", "getNode", "setNode", "onNodeChanged", "applyNode"
}

NameMap["renderStyle"]={
  "_renderStyle", "getRenderStyle", "setRenderStyle", "onRenderStyleChanged", "applyRenderStyle"
}

NameMap["oldRenderStyle"]={
   "_oldRenderStyle", "getOldRenderStyle", "setOldRenderStyle", "onOldRenderStyleChanged", "applyOldRenderStyle"
}

NameMap["needsLayout"]={
   "_needsLayout", "getNeedsLayout", "setNeedsLayout", "onNeedsLayoutChanged", "applyNeedsLayout"
}

NameMap["widthResolved"]={
   "_widthResolved", "getWidthResolved", "setWidthResolved", "onWidthResolvedChanged", "applyWidthResolved"
}

NameMap["heightResolved"]={
  "_heightResolved",  "getHeightResolved", "setHeightResolved", "onHeightResolvedChanged", "applyHeightResolved"
}

NameMap["parent"]={
   "_parent", "getParent", "setParent", "onParentChanged", "applyParent"
}

NameMap["children"]={
   "_children", "getChildren", "setChildren", "onChildrenChanged", "applyChildren"
}

NameMap["sizeModel"]={
  "_sizeModel", "getSizeModel", "setSizeModel", "onSizeModelChanged", "applySizeModel"
}

NameMap["layouts"]={
   "_layouts", "getLayouts", "setLayouts", "onLayoutsChanged", "applyLayouts"
}

NameMap["startX"]={
   "_startX", "getStartX", "setStartX", "onStartXChanged", "applyStartX"
}

NameMap["startY"]={
   "_startY", "getStartY", "setStartY", "onStartYChanged", "applyStartY"
}

NameMap["ownerRenderObject"]={
   "_ownerRenderObject", "getOwnerRenderObject", "setOwnerRenderObject", "onOwnerRenderObjectChanged", "applyOwnerRenderObject"
}

NameMap["renderItems"]={
   "_renderItems", "getRenderItems", "setRenderItems", "onRenderItemsChanged", "applyRenderItems"
}

NameMap["done"]={
   "_done", "getDone", "setDone", "onDoneChanged", "applyDone"
}

NameMap["dir"]={
   "_dir", "getDir", "setDir", "onDirChanged", "applyDir"
}

NameMap["pack"]={
   "_pack", "getPack", "setPack", "onPackChanged", "applyPack"
}

NameMap["align"]={
   "_align", "getAlign", "setAlign", "onAlignChanged", "applyAlign"
}

NameMap["lines"]={
   "_lines", "getLines", "setLines", "onLinesChanged", "applyLines"
}

NameMap["observers"]={
   "_observers", "getObservers", "setObservers", "onObserversChanged", "applyObservers"
}

NameMap["maxLines"]={
   "_maxLines", "getMaxLines", "setMaxLines", "onMaxLinesChanged", "applyMaxLines"
}

NameMap["owner"]={
    "_owner",
    "getOwner",
    "setOwner",
    "onOwnerChanged",
    "applyOwner",
}


NameMap["statePropertyName"]={
   "_statePropertyName",
   "getStatePropertyName",
   "setStatePropertyName",
   "onStatePropertyNameChanged",
   "applyStatePropertyName",
}

NameMap["activeColor"]={
   "_activeColor",
   "getActiveColor",
   "setActiveColor",
   "onActiveColorChanged",
   "applyActiveColor",
}

NameMap["src"]={
   "_src",
   "getSrc",
   "setSrc",
   "onSrcChanged",
   "applySrc",
}

NameMap["propName"]={
   "_propName",
   "getPropName",
   "setPropName",
   "onPropNameChanged",
   "applyPropName",
}

NameMap["context"]={
   "_context",
   "getContext",
   "setContext",
   "onContextChanged",
   "applyContext",
}

NameMap["store"]={
     "_store",
   "getStore",
   "setStore",
   "onStoreChanged",
   "applyStore",
}

NameMap["doingLayoutRestore"]={
  "_doingLayoutRestore",
   "getDoingLayoutRestore",
   "setDoingLayoutRestore",
   "onDoingLayoutRestoreChanged",
   "applyDoingLayoutRestore",
}

NameMap["flex"]={
   "_flex",
   "getFlex",
   "setFlex",
   "onFlexChanged",
   "applyFlex"
}

NameMap["name"]={
   "_name",
   "getName",
   "setName",
   "onNameChanged",
   "applyName",
}

NameMap["events"]={
  "_events",
  "getEvents",
  "setEvents",
  "onEventsChanged",
  "applyEvents"
}


NameMap["menuactions"]={
  "_menuactions",
  "getMenuactions",
  "setMenuactions",
}



NameMap["bigImg"]={
  "_bigImg",
  "getBigImg",
  "setBigImg",
  "onBigImgChanged",
  "applyBigImg",
}

NameMap["desc"]={
  "_desc",
  "getDesc",
  "setDesc",
  "onDescChanged",
  "applyDesc",
}

NameMap["ui"]={
   "_ui",
   "getUi",
   "setUi",
   "onUiChanged",
   "applyUi",
}

NameMap["data"]={
   "_data",
  "getData",
  "setData",
  "onDataChanged",
  "applyData",
}

NameMap["dataSource"]={
  "_dataSource",
  "getDataSource",
  "setDataSource",
  "onDataSourceChanged",
  "applyDataSource",
}

NameMap["startTime"]={
  "_startTime",
  "getStartTime",
  "setStartTime",
  "onStartTimeChanged",
  "applyStartTime",
}

NameMap["curTime"]={
  "_curTime",
  "getCurTime",
  "setCurTime",
  "onCurTimeChanged",
  "applyCurTime",
}

NameMap["endTime"]={
   "_endTime",
  "getEndTime",
  "setEndTime",
  "onEndTimeChanged",
  "applyEndTime",
}

NameMap["valueLabel"]={
  "_valueLabel",
  "getValueLabel",
  "setValueLabel",
  "onValueLabelChanged",
  "applyValueLabel",
}

NameMap["indent"]={
  "_indent",
  "getIndent",
  "setIndent",
  "onIndentChanged",
  "applyIndent",
}

NameMap["pickerDialog"]={
  "_pickerDialog",
  "getPickerDialog",
  "setPickerDialog",
  "onPickerDialogChanged",
  "applyPickerDialog",
}

NameMap["datePickerContainer"] = {
  "_datePickerContainer",
  "getDatePickerContainer",
  "setDatePickerContainer",
  "onDatePickerContainerChanged",
  "applyDatePickerContainer",
}

NameMap["defaultValue"]={
  "_defaultValue",
  "getDefaultValue",
  "setDefaultValue",
  "onDefaultValueChanged",
  "applyDefaultValue",
}

NameMap["pickerContainer"] = {
   "_pickerContainer",
  "getPickerContainer",
  "setPickerContainer",
  "onPickerContainerChanged",
  "applyPickerContainer",
}

NameMap["bgAlpha"] = {
  "_bgAlpha",
  "getBgAlpha",
  "setBgAlpha",
  "onBgAlphaChanged",
  "applyBgAlpha",
}
if not platform.isIOS() then
NameMap["title"]={
  "_title",
  "getTitle",
  "setTitle",
  "onTitleChanged",
  "applyTitle",
}
end
--for test
NameMap["zp"]={
    "_zp",
   "getZp",
   "setZp",
   "onZpChanged",
   "applyZp",
}
