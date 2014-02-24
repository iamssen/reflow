package ssen.mvc.impl.di {

internal class Property implements InjectionTarget {
	public var propertyName:String;
	public var valueType:String;

	public function mapping(instance:Object, factoryMap:InstanceFactoryMap):void {
		instance[propertyName]=factoryMap.get(valueType).getInstance();
	}
}
}
