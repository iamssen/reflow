package ssen.mvc.impl.context {
import flash.events.Event;

import ssen.mvc.EmitTo;
import ssen.mvc.IEventBus;
import ssen.mvc.IEventUnit;

internal class EventBus implements IEventBus {
	private static var globalEmitter:EventEmitter;
	private var eventEmitter:EventEmitter;

	private var parent:EventBus;

	private var fromParentContext:IEventUnit;
	private var fromGlobalContext:IEventUnit;
	private var fromChildrenContext:IEventUnit;

	public function EventBus(parentEventBus:EventBus=null) {
		if (globalEmitter === null) {
			globalEmitter=new EventEmitter;
		}

		eventEmitter=new EventEmitter;
		parent=parentEventBus;

		if (parent) {
			fromParentContext=parent.eventEmitter.addEventListener(ContextEvent.FROM_PARENT_CONTEXT, catchOutsideEvent);
		}
		fromGlobalContext=globalEmitter.addEventListener(ContextEvent.FROM_GLOBAL_CONTEXT, catchOutsideEvent);
		fromChildrenContext=eventEmitter.addEventListener(ContextEvent.FROM_CHILDREN_CONTEXT, catchOutsideEvent);
	}

	private function catchOutsideEvent(event:ContextEvent):void {
		eventEmitter.emitEvent(event.evt);

		if (event.penetrate) {
			if (event.type === ContextEvent.FROM_CHILDREN_CONTEXT) {
				emitEvent(event.evt, EmitTo.PARENT, true);
			} else if (event.type === ContextEvent.FROM_PARENT_CONTEXT) {
				emitEvent(event.evt, EmitTo.CHILDREN, true);
			}
		}
	}

	//----------------------------------------------------------------
	// dispatcher method
	//----------------------------------------------------------------
	public function addEventListener(type:String, listener:Function):IEventUnit {
		return eventEmitter.addEventListener(type, listener);
	}

	public function on(type:String, listener:Function):IEventUnit {
		return addEventListener(type, listener);
	}



	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	public function get parentEventBus():IEventBus {
		return parent;
	}

	public function createChildEventBus():IEventBus {
		return new EventBus(this);
	}

	public function emitEvent(evt:Event, to:String="self", penetrate:Boolean=false):void {
		if (to == EmitTo.CHILDREN) {
			eventEmitter.emitEvent(new ContextEvent(ContextEvent.FROM_PARENT_CONTEXT, evt, penetrate));
		} else if (to == EmitTo.GLOBAL) {
			globalEmitter.emitEvent(new ContextEvent(ContextEvent.FROM_GLOBAL_CONTEXT, evt, penetrate));
		} else if (to == EmitTo.PARENT) {
			if (parent) {
				parent.eventEmitter.emitEvent(new ContextEvent(ContextEvent.FROM_CHILDREN_CONTEXT, evt, penetrate));
			}
		} else if (to == EmitTo.SELF) {
			eventEmitter.emitEvent(evt);
		} else {
			throw new Error("unknown dispatch target :: " + to);
		}
	}

	public function stop():void {
		if (fromParentContext) {
			fromParentContext.stop();
		}
		fromGlobalContext.stop();
		fromChildrenContext.stop();
		eventEmitter.dispose();

		fromGlobalContext=null;
		fromParentContext=null;
		fromChildrenContext=null;
		eventEmitter=null;
		parent=null;
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
