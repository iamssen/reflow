package ssen.reflow.di {

/** @private implements class */
internal class Instantiate implements InstanceFactory {
	public var injector:Injector;
	public var type:Class;

	public function getInstance():Object {
		var instance:Object=new type;

		injector.injectInto(instance);

		return instance;
	}
}
}
