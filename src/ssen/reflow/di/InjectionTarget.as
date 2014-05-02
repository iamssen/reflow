package ssen.reflow.di {

/** @private implements class */
internal interface InjectionTarget {
	function mapping(instance:Object, injector:Injector):void;
}
}
