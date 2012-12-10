package ui
{
	import flash.display.Sprite;
	
	public class ResizableGrid extends Sprite
	{
		public var index : int;
		
		public function ResizableGrid()
		{
			super();
			
			graphics.beginFill(0xff0000,1);
			graphics.drawRect(-3, -3,7,7);
		}
		
	}
}