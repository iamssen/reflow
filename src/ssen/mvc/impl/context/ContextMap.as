package ssen.mvc.impl.context {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.mvc.mvc_internal;

use namespace mvc_internal;

/** @private implements class */
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
	// properties
	//==========================================================================================
	// dic[Context]=ContextInfo
	private var contextKeys:Dictionary=new Dictionary;

	// dic[DisplayObject]=ContextInfo
	private var contextViewKeys:Dictionary=new Dictionary;

	//==========================================================================================
	// apis
	//==========================================================================================
	public function register(context:Context, parentContext:Context=null):void {
		if (contextKeys[context] !== undefined) {
			throw new Error(getQualifiedClassName(context) + " is previously registered");
		}

		// make ContextInfo
		var contextInfo:ContextInfo=new ContextInfo;

		contextInfo.context=context;

		if (parentContext) {
			contextInfo.parentContext=parentContext;
			contextInfo.parentContextDefined=true;
		}

		// bookmark to dic
		contextKeys[context]=contextInfo;
		contextViewKeys[context.contextView]=contextInfo;
	}

	public function deregister(context:Context):void {
		// delete bookmarks
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
		// if registered context
		if (contextKeys[context] !== undefined) {
			var contextInfo:ContextInfo=contextKeys[context];
			var parentContextInfo:ContextInfo;

			// if not defined parent context
			if (!contextInfo.parentContextDefined) {

				// defined parent context by display tree (search directions to parent)
				var container:DisplayObject=contextInfo.context.contextView.parent;

				if (!container) {
					throw new Error("Not added ContextView into Stage");
				}

				while (!(container is Stage)) {
					if (contextViewKeys[container] !== undefined) {
						parentContextInfo=contextViewKeys[container];
						contextInfo.parentContext=parentContextInfo.context;
						break;
					}

					container=container.parent;
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
