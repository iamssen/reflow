package ssen.mvc.impl.context {
import flash.events.Event;

import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;

internal class EventChain implements ICommandChain {
	private var _commands:Vector.<ICommand>;
	private var _data:Object;
	private var _current:int=-1;
	private var _event:Event;

	public function EventChain(event:Event, commands:Vector.<ICommand>) {
		_event=event;
		_commands=commands;
	}

	public function get data():Object {
		return _data||={};
	}

	public function get current():int {
		return _current;
	}

	public function next():void {
		if (++_current < _commands.length) {
			_commands[_current].execute(this);
		}
	}

	public function exit():void {

	}

	public function get numCommands():int {
		return _commands.length;
	}

	public function get event():Event {
		return _event;
	}
}
}
