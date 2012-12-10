package ui.comp
{
	import components.TextFormatInfo;
	
	import fl.controls.Label;
	
	import flash.display.DisplayObjectContainer;
	
	import ui.struct.BaseData;
	import ui.struct.LabelData;

	public class LabelEditor extends Label implements IComponentEditor
	{
		public var textFormatStr : String;
		public var disabledTextFormatStr : String;
		private var _textFormatInfo : TextFormatInfo;
		private var _disabledTextFormatInfo : TextFormatInfo;
		
		public var labelData : LabelData;
		
		public function LabelEditor()
		{
			super();
			textFormatStr = "";
			disabledTextFormatStr = "";
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
		
		public function clone():LabelEditor
		{
			var labEditor : LabelEditor = new LabelEditor();
			labEditor.name = name;
			labEditor.x = x;
			labEditor.y = y;
			labEditor.width = width;
			labEditor.height = height;
			if(_textFormatInfo != null)
			{
				labEditor.changeTextFormat(_textFormatInfo);
			}
			if(_disabledTextFormatInfo != null)
			{
				labEditor.changeDisabledTextFormat(_disabledTextFormatInfo);
			}
			labEditor.text = text;
			return labEditor;
		}
		
		public function getData():BaseData
		{
			return labelData;
		}
		
		public function getContainer():DisplayObjectContainer
		{
			return this;
		}
	}
}