package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.events.Event;

import mx.core.IMXMLObject;
import mx.managers.SystemManager;

import ssen.mvc.ICommandMap;
import ssen.mvc.IEventBus;
import ssen.mvc.IInjector;
import ssen.mvc.IViewMap;
import ssen.mvc.mvc_internal;
import ssen.mvc.impl.di.Injector;

use namespace mvc_internal;

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
	mvc_internal var contextView:DisplayObject;

	/** @private */
	mvc_internal var stage:Stage;

	//---------------------------------------------
	// parts
	//---------------------------------------------
	/** @private */
	mvc_internal var _eventBus:EventBus;

	/** @private */
	mvc_internal var _commandMap:CommandMap;

	/** @private */
	mvc_internal var _viewMap:ViewMap;

	/** @private */
	mvc_internal var _injector:Injector;

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

	//==========================================================================================
	// abstract functions
	//==========================================================================================
	/** [Abstract] Configuration dependency for your module context */
	protected function mapDependency():void {
	}

	/** [Abstract] Context startup hook (run at Event.ADDED_TO_STAGE) */
	protected function startup():void {
	}

	/** [Abstract] Context shutdown hook (run at EVENT.REMOVED_FROM_STAGE) */
	protected function shutdown():void {
	}

	/**
	 * @private Set parent context forcibly into this context.
	 *
	 * if you want ignore automation make context tree by display object tree
	 */
	mvc_internal function getParentContext():Context {
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

		// set dependent to instances
		_eventBus.setContext(this);
		_commandMap.setContext(this);
		_viewMap.setContext(this);
		_viewWatcher.setContext(this);

		//----------------------------------------------------------------
		// 10. map dependencies
		//----------------------------------------------------------------
		// views
		_injector.mapValue(contextView["constructor"], contextView);
		_injector.mapValue(Stage, stage);

		_injector.mapValue(IEventBus, _eventBus);
		_injector.mapValue(ICommandMap, _commandMap);
		_injector.mapValue(IViewMap, _viewMap);
		_injector.mapValue(IInjector, _injector);

		mapDependency();

		//----------------------------------------------------------------
		// 20. start watch
		//----------------------------------------------------------------
		_eventBus.start();
		_viewWatcher.start();

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

		//----------------------------------------------------------------
		// 95. remove all instances
		//----------------------------------------------------------------
		_eventBus.dispose();
		_commandMap.dispose();
		_viewMap.dispose();
		_viewWatcher.dispose();

		_eventBus=null;
		_commandMap=null;
		_viewMap=null;
		_viewWatcher=null;

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
