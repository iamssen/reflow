package ssen.mvc.impl {
import flash.events.Event;

import ssen.mvc.DispatchTo;
import ssen.mvc.IEventBus;
import ssen.mvc.IEventUnit;
import ssen.mvc.IEvtDispatcher;

public class EventBus implements IEventBus {
	private static var _globalDispatcher:IEvtDispatcher;
	private var _parent:IEventBus;
	private var _evtDispatcher:IEvtDispatcher;
	private var fromParentContext:IEventUnit;
	private var fromGlobalContext:IEventUnit;
	private var fromChildrenContext:IEventUnit;

	public function EventBus(parent:IEventBus=null) {
		if (_globalDispatcher === null) {
			_globalDispatcher=new EvtDispatcher;
		}

		_evtDispatcher=new EvtDispatcher;
		_parent=parent;

		if (_parent) {
			fromParentContext=_parent.evtDispatcher.addEvtListener(ContextEvent.FROM_PARENT_CONTEXT, catchOutsideEvent);
		}
		fromGlobalContext=_globalDispatcher.addEvtListener(ContextEvent.FROM_GLOBAL_CONTEXT, catchOutsideEvent);
		fromChildrenContext=_evtDispatcher.addEvtListener(ContextEvent.FROM_CHILDREN_CONTEXT, catchOutsideEvent);
	}

	//----------------------------------------------------------------
	// dispatcher method
	//----------------------------------------------------------------
	public function addEventListener(type:String, listener:Function):IEventUnit {
		return _evtDispatcher.addEvtListener(type, listener);
	}

	private function catchOutsideEvent(event:ContextEvent):void {
		_evtDispatcher.dispatchEvt(event.evt);

		if (event.penetrate) {
			if (event.type === ContextEvent.FROM_CHILDREN_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.PARENT, true);
			} else if (event.type === ContextEvent.FROM_PARENT_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.CHILDREN, true);
			}
		}
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	public function get evtDispatcher():IEvtDispatcher {
		return _evtDispatcher;
	}

	public function get parentEventBus():IEventBus {
		return _parent;
	}

	public function createChildEventBus():IEventBus {
		return new EventBus(this);
	}

	public function dispatchEvent(evt:Event, to:String="self", penetrate:Boolean=false):void {
		if (to == DispatchTo.CHILDREN) {
			_evtDispatcher.dispatchEvt(new ContextEvent(ContextEvent.FROM_PARENT_CONTEXT, evt, penetrate));
		} else if (to == DispatchTo.GLOBAL) {
			_globalDispatcher.dispatchEvt(new ContextEvent(ContextEvent.FROM_GLOBAL_CONTEXT, evt, penetrate));
		} else if (to == DispatchTo.PARENT) {
			if (_parent) {
				_parent.evtDispatcher.dispatchEvt(new ContextEvent(ContextEvent.FROM_CHILDREN_CONTEXT, evt, penetrate));
			}
		} else if (to == DispatchTo.SELF) {
			_evtDispatcher.dispatchEvt(evt);
		} else {
			throw new Error("unknown dispatch target :: " + to);
		}
	}

	public function dispose():void {
		fromGlobalContext.dispose();
		fromParentContext.dispose();
		fromChildrenContext.dispose();
		_evtDispatcher.dispose();

		fromGlobalContext=null;
		fromParentContext=null;
		fromChildrenContext=null;
		_evtDispatcher=null;
		_parent=null;
	}
}
}
