package ssen.mvc.impl.context {
import flash.events.Event;

import ssen.mvc.IEventEmitter;
import ssen.mvc.IEventUnit;

internal class EventEmitter implements IEventEmitter {
	private var collection:Collection;

	public function EventEmitter() {
		collection=new Collection;
	}

	public function addEventListener(type:String, listener:Function):IEventUnit {
		return collection.add(type, listener);
	}

	public function on(type:String, listener:Function):IEventUnit {
		return addEventListener(type, listener);
	}

	public function emitEvent(event:Event):void {
		var units:Vector.<IEventUnit>=collection.get(event.type);
		var f:int=units.length;

		if (f === 0) {
			return;
		}

		while (--f >= 0) {
			units[f].listener(event);
		}
	}

	public function dispose():void {
		collection.dispose();
		collection=null;
	}
}
}
