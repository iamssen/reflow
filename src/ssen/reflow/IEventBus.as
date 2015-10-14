package ssen.reflow {
import flash.events.Event;

/**
 * [DO NOT IMPLEMENT]
 * @see ssen.reflow.context.Context#mapDependency()
 */
public interface IEventBus {
	function addEventListener(eventType:String, listener:Function):IEventListener;

	function on(eventType:String, listener:Function):IEventListener;

	function dispatchEvent(event:Event):void;

	function fire(event:Event):void;
}
}
