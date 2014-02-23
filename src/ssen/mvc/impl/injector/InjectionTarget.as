package ssen.mvc.impl.injector {

internal interface InjectionTarget {
	function mapping(instance:Object, factoryMap:InstanceFactoryMap):void;
}
}
