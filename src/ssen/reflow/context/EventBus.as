package ssen.reflow.context {
import flash.events.Event;

import ssen.reflow.DispatchTo;
import ssen.reflow.IEventBus;
import ssen.reflow.IEventListener;

/** @private implements class */
internal class EventBus implements IEventBus {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// tree
	//----------------------------------------------------------------
	private var parent:EventBus;

	//----------------------------------------------------------------
	// emitters
	//----------------------------------------------------------------
	private static var globalDispatcher:ContextEventDispatcher;
	private var dispatcher:ContextEventDispatcher;

	//----------------------------------------------------------------
	// events
	//----------------------------------------------------------------
	private var fromParentContext:IEventListener;
	private var fromGlobalContext:IEventListener;
	private var fromChildrenContext:IEventListener;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function EventBus(parentEventBus:EventBus=null) {
		if (globalDispatcher === null) {
			globalDispatcher=new ContextEventDispatcher;
		}

		dispatcher=new ContextEventDispatcher;

		parent=parentEventBus;
	}

	//==========================================================================================
	// life cycle on context
	//==========================================================================================
	public function setContext(hostContext:Context):void {
	}

	public function start():void {
		if (parent) {
			fromParentContext=parent.dispatcher.addEventListener(ContextEvent.FROM_PARENT_CONTEXT, contextEventHandler);
		}
		fromGlobalContext=globalDispatcher.addEventListener(ContextEvent.FROM_GLOBAL_CONTEXT, contextEventHandler);
		fromChildrenContext=dispatcher.addEventListener(ContextEvent.FROM_CHILDREN_CONTEXT, contextEventHandler);
	}

	public function stop():void {
		if (fromParentContext) {
			fromParentContext.remove();
		}
		fromGlobalContext.remove();
		fromChildrenContext.remove();
	}

	public function dispose():void {
		dispatcher.dispose();

		fromGlobalContext=null;
		fromParentContext=null;
		fromChildrenContext=null;

		dispatcher=null;

		parent=null;
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function contextEventHandler(event:ContextEvent):void {
		dispatcher.dispatchEvent(event.evt);

		if (event.penetrate) {
			if (event.type === ContextEvent.FROM_CHILDREN_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.PARENT, true);
			} else if (event.type === ContextEvent.FROM_PARENT_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.CHILDREN, true);
			}
		}
	}

	//==========================================================================================
	// implements IEventBus
	//==========================================================================================
	//----------------------------------------------------------------
	// dispatcher method
	//----------------------------------------------------------------
	public function addEventListener(type:String, listener:Function):IEventListener {
		return dispatcher.addEventListener(type, listener);
	}

	public function on(type:String, listener:Function):IEventListener {
		return addEventListener(type, listener);
	}

	public function get parentEventBus():IEventBus {
		return parent;
	}

	public function createChildEventBus():IEventBus {
		return new EventBus(this);
	}

	public function dispatchEvent(evt:Event, to:String="current", penetrate:Boolean=false):void {
		if (to == DispatchTo.CHILDREN) {
			dispatcher.dispatchEvent(new ContextEvent(ContextEvent.FROM_PARENT_CONTEXT, evt, penetrate));
		} else if (to == DispatchTo.GLOBAL) {
			globalDispatcher.dispatchEvent(new ContextEvent(ContextEvent.FROM_GLOBAL_CONTEXT, evt, penetrate));
		} else if (to == DispatchTo.PARENT) {
			if (parent) {
				parent.dispatcher.dispatchEvent(new ContextEvent(ContextEvent.FROM_CHILDREN_CONTEXT, evt, penetrate));
			}
		} else if (to == DispatchTo.CURRENT) {
			dispatcher.dispatchEvent(evt);
		} else {
			throw new Error("Unknown dispatch target :: " + to);
		}
	}
}
}
import flash.events.Event;

class ContextEvent extends Event {
	public static const FROM_PARENT_CONTEXT:String="fromParentContext";
	public static const FROM_GLOBAL_CONTEXT:String="fromGlobalContext";
	public static const FROM_CHILDREN_CONTEXT:String="fromChildContext";

	public var evt:Event;
	public var penetrate:Boolean;

	public function ContextEvent(type:String, evt:Event, penetrate:Boolean) {
		super(type);
		this.evt=evt;
		this.penetrate=penetrate;
	}
}
