package ui.comp
{
	import components.ButtonInfo;
	import components.TextFormatInfo;
	
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.skins.halo.ButtonSkin;
	
	import ui.struct.BaseData;
	import ui.struct.ButtonData;

	public class ButtonEditor extends Button implements IComponentEditor
	{
		public var buttonDic : Object;
		public var resizable : Boolean;
		public var textFormatStr : String;
		public var disabledTextFormatStr : String;
		private var _skinName : String;
		private var _originWidth : int;
		private var _originHeight : int;
		private var _textFormatInfo : TextFormatInfo;
		private var _disabledTextFormatInfo : TextFormatInfo;
		
		public var buttonData : ButtonData;
		
		public function ButtonEditor()
		{
			super();
			_skinName = "";
			_originHeight = height;
			_originWidth = width;
			resizable = true;
			textFormatStr = "";
			disabledTextFormatStr = "";
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
				var skinInfo : ButtonInfo = buttonDic[skinName];
				if(skinInfo != null)
				{
					resizable = skinInfo.resizable;
					setStyle("upSkin",skinInfo.upSkin.getScaleBitmap());
					setStyle("overSkin",skinInfo.overSkin.getScaleBitmap());
					setStyle("downSkin",skinInfo.downSkin.getScaleBitmap());
					setStyle("disabledSkin",skinInfo.disabledSkin.getScaleBitmap());
					setStyle("emphasizedSkin", Button_emphasizedSkin);
					setStyle("selectedUpSkin",Button_selectedUpSkin);
					setStyle("selectedOverSkin",Button_selectedOverSkin);
					setStyle("selectedDownSkin",Button_selectedDownSkin);
					setStyle("selectedDisabledSkin",Button_selectedDisabledSkin);
					this.width = skinInfo.upSkin.width;
					this.height = skinInfo.upSkin.height;
				}
				else
				{
					setStyle("upSkin",Button_upSkin);
					setStyle("overSkin",Button_overSkin);
					setStyle("downSkin",Button_downSkin);
					setStyle("disabledSkin", Button_disabledSkin);
					this.width = _originWidth;
					this.height = _originHeight;
					resizable = true;
				}
			}
		}
		
		public function changeTextFormat(textFormatInfo : TextFormatInfo):void
		{
			setStyle("textFormat", textFormatInfo.textFormat);
			textFormatStr = textFormatInfo.label;
			_textFormatInfo = textFormatInfo;
		}
		
		public function changeDisabledTextFormat(textFormatInfo : TextFormatInfo):void
		{
			setStyle("disabledTextFormat", textFormatInfo.textFormat);
			disabledTextFormatStr = textFormatInfo.label;
			_disabledTextFormatInfo = textFormatInfo;
		}
		
		public function clone():ButtonEditor
		{
			var buttonEditor : ButtonEditor = new ButtonEditor();
			buttonEditor.name = name;
			buttonEditor.buttonDic = buttonDic;
			buttonEditor.changeSkin(getSkinName());
			buttonEditor.x = x;
			buttonEditor.y = y;
			buttonEditor.width = width;
			buttonEditor.height = height;
			if(_textFormatInfo != null)
			{
				buttonEditor.changeTextFormat(_textFormatInfo);
			}
			if(_disabledTextFormatInfo)
			{
				buttonEditor.changeDisabledTextFormat(_disabledTextFormatInfo);
			}
			buttonEditor.label = label;
			
			return buttonEditor;
		}

		public function getData():BaseData
		{
			return buttonData;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return this;
		}
	}
}