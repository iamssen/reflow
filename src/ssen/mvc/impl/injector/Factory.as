package ssen.mvc.impl.injector {
import mx.core.IFactory;

internal class Factory implements InstanceFactory {
	public var injector:Injector;
	public var factoryType:Class;

	public function getInstance():Object {
		var factory:IFactory=injector.injectInto(new factoryType) as IFactory;
		return injector.injectInto(factory.newInstance());
	}
}
}
