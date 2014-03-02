package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.mvc.IViewInjector;

internal class ViewInjector implements IViewInjector {
	// TODO 필수 injection
	internal var context:Context;

	private var map:Dictionary;

	//==========================================================================================
	// implements
	//==========================================================================================
	public function mapView(viewClass:Class, mediatorClass:Class=null, global:Boolean=false):void {
		if (map[viewClass] !== undefined) {
			throw new Error(getQualifiedClassName(viewClass) + " is mapped!!!");
		}

		var info:ViewInfo=new ViewInfo;
		info.type=viewClass;
		info.mediatorType=mediatorClass;
		info.global=global;

		map[viewClass]=info;
	}

	public function unmapView(viewClass:Class):void {
		if (map[viewClass] !== undefined) {
			delete map[viewClass];
		}
	}

	public function hasMapping(view:*):Boolean {
		if (view is Class) {
			return map[view] !== undefined;
		}

		return map[view["constructor"]] !== undefined;
	}





	//==========================================================================================
	// delete
	//==========================================================================================
	internal function injectInto(view:Object):void {
		if (view is DisplayObject) {
			if (map[view["constructor"]] === undefined) {
				throw new Error("class is not inject target");
			} else {
				var info:ViewInfo=map[view["constructor"]];

				if (info.mediatorType is Class) {
					new MediatorController(injector, view as DisplayObject, info.mediatorType);
				} else {
					context.injector.injectInto(view);
						//					injector.injectInto(view);
				}
			}
		} else {
			throw new Error("view is just DisplayObject");
		}
	}

	internal function dispose():void {
		map=null;
		injector=null;
	}


	internal function isGlobal(view:*):Boolean {
		var info:ViewInfo=(view is Class) ? map[view] : map[view["constructor"]];
		return info.global;
	}
}
}

class ViewInfo {
	public var type:Class;
	public var mediatorType:Class;
	public var global:Boolean;
}
