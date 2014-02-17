package ssen.mvc.impl {
import ssen.mvc.Evt;
import ssen.mvc.IEvtDispatcher;
import ssen.mvc.IEventUnit;

internal class EvtDispatcher implements IEvtDispatcher {
	private var collection:Collection;

	public function EvtDispatcher() {
		collection=new Collection;
	}

	public function addEvtListener(type:String, listener:Function):IEventUnit {
		return collection.add(type, listener);
	}

	public function dispatchEvt(evt:Evt):void {
		var units:Vector.<IEventUnit>=collection.get(evt.type);
		var f:int=units.length;

		if (f === 0) {
			return;
		}

		while (--f >= 0) {
			units[f].listener(evt);
		}
	}

	public function dispose():void {
		collection.dispose();
		collection=null;
	}
}
}
