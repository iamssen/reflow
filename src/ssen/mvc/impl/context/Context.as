package ssen.mvc.impl.context {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.IEventDispatcher;

import ssen.mvc.ICommandMap;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IEventBus;
import ssen.mvc.IEventEmitter;
import ssen.mvc.IInjector;
import ssen.mvc.IParameters;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;
import ssen.mvc.mvc_internal;
import ssen.mvc.impl.injector.Injector;

use namespace mvc_internal;

public class Context implements IContext {
	mvc_internal var _viewCatcher:IViewCatcher;
	mvc_internal var _viewInjector:IViewInjector;
	mvc_internal var _contextView:IContextView;
	mvc_internal var _parentContext:IContext;
	mvc_internal var _eventBus:IEventBus;
	mvc_internal var _injector:IInjector;
	mvc_internal var _contextViewInjector:ContextViewInjector;
	mvc_internal var _commandMap:CommandMap;

	public function Context(contextView:IContextView, parentContext:IContext=null, parameters:Object=null) {
		_parentContext=parentContext;
		_contextView=contextView;

		if (parameters) {
			injector.mapValue(IParameters, new Parameters(parameters));
		}

		initialize();
	}

	private function initialize():void {
		injector.mapValue(IInjector, injector);
		injector.mapValue(IEventEmitter, eventBus.eventEmitter);
		injector.mapValue(IEventBus, eventBus);
		injector.mapValue(IContextView, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IViewInjector, viewInjector);

		mapDependency();

//		viewCatcher.start(contextView);

		var contextView:DisplayObjectContainer=this.contextView as DisplayObjectContainer;

		// stage 가 있으면 바로 start, 아니면 added to stage 까지 지연시킴
		if (contextView.stage) {
			startupContextView();
		} else {
			contextView.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
	}

	protected function mapDependency():void {
	}

	protected function startup():void {
	}

	protected function shutdown():void {
	}

	// ==========================================================================================
	// dispose resources
	// ==========================================================================================
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

		_viewCatcher=null;
		_viewInjector=null;
	}

	// =========================================================
	// initialize context
	// =========================================================
	final protected function get contextView():IContextView {
		return _contextView;
	}

	final protected function get parentContext():IContext {
		return _parentContext;
	}

	private function startupContextView():void {
		if (viewInjector.hasMapping(contextView)) {
			viewInjector.injectInto(contextView);
		}

		startup();

		IEventDispatcher(contextView).addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	final public function get eventBus():IEventBus {
		if (_eventBus) {
			return _eventBus;
		}

		_eventBus=parentContext === null ? new EventBus : new EventBus(parentContext.eventBus);

		return _eventBus;
	}

	final public function get injector():IInjector {
		if (_injector) {
			return _injector;
		}

		_injector=parentContext === null ? new Injector : parentContext.injector.createChild();

		return _injector;
	}

	private function addedToStage(event:Event):void {
		IEventDispatcher(contextView).removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		startupContextView();
	}

	private function removedFromStage(event:Event):void {
		IEventDispatcher(contextView).removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		shutdown();
		dispose();
	}

	protected function get contextViewInjector():IContextViewInjector {
		return _contextViewInjector||=new ContextViewInjector(this);
	}

	public function get commandMap():ICommandMap {
		return _commandMap||=new CommandMap(eventBus.eventEmitter, injector);
	}

	// =========================================================
	// implementation getters
	// =========================================================
	final protected function get viewCatcher():IViewCatcher {
		return _viewCatcher||=new ViewCatcher(viewInjector, contextViewInjector, contextView);
	}

	final protected function get viewInjector():IViewInjector {
		return _viewInjector||=new ViewInjector(injector);
	}
}
}
