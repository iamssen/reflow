package ssen.reflow.context {
import flash.events.Event;
import flash.utils.Dictionary;

import ssen.reflow.ICommandChain;
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

	private var _activatedCommandChains:Vector.<ICommandChain>;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function CommandMap() {
		commandInfos = new Dictionary;
		_activatedCommandChains = new <ICommandChain>[];
	}

	//==========================================================================================
	// life cycle on context
	//==========================================================================================
	public function setContext(hostContext:Context):void {
		context = hostContext;
	}

	// TODO [x] dispose() 명령이 떨어질 때, 현재 작동중인 모든 commandChain들 역시 멈춰야 한다
	// TODO [ ] 그리고, 중지 명령에 의한 에러가 없어야 한다
	public function dispose():void {
		// stop all activated command chains
		var commands:Vector.<ICommandChain> = _activatedCommandChains.slice();
		_activatedCommandChains = null;

		var f:int = commands.length;
		var chain:ICommandChain;
		while (--f >= 0) {
			chain = commands[f];
			commands[f].stop();
		}

		// dispose all variables
		commandInfos = null;
		context = null;
		_activatedCommandChains = null;
	}

	//==========================================================================================
	// implements ICommandMap
	//==========================================================================================
	public function map(eventType:String, commandClasses:Vector.<Class>, avoidRunSameCommand:Boolean = false):void {
		// throw error
		// if eventType was exists (do not map twice same event type)
		if (commandInfos[eventType] !== undefined) {
			throw new Error(eventType + " is already exists on command map");
		}

		// create command info
		var commandInfo:CommandInfo = new CommandInfo;
		commandInfo.eventType = eventType;
		commandInfo.eventListener = context._eventBus.addEventListener(eventType, eventHandler);
		commandInfo.commandClasses = commandClasses;
		commandInfo.avoidRunSameCommand = avoidRunSameCommand;

		commandInfos[eventType] = commandInfo;
	}

	// TODO [x] unmap 상황에서 작동 중인 모든 command chain을 작동 중지 시킨다
	public function unmap(eventType:String):void {
		// throw error
		// if eventType is not exists
		if (commandInfos[eventType] === undefined) {
			throw new Error(eventType + " is not exists on command map");
		}

		// stop all activated command chains by unmap event type
		var f:int = -1;
		var fmax:int = _activatedCommandChains.length;

		while (++f < fmax) {
			var commandChain:ICommandChain = _activatedCommandChains[f];
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

	public function get activatedCommandChains():Vector.<ICommandChain> {
		return _activatedCommandChains.slice();
	}

	//==========================================================================================
	// event handlers
	//==========================================================================================
	private function eventHandler(event:Event):void {
		var commandInfo:CommandInfo = commandInfos[event.type];
		var commandChain:ICommandChain;

		if (commandInfo) {
			// stop all activated command chains
			// if it command has `avoidRunSameCommand` option
			if (commandInfo.avoidRunSameCommand) {
				var f:int = -1;
				var fmax:int = _activatedCommandChains.length;

				while (++f < fmax) {
					commandChain = _activatedCommandChains[f];
					if (commandChain.event.type === event.type) {
						commandChain.stop();
					}
				}
			}

			// create and run command chain
			var commandChain:ICommandChain = new CommandChain(
					event,
					context._injector,
					commandInfo.commandClasses,
					commandChainDeconstructed
			);

			_activatedCommandChains.push(commandChain);
			commandChain.next();
		} else {
			throw new Error(event.type + " is not exists on command map");
		}
	}

	private function commandChainDeconstructed(chain:ICommandChain):void {
		if (!_activatedCommandChains) return;
		var index:int = _activatedCommandChains.indexOf(chain);
		if (index > -1) _activatedCommandChains.splice(index, 1);
	}
}
}

import ssen.reflow.IEventListener;

class CommandInfo {
	public var eventType:String;
	public var eventListener:IEventListener;
	public var commandClasses:Vector.<Class>;
	public var avoidRunSameCommand:Boolean;
}
