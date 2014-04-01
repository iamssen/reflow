package ssen.mvc.impl.context {
import flash.utils.Dictionary;

import ssen.mvc.IEventUnit;

internal class EventCollection {
	// types["change"][Function]=IEventUnit
	private var types:Dictionary=new Dictionary;

	public function add(type:String, listener:Function):IEventUnit {
		if (types[type] !== undefined && types[type][listener] !== undefined) {
			return types[type][listener];
		}

		if (types[type] === undefined) {
			types[type]=new Dictionary;
		}

		var unit:EventUnit=new EventUnit;
		unit._collection=this;
		unit._listener=listener;
		unit._type=type;

		types[type][listener]=unit;

		return unit;
	}

	public function remove(type:String, listener:Function):void {
		if (types[type] !== undefined) {
			if (types[type][listener]) {
				delete types[type][listener];
			}
		}
	}

	public function get(type:String):Vector.<IEventUnit> {
		var units:Vector.<IEventUnit>=new Vector.<IEventUnit>;

		if (types[type] !== undefined) {
			var listeners:Dictionary=types[type];

			for each (var unit:IEventUnit in listeners) {
				units.push(unit);
			}
		}

		return units;
	}

	public function dispose():void {
		types=null;
	}
}
}
