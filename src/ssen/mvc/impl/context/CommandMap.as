package ssen.mvc.impl.context {
import flash.events.Event;
import flash.utils.Dictionary;

import ssen.mvc.ICommandMap;
import ssen.mvc.mvc_internal;

use namespace mvc_internal;

/** @private implements class */
internal class CommandMap implements ICommandMap {
	//==========================================================================================
	// properties
	//==========================================================================================
	private var context:Context;

	// dic["eventType"]=CommandInfo
	private var commandInfos:Dictionary=new Dictionary;

	public function CommandMap() {
		commandInfos=new Dictionary;
	}

	//==========================================================================================
	// life cycle
	//==========================================================================================
	public function setContext(hostContext:Context):void {
		context=hostContext;
	}

	public function dispose():void {
		context=null;
	}

	//==========================================================================================
	// implements ICommandMap
	//==========================================================================================
	public function mapCommand(eventType:String, commandClasses:Vector.<Class>):void {
		if (commandInfos[eventType] !== undefined) {
			throw new Error("");
		}

		var commandInfo:CommandInfo=new CommandInfo;
		commandInfo.eventType=eventType;
		commandInfo.eventListener=context._eventBus.addEventListener(eventType, eventHandler);
		commandInfo.commandClasses=commandClasses;

		commandInfos[eventType]=commandInfo;
	}

	private function eventHandler(event:Event):void {
		var commandInfo:CommandInfo=commandInfos[event.type];

		if (commandInfo) {
			new CommandChain(event, context._injector, commandInfo.commandClasses).next();
		} else {
			throw new Error("Undefined event type :: " + event.type);
		}
	}

	public function unmapCommand(eventType:String):void {
		if (commandInfos[eventType] === undefined) {
			throw new Error("Undefined event type :: " + eventType);
		}

		var commandInfo:CommandInfo=commandInfos[eventType];
		commandInfo.eventListener.remove();
		delete commandInfos[eventType];
	}

	public function hasCommand(eventType:String):Boolean {
		return commandInfos[eventType] !== undefined;
	}
}
}
import flash.utils.Dictionary;

import ssen.mvc.IEventListener;

class CommandInfo {
	public var eventType:String;
	public var eventListener:IEventListener;
	public var commandClasses:Vector.<Class>;
}

class EvtGatherer {
	private var map:Dictionary;

	public function add(unit:IEventListener):void {
		if (map === null) {
			map=new Dictionary;
		}

		if (map.has(unit.type)) {
			throw new Error("don't add same name event type");
		} else {
			map.set(unit.type, unit);
		}
	}

	public function remove(type:String):void {
		if (map.has(type)) {
			var unit:IEventListener=map.get(type) as IEventListener;
			unit.remove();
			map.remove(type);
		}
	}
}
