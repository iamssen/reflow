package ssen.mvc.impl.context {

import ssen.mvc.IEventUnit;

internal class EventUnit implements IEventUnit {
	internal var _collection:Collection;
	internal var _listener:Function;
	internal var _type:String;

	public function dispose():void {
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
