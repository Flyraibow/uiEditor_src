package components
{
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.formats.TextAlign;

	public class TextFormatInfo
	{
		public var label : String;
		public var textFormat : TextFormat;
		
		public function TextFormatInfo()
		{
		}
		
		public function toXmlString():String
		{
			var str : String = "<item id=\"" + label + "\" font=\"" + textFormat.font +
				"\" size=\"" + textFormat.size + "\" color=\"" + textFormat.color + 
				"\" bold=\"" + textFormat.bold + "\" italic=\""+ textFormat.italic +
				"\" align=\"" + textFormat.align + "\"/>";
			return str;
		}
		
		public function toByteArray():ByteArray
		{
			var byteArray : ByteArray = new ByteArray();
			byteArray.writeByte(label.length);
			byteArray.writeUTFBytes(label);
			var fontBa : ByteArray = new ByteArray();
			fontBa.writeUTFBytes(textFormat.font);
			byteArray.writeByte(fontBa.length);
			byteArray.writeUTFBytes(textFormat.font);
			byteArray.writeByte(int(textFormat.size));
			byteArray.writeUnsignedInt(uint(textFormat.color));
			byteArray.writeBoolean(Boolean(textFormat.bold));
			byteArray.writeBoolean(Boolean(textFormat.italic));
			var alignType : int;
			switch(textFormat.align)
			{
				case TextAlign.LEFT:
					alignType = 0;
					break;
				case TextAlign.CENTER:
					alignType = 1;
					break;
				case TextAlign.RIGHT:
					alignType = 2;
					break;
				default:
					alignType = 0;
					break;
			}
			byteArray.writeByte(alignType);
			return byteArray;
		}
	}
}