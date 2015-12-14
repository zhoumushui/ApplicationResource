ViewOwner={}
ViewMap = {
		View = "com.netease.colorui.view.util.ViewUtil",
		TextView = "com.netease.colorui.view.util.TextViewUtil",
		EditText = "com.netease.colorui.view.util.EditTextUtil",
		FrameLayout="com.netease.colorui.view.util.ViewLayoutUtil",
		Button = "com.netease.colorui.view.util.ButtonUtil",
	--	ImageView = "com.netease.colorui.view.util.ImageViewUtil",
		ImageView = "com.netease.colorui.view.util.YixinImageViewUtil",
		HtmlTextView = "com.netease.colorui.view.util.HtmlTextViewUtil",
		ScrollView = "com.netease.colorui.view.util.ScrollViewUtil",
		HorizontalScrollView = "com.netease.colorui.view.util.HorizontalScrollViewUtil",
		PickerView =  "com.netease.colorui.view.util.PickerViewUtil",
		SwitchButton = "com.netease.colorui.view.util.SwitchButtonUtil",
		TableView=  "com.netease.colorui.view.util.TableViewUtil",
		WebView=  "com.netease.colorui.view.util.WebViewUtil",
		DatePicker =  "com.netease.colorui.view.util.DatePickerUtil",
		MultipleSelectedView =  "com.netease.colorui.view.util.MultipleSelectedViewUtil",
	--	QRView =  "com.netease.colorui.view.util.QRViewUtil",
		ViewPager =  "com.netease.colorui.view.util.ViewPagerUtil",
}



ViewOwner.View =  luabridge.bindClass(ViewMap.View)	
ViewOwner.TextView =  luabridge.bindClass(ViewMap.TextView)	
ViewOwner.FrameLayout =  luabridge.bindClass(ViewMap.FrameLayout)	
ViewOwner.Button =  luabridge.bindClass(ViewMap.Button)	
ViewOwner.ImageView =  luabridge.bindClass(ViewMap.ImageView)	
ViewOwner.HtmlTextView =  luabridge.bindClass(ViewMap.HtmlTextView)	
ViewOwner.ScrollView = luabridge.bindClass(ViewMap.ScrollView)	
ViewOwner.HorizontalScrollView = luabridge.bindClass(ViewMap.HorizontalScrollView)	
ViewOwner.PickerView =  luabridge.bindClass(ViewMap.PickerView)	
ViewOwner.EditText =  luabridge.bindClass(ViewMap.EditText)	
ViewOwner.SwitchButton=  luabridge.bindClass(ViewMap.SwitchButton)	
ViewOwner.TableView=  luabridge.bindClass(ViewMap.TableView)
ViewOwner.WebView=  luabridge.bindClass(ViewMap.WebView)
--ViewOwner.VedioPlayerView=  luabridge.bindClass(ViewMap.VedioPlayerView)
ViewOwner.DatePicker=  luabridge.bindClass(ViewMap.DatePicker)
ViewOwner.MultipleSelectedView=  luabridge.bindClass(ViewMap.MultipleSelectedView)
--ViewOwner.QRView = luabridge.bindClass(ViewMap.QRView)
ViewOwner.ViewPager = luabridge.bindClass(ViewMap.ViewPager)
--ViewOwner.GifImageView =   luabridge.bindClass(ViewMap.GifImageView)

function ViewOwner:createView(viewName,context)
		--print("viewName is "..viewName)
	return ViewOwner[viewName]["newView.(Landroid/content/Context;)Landroid/view/View;"](ViewOwner[viewName],context)
end