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
		if (_data === null) {
			_data={};
		}

		return _data;
	}

	public function get current():int {
		return _current;
	}

	public function next():void {
		if (++_current < _commands.length) {
			_commands[_current].execute(this);
		} else {
			var f:int=_commands.length;
			while (--f >= 0) {
				_commands[f].dispose();
			}
			_commands=null;
			_data=null;
		}
	}

	public function get numCommands():int {
		return _commands.length;
	}

	public function get event():Event {
		return _event;
	}
}
}
