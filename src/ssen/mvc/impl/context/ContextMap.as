package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.utils.Dictionary;

import ssen.mvc.mvc_internal;

use namespace mvc_internal;

internal class ContextMap {
	//==========================================================================================
	// singleton
	//==========================================================================================
	private static var _instance:ContextMap;

	/** get singleton instance */
	public static function getInstance():ContextMap {
		if (_instance == null) {
			_instance=new ContextMap();
		}
		return _instance;
	}

	//==========================================================================================
	// 
	//==========================================================================================
	private var contextKeys:Dictionary=new Dictionary;
	private var contextViewKeys:Dictionary=new Dictionary;

	public function register(context:Context):void {
		if (contextKeys[context] !== undefined) {
			throw new Error("!!!!");
		}

		var contextInfo:ContextInfo=new ContextInfo;
		var contextView:DisplayObject=context.contextView;

		contextInfo.context=context;

		contextKeys[context]=contextInfo;
		contextViewKeys[contextView]=contextInfo;
	}

	public function deregister(context:Context):void {
		if (contextKeys[context] !== undefined) {
			delete contextKeys[context];
		}

		if (contextViewKeys[context.contextView] !== undefined) {
			delete contextViewKeys[context.contextView];
		}
	}

	//	public function isContextView(view:DisplayObjectContainer):Boolean {
	//		return contextViewKeys[view] !== undefined;
	//	}

	public function getParentContext(context:Context):Context {
		if (contextKeys[context] !== undefined) {
			var contextInfo:ContextInfo=contextKeys[context];

			if (!contextInfo.parentContextDefined) {
				var container:DisplayObject=contextInfo.context.contextView;

				while (!(container is Stage)) {
					if (contextViewKeys[container] !== undefined) {
						contextInfo.parentContext=contextViewKeys[container];
						break;
					}
				}

				contextInfo.parentContextDefined=true;
			}

			return contextInfo.parentContext;
		}

		return null;
	}
}
}
import ssen.mvc.impl.context.Context;

class ContextInfo {
	public var context:Context;
	public var parentContext:Context;
	public var parentContextDefined:Boolean;
}
