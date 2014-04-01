package ssen.mvc {

public interface IViewMap {
	function mapView(viewClass:Class, mediatorClass:Class=null, global:Boolean=false):void;

	function unmapView(viewClass:Class):void;

	function hasMapping(view:*):Boolean;

//	function injectInto(view:Object):void;

//	function isGlobal(view:*):Boolean;
}
}
