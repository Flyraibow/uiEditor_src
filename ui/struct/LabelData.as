package ui.struct
{
	import components.TextFormatInfo;
	
	import mx.collections.ArrayCollection;
	
	import ui.comp.LabelEditor;

	public class LabelData extends BaseData
	{
		public var labelEditor : LabelEditor;
		
		private const TYPE_LABEL : int = 5;
		private const TYPE_TEXT_FORMAT : int = 6;
		private const TYPE_DISABLED_TEXTFORMAT: int = 7;
		
		public function LabelData()
		{
			super();
			resizable = true;
		}
		
		public function setLabel(labelEditor1 : LabelEditor):void
		{
			componentEditor = labelEditor1;
			container = labelEditor1;
			labelEditor = labelEditor1;
			label = labelEditor1.name + "[ Label ]";
			labelEditor1.labelData = this;
		}
		
		public override function getDataProvider():ArrayCollection
		{
			super.getDataProvider();
			_dataProvider.addItem({Name : "label", Value : labelEditor.text, type : "String", callback:changeLabel});
			_dataProvider.addItem({Name : "textFormat", Value : labelEditor.textFormatStr, type : "TextFormat", callback : changeTextFormat});
			_dataProvider.addItem({Name : "disabledTextFormat", Value : labelEditor.disabledTextFormatStr, type : "TextFormat", 
				callback : changeDisabledTextFormat});
			return _dataProvider;
		}
		
		private function changeLabel(str : String):void
		{
			labelEditor.text = str;
			_dataProvider[TYPE_LABEL]["Value"] = str;
			_dataProvider.itemUpdated(_dataProvider[TYPE_LABEL]);
		}
		
		private function changeTextFormat(textFormatInfo : TextFormatInfo):void
		{
			labelEditor.changeTextFormat(textFormatInfo);
			_dataProvider[TYPE_TEXT_FORMAT]["Value"] =  labelEditor.textFormatStr;
			_dataProvider.itemUpdated(_dataProvider[TYPE_TEXT_FORMAT]);
		}
		
		private function changeDisabledTextFormat(textFormatInfo : TextFormatInfo):void
		{
			labelEditor.changeDisabledTextFormat(textFormatInfo);
			_dataProvider[TYPE_DISABLED_TEXTFORMAT]["Value"] =  labelEditor.disabledTextFormatStr;
			_dataProvider.itemUpdated(_dataProvider[TYPE_DISABLED_TEXTFORMAT]);
		}
		
		public override function clone():BaseData
		{
			var labelData : LabelData = new LabelData();
			var labEditor : LabelEditor = labelEditor.clone();
			labelData.setLabel(labEditor);
			
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					labelData.push(baseData.clone());
				}
			}
			
			return labelData;
		}
		
		public override function getSaveStr():String
		{
			var str : String = "<Label id=\"" + labelEditor.name + "\" x=\"" + labelEditor.x + "\" y=\"" + labelEditor.y +
				"\" width=\"" + labelEditor.width + "\" height=\"" + labelEditor.height + "\" label=\"" + labelEditor.text +
				"\" textFormat=\"" + labelEditor.textFormatStr + "\" disabledTextFormat=\"" + labelEditor.disabledTextFormatStr + "\">";
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					str += baseData.getSaveStr();
				}
			}
			str += "</Label>";
			return str;
		}
	}
}