package ssen.reflow {

// TODO 기존 DispatchTo의 처리를 IEventDistributor로 이전
public interface IEventDistributor {
	function map(eventType:String, dispatchTo:*):void;

	function unmap(eventType:String):void;

	function has(eventType:String):Boolean;
}
}
