package ssen.reflow.di {
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

/** @private implements class */
internal class Property implements InjectionTarget {
	public var propertyName:String;
	public var valueType:String;

	public function mapping(instance:Object, injector:Injector):void {
		instance[propertyName]=injector.getInstanceByName(valueType);
		//		instance[propertyName]=factoryMap.get(valueType).getInstance();
	}
}
}
