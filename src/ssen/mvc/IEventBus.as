package ssen.mvc {
import flash.events.Event;

public interface IEventBus {
	//==========================================================================================
	// listener
	//==========================================================================================
	function addEventListener(type:String, listener:Function):IEventUnit;
	function on(type:String, listener:Function):IEventUnit;

	//==========================================================================================
	// emitter
	//==========================================================================================
	function emitEvent(event:Event, to:String="self", penetrate:Boolean=false):void;

	//==========================================================================================
	// tree
	//==========================================================================================
	function get parentEventBus():IEventBus;
	function createChildEventBus():IEventBus;
}
}
