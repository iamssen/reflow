package ssen.mvc {

public interface IEventListener {
	function get type():String;
	function get listener():Function;
	function remove():void;
}
}
