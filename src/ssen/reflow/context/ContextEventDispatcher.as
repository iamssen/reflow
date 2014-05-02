package ssen.reflow.context {
import flash.events.Event;

import ssen.reflow.IEventListener;

/** @private implements class */
internal class ContextEventDispatcher {
	//==========================================================================================
	// properties
	//==========================================================================================
	private var collection:EventCollection;

	//==========================================================================================
	// constructor and life cycle
	//==========================================================================================
	public function ContextEventDispatcher() {
		collection=new EventCollection;
	}

	public function dispose():void {
		collection.dispose();
		collection=null;
	}

	//==========================================================================================
	// apis
	//==========================================================================================
	public function addEventListener(type:String, listener:Function):IEventListener {
		return collection.add(type, listener);
	}

	public function on(type:String, listener:Function):IEventListener {
		return addEventListener(type, listener);
	}

	public function dispatchEvent(event:Event):void {
		var units:Vector.<IEventListener>=collection.get(event.type);
		var f:int=units.length;

		if (f === 0) {
			return;
		}

		while (--f >= 0) {
			units[f].listener(event);
		}
	}
}
}
