package ssen.mvc {

public interface IContext {
	function get injector():IInjector;
	function get eventBus():IEventBus;
}
}
