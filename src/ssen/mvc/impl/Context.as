package ssen.mvc.impl {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.IEventDispatcher;

import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;

public class Context extends ContextBase {
	private var _viewCatcher:IViewCatcher;
	private var _viewInjector:IViewInjector;

	public function Context(contextView:IContextView, parentContext:IContext=null) {
		super(contextView, parentContext);
	}

	// =========================================================
	// initialize
	// =========================================================
	/** @private */
	final override protected function initialize():void {
		super.initialize();

		var contextView:DisplayObjectContainer=this.contextView as DisplayObjectContainer;

		// stage 가 있으면 바로 start, 아니면 added to stage 까지 지연시킴
		if (contextView.stage) {
			startupContextView();
		} else {
			contextView.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
	}

	// ==========================================================================================
	// dispose resources
	// ==========================================================================================
	override protected function dispose():void {
		super.dispose();

		_viewCatcher=null;
		_viewInjector=null;
	}

	// =========================================================
	// initialize context
	// =========================================================
	private function startupContextView():void {
		if (viewInjector.hasMapping(contextView)) {
			viewInjector.injectInto(contextView);
		}

		startup();

		IEventDispatcher(contextView).addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
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

	// =========================================================
	// implementation getters
	// =========================================================
	/** @private */
	final override protected function get viewCatcher():IViewCatcher {
		return _viewCatcher||=new ImplViewCatcher(viewInjector, contextViewInjector, contextView);
	}

	/** @see ssen.mvc.core.IViewInjector */
	final override protected function get viewInjector():IViewInjector {
		return _viewInjector||=new ImplViewInjector(injector);
	}
}
}
