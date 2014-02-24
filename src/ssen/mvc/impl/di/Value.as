package ssen.mvc.impl.di {

internal class Value implements InstanceFactory {
	public var instance:Object;

	public function getInstance():Object {
		return instance;
	}
}
}
