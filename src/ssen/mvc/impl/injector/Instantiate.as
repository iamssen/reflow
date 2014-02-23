package ssen.mvc.impl.injector {

internal class Instantiate implements InstanceFactory {
	public var injector:Injector;
	public var type:Class;

	public function getInstance():Object {
		return injector.injectInto(new type);
	}
}
}
