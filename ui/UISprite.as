package ui
{
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DataGrid;
	import mx.controls.Tree;
	import mx.events.CloseEvent;
	
	import panel.Manager;
	
	import ui.comp.ButtonEditor;
	import ui.comp.IComponentEditor;
	import ui.struct.BaseData;
	import ui.struct.ButtonData;
	
	public class UISprite extends Sprite
	{
		public var optionManager : OptionManager;
		
		public var resizablePanel : ResizablePanel;
		public var componentTree : ArrayCollection;
		public var dataGrid : DataGrid;
		public var tree : Tree;
		private var _selectedData : BaseData;
		private var _curIndex : int;
		
		private var _copyData : BaseData;
		
		public function UISprite()
		{
			super();
			_selectedData = null;
			var sprite : Sprite = new Sprite();
			sprite.graphics.beginFill(0x000000,0);
			sprite.graphics.drawRect(0,0,2800,2800);
			sprite.addEventListener(MouseEvent.CLICK, onClickBackground);
			addChild(sprite);
			componentTree = new ArrayCollection();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function clear():void
		{
			for(var i : int = numChildren - 1; i >= 1; --i)
			{
				removeChildAt(i);
			}
			componentTree.removeAll();
		}
		
		public function addComponent(baseData : BaseData):void
		{
			if(_selectedData != null)
			{
				_selectedData.push(baseData);
				baseData.container.x = 0;
				baseData.container.y = 0;
				componentTree.itemUpdated(_selectedData);
			}
			else
			{
				componentTree.addItem(baseData);
				addChild(baseData.container);
			}
			changeClickEvent(baseData, true);
			
			setSelectedData(baseData);
		}
		
		private function changeClickEvent(baseData : BaseData, addFlag : Boolean):void
		{
			if(addFlag)
			{
				baseData.container.addEventListener(MouseEvent.CLICK, onClickMouse);
			}
			else
			{
				baseData.container.removeEventListener(MouseEvent.CLICK, onClickMouse);
			}
			if(baseData.children != null)
			{
				var count : int = baseData.children.length;
				for(var i : int =  0; i < count; ++i)
				{
					changeClickEvent(baseData.children[i] as BaseData,addFlag);
				}
			}
		}
		
		public function setSelectedData(data : BaseData):void
		{
			if(_selectedData != null)
			{
				_selectedData.resizePanel = null;
			}
			_selectedData = data;
			resizablePanel.setData(_selectedData);
			if(data != null)
			{
				_selectedData.resizePanel = resizablePanel;
				if(data != null)
				{
					dataGrid.dataProvider = _selectedData.getDataProvider();
				}
				else
				{
					dataGrid.dataProvider = null;
				}
			}
		}
		
		public function saveFiles():void
		{
			_curIndex = 0;
			saveFile();
		}
		
		private function saveFile():void
		{
			if(_curIndex < componentTree.length)
			{
				var baseData : BaseData = componentTree[_curIndex];
				var file : File = new File(optionManager.uiDictionary);
				file.browseForSave("保存" + baseData.label);
				file.addEventListener(Event.SELECT, onSelectFile);
				file.addEventListener(Event.CANCEL, onCancelFile);
			}
		}
		
		private function onSelectFile(event : Event):void
		{
			var file : File = event.currentTarget as File;
			file.removeEventListener(Event.SELECT, onSelectFile); 
			file.removeEventListener(Event.SELECT, onCancelFile); 
			
			var baseData : BaseData = componentTree[_curIndex];
			var str : String = baseData.getSaveStr();
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(XML(str).toXMLString());
			fileStream.close();
			
			++_curIndex;
			saveFile();
		}
		
		private function onCancelFile(event : Event):void
		{
			var file : File = event.currentTarget as File;
			file.removeEventListener(Event.SELECT, onSelectFile); 
			file.removeEventListener(Event.SELECT, onCancelFile); 
			
			++_curIndex;
			saveFile();
		}
		
		private function onClickMouse(event : MouseEvent):void
		{
			try
			{
				if(_selectedData != null)
				{
					_selectedData.resizePanel = null;
				}
				_selectedData = (event.currentTarget as IComponentEditor).getData();
				resizablePanel.setData(_selectedData);
				_selectedData.resizePanel = resizablePanel;
				dataGrid.dataProvider = _selectedData.getDataProvider();
				if(_selectedData.parent != null)
				{
					var data : BaseData = _selectedData.parent;
					do
					{
						tree.expandChildrenOf(data,true); 
						data = data.parent;
					}
					while(data != null);
				}
				tree.selectedItem = _selectedData;
				tree.scrollToIndex(tree.selectedIndex);
				event.stopImmediatePropagation();
			}
			catch(e : Error)
			{
				trace(e.message);
			}
		}
		
		private function onClickBackground(event : MouseEvent):void
		{
			if(_selectedData != null)
			{
				_selectedData = null;
				resizablePanel.setData(null);
				tree.selectedIndex = -1;
				dataGrid.dataProvider = null;
			}
			Manager.textInPutEnable = true;
		}
		
		private function onKeyDown(event : KeyboardEvent):void
		{
			if(Manager.textInPutEnable)
			{
				switch(event.keyCode)
				{
					case Keyboard.S:
						if(_selectedData != null)
						{
							_selectedData.container.y += 1;
							_selectedData.resizePanel.setData(_selectedData);
							_selectedData.update();
						}
						break;
					case Keyboard.A:
						if(_selectedData != null)
						{
							_selectedData.container.x -= 1;
							_selectedData.resizePanel.setData(_selectedData);
							_selectedData.update();
						}
						break;
					case Keyboard.D:
						if(_selectedData != null)
						{
							_selectedData.container.x += 1;
							_selectedData.resizePanel.setData(_selectedData);
							_selectedData.update();
						}
						break;
					case Keyboard.W:
						if(_selectedData != null)
						{
							_selectedData.container.y -= 1;
							_selectedData.resizePanel.setData(_selectedData);
							_selectedData.update();
						}
						break;
				}
			}
		}
		
		private function onKeyUp(event : KeyboardEvent):void
		{
			if(Manager.textInPutEnable)
			{
				switch(event.keyCode)
				{
					case Keyboard.DELETE:
						if(_selectedData != null)
						{
							Manager.textInPutEnable = false;
							Alert.show("是否确定要删除此控件？","提示",Alert.YES|Alert.NO, null, onCloseEvent);
						}
						break;
					case Keyboard.C:
						if(event.ctrlKey && _selectedData != null)
						{
							_copyData = _selectedData.clone();
							if(_selectedData.parent != null)
							{
								setSelectedData(_selectedData.parent);
							}
							else
							{
								setSelectedData(null);
							}
						}
						break;
					case Keyboard.V:
						if(event.ctrlKey && _copyData != null)
						{
							var baseData : BaseData = _copyData.clone();
							addComponent(baseData);
						}
						break;
				}
			}
		}
		
		private function onCloseEvent(event : CloseEvent):void
		{
			if(event.detail == Alert.YES)
			{
				changeClickEvent(_selectedData, false);
				if(_selectedData.parent != null)
				{
					_selectedData.deleteData();
				}
				else
				{
					var index : int = componentTree.getItemIndex(_selectedData);
					componentTree.removeItemAt(index);
					removeChild(_selectedData.container);
				}
				setSelectedData(null);
				dataGrid.dataProvider = null;
			}
			Manager.textInPutEnable = true;
		}
	}
}