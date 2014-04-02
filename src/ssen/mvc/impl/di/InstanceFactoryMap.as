package ssen.mvc.impl.di {

/** @private implements class */
internal class InstanceFactoryMap {
	private var map:Object={};

	public function set(typeName:String, fac:InstanceFactory):void {
		map[typeName]=fac;
	}

	public function unset(typeName:String):void {
		if (map[typeName] != undefined) {
			delete map[typeName];
		}
	}

	public function get(typeName:String):InstanceFactory {
		return map[typeName];
	}

	public function has(typeName:String):Boolean {
		return map[typeName] != undefined;
	}
}
}
