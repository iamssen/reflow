package ssen.mvc {

public interface IMediator {
	// TODO display 전용 변경 고려
	function setView(value:Object):void;
	function onRegister():void;
	function onRemove():void;
}
}
