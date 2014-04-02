package ssen.mvc.impl.di {

/** @private implements class */
internal class Instantiate implements InstanceFactory {
	public var injector:Injector;
	public var type:Class;

	public function getInstance():Object {
		return injector.injectInto(new type);
	}
}
}
