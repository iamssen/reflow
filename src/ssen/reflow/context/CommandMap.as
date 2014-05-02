package ssen.reflow.context {
import flash.events.Event;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.reflow.ICommandMap;
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

/** @private implements class */
internal class CommandMap implements ICommandMap {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// dependent
	//----------------------------------------------------------------
	private var context:Context;

	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	// dic["eventType"]=CommandInfo
	private var commandInfos:Dictionary;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function CommandMap() {
		commandInfos=new Dictionary;
	}

	//==========================================================================================
	// life cycle on context
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
	public function map(eventType:String, commandClasses:Vector.<Class>):void {
		if (commandInfos[eventType] !== undefined) {
			commandInfo=commandInfos[eventType];
			commandClasses=commandInfo.commandClasses;

			var commandNames:Vector.<String>=new Vector.<String>;

			var f:int=-1;
			var fmax:int=commandClasses.length;
			while (++f < fmax) {
				commandNames.push(getQualifiedClassName(commandClasses[f]));
			}

			throw new Error(eventType + " is previously maped commands :: " + commandNames.join(", "));
		}

		var commandInfo:CommandInfo=new CommandInfo;
		commandInfo.eventType=eventType;
		commandInfo.eventListener=context._eventBus.addEventListener(eventType, eventHandler);
		commandInfo.commandClasses=commandClasses;

		commandInfos[eventType]=commandInfo;
	}

	public function unmap(eventType:String):void {
		if (commandInfos[eventType] === undefined) {
			throw new Error("Undefined event type :: " + eventType);
		}

		var commandInfo:CommandInfo=commandInfos[eventType];
		commandInfo.eventListener.remove();
		delete commandInfos[eventType];
	}

	public function has(eventType:String):Boolean {
		return commandInfos[eventType] !== undefined;
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function eventHandler(event:Event):void {
		var commandInfo:CommandInfo=commandInfos[event.type];

		if (commandInfo) {
			new CommandChain(event, context._injector, commandInfo.commandClasses).next();
		} else {
			throw new Error("Undefined event type :: " + event.type);
		}
	}
}
}
import ssen.reflow.IEventListener;

class CommandInfo {
	public var eventType:String;
	public var eventListener:IEventListener;
	public var commandClasses:Vector.<Class>;

}
