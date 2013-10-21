package ssen.mvc {

public interface IContext {
	/** @see ssen.mvc.core.IInjector */
	function get injector():IInjector;

	/** @see ssen.mvc.core.IEventBus */
	function get eventBus():IEventBus;
}
}
