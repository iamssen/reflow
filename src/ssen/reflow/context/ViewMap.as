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
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// dependent
	//----------------------------------------------------------------
	private var context:Context;

	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	// map[ViewClass:Class]=ViewInfo
	private var viewInfors:Dictionary;

	//==========================================================================================
	// life cycle on context
	//==========================================================================================
	public function setContext(hostContext:Context):void {
		context=hostContext;
		viewInfors=new Dictionary;
	}

	public function dispose():void {
		context=null;
		viewInfors=null;
	}

	//==========================================================================================
	// implements IViewMap
	//==========================================================================================
	public function map(viewClass:Class, mediatorClass:Class=null, global:Boolean=false):void {
		if (viewInfors[viewClass] !== undefined) {
			throw new Error(getQualifiedClassName(viewClass) + " is mapped!!!");
		}

		var info:ViewInfo=new ViewInfo;
		info.type=viewClass;
		info.mediatorType=mediatorClass;
		info.global=global;

		viewInfors[viewClass]=info;
	}

	public function unmap(viewClass:Class):void {
		if (viewInfors[viewClass] !== undefined) {
			delete viewInfors[viewClass];
		}
	}

	public function has(view:*):Boolean {
		if (view is Class) {
			return viewInfors[view] !== undefined;
		}

		return viewInfors[view["constructor"]] !== undefined;
	}

	//==========================================================================================
	// local api
	//==========================================================================================
	public function injectInto(view:Object):void {
		if (view is DisplayObject) {
			if (viewInfors[view["constructor"]] === undefined) {
				throw new Error(getQualifiedClassName(view) + " isn't View");
			} else {
				var viewInfo:ViewInfo=viewInfors[view["constructor"]];

				if (viewInfo.mediatorType) {
					var mediator:IMediator=new viewInfo.mediatorType;
					var mediatorController:MediatorController=new MediatorController;

					context._injector.injectInto(mediator);

					mediatorController.view=view as DisplayObject;
					mediatorController.mediator=mediator;
					mediatorController.start();
				} else {
					context._injector.injectInto(view);
				}
			}
		} else {
			throw new Error(getQualifiedClassName(view) + " isn't DisplayObject");
		}
	}

	public function isGlobal(view:*):Boolean {
		var info:ViewInfo=(view is Class) ? viewInfors[view] : viewInfors[view["constructor"]];
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

		mediator=null;
		view=null;
	}
}
