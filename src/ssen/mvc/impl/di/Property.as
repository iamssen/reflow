package ssen.mvc.impl.di {
import ssen.mvc.mvc_internal;

use namespace mvc_internal;

internal class Property implements InjectionTarget {
	public var propertyName:String;
	public var valueType:String;

	public function mapping(instance:Object, injector:Injector):void {
		instance[propertyName]=injector.getInstanceByName(valueType);
		//		instance[propertyName]=factoryMap.get(valueType).getInstance();
	}
}
}
