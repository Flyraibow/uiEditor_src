package ui.struct
{
	import components.TextFormatInfo;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;
	
	import panel.CheckBoxSelectPanel;
	
	import ui.comp.CheckBoxEditor;

	public class CheckBoxData extends BaseData
	{
		public var checkBox : CheckBoxEditor;
		
		private const TYPE_LABEL : int = 5;
		private const TYPE_SKIN : int = 6
		private const TYPE_TEXT_FORMAT : int = 7;
		private const TYPE_DISABLED_TEXTFORMAT: int = 8;
		
		public function CheckBoxData()
		{
			super();
			resizable = true;
		}
		
		public function setCheckBox(checkBoxEditor : CheckBoxEditor) : void
		{
			componentEditor = checkBoxEditor;
			container = checkBoxEditor;
			checkBox = checkBoxEditor;
			label = checkBox.name + "[ checkBox ]";
			checkBox.checkBoxData = this;
		}
		
		public override function getDataProvider():ArrayCollection
		{
			super.getDataProvider();
			_dataProvider.addItem({Name : "label", Value : checkBox.label, type : "String", callback:changeLabel});
			_dataProvider.addItem({Name : "skin", Value : checkBox.getSkinName(), type : "Skin", changeSkin:changeSkin});
			_dataProvider.addItem({Name : "textFormat", Value : checkBox.textFormatStr, type : "TextFormat", callback : changeTextFormat});
			_dataProvider.addItem({Name : "disabledTextFormat", Value : checkBox.disabledTextFormatStr, type : "TextFormat", 
				callback : changeDisabledTextFormat});
			return _dataProvider;
		}
		
		private function changeLabel(str : String):void
		{
			checkBox.label = str;
			_dataProvider[TYPE_LABEL]["Value"] = str;
			_dataProvider.itemUpdated(_dataProvider[TYPE_LABEL]);
		}
		
		private function changeSkin(pa : DisplayObject, optionManager : OptionManager):void
		{
			var checkBoxSelectPanel : CheckBoxSelectPanel = new CheckBoxSelectPanel();
			checkBoxSelectPanel.checkBoxData = this;
			checkBoxSelectPanel.optionManager = optionManager;
			PopUpManager.addPopUp(checkBoxSelectPanel,pa,true);
			PopUpManager.centerPopUp(checkBoxSelectPanel);
		}
		
		public function updateSkin():void
		{
			_dataProvider[TYPE_WIDTH]["Value"] = checkBox.width;
			_dataProvider[TYPE_HEIGHT]["Value"] = checkBox.height;
			_dataProvider[TYPE_SKIN]["Value"] =  checkBox.getSkinName();
			_dataProvider.itemUpdated(_dataProvider[TYPE_WIDTH]);
			_dataProvider.itemUpdated(_dataProvider[TYPE_HEIGHT]);
			_dataProvider.itemUpdated(_dataProvider[TYPE_SKIN]);
			
			if(resizePanel != null)
			{
				resizePanel.setData(this);
			}
		}
		
		private function changeTextFormat(textFormatInfo : TextFormatInfo):void
		{
			checkBox.changeTextFormat(textFormatInfo);
			_dataProvider[TYPE_TEXT_FORMAT]["Value"] =  checkBox.textFormatStr;
			_dataProvider.itemUpdated(_dataProvider[TYPE_TEXT_FORMAT]);
		}
		
		private function changeDisabledTextFormat(textFormatInfo : TextFormatInfo):void
		{
			checkBox.changeDisabledTextFormat(textFormatInfo);
			_dataProvider[TYPE_DISABLED_TEXTFORMAT]["Value"] =  checkBox.disabledTextFormatStr;
			_dataProvider.itemUpdated(_dataProvider[TYPE_DISABLED_TEXTFORMAT]);
		}
		
		public override function clone():BaseData
		{
			var checkBoxData : CheckBoxData = new CheckBoxData();
			var checkBoxEditor : CheckBoxEditor = checkBox.clone();
			checkBoxData.setCheckBox(checkBoxEditor);
			
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					checkBoxData.push(baseData.clone());
				}
			}
			
			return checkBoxData;
		}
		
		public override function getSaveStr():String
		{
			var str : String = "<CheckBox id=\"" + checkBox.name + "\" x=\"" + checkBox.x + "\" y=\"" + checkBox.y +
				"\" width=\"" + checkBox.width + "\" height=\"" + checkBox.height + "\" label=\"" + checkBox.label +
				"\" skin=\"" + checkBox.getSkinName() + "\" textFormat=\"" + checkBox.textFormatStr + 
				"\" disabledTextFormat=\"" + checkBox.disabledTextFormatStr + "\">";
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					str += baseData.getSaveStr();
				}
			}
			str += "</CheckBox>";
			return str;
		}
	}
}