package ssen.mvc {
import flash.events.Event;

import ssen.common.IDisposable;

public interface IEventBus extends IDisposable {
	// ---------------------------------------
	// listener
	// ---------------------------------------
	function get evtDispatcher():IEvtDispatcher;

	function addEventListener(type:String, listener:Function):IEventUnit;

	// ---------------------------------------
	// dispatcher
	// ---------------------------------------
	function dispatchEvent(evt:Event, to:String="self", penetrate:Boolean=false):void;

	// ---------------------------------------
	// chain
	// ---------------------------------------
	function get parentEventBus():IEventBus;

	function createChildEventBus():IEventBus;
}
}
