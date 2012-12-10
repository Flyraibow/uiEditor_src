package components
{
	import flash.utils.ByteArray;
	
	import org.ScaleBitmapSkinInfo;

	public class CheckBoxInfo
	{
		public var name : String;
		
		public var upIconName : String;
		public var overIconName : String;
		public var downIconName : String;
		public var disabledIconName : String;
		
		public var selectedUpIconName : String;
		public var selectedOverIconName : String;
		public var selectedDownIconName : String;
		public var selectedDisabledIconName : String;
		
		public var upIcon : ScaleBitmapSkinInfo;
		public var overIcon : ScaleBitmapSkinInfo;
		public var downIcon : ScaleBitmapSkinInfo;
		public var disabledIcon : ScaleBitmapSkinInfo;
		
		public var selectedUpIcon : ScaleBitmapSkinInfo;
		public var selectedOverIcon : ScaleBitmapSkinInfo;
		public var selectedDownIcon : ScaleBitmapSkinInfo;
		public var selectedDisabledIcon : ScaleBitmapSkinInfo;
		
		public function CheckBoxInfo()
		{
		}
		
		public function toByteArray():ByteArray
		{
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeByte(name.length);
			byteArray.writeUTFBytes(name);
			
			byteArray.writeByte(upIconName.length);
			byteArray.writeUTFBytes(upIconName);
			byteArray.writeByte(overIconName.length);
			byteArray.writeUTFBytes(overIconName);
			byteArray.writeByte(downIconName.length);
			byteArray.writeUTFBytes(downIconName);
			byteArray.writeByte(disabledIconName.length);
			byteArray.writeUTFBytes(disabledIconName);
			
			byteArray.writeByte(selectedUpIconName.length);
			byteArray.writeUTFBytes(selectedUpIconName);
			byteArray.writeByte(selectedOverIconName.length);
			byteArray.writeUTFBytes(selectedOverIconName);
			byteArray.writeByte(selectedDownIconName.length);
			byteArray.writeUTFBytes(selectedDownIconName);
			byteArray.writeByte(selectedDisabledIconName.length);
			byteArray.writeUTFBytes(selectedDisabledIconName);
			
			return byteArray;
		}
	}
}