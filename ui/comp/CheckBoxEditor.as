package ui.comp
{
	import components.CheckBoxInfo;
	import components.TextFormatInfo;
	
	import fl.controls.CheckBox;
	
	import flash.display.DisplayObjectContainer;
	
	import ui.struct.BaseData;
	import ui.struct.CheckBoxData;
	
	public class CheckBoxEditor extends CheckBox implements IComponentEditor
	{
		public var checkBoxDic : Object;
		private var _skinName : String;
		
		private var _originWidth : int;
		private var _originHeight : int;
		
		public var textFormatStr : String;
		public var disabledTextFormatStr : String;
		
		public var checkBoxData : CheckBoxData;
		private var _textFormatInfo : TextFormatInfo;
		private var _disabledTextFormatInfo : TextFormatInfo;
		
		public function CheckBoxEditor()
		{
			super();
			_skinName = "";
			_originHeight = height;
			_originWidth = width;
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
				var skinInfo : CheckBoxInfo = checkBoxDic[skinName];
				if(skinInfo != null)
				{
					setStyle("upIcon", skinInfo.upIcon.getScaleBitmap());
					setStyle("overIcon", skinInfo.overIcon.getScaleBitmap());
					setStyle("downIcon", skinInfo.downIcon.getScaleBitmap());
					setStyle("disabledIcon", skinInfo.disabledIcon.getScaleBitmap());
					setStyle("selectedUpIcon", skinInfo.selectedUpIcon.getScaleBitmap());
					setStyle("selectedOverIcon", skinInfo.selectedOverIcon.getScaleBitmap());
					setStyle("selectedDownIcon", skinInfo.selectedDownIcon.getScaleBitmap());
					setStyle("selectedDisabledIcon", skinInfo.selectedDisabledIcon.getScaleBitmap());
					
				}
				else
				{
					setStyle("upIcon", CheckBox_upIcon);
					setStyle("overIcon", CheckBox_overIcon);
					setStyle("downIcon", CheckBox_downIcon);
					setStyle("disabledIcon", CheckBox_disabledIcon);
					setStyle("selectedUpIcon",CheckBox_selectedUpIcon);
					setStyle("selectedOverIcon", CheckBox_selectedOverIcon);
					setStyle("selectedDownIcon", CheckBox_selectedDownIcon);
					setStyle("selectedDisabledIcon", CheckBox_selectedDisabledIcon);
					
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
		
		public function clone():CheckBoxEditor
		{
			var checkBoxEditor : CheckBoxEditor = new CheckBoxEditor();
			checkBoxEditor.name = name;
			checkBoxEditor.checkBoxDic = checkBoxDic;
			checkBoxEditor.changeSkin(getSkinName());
			checkBoxEditor.x = x;
			checkBoxEditor.y = y;
			checkBoxEditor.width = width;
			checkBoxEditor.height = height;
			if(_textFormatInfo != null)
			{
				checkBoxEditor.changeTextFormat(_textFormatInfo);
			}
			if(_disabledTextFormatInfo)
			{
				checkBoxEditor.changeDisabledTextFormat(_disabledTextFormatInfo);
			}
			checkBoxEditor.label = label;
			return checkBoxEditor;
		}
		
		public function getData():BaseData
		{
			return checkBoxData;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return this;
		}
	}
}