package ui.comp
{
	import flash.display.DisplayObjectContainer;
	
	import mx.collections.ArrayCollection;
	import mx.core.IContainer;
	
	import ui.struct.BaseData;

	public interface IComponentEditor
	{
		function getData():BaseData;
		
		function getContainer():DisplayObjectContainer;
	}
}