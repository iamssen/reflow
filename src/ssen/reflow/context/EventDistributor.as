package ssen.reflow.context {
import flash.events.Event;
import flash.utils.Dictionary;

import ssen.reflow.DispatchTo;
import ssen.reflow.IEventDistributor;
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

public class EventDistributor implements IEventDistributor {
	private var hostContext:Context;
	private var eventInfos:Dictionary; // dic["eventType"]=EventInfo

	//==========================================================================================
	// func
	//==========================================================================================
	//----------------------------------------------------------------
	// context life cycle
	//----------------------------------------------------------------
	public function setContext(context:Context):void {
		hostContext = context;
		eventInfos = new Dictionary;
	}

	public function dispose():void {
		hostContext = null;
		eventInfos = null;
	}

	//----------------------------------------------------------------
	// implements IEventDistributor
	//----------------------------------------------------------------
	public function map(eventType:String, dispatchTo:*):void {
		if (eventInfos[eventType] !== undefined) throw new Error(eventType + " is already exists on event distributor");

		var eventInfo:EventInfo = new EventInfo;
		eventInfo.eventType = eventType;
		eventInfo.eventListener = hostContext._eventBus.addEventListener(eventType, eventHandler);
		eventInfo.dispatchTo = dispatchTo;

		eventInfos[eventType] = eventInfo;
	}

	public function unmap(eventType:String):void {
		if (eventInfos[eventType] === undefined) throw new Error(eventType + " is not exists on event distributor");

		var eventInfo:EventInfo = eventInfos[eventType];
		eventInfo.eventListener.remove();
		delete eventInfos[eventType];
	}

	public function has(eventType:String):Boolean {
		return eventInfos[eventType] !== undefined;
	}

	//----------------------------------------------------------------
	// event handler
	//----------------------------------------------------------------
	private function eventHandler(event:Event):void {
		var eventInfo:EventInfo = eventInfos[event.type];
		if (!eventInfo) throw new Error(event.type + " is not exists on event distributor");

		if (eventInfo.dispatchTo is Function) {
			dispatchWithFunction(event, eventInfo.dispatchTo);
		} else if (eventInfo.dispatchTo is String) {
			var dispatchTo:String = eventInfo.dispatchTo;

			if (dispatchTo === DispatchTo.GLOBAL) {
				dispatchToGlobal(event);
			} else if (dispatchTo === DispatchTo.CHILDREN) {
				dispatchToChildren(event);
			} else if (dispatchTo === DispatchTo.PARENT) {
				dispatchToParent(event);
			}
		}
	}

	private function dispatchWithFunction(event:Event, test:Function):void {
		var contextList:Vector.<Context> = ContextMap.getInstance().getContextList();
		var context:Context;

		var f:int = -1;
		var fmax:int = contextList.length;
		while (++f < fmax) {
			context = contextList[f];
			if (context === hostContext) continue;
			if (test(context)) context._eventBus.dispatchEvent(event);
		}
	}

	private function dispatchToGlobal(event:Event):void {
		var contextList:Vector.<Context> = ContextMap.getInstance().getContextList();
		var context:Context;

		var f:int = -1;
		var fmax:int = contextList.length;
		while (++f < fmax) {
			context = contextList[f];
			if (context === hostContext) continue;
			context._eventBus.dispatchEvent(event);
		}
	}

	private function dispatchToParent(event:Event):void {
		var context:Context = ContextMap.getInstance().getParentContext(hostContext);
		context._eventBus.dispatchEvent(event);
	}

	private function dispatchToChildren(event:Event):void {
		var contextList:Vector.<Context> = ContextMap.getInstance().getChildrenContexts(hostContext);
		var context:Context;

		var f:int = -1;
		var fmax:int = contextList.length;
		while (++f < fmax) {
			context = contextList[f];
			context._eventBus.dispatchEvent(event);
		}
	}
}
}

import ssen.reflow.IEventListener;

class EventInfo {
	public var eventType:String;
	public var eventListener:IEventListener;
	public var dispatchTo:*;
}