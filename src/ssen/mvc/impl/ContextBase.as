package ssen.mvc.impl {
import ssen.mvc.ICommandMap;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IEventBus;
import ssen.mvc.IEvtDispatcher;
import ssen.mvc.IInjector;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;

/** @see ssen.mvc.ondisplay.Context */
public class ContextBase implements IContext {
	private var _contextView:IContextView;
	private var _parentContext:IContext;
	private var _eventBus:IEventBus;
	private var _injector:IInjector;
	private var _contextViewInjector:ImplContextViewInjector;
	private var _commandMap:ImplCommandMap;

	public function ContextBase(contextView:IContextView, parentContext:IContext=null) {
		_parentContext=parentContext;
		_contextView=contextView;

		initialize();
	}

	/** @private */
	protected function initialize():void {
		injector.mapValue(IInjector, injector);
		injector.mapValue(IEvtDispatcher, eventBus.evtDispatcher);
		injector.mapValue(IEventBus, eventBus);
		injector.mapValue(IContextView, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IViewInjector, viewInjector);

		mapDependency();

		viewCatcher.start(contextView);
	}

	protected function mapDependency():void {
	}

	protected function startup():void {
	}

	protected function shutdown():void {
	}

	protected function dispose():void {
		viewCatcher.stop();

		eventBus.dispose();
		injector.dispose();
		viewCatcher.dispose();
		viewInjector.dispose();
		contextViewInjector.dispose();
		commandMap.dispose();

		_contextView=null;
		_parentContext=null;
		_eventBus=null;
		_injector=null;
		_contextViewInjector=null;
		_commandMap=null;
	}

	//==========================================================================================
	// 
	//==========================================================================================
	/** @see ssen.mvc.core.IContextView */
	final protected function get contextView():IContextView {
		return _contextView;
	}

	/** @private */
	final protected function get parentContext():IContext {
		return _parentContext;
	}

	protected function get stage():Object {
		throw new Error("not implemented");
	}

	/** @see ssen.mvc.core.IEventBus */
	final public function get eventBus():IEventBus {
		if (_eventBus) {
			return _eventBus;
		}

		_eventBus=parentContext === null ? new EventBus : new EventBus(parentContext.eventBus);

		return _eventBus;
	}

	/** @see ssen.mvc.core.IInjector */
	final public function get injector():IInjector {
		if (_injector) {
			return _injector;
		}

		_injector=parentContext === null ? new Injector : parentContext.injector.createChild();

		return _injector;
	}

	protected function get viewCatcher():IViewCatcher {
		throw new Error("not implemented");
	}

	protected function get viewInjector():IViewInjector {
		throw new Error("not implemented");
	}

	final protected function get contextViewInjector():IContextViewInjector {
		return _contextViewInjector||=new ImplContextViewInjector(this);
	}

	/** @see ssen.mvc.core.ICommandMap */
	public function get commandMap():ICommandMap {
		return _commandMap||=new ImplCommandMap(eventBus.evtDispatcher, injector);
	}
}
}
