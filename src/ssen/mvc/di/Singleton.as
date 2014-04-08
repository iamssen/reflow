package ssen.mvc.di {

/** @private implements class */
internal class Singleton implements InstanceFactory {
	public var injector:Injector;
	public var type:Class;

	private var instance:Object;

	public function getInstance():Object {
		if (!instance) {
			instance=new type;
			injector.injectInto(instance);
		}
		return instance;
	}
}
}
