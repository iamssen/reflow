package ssen.mvc.impl.di {

/** @private implements class */
internal class Singleton implements InstanceFactory {
	public var injector:Injector;
	public var type:Class;

	private var instance:Object;

	public function getInstance():Object {
		if (!instance) {
			instance=injector.injectInto(new type);
		}
		return instance;
	}
}
}
