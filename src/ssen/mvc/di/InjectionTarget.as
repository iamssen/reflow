package ssen.mvc.di {

/** @private implements class */
internal interface InjectionTarget {
	function mapping(instance:Object, injector:Injector):void;
}
}
