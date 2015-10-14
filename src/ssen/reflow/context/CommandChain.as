package ssen.reflow.context {
import flash.events.Event;

import ssen.reflow.ICommand;
import ssen.reflow.ICommandChain;
import ssen.reflow.ICommandFlow;
import ssen.reflow.IInjector;

/** @private implements class */
internal class CommandChain implements ICommandChain {
	private var _injector:IInjector;

	private var _event:Event;
	private var _commands:ICommandFlow;
	private var _deconstructCallback:Function;

	private var _sharedData:Object;

	private var _currentCommand:ICommand;

	//==========================================================================================
	// func
	//==========================================================================================
	public function CommandChain(event:Event, injector:IInjector, commands:ICommandFlow, deconstructCallback:Function) {
		_injector = injector;

		_event = event;
		_commands = commands;
		_deconstructCallback = deconstructCallback;
	}

	//----------------------------------------------------------------
	// implements ICommandChain
	//----------------------------------------------------------------
	public function get sharedData():Object {
		return _sharedData ||= {};
	}

	public function get event():Event {
		return _event;
	}

	public function next():void {
		if (_commands.hasNext()) {
			var CommandClass:Class = _commands.next();
			var command:ICommand = new CommandClass;

			_injector.injectInto(command);
			_currentCommand = command;

			command.execute(this);
		} else {
			deconstruct();
		}
	}

	public function stop():void {
		if (_currentCommand) _currentCommand.stop();
		deconstruct();
	}

	private function deconstruct():void {
		_currentCommand = null;

		if (_deconstructCallback !== null) {
			_deconstructCallback(this);
			_deconstructCallback = null;
		}
	}
}
}
