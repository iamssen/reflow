package ssen.mvc {
import flash.events.Event;

public interface IEventBus {
	//==========================================================================================
	// listener
	//==========================================================================================
	function addEventListener(type:String, listener:Function):IEventListener;
	function on(type:String, listener:Function):IEventListener;

	//==========================================================================================
	// dispatcher
	//==========================================================================================
	function dispatchEvent(event:Event, to:String="self", penetrate:Boolean=false):void;

	//==========================================================================================
	// tree
	//==========================================================================================
	function get parentEventBus():IEventBus;
	function createChildEventBus():IEventBus;
}
}
