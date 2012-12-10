package ui.comp
{
	import components.UIPanelInfo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;
	
	import ui.struct.BaseData;
	import ui.struct.UIPanelData;

	public class UIPanelEditor extends UIPanel implements IComponentEditor
	{
		public var panelDic : Object;
		private var _skinName : String;

		public var panelData : UIPanelData;
		public var resizable : Boolean;

		public function UIPanelEditor()
		{
			super();
			resizable = true;
		}
		
		public function getSkinName():String
		{
			return _skinName;
		}
		
		public function changeSkin(skinName : String):void
		{
			if(_skinName != skinName)
			{
				_skinName = skinName;
				var skinInfo : UIPanelInfo = panelDic[skinName];
				if(skinInfo != null)
				{
					resizable = skinInfo.resizable;
					setStyle("skin", skinInfo.skin.getScaleBitmap());
					this.width = skinInfo.skin.width;
					this.height = skinInfo.skin.height;
				}
				else
				{
					var bitmap : Bitmap = new Bitmap(new BitmapData(1,1,true,0x00000000));
					setStyle("skin", bitmap);
					this.width = 100;
					this.height = 100;
					resizable = true;
				}
			}
		}
		
		public function clone():UIPanelEditor
		{
			var uipanelEditor : UIPanelEditor = new UIPanelEditor();
			uipanelEditor.name = name;
			uipanelEditor.panelDic = panelDic;
			uipanelEditor.changeSkin(getSkinName());
			uipanelEditor.x = x;
			uipanelEditor.y = y;
			uipanelEditor.width = width;
			uipanelEditor.height = height;
			return uipanelEditor;
		}
		
		public function getData():BaseData
		{
			return panelData;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return this;
		}
	}
}