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
	mvc_internal var contextView:DisplayObject;
	mvc_internal var stage:Stage;
	//---------------------------------------------
	// parts
	//---------------------------------------------
	mvc_internal var eventBus:EventBus;
	mvc_internal var commandMap:CommandMap;
	mvc_internal var viewMap:ViewMap;
	mvc_internal var injector:Injector;
	private var viewWatcher:ViewWatcher;

	//==========================================================================================
	// abstract functions
	//==========================================================================================
	protected function mapDependency():void {
	}

	protected function startup():void {
	}

	protected function shutdown():void {
	}

	//==========================================================================================
	// context life cycle
	//==========================================================================================
	public function initialized(document:Object, id:String):void {
		contextView=document as DisplayObject;
		contextView.addEventListener(Event.ADDED, onAdded);

		ContextMap.getInstance().register(this);
	}

	private function onAdded(event:Event):void {
		saveStage();

		if (!stage) {
			return;
		}

		contextView.removeEventListener(Event.ADDED, onAdded);

		//----------------------------------------------------------------
		// 05. create instances
		//----------------------------------------------------------------
		var parentContext:Context=ContextMap.getInstance().getParentContext(this);
		var hasParent:Boolean=parentContext !== null;

		eventBus=hasParent ? parentContext.eventBus.createChildEventBus() as EventBus : new EventBus;
		injector=hasParent ? parentContext.injector.createChild() as Injector : new Injector;
		commandMap=new CommandMap;
		viewMap=new ViewMap;
		viewWatcher=new ViewWatcher;

		// set dependent to instances
		viewWatcher.setContext(this);

		//----------------------------------------------------------------
		// 10. map dependencies
		//----------------------------------------------------------------
		// views
		injector.mapValue(contextView["constructor"], contextView);
		injector.mapValue(Stage, stage);

		injector.mapValue(IEventBus, eventBus);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IViewMap, viewMap);
		injector.mapValue(IInjector, injector);

		mapDependency();

		//----------------------------------------------------------------
		// 20. start watch
		//----------------------------------------------------------------
		viewWatcher.start();

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
		viewWatcher.stop();

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
