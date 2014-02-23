package ssen.mvc.impl.injector {

internal class Value implements InstanceFactory {
	public var instance:Object;

	public function getInstance():Object {
		return instance;
	}
}
}
