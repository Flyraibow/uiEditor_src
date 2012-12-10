package ui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import ui.struct.BaseData;
	
	public class ResizablePanel extends Sprite
	{
		private var _gridList : Vector.<ResizableGrid>;
		
		private var _dragGrid : ResizableGrid;
		
		private var _data : BaseData;
		
		private var _width : Number;
		private var _height : Number;
		private var _parent : DisplayObjectContainer;
		
		public function ResizablePanel()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event : Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			_parent = parent;
			
			_gridList = new Vector.<ResizableGrid>(9);
			for(var i : int = 0; i < 9; ++i)
			{
				var grid : ResizableGrid = new ResizableGrid();
				grid.index = i;
				_gridList[i] = grid;
				addChild(grid);
				grid.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			visible = false;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(event : MouseEvent):void
		{
			_dragGrid = event.currentTarget as ResizableGrid;
		}
		
		private function onMouseUp(event : MouseEvent):void
		{
			if(_dragGrid != null)
			{
				_dragGrid = null;
			}
		}
		
		private function onMouseMove(event : MouseEvent):void
		{
			if(_dragGrid != null)
			{
				switch(_dragGrid.index)
				{
					case 4:
						var newX : Number = _parent.mouseX - _width / 2;
						var newY : Number = _parent.mouseY - _height / 2;
						this.x = newX;
						this.y = newY;
						_data.setStageX(newX);
						_data.setStageY(newY);
						break;
					case 0:
						newX = _parent.mouseX;
						newY = _parent.mouseY;
						newHeight = _height - newY + _data.getStageY();
						newWidth = _width - newX + _data.getStageX();
						if(newHeight > 0 && newWidth > 0)
						{
							resize(newX,newY,newWidth,newHeight);
						}
						break;
					case 1:
						newY = _parent.mouseY;
						var newHeight : int = _height - newY + _data.getStageY();
						if(newHeight > 0)
						{
							resize(x,newY,_width,newHeight);
						}
						break;
					case 2:
						newY = _parent.mouseY;
						newWidth = _parent.mouseX - _data.getStageX();
						newHeight = _height - newY + _data.getStageY();
						if(newHeight > 0 && newWidth > 0)
						{
							resize(x,newY,newWidth,newHeight);
						}
						break;
					case 3:
						newX = _parent.mouseX;
						var newWidth : int = _width - newX + _data.getStageX();
						if(newWidth > 0)
						{
							resize(newX,y,newWidth,_height);
						}
						break;
					case 5:
						newWidth = _parent.mouseX - _data.getStageX();
						if(newWidth > 0)
						{
							resize(x,y,newWidth,_height);
						}
						break;
					case 6:
						newX = _parent.mouseX;
						newWidth = _width - newX + _data.getStageX();
						newHeight = _parent.mouseY - _data.getStageY();
						if(newWidth > 0 && newHeight > 0)
						{
							resize(newX,y,newWidth,newHeight);
						}
						break;
					case 7:
						newHeight = _parent.mouseY - _data.getStageY();
						if(newHeight > 0)
						{
							resize(x,y,_width,newHeight);
						}
						break;
					case 8:
						newWidth = _parent.mouseX - _data.getStageX();
						newHeight = _parent.mouseY - _data.getStageY();
						if(newHeight > 0 && newWidth > 0)
						{
							resize(x,y,newWidth,newHeight);
						}
						break;
				}
				_data.update();
			}
		}
		
		private function resize(x : Number, y : Number, w : Number, h : Number):void
		{
			this.x = x;
			this.y = y;
			graphics.clear();
			graphics.lineStyle(0,0xFF0000);
			_width = w;
			_height = h;
			graphics.drawRect( 0, 0,_width, _height);
			for(var i : int = 0; i < 9; ++i)
			{
				var grid : ResizableGrid = _gridList[i];
				grid.x = (i % 3) *  _width / 2;
				grid.y = int(i / 3) *  _height / 2;
			}
			_data.resize(w,h);
			_data.setStageX(x);
			_data.setStageY(y);
		}
		
		public function setData(baseData : BaseData):void
		{
			graphics.clear();
			_data = baseData;
			_dragGrid = null;
			if(baseData != null)
			{
				visible = true;
				graphics.lineStyle(0,0xFF0000);
				_width = baseData.container.width;
				_height = baseData.container.height;
				graphics.drawRect( 0, 0,_width, _height);
				if(baseData.resizable)
				{
					for(var i : int = 0; i < 9; ++i)
					{
						var grid : ResizableGrid = _gridList[i];
						grid.visible = true;
						grid.x = (i % 3) *  _width / 2;
						grid.y = int(i / 3) *  _height / 2;
					}
				}
				else
				{
					for(i = 0; i < 4; ++i)
					{
						grid = _gridList[i];
						grid.visible = false;
					}
					for(i = 5; i < 9; ++i)
					{
						grid = _gridList[i];
						grid.visible = false;
					}
					_gridList[4].x = _width / 2;
					_gridList[4].y = _height / 2;
					
				}
				x = baseData.getStageX();
				y = baseData.getStageY();
			}
			else
			{
				visible = false;
			}
		}
	}
}