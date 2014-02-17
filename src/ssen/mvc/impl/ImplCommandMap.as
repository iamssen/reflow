package ssen.mvc.impl {
import flash.utils.Dictionary;

import ssen.mvc.Evt;
import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;
import ssen.mvc.ICommandMap;
import ssen.mvc.IEvtDispatcher;
import ssen.mvc.IInjector;

internal class ImplCommandMap implements ICommandMap {
	private var dic:Dictionary;
	private var injector:IInjector;
	private var dispatcher:IEvtDispatcher;
	private var evtUnits:EvtGatherer;

	public function ImplCommandMap(dispatcher:IEvtDispatcher, injector:IInjector) {
		this.dispatcher=dispatcher;
		this.injector=injector;
		dic=new Dictionary;
		evtUnits=new EvtGatherer;
	}

	public function mapCommand(eventType:String, commandClasses:Vector.<Class>):void {
		if (dic[eventType] !== undefined) {
			throw new Error("mapped this event type");
		}

		dic[eventType]=commandClasses;
		evtUnits.add(dispatcher.addEvtListener(eventType, eventCatched));
	}

	private function eventCatched(event:Evt):void {
		var chain:ICommandChain=new ImplEventChain(event, create(event.type));
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
			injector.injectInto(commands[f]);
		}

		return commands;
	}

	public function dispose():void {
		dic=null;
	}
}
}
