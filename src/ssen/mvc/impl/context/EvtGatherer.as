package ssen.mvc.impl.context {
import de.polygonal.ds.HashMap;
import de.polygonal.ds.Itr;

import ssen.common.IDisposable;
import ssen.mvc.IEventUnit;

internal class EvtGatherer implements IDisposable {
	private var map:HashMap;

	public function add(unit:IEventUnit):void {
		if (map === null) {
			map=new HashMap;
		}

		if (map.has(unit.type)) {
			throw new Error("don't add same name event type");
		} else {
			map.set(unit.type, unit);
		}
	}

	public function remove(type:String):void {
		if (map.has(type)) {
			var unit:IEventUnit=map.get(type) as IEventUnit;
			unit.dispose();
			map.remove(type);
		}
	}

	public function dispose():void {
		var itr:Itr=map.iterator();
		var unit:IEventUnit;

		while (itr.hasNext()) {
			unit=itr.next() as IEventUnit;
			unit.dispose();
		}

		map.clear(true);
		map=null;
	}
}
}
