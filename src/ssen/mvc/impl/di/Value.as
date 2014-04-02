package ssen.mvc.impl.di {

/** @private implements class */
internal class Value implements InstanceFactory {
	public var instance:Object;

	public function getInstance():Object {
		return instance;
	}
}
}
