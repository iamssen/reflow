package ssen.mvc.impl.context {
import ssen.mvc.IParameters;

internal class Parameters implements IParameters {
	private var object:Object;

	public function Parameters(obj:Object) {
		if (!obj) {
			throw new Error("obj is null");
		}
		object=obj;
	}

	public function get(key:*):* {
		return object[key];
	}

	public function has(key:*):Boolean {
		return object[key] !== null && object[key] !== undefined;
	}
}
}
