package ssen.reflow.context {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;

import mx.core.IMXMLObject;
import mx.core.IVisualElementContainer;
import mx.managers.SystemManager;

import ssen.reflow.IBackgroundServiceMap;
import ssen.reflow.ICommandMap;
import ssen.reflow.IEventBus;
import ssen.reflow.IInjector;
import ssen.reflow.IViewMap;
import ssen.reflow.reflow_internal;
import ssen.reflow.di.Injector;

use namespace reflow_internal;

/**
 * MVC Module Context
 */
public class Context implements IMXMLObject {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// state flags
	//----------------------------------------------------------------
	private var stageSaved:Boolean;

	//----------------------------------------------------------------
	// parts
	//----------------------------------------------------------------
	//---------------------------------------------
	// display objecties
	//---------------------------------------------
	/** @private */
	reflow_internal var contextView:DisplayObject;

	/** @private */
	reflow_internal var stage:Stage;

	//---------------------------------------------
	// parts
	//---------------------------------------------
	/** @private */
	reflow_internal var _eventBus:EventBus;

	/** @private */
	reflow_internal var _commandMap:CommandMap;

	/** @private */
	reflow_internal var _viewMap:ViewMap;

	/** @private */
	reflow_internal var _injector:Injector;

	/** @private */
	reflow_internal var _backgroundServiceMap:BackgroundServiceMap;

	private var _viewWatcher:ViewWatcher;

	//==========================================================================================
	// getters
	//==========================================================================================
	protected function get eventBus():IEventBus {
		return _eventBus;
	}

	protected function get commandMap():ICommandMap {
		return _commandMap;
	}

	protected function get viewMap():IViewMap {
		return _viewMap;
	}

	protected function get injector():IInjector {
		return _injector;
	}

	protected function get backgroundServiceMap():IBackgroundServiceMap {
		return _backgroundServiceMap;
	}

	//==========================================================================================
	// abstract functions
	//==========================================================================================
	/** [Hook] 이 함수 내에서 여러 의존성을 선언 */
	protected function mapDependency():void {
	}

	/** [Hook] <code>Context</code>가 시작될 때 (<code>Event.ADDED_TO_STAGE</code>에 실행됨) */
	protected function startup():void {
	}

	/** [Hook] <code>Context</code>가 종료될 때 (<code>EVENT.REMOVED_FROM_STAGE</code>에 실행됨) */
	protected function shutdown():void {
	}

	/**
	 * [주의] 강제로 상위 <code>Context</code>를 지정하고 싶을 때 사용합니다. (예를 들어 팝업으로 떠야하는 하위 <code>Context</code>와 같은 경우)
	 *
	 * 이 함수가 <code>null</code>을 return하지 않으면, <code>Display Object</code>의 포함 관계를 무시합니다.
	 */
	reflow_internal function getParentContext():Context {
		return null;
	}

	//==========================================================================================
	// context life cycle
	//==========================================================================================
	/** @private IMXMLObject initialized */
	public function initialized(document:Object, id:String):void {
		contextView=document as DisplayObject;
		contextView.addEventListener(Event.ADDED, onAdded);
	}

	private function onAdded(event:Event):void {
		saveStage();

		if (!stage) {
			return;
		}

		contextView.removeEventListener(Event.ADDED, onAdded);

		ContextMap.getInstance().register(this, getParentContext());

		//----------------------------------------------------------------
		// 05. create instances
		//----------------------------------------------------------------
		var parentContext:Context=ContextMap.getInstance().getParentContext(this);
		var hasParent:Boolean=parentContext !== null;

		_eventBus=hasParent ? parentContext._eventBus.createChildEventBus() as EventBus : new EventBus;
		_injector=hasParent ? parentContext._injector.createChildInjector() as Injector : new Injector;
		_commandMap=new CommandMap;
		_viewMap=new ViewMap;
		_viewWatcher=new ViewWatcher;
		_backgroundServiceMap=new BackgroundServiceMap;

		// set dependent to instances
		_eventBus.setContext(this);
		_commandMap.setContext(this);
		_viewMap.setContext(this);
		_viewWatcher.setContext(this);
		_backgroundServiceMap.setContext(this);

		//----------------------------------------------------------------
		// 10. map dependencies
		//----------------------------------------------------------------
		// views
		if (contextView is IVisualElementContainer) {
			_injector.mapValue(IVisualElementContainer, contextView);
		}
		_injector.mapValue(contextView["constructor"], contextView);
		_injector.mapValue(Stage, stage);

		_injector.mapValue(IEventBus, _eventBus);
		_injector.mapValue(ICommandMap, _commandMap);
		_injector.mapValue(IViewMap, _viewMap);
		_injector.mapValue(IInjector, _injector);
		_injector.mapValue(IBackgroundServiceMap, _backgroundServiceMap);

		mapDependency();

		//----------------------------------------------------------------
		// 20. start watch
		//----------------------------------------------------------------
		_eventBus.start();
		_viewWatcher.start();
		_backgroundServiceMap.start();

		contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	private function onAddedToStage(event:Event):void {
		contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		//----------------------------------------------------------------
		// 30. startup
		//----------------------------------------------------------------
		startup();

		contextView.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
	}

	private function onRemovedFromStage(event:Event):void {
		contextView.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		//----------------------------------------------------------------
		// 80. shutdown
		//----------------------------------------------------------------
		shutdown();

		//----------------------------------------------------------------
		// 90. unwatch all watchable instances
		//----------------------------------------------------------------
		_eventBus.stop();
		_viewWatcher.stop();
		_backgroundServiceMap.stop();

		//----------------------------------------------------------------
		// 95. remove all instances
		//----------------------------------------------------------------
		_eventBus.dispose();
		_commandMap.dispose();
		_viewMap.dispose();
		_viewWatcher.dispose();
		_backgroundServiceMap.dispose();

		_eventBus=null;
		_commandMap=null;
		_viewMap=null;
		_viewWatcher=null;
		_backgroundServiceMap=null;

		ContextMap.getInstance().deregister(this);
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	private function saveStage():void {
		if (!stageSaved) {
			if (contextView["systemManager"]) {
				var systemManager:SystemManager=contextView["systemManager"];
				stage=systemManager.stage;
				stageSaved=true;
			} else if (contextView.stage) {
				stage=contextView.stage;
				stageSaved=true;
			}
		}
	}
}
}
