package ssen.mvc.context {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;

import ssen.mvc.mvc_internal;

use namespace mvc_internal;

/** @private implements class */
internal class ViewWatcher {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// dependent
	//----------------------------------------------------------------
	private var context:Context;
	private var contextView:DisplayObjectContainer;

	//----------------------------------------------------------------
	// flags
	//----------------------------------------------------------------
	private var started:Boolean;

	//==========================================================================================
	// life cycle on context
	//==========================================================================================
	public function setContext(hostContext:Context):void {
		context=hostContext;
		contextView=hostContext.contextView as DisplayObjectContainer;
	}

	public function start():void {
		if (started || !contextView) {
			return;
		}

		contextView.addEventListener(Event.ADDED, added, true);
		context.stage.addEventListener(Event.ADDED_TO_STAGE, addedOnGlobal, true);

		started=true;
	}

	public function stop():void {
		if (!started || !contextView) {
			return;
		}

		contextView.removeEventListener(Event.ADDED, added, true);
		context.stage.removeEventListener(Event.ADDED_TO_STAGE, addedOnGlobal, true);

		started=false;
	}

	public function dispose():void {
		context=null;
		contextView=null;
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function addedOnGlobal(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;

		if (context._viewMap.hasView(view) && context._viewMap.isGlobal(view)) {
			context._viewMap.injectInto(view);
		}
	}

	private function added(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;

		if (context._viewMap.hasView(view) && !context._viewMap.isGlobal(view)) {
			//			if (isContextChild(view)) {
			context._viewMap.injectInto(view);
		}
	}

	//	에러가 생기면 연다
	//	private function isContextChild(view:DisplayObject):Boolean {
	//		var parent:DisplayObjectContainer=view.parent;
	//		var contextMap:ContextMap=ContextMap.getInstance();
	//
	//		while (true) {
	//			if (contextMap.isContextView(parent)) {
	//				if (parent == contextView) {
	//					return true;
	//				} else {
	//					return false;
	//				}
	//			}
	//
	//			parent=parent.parent;
	//
	//			if (parent === null) {
	//				break;
	//			}
	//		}
	//
	//		return false;
	//	}
}
}
