package ssen.mvc.impl.injector {

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
