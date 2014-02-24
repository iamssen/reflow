package ssen.mvc.impl.di {

internal interface InjectionTarget {
	function mapping(instance:Object, factoryMap:InstanceFactoryMap):void;
}
}
