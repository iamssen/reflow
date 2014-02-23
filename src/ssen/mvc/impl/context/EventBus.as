package ssen.mvc.impl.context {
import flash.events.Event;

import ssen.mvc.EmitTo;
import ssen.mvc.IEventBus;
import ssen.mvc.IEventEmitter;
import ssen.mvc.IEventUnit;

internal class EventBus implements IEventBus {
	private static var _globalEmitter:IEventEmitter;
	private var _eventEmitter:IEventEmitter;

	private var _parent:IEventBus;

	private var fromParentContext:IEventUnit;
	private var fromGlobalContext:IEventUnit;
	private var fromChildrenContext:IEventUnit;

	public function EventBus(parent:IEventBus=null) {
		if (_globalEmitter === null) {
			_globalEmitter=new EventEmitter;
		}

		_eventEmitter=new EventEmitter;
		_parent=parent;

		if (_parent) {
			fromParentContext=_parent.eventEmitter.addEventListener(ContextEvent.FROM_PARENT_CONTEXT, catchOutsideEvent);
		}
		fromGlobalContext=_globalEmitter.addEventListener(ContextEvent.FROM_GLOBAL_CONTEXT, catchOutsideEvent);
		fromChildrenContext=_eventEmitter.addEventListener(ContextEvent.FROM_CHILDREN_CONTEXT, catchOutsideEvent);
	}

	//----------------------------------------------------------------
	// dispatcher method
	//----------------------------------------------------------------
	public function addEventListener(type:String, listener:Function):IEventUnit {
		return _eventEmitter.addEventListener(type, listener);
	}

	public function on(type:String, listener:Function):IEventUnit {
		return addEventListener(type, listener);
	}

	private function catchOutsideEvent(event:ContextEvent):void {
		_eventEmitter.emitEvent(event.evt);

		if (event.penetrate) {
			if (event.type === ContextEvent.FROM_CHILDREN_CONTEXT) {
				emitEvent(event.evt, EmitTo.PARENT, true);
			} else if (event.type === ContextEvent.FROM_PARENT_CONTEXT) {
				emitEvent(event.evt, EmitTo.CHILDREN, true);
			}
		}
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	public function get eventEmitter():IEventEmitter {
		return _eventEmitter;
	}

	public function get parentEventBus():IEventBus {
		return _parent;
	}

	public function createChildEventBus():IEventBus {
		return new EventBus(this);
	}

	public function emitEvent(evt:Event, to:String="self", penetrate:Boolean=false):void {
		if (to == EmitTo.CHILDREN) {
			_eventEmitter.emitEvent(new ContextEvent(ContextEvent.FROM_PARENT_CONTEXT, evt, penetrate));
		} else if (to == EmitTo.GLOBAL) {
			_globalEmitter.emitEvent(new ContextEvent(ContextEvent.FROM_GLOBAL_CONTEXT, evt, penetrate));
		} else if (to == EmitTo.PARENT) {
			if (_parent) {
				_parent.eventEmitter.emitEvent(new ContextEvent(ContextEvent.FROM_CHILDREN_CONTEXT, evt, penetrate));
			}
		} else if (to == EmitTo.SELF) {
			_eventEmitter.emitEvent(evt);
		} else {
			throw new Error("unknown dispatch target :: " + to);
		}
	}

	public function dispose():void {
		fromGlobalContext.dispose();
		fromParentContext.dispose();
		fromChildrenContext.dispose();
		_eventEmitter.dispose();

		fromGlobalContext=null;
		fromParentContext=null;
		fromChildrenContext=null;
		_eventEmitter=null;
		_parent=null;
	}
}
}
