package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;

import ssen.mvc.IContextView;

internal class ViewCatcher {
	public var contextView:DisplayObjectContainer;
	public var context:Context;

	private var stage:Stage;
	private var watched:Boolean;

	public function start():void {
		if (watched) {
			return;
		}

		contextView.addEventListener(Event.ADDED, addedChildInContext, true);
		contextView.stage.addEventListener(Event.ADDED_TO_STAGE, addChildInGlobal, true);

		watched=true;
	}

	private function addChildInGlobal(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;
		var viewInjector:ViewInjector=context.viewInjector;

		if (viewInjector.hasMapping(view) && viewInjector.isGlobal(view)) {
			viewInjector.injectInto(view);
		}
	}

	private function addedChildInContext(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;
		var isChild:Boolean=isMyChild(view);

		if (view is IContextView && isChild) {
			// context view
			var contextView:IContextView=view as IContextView;
			if (!contextView.contextInitialized) {
				if (!contextView.contextInitialized) {
					contextView.initialContext(context);
				}
			}
		} else if (viewInjector.hasMapping(view) && !viewInjector.isGlobal(view) && isChild) {
			var viewInjector:ViewInjector=context.viewInjector;
			// view
			viewInjector.injectInto(view);
		}
	}

	private function isMyChild(view:DisplayObject):Boolean {
		var parent:DisplayObjectContainer=view.parent;

		while (true) {
			if (parent is IContextView) {
				if (parent == this.contextView) {
					return true;
				} else {
					return false;
				}
			}

			parent=parent.parent;

			if (parent === null) {
				break;
			}
		}

		return false;
	}

	public function stop():void {
//		view.removeEventListener(Event.ADDED, added, true);
//		stage.removeEventListener(Event.ADDED_TO_STAGE, globalAdded, true);
//
//		_run=false;
//		view=null;
//		stage=null;
	}

//	public function isRun():Boolean {
//		return _run;
//	}
}
}
