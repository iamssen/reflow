package ssen.reflow.context {
import flash.display.DisplayObject;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.reflow.IMediator;
import ssen.reflow.IViewMap;
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

/** @private implements class */
internal class ViewMap implements IViewMap {
	private var hostContext:Context;
	private var viewInfors:Dictionary; // map[ViewClass:Class]=ViewInfo

	//==========================================================================================
	// func
	//==========================================================================================
	//----------------------------------------------------------------
	// context life cycle
	//----------------------------------------------------------------
	public function setContext(context:Context):void {
		hostContext = context;
		viewInfors = new Dictionary;
	}

	public function dispose():void {
		hostContext = null;
		viewInfors = null;
	}

	//----------------------------------------------------------------
	// implements IViewMap
	//----------------------------------------------------------------
	public function map(ViewType:Class, MediatorType:Class = null, global:Boolean = false):void {
		if (viewInfors[ViewType] !== undefined) throw new Error(getQualifiedClassName(ViewType) + " is mapped!!!");

		var info:ViewInfo = new ViewInfo;
		info.type = ViewType;
		info.mediatorType = MediatorType;
		info.global = global;

		viewInfors[ViewType] = info;
	}

	public function unmap(ViewType:Class):void {
		if (viewInfors[ViewType] !== undefined) {
			delete viewInfors[ViewType];
		}
	}

	public function has(view:*):Boolean {
		if (view is Class) {
			return viewInfors[view] !== undefined;
		}

		return viewInfors[view["constructor"]] !== undefined;
	}

	//----------------------------------------------------------------
	// internal
	//----------------------------------------------------------------
	public function injectInto(view:Object):void {
		if (view is DisplayObject) {
			if (viewInfors[view["constructor"]] === undefined) {
				throw new Error(getQualifiedClassName(view) + " isn't View");
			} else {
				var viewInfo:ViewInfo = viewInfors[view["constructor"]];

				if (viewInfo.mediatorType) {
					var mediator:IMediator = new viewInfo.mediatorType;
					var mediatorController:MediatorController = new MediatorController;

					hostContext._injector.injectInto(mediator);

					mediatorController.view = view as DisplayObject;
					mediatorController.mediator = mediator;
					mediatorController.start();
				} else {
					hostContext._injector.injectInto(view);
				}
			}
		} else {
			throw new Error(getQualifiedClassName(view) + " isn't DisplayObject");
		}
	}

	public function isGlobal(view:*):Boolean {
		var info:ViewInfo = (view is Class) ? viewInfors[view] : viewInfors[view["constructor"]];
		return info.global;
	}
}
}

import flash.display.DisplayObject;
import flash.events.Event;

import ssen.reflow.IMediator;

class ViewInfo {
	public var type:Class;
	public var mediatorType:Class;
	public var global:Boolean;
}

class MediatorController {
	public var view:DisplayObject;
	public var mediator:IMediator;

	public function start():void {
		mediator.setView(view);

		if (view.stage) {
			mediator.startup();
			view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		} else {
			view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
	}

	private function addedToStage(event:Event):void {
		view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

		mediator.startup();

		view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	private function removedFromStage(event:Event):void {
		view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);

		mediator.shutdown();

		mediator = null;
		view = null;
	}
}
