package ssen.reflow.context {
import flash.events.Event;

import ssen.reflow.IEventBus;
import ssen.reflow.IEventListener;

/** @private implements class */
internal class EventBus implements IEventBus {
	private var dispatcher:ContextEventDispatcher;

	//==========================================================================================
	// func
	//==========================================================================================
	//----------------------------------------------------------------
	// context life cycle
	//----------------------------------------------------------------
	public function setContext(hostContext:Context):void {
		dispatcher = new ContextEventDispatcher;
	}

	public function dispose():void {
		dispatcher.dispose();
		dispatcher = null;
	}

	//----------------------------------------------------------------
	// implements IEventBus
	//----------------------------------------------------------------
	public function addEventListener(type:String, listener:Function):IEventListener {
		return dispatcher.addEventListener(type, listener);
	}

	public function on(type:String, listener:Function):IEventListener {
		return addEventListener(type, listener);
	}

	public function dispatchEvent(event:Event):void {
		dispatcher.dispatchEvent(event);
	}

	public function fire(event:Event):void {
		dispatchEvent(event);
	}
}
}