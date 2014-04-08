package ssen.mvc.di {
import mx.core.IFactory;

/** @private implements class */
internal class Factory implements InstanceFactory {
	public var injector:Injector;
	public var factoryType:Class;

	public function getInstance():Object {
		var factory:IFactory=new factoryType();
		injector.injectInto(factory);

		var instance:Object=factory.newInstance();
		injector.injectInto(instance);

		return instance;
	}
}
}
