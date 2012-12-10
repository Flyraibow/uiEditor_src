package org
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	
	public class ScaleBitmapSkinInfo
	{
		private var _skinClass : Class;
		private var _skinScale9Grid : Rectangle;
		public var width : int;
		public var height : int;
		
		public function ScaleBitmapSkinInfo(skinClass : Class, skinScale9Grid : Rectangle = null)
		{
			_skinClass = skinClass;
			_skinScale9Grid = skinScale9Grid;
		}
		
		public function getScaleBitmap():ScaleBitmap
		{
			var bitmapData : BitmapData = new _skinClass()
			width = bitmapData.width;
			height = bitmapData.height;
			var scaleBitmap : ScaleBitmap = new ScaleBitmap(bitmapData);
			scaleBitmap.scale9Grid = _skinScale9Grid;
			return scaleBitmap;
		}
	}
}