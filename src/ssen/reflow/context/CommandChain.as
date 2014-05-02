package ssen.reflow.context {
import flash.events.Event;

import ssen.reflow.ICommand;
import ssen.reflow.ICommandChain;
import ssen.reflow.IInjector;

/** @private implements class */
internal class CommandChain implements ICommandChain {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// dependent
	//----------------------------------------------------------------
	private var _injector:IInjector;

	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	// trigger event
	private var _event:Event;

	// chain step
	private var _commandClasses:Vector.<Class>;
	private var _current:int=-1;

	// shared data in chain
	private var _sharedData:Object;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function CommandChain(event:Event, injector:IInjector, commandClasses:Vector.<Class>) {
		_event=event;
		_injector=injector;
		_commandClasses=commandClasses;
	}

	//==========================================================================================
	// implements IEventChain
	//==========================================================================================
	public function get sharedData():Object {
		return _sharedData||={};
	}

	public function get event():Event {
		return _event;
	}

	public function get current():int {
		return _current;
	}

	public function get numCommands():int {
		return _commandClasses.length;
	}

	public function next():void {
		if (++_current < _commandClasses.length) {
			var CommandClass:Class=_commandClasses[_current];
			var command:ICommand=new CommandClass;

			_injector.injectInto(command);

			command.execute(this);
		}
	}

	public function exit():void {
		_current=_commandClasses.length;
	}
}
}
