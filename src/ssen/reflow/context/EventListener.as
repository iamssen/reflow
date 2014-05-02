package ssen.reflow.context {

import ssen.reflow.IEventListener;

/** @private implements class */
internal class EventListener implements IEventListener {
	internal var _collection:EventCollection;
	internal var _listener:Function;
	internal var _type:String;

	public function remove():void {
		if (_collection) {
			_collection.remove(_type, _listener);
		}

		_collection=null;
		_listener=null;
		_type=null;
	}

	public function get listener():Function {
		return _listener;
	}

	public function get type():String {
		return _type;
	}
}
}
