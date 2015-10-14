package ssen.reflow.context {
import flash.events.Event;
import flash.utils.Dictionary;

import ssen.reflow.ICommandChain;
import ssen.reflow.ICommandFlow;
import ssen.reflow.ICommandMap;
import ssen.reflow.reflow_internal;

use namespace reflow_internal;

/** @private implements class */
internal class CommandMap implements ICommandMap {
	private var hostContext:Context;
	private var commandInfos:Dictionary; // [eventType:String]=CommandInfo

	private var _progressingCommandChains:Vector.<ICommandChain>;

	//==========================================================================================
	// func
	//==========================================================================================
	//----------------------------------------------------------------
	// context life cycle
	//----------------------------------------------------------------
	public function setContext(context:Context):void {
		hostContext = context;
		commandInfos = new Dictionary;
		_progressingCommandChains = new <ICommandChain>[];
	}

	public function dispose():void {
		// stop all activated command chains
		var commands:Vector.<ICommandChain> = _progressingCommandChains.slice();
		_progressingCommandChains = null;

		var f:int = commands.length;
		while (--f >= 0) {
			commands[f].stop();
		}

		// dispose all variables
		hostContext = null;
		commandInfos = null;
		_progressingCommandChains = null;
	}

	//----------------------------------------------------------------
	// implements ICommandMap
	//----------------------------------------------------------------
	public function map(eventType:String, commands:ICommandFlow, avoidRunSameCommand:Boolean = false):void {
		// throw error
		// if eventType was exists (do not map twice same event type)
		if (commandInfos[eventType] !== undefined) throw new Error(eventType + " is already exists on command map");

		// create command info
		var commandInfo:CommandInfo = new CommandInfo;
		commandInfo.eventType = eventType;
		commandInfo.eventListener = hostContext._eventBus.addEventListener(eventType, eventHandler);
		commandInfo.commands = commands;
		commandInfo.avoidRunSameCommand = avoidRunSameCommand;

		commandInfos[eventType] = commandInfo;
	}

	public function unmap(eventType:String):void {
		// throw error
		// if eventType is not exists
		if (commandInfos[eventType] === undefined) throw new Error(eventType + " is not exists on command map");

		// stop all activated command chains by unmap event type
		var f:int = -1;
		var fmax:int = _progressingCommandChains.length;

		while (++f < fmax) {
			var commandChain:ICommandChain = _progressingCommandChains[f];
			if (commandChain.event.type === eventType) {
				commandChain.stop();
			}
		}

		// delete command infos
		var commandInfo:CommandInfo = commandInfos[eventType];
		commandInfo.eventListener.remove();
		delete commandInfos[eventType];
	}

	public function has(eventType:String):Boolean {
		return commandInfos[eventType] !== undefined;
	}

	public function get progressingCommandChains():Vector.<ICommandChain> {
		return _progressingCommandChains.slice();
	}

	//----------------------------------------------------------------
	// event handler
	//----------------------------------------------------------------
	private function eventHandler(event:Event):void {
		var commandInfo:CommandInfo = commandInfos[event.type];
		if (!commandInfo) throw new Error(event.type + " is not exists on command map");

		var commandChain:ICommandChain;
		// stop all progressing command chains
		// if it command has `avoidRunSameCommand` option
		if (commandInfo.avoidRunSameCommand) {
			var f:int = -1;
			var fmax:int = _progressingCommandChains.length;

			while (++f < fmax) {
				commandChain = _progressingCommandChains[f];
				if (commandChain.event.type === event.type) commandChain.stop();
			}
		}

		// create and run command chain
		commandChain = new CommandChain(
				event,
				hostContext._injector,
				commandInfo.commands,
				commandChainDeconstructed
		);

		_progressingCommandChains.push(commandChain);
		commandChain.next();
	}

	private function commandChainDeconstructed(chain:ICommandChain):void {
		if (!_progressingCommandChains) return;
		var index:int = _progressingCommandChains.indexOf(chain);
		if (index > -1) _progressingCommandChains.splice(index, 1);
	}
}
}

import ssen.reflow.ICommandFlow;
import ssen.reflow.IEventListener;

class CommandInfo {
	public var eventType:String;
	public var eventListener:IEventListener;
	public var commands:ICommandFlow;
	public var avoidRunSameCommand:Boolean;
}
