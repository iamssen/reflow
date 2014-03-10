package ssen.mvc {
import mx.core.IMXMLObject;

public interface IContext extends IMXMLObject {
	function get injector():IInjector;
	function get eventBus():IEventBus;
}
}
