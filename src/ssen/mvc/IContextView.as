package ssen.mvc {

public interface IContextView {
	function initialContext(parentContext:IContext=null):void;
	function get contextInitialized():Boolean;
}
}
