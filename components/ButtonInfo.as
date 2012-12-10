package components
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import org.ScaleBitmapSkinInfo;

	public class ButtonInfo
	{
		public var name : String;
		public var resizable : Boolean;
		public var scale9Grid : Rectangle;
		public var upSkinName : String;
		public var overSkinName : String;
		public var downSkinName : String;
		public var disabledSkinName : String;
		public var upSkin : ScaleBitmapSkinInfo;
		public var overSkin : ScaleBitmapSkinInfo;
		public var downSkin : ScaleBitmapSkinInfo;
		public var disabledSkin : ScaleBitmapSkinInfo;
		
		public function ButtonInfo()
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
			byteArray.writeByte(upSkinName.length);
			byteArray.writeUTFBytes(upSkinName);
			byteArray.writeByte(overSkinName.length);
			byteArray.writeUTFBytes(overSkinName);
			byteArray.writeByte(downSkinName.length);
			byteArray.writeUTFBytes(downSkinName);
			byteArray.writeByte(disabledSkinName.length);
			byteArray.writeUTFBytes(disabledSkinName);
			
			return byteArray;
		}
	}
}