package ssen.mvc {

// TODO 이름이 맘에 안든다.
public interface IEventUnit {
	function get type():String;
	function get listener():Function;
	// TODO 이름 바꾸기...
	function stop():void;
}
}
