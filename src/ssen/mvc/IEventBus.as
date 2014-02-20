package ssen.mvc {
import flash.events.Event;

import ssen.common.IDisposable;

public interface IEventBus extends IDisposable {
	// ---------------------------------------
	// listener
	// ---------------------------------------
	function get eventEmitter():IEventEmitter;

	function addEventListener(type:String, listener:Function):IEventUnit;
	function on(type:String, listener:Function):IEventUnit;

	// ---------------------------------------
	// dispatcher
	// ---------------------------------------
	function emitEvent(event:Event, to:String="self", penetrate:Boolean=false):void;

	// ---------------------------------------
	// chain
	// ---------------------------------------
	function get parentEventBus():IEventBus;
	function createChildEventBus():IEventBus;
}
}
