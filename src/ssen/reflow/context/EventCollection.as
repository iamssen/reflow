package ssen.reflow.context {
import flash.utils.Dictionary;

import ssen.reflow.IEventListener;

/** @private implements class */
internal class EventCollection {
	private var types:Dictionary = new Dictionary; // types["change"][Function]=IEventUnit

	public function add(type:String, listener:Function):IEventListener {
		if (types[type] !== undefined && types[type][listener] !== undefined) {
			return types[type][listener];
		}

		if (types[type] === undefined) {
			types[type] = new Dictionary;
		}

		var eventListener:EventListener = new EventListener;
		eventListener._collection = this;
		eventListener._listener = listener;
		eventListener._type = type;

		types[type][listener] = eventListener;

		return eventListener;
	}

	public function remove(type:String, listener:Function):void {
		if (!types) return;

		if (types[type] !== undefined) {
			if (types[type][listener]) {
				delete types[type][listener];
			}
		}
	}

	public function get(type:String):Vector.<IEventListener> {
		if (!types) return null;

		var eventListeners:Vector.<IEventListener> = new Vector.<IEventListener>;

		if (types[type] !== undefined) {
			var listeners:Dictionary = types[type];

			for each (var eventListener:IEventListener in listeners) {
				eventListeners.push(eventListener);
			}
		}

		return eventListeners;
	}

	public function dispose():void {
		types = null;
	}
}
}
