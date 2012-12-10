package ui.comp
{
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	
	[Style(name="skin", type="Class")]
	public class UIPanel extends UIComponent
	{
		protected var _background : DisplayObject;
		
		private static var defaultStyles : Object = {skin:null, backgroundFilter : null};
		
		private static function getStypeDefinition():Object
		{
			return defaultStyles;
		}
		
		public static var createAccessibilityImplementation:Function;
		
		public function UIPanel()
		{
			super();
		}
		
		override protected function configUI():void
		{
			super.configUI();
			_background = null;
		}
		
		override protected function draw():void
		{
			if(isInvalid(InvalidationType.STYLES))
			{
				drawBackground();
				
				invalidate(InvalidationType.SIZE,false);
			}
			if(isInvalid(InvalidationType.SIZE))
			{
				drawLayout();
			}
			
			super.draw();
		}
		
		protected function drawBackground():void
		{
			var bg : DisplayObject = _background;
			_background = getDisplayObjectInstance(getStyleValue("skin"));
			if(_background != null)
			{
				_background.filters = getStyleValue("backgroundFilters") as Array;
				addChildAt(_background, 0);
			}
			if(bg != null && bg != _background && contains(bg))
			{
				removeChild(bg);
			}
		}
		
		protected function drawLayout():void
		{
			if(_background != null)
			{
				_background.width = width;
				_background.height = height;
			}
		}
		
		public function get background() : DisplayObject
		{
			return _background;
		}
	}
}