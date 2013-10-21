package ssen.mvc {
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.IEventDispatcher;


/**
 * @see https://github.com/iamssen/SSenMvcFramework
 * @see https://github.com/iamssen/SSenMvcFramework.Basic
 * @see https://github.com/iamssen/SSenMvcFramework.Flash
 * @see https://github.com/iamssen/SSenMvcFramework.Modular
 */
public class Context extends ContextBase {
	private var _viewCatcher:IViewCatcher;
	private var _viewInjector:IViewInjector;
	private var _callLater:CallLater;

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
		_callLater=null;
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
	/** @see ssen.mvc.ICallLater */
	override protected function get callLater():ICallLater {
		if (!_callLater) {
			_callLater=new CallLater;
			_callLater.setContextView(contextView);
		}
		return _callLater;
	}

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

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Stage;
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.common.IDisposable;
import ssen.mvc.ICallLater;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IInjector;
import ssen.mvc.IMediator;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;

class CallLater implements ICallLater {

	private var contextView:DisplayObjectContainer;
	private var pool:Vector.<Item>;
	private var on:Boolean;

	public function CallLater() {
		pool=new Vector.<Item>;
	}

	public function setContextView(value:IContextView):void {
		contextView=value as DisplayObjectContainer;
	}

	public function add(func:Function, params:Array=null):void {
		var item:Item=new Item;
		item.func=func;
		item.params=params;

		pool.push(item);

		if (!on) {
			contextView.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			on=true;
		}
	}

	public function dispose():void {
		contextView.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		contextView=null;
		pool=null;
	}

	public function has(func:Function):Boolean {
		var f:int=pool.length;
		var item:Item;
		while (--f >= 0) {
			item=pool[f];
			if (item.func === func) {
				return true;
			}
		}

		return false;
	}

	private function enterFrameHandler(event:Event):void {
		contextView.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		executeAll();
	}

	private function executeAll():void {
		on=false;

		if (pool.length <= 0) {
			return;
		}

		var item:Item;

		var f:int=-1;
		var fmax:int=pool.length;

		while (++f < fmax) {
			item=pool[f];
			item.func.apply(null, item.params);
		}

		pool.length=0;
	}
}

class Item {
	public var func:Function;
	public var params:Array;
}

//==========================================================================================
// view catcher
//==========================================================================================
class ImplViewCatcher implements IViewCatcher {
	private var _run:Boolean;
	private var view:DisplayObjectContainer;
	private var stage:Stage;
	private var viewInjector:IViewInjector;
	private var contextViewInjector:IContextViewInjector;
	private var contextView:IContextView;

	public function ImplViewCatcher(viewInjector:IViewInjector, contextViewInjector:IContextViewInjector, contextView:IContextView) {
		this.viewInjector=viewInjector;
		this.contextViewInjector=contextViewInjector;
		this.contextView=contextView;
	}

	public function dispose():void {
		if (_run) {
			stop();
		}

		viewInjector=null;
		contextViewInjector=null;
	}

	public function start(view:IContextView):void {
		this.view=view as DisplayObjectContainer;
		this.stage=view.getStage() as Stage;
		this.view.addEventListener(Event.ADDED, added, true);
		this.stage.addEventListener(Event.ADDED_TO_STAGE, globalAdded, true);

		_run=true;
	}

	private function globalAdded(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;

		if (viewInjector.hasMapping(view) && viewInjector.isGlobal(view)) {
			viewInjector.injectInto(view);
		}
	}

	private function added(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;
		var isChild:Boolean=isMyChild(view);

		if (view is IContextView && isChild) {
			var contextView:IContextView=view as IContextView;

			if (!contextView.contextInitialized) {
				contextViewInjector.injectInto(contextView);
			}
		} else if (viewInjector.hasMapping(view) && !viewInjector.isGlobal(view) && isChild) {
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
		view.removeEventListener(Event.ADDED, added, true);
		stage.removeEventListener(Event.ADDED_TO_STAGE, globalAdded, true);

		_run=false;
		view=null;
		stage=null;
	}

	public function isRun():Boolean {
		return _run;
	}
}

//==========================================================================================
// view injector
//==========================================================================================
class ImplViewInjector implements IViewInjector {
	private var map:Dictionary;
	private var injector:IInjector;

	public function ImplViewInjector(injector:IInjector) {
		this.injector=injector;
		map=new Dictionary;
	}

	public function dispose():void {
		map=null;
		injector=null;
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

	public function injectInto(view:Object):void {
		if (view is DisplayObject) {
			if (map[view["constructor"]] === undefined) {
				throw new Error("class is not inject target");
			} else {
				var info:ViewInfo=map[view["constructor"]];

				if (info.mediatorType is Class) {
					new MediatorController(injector, view as DisplayObject, info.mediatorType);
				} else {
					injector.injectInto(view);
				}
			}
		} else {
			throw new Error("view is just DisplayObject");
		}
	}

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

	public function isGlobal(view:*):Boolean {
		var info:ViewInfo=(view is Class) ? map[view] : map[view["constructor"]];
		return info.global;
	}
}

class ViewInfo {
	public var type:Class;
	public var mediatorType:Class;
	public var global:Boolean;
}

class MediatorController implements IDisposable {
	private var view:DisplayObject;
	private var mediator:IMediator;

	public function MediatorController(injector:IInjector, view:DisplayObject, mediatorType:Class) {
		this.view=view;

		if (mediatorType) {
			mediator=injector.injectInto(new mediatorType) as IMediator;
			mediator.setView(view);

			if (view.stage) {
				mediator.onRegister();
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			} else {
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
	}

	private function addedToStage(event:Event):void {
		view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		mediator.onRegister();
		view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	private function removedFromStage(event:Event):void {
		dispose();
	}

	public function dispose():void {
		view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		mediator.onRemove();
		mediator=null;
		view=null;
	}
}
