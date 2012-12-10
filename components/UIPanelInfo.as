package components
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.ScaleBitmapSkinInfo;

	public class UIPanelInfo
	{
		public var name : String;
		
		public var resizable : Boolean;
		public var scale9Grid : Rectangle;
		
		public var skin : ScaleBitmapSkinInfo;
		
		public function UIPanelInfo()
		{
		}
		
		public function toByteArray():ByteArray
		{
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeByte(name.length);
			byteArray.writeUTFBytes(name);
			byteArray.writeBoolean(resizable);
			if(resizable)
			{
				byteArray.writeShort(scale9Grid.x);
				byteArray.writeShort(scale9Grid.y);
				byteArray.writeShort(scale9Grid.width);
				byteArray.writeShort(scale9Grid.height);
			}
			
			return byteArray;
		}
	}
}