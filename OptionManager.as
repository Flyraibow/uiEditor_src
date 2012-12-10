package
{
	import components.ButtonInfo;
	import components.CheckBoxInfo;
	import components.TextFormatInfo;
	import components.UIPanelInfo;
	
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	import org.ScaleBitmapSkinInfo;

	public class OptionManager
	{
		public var skinSwfPath : String;			// 皮肤swf路径
		public var skinCfgPath : String;			// 皮肤配置路径
		public var textFormatPath : String;			// 字体配置
		public var uiDictionary : String;			// 界面文件夹
		public var resPackagePath : String;			// 资源打包路径
		public var uiPackagePath : String;			// ui打包路径
		public var resPackagePath1 : String;			// 资源打包路径
		public var uiPackagePath1 : String;			// ui打包路径
		public var swcPath : String;				//swc路径
		public var swcPath1 : String;				//swc路径
		
		private var _callbackFunction : Function;
		private var _errorList : Vector.<String>;
		
		public var textFormatCollection : ArrayCollection;
		public var textFormatDic : Object;
		
		public var buttonList : ArrayCollection;
		public var buttonSkinDic : Object;
		
		public var panelList : ArrayCollection;
		public var panelSkinDic : Object;
		
		public var checkBoxList : ArrayCollection;
		public var checkBoxDic : Object;
		
		private var _applicationBytes : ByteArray;
		
		public function OptionManager()
		{
		}
		
		public function init(callback : Function):void
		{
			_callbackFunction = callback;
			_errorList = new Vector.<String>();
			var sharedObject : SharedObject = SharedObject.getLocal("UIEDITOR");
			skinSwfPath = sharedObject.data["Path_SkinSwf"];
			skinCfgPath = sharedObject.data["Path_SkinCfg"];
			textFormatPath = sharedObject.data["Path_TextFormat"];
			uiDictionary = sharedObject.data["Path_UIDictionary"];
			resPackagePath = sharedObject.data["Path_ResPackage"];
			uiPackagePath = sharedObject.data["Path_uiPackage"];
			resPackagePath1 = sharedObject.data["Path_ResPackage1"];
			uiPackagePath1 = sharedObject.data["Path_uiPackage1"];
			swcPath = sharedObject.data["Path_SWC"];
			swcPath1 = sharedObject.data["Path_SWC1"];
			
			checkPath("skinSwfPath",skinSwfPath,false,_errorList);
			checkPath("skinCfgPath",skinCfgPath,false,_errorList);
			checkPath("textFormatPath",textFormatPath,false,_errorList);
			checkPath("uiDictionary",uiDictionary,true,_errorList);
			
			if(_errorList.length == 0)
			{
				// 加载资源
				var file : File = new File(skinSwfPath);
				var fileStream : FileStream = new FileStream();
				fileStream.open(file, FileMode.READ);
				_applicationBytes = new ByteArray();
				fileStream.readBytes(_applicationBytes);
				fileStream.close();
				
				var context : LoaderContext = new LoaderContext();
				context.allowCodeImport = true;
				
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadSwfComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadSwfError);
				loader.loadBytes(_applicationBytes,context);
			}
			else
			{
				_callbackFunction(_errorList);
			}
		}
		
		private function onLoadSwfComplete(event : Event):void
		{
			var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadSwfComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadSwfError);
			
			var application : ApplicationDomain = loaderInfo.applicationDomain;
			
			var file : File = new File(skinCfgPath);
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			var xml : XML = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			fileStream.close();
			
			initButton(application,xml);
			
			initPanel(application,xml);
			
			initCheckBox(application,xml);
			
			file = new File(textFormatPath);
			fileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			textFormatCollection = new ArrayCollection();
			textFormatDic = new Object();
			xml = XML(fileStream.readUTFBytes(fileStream.bytesAvailable));
			for each(var formatXml : XML in xml.elements())
			{
				var textFormatInfo : TextFormatInfo = new TextFormatInfo();
				textFormatInfo.label = formatXml.@id.toString();
				var textFormat : TextFormat = new TextFormat();
				textFormat.font = formatXml.@font.toString();
				textFormat.size = int(formatXml.@size);
				textFormat.color = uint(formatXml.@color);
				textFormat.bold = (formatXml.@bold.toString() == "true");
				textFormat.italic = (formatXml.@italic.toString() == "true");
				textFormat.align = formatXml.@align.toString();
				textFormatInfo.textFormat = textFormat;
				textFormatDic[textFormatInfo.label] = textFormatInfo;
				textFormatCollection.addItem(textFormatInfo);
			}
			fileStream.close();
			
			
			_callbackFunction(_errorList);
		}
		
		private function initButton(application : ApplicationDomain, xml : XML):void
		{
			buttonList = new ArrayCollection();
			var buttonInfo : ButtonInfo = new ButtonInfo();
			buttonInfo.resizable = true;
			buttonInfo.name = "default";
			buttonList.addItem("");
			buttonSkinDic = new Object();
			for each(var buttonXML : XML in xml.elements("Button"))
			{
				buttonInfo = new ButtonInfo();
				buttonInfo.name = buttonXML.@name.toString();
				try
				{
					buttonInfo.resizable = (int(buttonXML.@resizable) == 1);
					if(buttonInfo.resizable)
					{
						buttonInfo.scale9Grid = new Rectangle(int(buttonXML.@scaleX),int(buttonXML.@scaleY),
							int(buttonXML.@scaleWidth),int(buttonXML.@scaleHeight));
					}
					var skinClass : Class;
					buttonInfo.upSkinName = buttonXML.@upSkin.toString();
					if(buttonInfo.upSkinName != null && buttonInfo.upSkinName.length > 0)
					{
						skinClass = getSkinDefinition(application, buttonInfo.upSkinName);
						buttonInfo.upSkin = new ScaleBitmapSkinInfo(skinClass,buttonInfo.scale9Grid);
					}
					buttonInfo.overSkinName = buttonXML.@overSkin.toString();
					if(buttonInfo.overSkinName != null && buttonInfo.overSkinName.length > 0)
					{
						skinClass = getSkinDefinition(application, buttonInfo.overSkinName);
						buttonInfo.overSkin = new ScaleBitmapSkinInfo(skinClass,buttonInfo.scale9Grid);
					}
					buttonInfo.downSkinName = buttonXML.@downSkin.toString();
					if(buttonInfo.downSkinName != null && buttonInfo.downSkinName.length > 0)
					{
						skinClass = getSkinDefinition(application, buttonInfo.downSkinName);
						buttonInfo.downSkin = new ScaleBitmapSkinInfo(skinClass,buttonInfo.scale9Grid);
					}
					buttonInfo.disabledSkinName = buttonXML.@disabledSkin.toString();
					if(buttonInfo.disabledSkinName != null && buttonInfo.disabledSkinName.length > 0)
					{
						skinClass = getSkinDefinition(application, buttonInfo.disabledSkinName);
						buttonInfo.disabledSkin = new ScaleBitmapSkinInfo(skinClass,buttonInfo.scale9Grid);
					}
					buttonSkinDic[buttonInfo.name] = buttonInfo;
					buttonList.addItem(buttonInfo.name);
				}
				catch(e : Error)
				{
					_errorList.push("button:"+ buttonInfo.name + "配置有错");
				}
			}
		}
		
		private function initPanel(application : ApplicationDomain, xml : XML):void
		{
			panelSkinDic = new Object();
			panelList = new ArrayCollection();
			panelList.addItem("");
			
			for each(var panelXML : XML in xml.elements("UIPanel"))
			{
				var panelInfo : UIPanelInfo = new UIPanelInfo();
				panelInfo.name = panelXML.@name.toString();
				try
				{
					panelInfo.resizable = (int(panelXML.@resizable) == 1);
					if(panelInfo.resizable)
					{
						panelInfo.scale9Grid = new Rectangle(int(panelXML.@scaleX),int(panelXML.@scaleY),
							int(panelXML.@scaleWidth),int(panelXML.@scaleHeight));
					}
					var skinClass : Class = getSkinDefinition(application, panelInfo.name);
					if(skinClass != null)
					{
						panelInfo.skin = new ScaleBitmapSkinInfo(skinClass, panelInfo.scale9Grid);
					}
					panelList.addItem(panelInfo.name);
					panelSkinDic[panelInfo.name] = panelInfo;
				}
				catch(e : Error)
				{
					_errorList.push("uipanel:"+ panelInfo.name + "配置有错");
				}
			}
		}
		
		private function initCheckBox(application : ApplicationDomain, xml : XML):void
		{
			checkBoxList = new ArrayCollection();
			checkBoxDic = new Object();
			checkBoxList.addItem("");
			
			for each(var checkXml : XML in xml.elements("CheckBox"))
			{
				var checkBoxInfo : CheckBoxInfo = new CheckBoxInfo();
				checkBoxInfo.name = checkXml.@name.toString();
				
				try
				{
					var upIcon : String = checkXml.@upIcon.toString();
					var overIcon : String = checkXml.@overIcon.toString();
					var downIcon : String = checkXml.@downIcon.toString();
					var disabledIcon : String = checkXml.@selectedUpIcon.toString();
					var selectedUpIcon : String = checkXml.@selectedUpIcon.toString();
					var selectedOverIcon : String = checkXml.@selectedOverIcon.toString();
					var selectedDownIcon : String = checkXml.@selectedDownIcon.toString();
					var selectedDisabledIcon : String = checkXml.@selectedDisabledIcon.toString();
					
					checkBoxInfo.upIconName = upIcon;
					checkBoxInfo.overIconName = overIcon;
					checkBoxInfo.downIconName = downIcon;
					checkBoxInfo.disabledIconName = disabledIcon;
					checkBoxInfo.selectedUpIconName = selectedUpIcon;
					checkBoxInfo.selectedOverIconName = selectedOverIcon;
					checkBoxInfo.selectedDownIconName = selectedDownIcon;
					checkBoxInfo.selectedDisabledIconName = selectedDisabledIcon;
					
					if(upIcon != null && upIcon.length > 0)
					{
						var skinClass : Class = getSkinDefinition(application, upIcon);
						checkBoxInfo.upIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(overIcon != null && overIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, overIcon);
						checkBoxInfo.overIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(downIcon != null && downIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, downIcon);
						checkBoxInfo.downIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(disabledIcon != null && disabledIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, disabledIcon);
						checkBoxInfo.disabledIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(selectedUpIcon != null && selectedUpIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, selectedUpIcon);
						checkBoxInfo.selectedUpIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(selectedOverIcon != null && selectedOverIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, selectedOverIcon);
						checkBoxInfo.selectedOverIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(selectedDownIcon != null && selectedDownIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, selectedDownIcon);
						checkBoxInfo.selectedDownIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					if(selectedDisabledIcon != null && selectedDisabledIcon.length > 0)
					{
						skinClass = getSkinDefinition(application, selectedDisabledIcon);
						checkBoxInfo.selectedDisabledIcon = new ScaleBitmapSkinInfo(skinClass);
					}
					checkBoxDic[checkBoxInfo.name] = checkBoxInfo;
					checkBoxList.addItem(checkBoxInfo.name);
				}
				catch(e : Error)
				{
					_errorList.push("checkBox:"+ checkBoxInfo.name + "配置有错");
					
				}
			}
		}
		
		private function getSkinDefinition(skinDomain : ApplicationDomain, className : String):Class
		{
			try
			{
				return skinDomain.getDefinition(className) as Class;
			}
			catch(e : Error)
			{
				_errorList.push(e.message + "  " + className);
			}
			return null;
		}
		
		private function onLoadSwfError(event : Event):void
		{
			var loaderInfo : LoaderInfo = event.currentTarget as LoaderInfo;
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadSwfComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadSwfError);
			
			_errorList.push("swf读取失败");
			_callbackFunction(_errorList);
		}
		
		public function save():void
		{
			var sharedObject : SharedObject = SharedObject.getLocal("UIEDITOR");
			sharedObject.data["Path_SkinSwf"] = skinSwfPath;
			sharedObject.data["Path_SkinCfg"] = skinCfgPath;
			sharedObject.data["Path_TextFormat"] = textFormatPath;
			sharedObject.data["Path_UIDictionary"] = uiDictionary;
			sharedObject.data["Path_ResPackage"] = resPackagePath;
			sharedObject.data["Path_uiPackage"] = uiPackagePath;
			sharedObject.data["Path_ResPackage1"] = resPackagePath1;
			sharedObject.data["Path_uiPackage1"] = uiPackagePath1;
			sharedObject.data["Path_SWC"] = swcPath;
			sharedObject.data["Path_SWC1"] = swcPath1;
			
			sharedObject.flush();
		}
		
		public function saveTextFormat():void
		{
			var str : String = "<TextFormat>"
			var count : int = textFormatCollection.length;
			for(var i : int = 0; i < count; ++i)
			{
				var textFormatInfo : TextFormatInfo = textFormatCollection[i] as TextFormatInfo;
				str += textFormatInfo.toXmlString();
			}
			str += "</TextFormat>";
			
			var file : File = new File(textFormatPath);
			var fileStream : FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTFBytes(str);
			fileStream.close();
		}
		
		public function outputRes():void
		{
			try
			{
				var file : File = new File(resPackagePath);
				var fileStream : FileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);;
				var ba : ByteArray = new ByteArray();
				var count : int = textFormatCollection.length;
				ba.writeShort(count);
				for(var i : int = 0; i < count; ++i)
				{
					var textFormatInfo : TextFormatInfo = textFormatCollection[i] as TextFormatInfo;
					ba.writeBytes(textFormatInfo.toByteArray());
				}
				count = buttonList.length;
				ba.writeByte(count - 1);
				for(i = 1; i < count; ++i)
				{
					var buttonInfo : ButtonInfo = buttonSkinDic[buttonList[i]];
					var byteArray : ByteArray = buttonInfo.toByteArray();
					ba.writeBytes(byteArray);
				}
				count = panelList.length;
				ba.writeByte(count - 1);
				for(i = 1; i < count; ++i)
				{
					var panelInfo : UIPanelInfo = panelSkinDic[panelList[i]];
					ba.writeBytes(panelInfo.toByteArray());
				}
				count = checkBoxList.length;
				ba.writeByte(count - 1);
				for(i = 1; i < count; ++i)
				{
					var checkBoxInfo : CheckBoxInfo = checkBoxDic[checkBoxList[i]];
					ba.writeBytes(checkBoxInfo.toByteArray());
				}
				ba.compress();
				fileStream.writeBytes(ba);
				fileStream.close();
				
				ba.position = 0;
				try
				{
					file = new File(resPackagePath1);
					fileStream = new FileStream();
					fileStream.open(file, FileMode.WRITE);
					fileStream.writeBytes(ba);
					fileStream.close();
					Alert.show("导出资源包完成");
				}
				catch(e : Error)
				{
					Alert.show("导出资源包完成,但没有打包资源2");
				}
				if(swcPath != null && swcPath.length > 0 && swcPath1 != null && swcPath1.length > 0)
				{
					try
					{
						file = new File(swcPath);
						fileStream = new FileStream();
						fileStream.open(file, FileMode.READ);
						ba = new ByteArray();
						fileStream.readBytes(ba);
						fileStream.close();
						file = new File(swcPath1);
						fileStream = new FileStream();
						fileStream.open(file, FileMode.WRITE);
						fileStream.writeBytes(ba);
						fileStream.close();
					}
					catch(e : Error)
					{
						Alert.show("复制swc报错：" + e.message);
					}
				}
			}
			catch(e : Error)
			{
				Alert.show("导出资源失败：" + e.message);
			}
			
		}
		
		public function outputUI():void
		{
			try
			{
				var obj : Object = new Object();
				var file : File = new File(uiDictionary);
				var files : Array = file.getDirectoryListing();
				var count : int = files.length;
				for(var i : int = 0; i < count; ++i)
				{
					file = files[i];
					var fileName : String = file.name;
					if(fileName.split(".").length == 2 && fileName.split(".")[1] == "xml")
					{
						fileName = fileName.split(".")[0];
						var fileStream : FileStream = new FileStream();
						fileStream.open(file, FileMode.READ);
						obj[fileName] = fileStream.readUTFBytes(fileStream.bytesAvailable);
						fileStream.close();
					}
				}
				file = new File(uiPackagePath);
				fileStream = new FileStream();
				fileStream.open(file, FileMode.WRITE);
				var byteArray : ByteArray = new ByteArray();
				byteArray.writeObject(obj);
				byteArray.compress();
				fileStream.writeBytes(byteArray);
				fileStream.close();
				
				byteArray.position = 0;
				try
				{
					file = new File(uiPackagePath1);
					fileStream = new FileStream();
					fileStream.open(file, FileMode.WRITE);
					fileStream.writeBytes(byteArray);
					fileStream.close();
					Alert.show("打包界面完成");
				}
				catch(e : Error)
				{
					Alert.show("打包界面完成,但没有打包界面2");
				}
			} 
			catch(error:Error) 
			{
				Alert.show("打包界面出错：" + error.message);
			}
		}
		
		private function checkPath(name : String, path : String, isDirect : Boolean, errorList : Vector.<String>):void
		{
			try
			{
				var file : File = new File(path);
				if(file.exists && file.isDirectory == isDirect)
				{
					return;
				}
			} 
			catch(error:Error) 
			{
			}
			errorList.push(name + " 的路径：" + path + "不存在");
		}
	}
}