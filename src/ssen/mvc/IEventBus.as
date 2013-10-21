package ssen.mvc {
import ssen.common.IDisposable;

public interface IEventBus extends IDisposable {
	// ---------------------------------------
	// listener
	// ---------------------------------------
	function get evtDispatcher():IEvtDispatcher;
	
	function addEventListener(type:String, listener:Function):IEvtUnit;
	
	// ---------------------------------------
	// dispatcher
	// ---------------------------------------
	function dispatchEvent(evt:Evt, to:String="self", penetrate:Boolean=false):void;
	
	// ---------------------------------------
	// chain
	// ---------------------------------------
	function get parentEventBus():IEventBus;
	
	function createChildEventBus():IEventBus;
}
}
