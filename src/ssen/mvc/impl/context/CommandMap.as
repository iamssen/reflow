package ssen.mvc.impl.context {
import flash.events.Event;
import flash.utils.Dictionary;

import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;
import ssen.mvc.ICommandMap;

// TODO EvtGatherer 의존 끊고, 최적화 시키기
internal class CommandMap implements ICommandMap {
	internal var context:Context;

	private var dic:Dictionary=new Dictionary;
	//	private var injector:IInjector;
	//	private var dispatcher:EventEmitter;
	private var evtUnits:EvtGatherer=new EvtGatherer;

	//	public function CommandMap(dispatcher:IEventEmitter, injector:IInjector) {
	//		this.dispatcher=dispatcher;
	//		this.injector=injector;
	//		dic=new Dictionary;
	//		evtUnits=new EvtGatherer;
	//	}

	// dic["change"]=Vector.<Class.<ICommand>>
	public function mapCommand(eventType:String, commandClasses:Vector.<Class>):void {
		if (dic[eventType] !== undefined) {
			throw new Error("");
		}

		dic[eventType]=commandClasses;
//		evtUnits.add(context._eventBus .addEventListener(eventType, eventCatched));
	}

	private function eventCatched(event:Event):void {
		var chain:ICommandChain=new EventChain(event, create(event.type));
		chain.next();
	}

	public function unmapCommand(eventType:String):void {
		if (dic[eventType] === undefined) {
			throw new Error("undefined this command type");
		}

		evtUnits.remove(eventType);
		delete dic[eventType];
	}

	public function hasMapping(eventType:String):Boolean {
		return dic[eventType] !== undefined;
	}

	private function create(eventType:String):Vector.<ICommand> {
		if (dic[eventType] === undefined) {
			throw new Error("undefined command");
		}

		var commandClasses:Vector.<Class>=dic[eventType];
		var commands:Vector.<ICommand>=new Vector.<ICommand>(commandClasses.length, true);
		var cls:Class;

		var f:int=commandClasses.length;
		while (--f >= 0) {
			cls=commandClasses[f];
			commands[f]=new cls();
//			injector.injectInto(commands[f]);
		}

		return commands;
	}

	public function dispose():void {
		dic=null;
	}
}
}
import flash.utils.Dictionary;

import ssen.mvc.IEventUnit;

class EvtGatherer {
	private var map:Dictionary;

	public function add(unit:IEventUnit):void {
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
			var unit:IEventUnit=map.get(type) as IEventUnit;
			unit.stop();
			map.remove(type);
		}
	}
}
