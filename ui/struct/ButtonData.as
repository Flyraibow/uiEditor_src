package ui.struct
{
	import components.TextFormatInfo;
	
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;
	
	import panel.ButtonSelectPanel;
	
	import ui.comp.ButtonEditor;

	public class ButtonData extends BaseData
	{
		public var button : ButtonEditor;
		
		private const TYPE_LABEL : int = 5;
		private const TYPE_SKIN : int = 6
		private const TYPE_TEXT_FORMAT : int = 7;
		private const TYPE_DISABLED_TEXTFORMAT: int = 8;
		
		public function ButtonData()
		{
			super();
		}
		
		public function setButton(buttonEditor : ButtonEditor):void
		{
			componentEditor = buttonEditor;
			container = buttonEditor;
			button = buttonEditor;
			label = buttonEditor.name + "[ button ]";
			resizable = buttonEditor.resizable;
			buttonEditor.buttonData = this;
		}
		
		public override function getDataProvider():ArrayCollection
		{
			super.getDataProvider();
			_dataProvider.addItem({Name : "label", Value : button.label, type : "String", callback:changeLabel});
			_dataProvider.addItem({Name : "skin", Value : button.getSkinName(), type : "Skin", changeSkin:changeSkin});
			_dataProvider.addItem({Name : "textFormat", Value : button.textFormatStr, type : "TextFormat", callback : changeTextFormat});
			_dataProvider.addItem({Name : "disabledTextFormat", Value : button.disabledTextFormatStr, type : "TextFormat", 
				callback : changeDisabledTextFormat});
			return _dataProvider;
		}
		
		private function changeLabel(str : String):void
		{
			button.label = str;
			_dataProvider[TYPE_LABEL]["Value"] = str;
			_dataProvider.itemUpdated(_dataProvider[TYPE_LABEL]);
		}
		
		private function changeSkin(pa : DisplayObject, optionManager : OptionManager):void
		{
			var buttonSelectPanel : ButtonSelectPanel = new ButtonSelectPanel();
			buttonSelectPanel.buttonData = this;
			buttonSelectPanel.optionManager = optionManager;
			PopUpManager.addPopUp(buttonSelectPanel,pa,true);
			PopUpManager.centerPopUp(buttonSelectPanel);
		}
		
		public function updateSkin():void
		{
			_dataProvider[TYPE_WIDTH]["Value"] = button.width;
			_dataProvider[TYPE_HEIGHT]["Value"] = button.height;
			_dataProvider[TYPE_SKIN]["Value"] =  button.getSkinName();
			_dataProvider.itemUpdated(_dataProvider[TYPE_WIDTH]);
			_dataProvider.itemUpdated(_dataProvider[TYPE_HEIGHT]);
			_dataProvider.itemUpdated(_dataProvider[TYPE_SKIN]);
			resizable = button.resizable;
			_dataProvider[TYPE_WIDTH]["Editable"] = resizable;
			_dataProvider[TYPE_HEIGHT]["Editable"] = resizable;
			
			if(resizePanel != null)
			{
				resizePanel.setData(this);
			}
		}
		
		private function changeTextFormat(textFormatInfo : TextFormatInfo):void
		{
			button.changeTextFormat(textFormatInfo);
			_dataProvider[TYPE_TEXT_FORMAT]["Value"] =  button.textFormatStr;
			_dataProvider.itemUpdated(_dataProvider[TYPE_TEXT_FORMAT]);
		}
		
		private function changeDisabledTextFormat(textFormatInfo : TextFormatInfo):void
		{
			button.changeDisabledTextFormat(textFormatInfo);
			_dataProvider[TYPE_DISABLED_TEXTFORMAT]["Value"] =  button.disabledTextFormatStr;
			_dataProvider.itemUpdated(_dataProvider[TYPE_DISABLED_TEXTFORMAT]);
		}
		
		public override function clone():BaseData
		{
			var buttonData : ButtonData = new ButtonData();
			var buttonEditor : ButtonEditor = button.clone();
			buttonData.setButton(buttonEditor);
			
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					buttonData.push(baseData.clone());
				}
			}
			
			return buttonData;
		}
		
		public override function getSaveStr():String
		{
			var str : String = "<Button id=\"" + button.name + "\" x=\"" + button.x + "\" y=\"" + button.y +
				"\" width=\"" + button.width + "\" height=\"" + button.height + "\" label=\"" + button.label +
				"\" skin=\"" + button.getSkinName() + "\" textFormat=\"" + button.textFormatStr + 
				"\" disabledTextFormat=\"" + button.disabledTextFormatStr + "\">";
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					str += baseData.getSaveStr();
				}
			}
			str += "</Button>";
			return str;
		}
	}
}