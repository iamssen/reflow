package ssen.reflow {

/**
 * [DO NOT IMPLEMENT]
 */
public interface IEventDistributor {
	function map(eventType:String, dispatchTo:*):void;

	function unmap(eventType:String):void;

	function has(eventType:String):Boolean;
}
}
