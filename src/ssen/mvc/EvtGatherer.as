package ssen.mvc {
import de.polygonal.ds.HashMap;
import de.polygonal.ds.Itr;

import ssen.common.IDisposable;

public class EvtGatherer implements IDisposable {
	private var map:HashMap;
	
	public function add(unit:IEvtUnit):void {
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
			var unit:IEvtUnit=map.get(type) as IEvtUnit;
			unit.dispose();
			map.remove(type);
		}
	}
	
	public function dispose():void {
		var itr:Itr=map.iterator();
		var unit:IEvtUnit;
		
		while (itr.hasNext()) {
			unit=itr.next() as IEvtUnit;
			unit.dispose();
		}
		
		map.clear(true);
		map=null;
	}
}
}
