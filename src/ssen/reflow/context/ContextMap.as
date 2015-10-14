package ssen.reflow.context {
import flash.display.DisplayObject;
import flash.display.Stage;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.reflow.reflow_internal;

use namespace reflow_internal;

/** @private implements class */
internal class ContextMap {
	//==========================================================================================
	// singleton
	//==========================================================================================
	private static var _instance:ContextMap;

	/** get singleton instance */
	public static function getInstance():ContextMap {
		if (_instance == null) _instance = new ContextMap;
		return _instance;
	}

	//==========================================================================================
	// properties
	//==========================================================================================
	private var contextKeys:Dictionary; // dic[Context]=ContextInfo
	private var contextViewKeys:Dictionary; // dic[DisplayObject]=ContextInfo
	private var contextList:Vector.<Context>;

	//==========================================================================================
	// func
	//==========================================================================================
	public function ContextMap() {
		contextKeys = new Dictionary;
		contextViewKeys = new Dictionary;
		contextList = new <Context>[];
	}

	public function register(context:Context, parentContext:Context = null):void {
		if (contextKeys[context] !== undefined) {
			throw new Error(getQualifiedClassName(context) + " is previously registered");
		}

		// create ContextInfo
		var contextInfo:ContextInfo = new ContextInfo;

		contextInfo.context = context;

		if (parentContext) {
			contextInfo.parentContext = parentContext;
			contextInfo.parentContextDefined = true;
		}

		// bookmark to dic
		contextKeys[context] = contextInfo;
		contextViewKeys[context.contextView] = contextInfo;
		contextList.push(context);
	}

	public function deregister(context:Context):void {
		// delete bookmarks
		if (contextKeys[context] !== undefined) {
			delete contextKeys[context];
		}

		if (contextViewKeys[context.contextView] !== undefined) {
			delete contextViewKeys[context.contextView];
		}

		var index:int = contextList.lastIndexOf(context);
		if (index > -1) contextList.splice(index, 1);
	}

	//	public function isContextView(view:DisplayObjectContainer):Boolean {
	//		return contextViewKeys[view] !== undefined;
	//	}

	public function getParentContext(context:Context):Context {
		// if context isn't registered
		if (!contextKeys[context]) throw new Error("Context is not registered");

		// if context parent is defined
		var contextInfo:ContextInfo = contextKeys[context];
		if (contextInfo.parentContextDefined) return contextInfo.parentContext;

		// defined parent context by display tree (search directions to parent)
		var container:DisplayObject = contextInfo.context.contextView.parent;
		if (!container) throw new Error("Not added ContextView into Stage");

		while (!(container is Stage)) {
			if (contextViewKeys[container] !== undefined) {
				var parentContextInfo:ContextInfo = contextViewKeys[container];
				contextInfo.parentContext = parentContextInfo.context;
				break;
			}

			container = container.parent;
		}

		contextInfo.parentContextDefined = true;
		return contextInfo.parentContext;
	}

	public function getChildrenContexts(context:Context):Vector.<Context> {
		// if context is registered
		if (!contextKeys[context]) throw new Error("Context is not registered");

		var contextInfo:ContextInfo = contextKeys[context];
		if (!contextInfo.parentContextDefined) throw new Error("Context parent is not defined");

		var children:Vector.<Context> = new <Context>[];
		for each(contextInfo in contextKeys) {
			if (contextInfo.parentContext === context) children.push(contextInfo.context);
		}

		return children;
	}

	public function getContextList():Vector.<Context> {
		return contextList.slice();
	}
}
}

import ssen.reflow.context.Context;

class ContextInfo {
	public var context:Context;
	public var parentContext:Context;
	public var parentContextDefined:Boolean;
}
