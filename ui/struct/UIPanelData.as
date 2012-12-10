package ui.struct
{
	import flash.display.DisplayObject;
	
	import mx.collections.ArrayCollection;
	import mx.managers.PopUpManager;
	
	import panel.PanelSelectPanel;
	
	import ui.comp.UIPanelEditor;

	public class UIPanelData extends BaseData
	{
		public var uiPanel : UIPanelEditor;
		
		private const TYPE_LABEL : int = 5;
		
		public function UIPanelData()
		{
			super();
		}
		
		public function setUIPanel(uiPanelEditor : UIPanelEditor):void
		{
			componentEditor = uiPanelEditor;
			container = uiPanelEditor;
			label = uiPanelEditor.name + "[ UIPanel ]";
			uiPanel = uiPanelEditor;
			resizable = uiPanelEditor.resizable;
			uiPanelEditor.panelData = this;
		}
		
		public override function getDataProvider():ArrayCollection
		{
			super.getDataProvider();
			_dataProvider.addItem({Name : "skin", Value : uiPanel.getSkinName(), type : "Skin", changeSkin:changeSkin});
			return _dataProvider;
		}
		
		public override function getSaveStr():String
		{
			var str : String = "<UIPanel id=\"" + uiPanel.name + "\" x=\"" + uiPanel.x + "\" y=\"" + uiPanel.y +
				"\" width=\"" + uiPanel.width + "\" height=\"" + uiPanel.height + "\" skin=\"" + uiPanel.getSkinName() +
				"\">";
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					str += baseData.getSaveStr();
				}
			}
			str += "</UIPanel>";
			return str;
		}
		
		private function changeSkin(pa : DisplayObject, optionManager : OptionManager):void
		{
			var panelSelectPanel : PanelSelectPanel = new PanelSelectPanel();
			panelSelectPanel.uipanelData = this;
			panelSelectPanel.optionManager = optionManager;
			PopUpManager.addPopUp(panelSelectPanel,pa,true);
			PopUpManager.centerPopUp(panelSelectPanel);
		}
		
		public function updateSkin():void
		{
			_dataProvider[TYPE_WIDTH]["Value"] = uiPanel.width;
			_dataProvider[TYPE_HEIGHT]["Value"] = uiPanel.height;
			_dataProvider[TYPE_LABEL]["Value"] =  uiPanel.getSkinName();
			_dataProvider.itemUpdated(_dataProvider[TYPE_WIDTH]);
			_dataProvider.itemUpdated(_dataProvider[TYPE_HEIGHT]);
			_dataProvider.itemUpdated(_dataProvider[TYPE_LABEL]);
			
			resizable = uiPanel.resizable;
			
			_dataProvider[TYPE_WIDTH]["Editable"] = resizable;
			_dataProvider[TYPE_HEIGHT]["Editable"] = resizable;
			
			if(resizePanel != null)
			{
				resizePanel.setData(this);
			}
		}
		
		
		public override function clone():BaseData
		{
			var uipanelData : UIPanelData = new UIPanelData();
			var uipanelEditor : UIPanelEditor = uiPanel.clone();
			uipanelData.setUIPanel(uipanelEditor);
			
			if(children != null)
			{
				var count : int = children.length;
				for(var i : int = 0; i < count; ++i)
				{
					var baseData : BaseData = children[i];
					uipanelData.push(baseData.clone());
				}
			}
			
			return uipanelData;
		}
	}
}