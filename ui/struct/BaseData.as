package ui.struct
{
	
	import components.TextFormatInfo;
	
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;
	
	import ui.ResizablePanel;
	import ui.comp.ButtonEditor;
	import ui.comp.CheckBoxEditor;
	import ui.comp.IComponentEditor;
	import ui.comp.LabelEditor;
	import ui.comp.UIPanelEditor;

	public class BaseData
	{
		public var label : String;
		
		public var children : ArrayCollection;
		public var parent : BaseData;
		
		public var resizePanel : ResizablePanel;
		public var resizable : Boolean;
		
		public static const TYPE_BUTTON : int = 1;
		public static const TYPE_UIPANEL : int = 2;
		
		public var componentEditor : IComponentEditor;
		public var container : DisplayObjectContainer;
		
		protected var _dataProvider : ArrayCollection;
		
		protected const TYPE_ID : int = 0;
		protected const TYPE_X : int = 1;
		protected const TYPE_Y : int = 2;
		protected const TYPE_WIDTH : int = 3;
		protected const TYPE_HEIGHT : int = 4;
		
		public function BaseData()
		{
		}
		
		public function push(data : BaseData):void
		{
			if(children == null)
			{
				children = new ArrayCollection();
			}
			children.addItem(data);
			data.parent = this;
			
			container.addChild(data.container);
		}
		
		public function getDataProvider():ArrayCollection
		{
			_dataProvider = new ArrayCollection();
			_dataProvider.addItem({Name : "id", Value : container.name, type:"String", callback:changeId});
			_dataProvider.addItem({Name : "x", Value : container.x,type:"Number",callback:changeX});
			_dataProvider.addItem({Name : "y", Value : container.y,type:"Number",callback:changeY});
			_dataProvider.addItem({Name : "width", Value : container.width,type:"Number",callback:changeWidth, Editable : resizable});
			_dataProvider.addItem({Name : "height", Value : container.height,type:"Number",callback:changeHeight, Editable : resizable});
			
			return _dataProvider;
		}
		
		public function getStageX():Number
		{
			if(parent != null)
			{
				return parent.getStageX() + container.x;
			}
			else
			{
				return container.x;
			}
		}
		
		public function getStageY():Number
		{
			if(parent != null)
			{
				return parent.getStageY() + container.y;
			}
			else
			{
				return container.y;
			}
		}
		
		public function setStageX(val : Number):void
		{
			if(parent != null)
			{
				container.x = val - parent.getStageX();
			}
			else
			{
				container.x = val;
			}
		}
		
		public function setStageY(val : Number):void
		{
			if(parent != null)
			{
				container.y = val - parent.getStageY();
			}
			else
			{
				container.y = val;
			}
		}
		
		public function resize(w : Number, h : Number):void
		{
			container.width = w;
			container.height = h;
		}
		
		public function update():void
		{
			if(_dataProvider != null)
			{
				_dataProvider[TYPE_X]["Value"] = container.x;
				_dataProvider[TYPE_Y]["Value"] = container.y;
				_dataProvider[TYPE_WIDTH]["Value"] = container.width;
				_dataProvider[TYPE_HEIGHT]["Value"] = container.height;
				_dataProvider.itemUpdated(_dataProvider[TYPE_X]);
				_dataProvider.itemUpdated(_dataProvider[TYPE_Y]);
				_dataProvider.itemUpdated(_dataProvider[TYPE_WIDTH]);
				_dataProvider.itemUpdated(_dataProvider[TYPE_HEIGHT]);
			}
		}
		
		protected function changeId(str : String):void
		{
			container.name = str;
			label = str + "[ UIPanel ]";
			_dataProvider[TYPE_ID]["Value"] = label;
			_dataProvider.itemUpdated(_dataProvider[TYPE_ID]);
		}
		
		protected function changeX(num : Number):void
		{
			container.x = num;
			_dataProvider[TYPE_X]["Value"] = container.x;
			_dataProvider.itemUpdated(_dataProvider[TYPE_X]);
			update();
			if(resizePanel != null)
			{
				resizePanel.setData(this);
			}
		}
		
		protected function changeY(num : Number):void
		{
			container.y = num;
			_dataProvider[TYPE_Y]["Value"] = container.x;
			_dataProvider.itemUpdated(_dataProvider[TYPE_Y]);
			update();
			if(resizePanel != null)
			{
				resizePanel.setData(this);
			}
		}
		
		protected function changeWidth(num : Number):void
		{
			if(num > 0)
			{
				container.width = num;
				_dataProvider[TYPE_WIDTH]["Value"] = container.width;
				_dataProvider.itemUpdated(_dataProvider[TYPE_WIDTH]);
				update();
				if(resizePanel != null)
				{
					resizePanel.setData(this);
				}
			}
		}
		
		protected function changeHeight(num : Number):void
		{
			if(num > 0)
			{
				container.height = num;
				_dataProvider[TYPE_HEIGHT]["Value"] = container.height;
				_dataProvider.itemUpdated(_dataProvider[TYPE_HEIGHT]);
				update();
				if(resizePanel != null)
				{
					resizePanel.setData(this);
				}
			}
		}
		
		public function getSaveStr():String
		{
			return ""
		}
		
		public function deleteData():void
		{
			if(parent != null)
			{
				var index : int = parent.children.getItemIndex(this);
				parent.children.removeItemAt(index);
				parent.container.removeChild(container);
				if(parent.children.length == 0)
				{
					parent.children = null;
				}
			}
		}
		
		public function clone():BaseData
		{
			//子类继承
			return null;
		}
		
		public static function openFile(xml : XML, optionManager : OptionManager):BaseData
		{
			var name : String = xml.name();
			var baseData : BaseData;
			switch(name)
			{
				case "Button":
					var buttonData : ButtonData = new ButtonData();
					var buttonEditor : ButtonEditor = new ButtonEditor();
					buttonEditor.buttonDic = optionManager.buttonSkinDic;
					buttonEditor.changeSkin(xml.@skin.toString());
					buttonEditor.name = xml.@id.toString();
					buttonEditor.x = Number(xml.@x);
					buttonEditor.y = Number(xml.@y);
					buttonEditor.width = Number(xml.@width);
					buttonEditor.height = Number(xml.@height);
					buttonEditor.label = xml.@label.toString();
					var textFormatInfo : TextFormatInfo = optionManager.textFormatDic[xml.@textFormat.toString()];
					if(textFormatInfo != null)
					{
						buttonEditor.changeTextFormat(textFormatInfo);
					}
					textFormatInfo = optionManager.textFormatDic[xml.@disabledTextFormat.toString()];
					if(textFormatInfo != null)
					{
						buttonEditor.changeDisabledTextFormat(textFormatInfo);
					}
					buttonData.setButton(buttonEditor);
					baseData = buttonData;
					break;
				case "UIPanel":
					var panelData : UIPanelData = new UIPanelData();
					var uiPanelEditor : UIPanelEditor = new UIPanelEditor();
					uiPanelEditor.panelDic = optionManager.panelSkinDic;
					uiPanelEditor.changeSkin(xml.@skin.toString());
					uiPanelEditor.name = xml.@id.toString();
					uiPanelEditor.x = Number(xml.@x);
					uiPanelEditor.y = Number(xml.@y);
					uiPanelEditor.width = Number(xml.@width);
					uiPanelEditor.height = Number(xml.@height);
					panelData.setUIPanel(uiPanelEditor);
					baseData = panelData;
					break;
				case "CheckBox":
					var checkBoxData : CheckBoxData = new CheckBoxData();
					var checkBoxEditor : CheckBoxEditor = new CheckBoxEditor();
					checkBoxEditor.checkBoxDic = optionManager.checkBoxDic;
					checkBoxEditor.changeSkin(xml.@skin.toString());
					checkBoxEditor.name = xml.@id.toString();
					checkBoxEditor.x = Number(xml.@x);
					checkBoxEditor.y = Number(xml.@y);
					checkBoxEditor.width = Number(xml.@width);
					checkBoxEditor.height = Number(xml.@height);
					checkBoxEditor.label = xml.@label.toString();
					textFormatInfo = optionManager.textFormatDic[xml.@textFormat.toString()];
					if(textFormatInfo != null)
					{
						checkBoxEditor.changeTextFormat(textFormatInfo);
					}
					textFormatInfo = optionManager.textFormatDic[xml.@disabledTextFormat.toString()];
					if(textFormatInfo != null)
					{
						checkBoxEditor.changeDisabledTextFormat(textFormatInfo);
					}
					checkBoxData.setCheckBox(checkBoxEditor);
					baseData = checkBoxData;
					break;
				case "Label":
					var labelData : LabelData = new LabelData();
					var labelEditor : LabelEditor = new LabelEditor();
					labelEditor.name = xml.@id.toString();
					labelEditor.x = Number(xml.@x);
					labelEditor.y = Number(xml.@y);
					labelEditor.width = Number(xml.@width);
					labelEditor.height = Number(xml.@height);;
					labelEditor.text = xml.@label.toString();
					textFormatInfo = optionManager.textFormatDic[xml.@textFormat.toString()];
					if(textFormatInfo != null)
					{
						labelEditor.changeTextFormat(textFormatInfo);
					}
					textFormatInfo = optionManager.textFormatDic[xml.@disabledTextFormat.toString()];
					if(textFormatInfo != null)
					{
						labelEditor.changeDisabledTextFormat(textFormatInfo);
					}
					labelData.setLabel(labelEditor);
					baseData = labelData;
					break;
			}
			for each(var itemXml : XML in xml.elements())
			{
				var childData : BaseData = openFile(itemXml,optionManager);
				baseData.push(childData);
			}
			return baseData;
		}
								 
	}
}