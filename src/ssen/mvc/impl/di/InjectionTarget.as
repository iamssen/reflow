package ssen.mvc.impl.di {

/** @private implements class */
internal interface InjectionTarget {
	function mapping(instance:Object, injector:Injector):void;
}
}
