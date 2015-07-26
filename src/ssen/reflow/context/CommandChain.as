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
	// states
	//----------------------------------------------------------------
	private static const PROGRESS_EXECUTE:int = 0;
	private static const PROGRESS_COMMIT:int = 1;
	private static const STOPED:int = -1;

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
	private var _current:int;
	private var _commands:Vector.<ICommand>;
	private var _numCommands:int;
	private var _state:int;

	// shared data in chain
	private var _sharedData:Object;

	// notify deconstruct situation (stop, end chain)
	private var _deconstructCallback:Function;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function CommandChain(event:Event, injector:IInjector, commandClasses:Vector.<Class>, deconstructCallback:Function) {
		_current = -1;
		_state = PROGRESS_EXECUTE;
		_event = event;
		_injector = injector;
		_commandClasses = commandClasses;
		_numCommands = commandClasses.length;
		_commands = new Vector.<ICommand>(commandClasses.length, true);
		_deconstructCallback = deconstructCallback;
	}

	//==========================================================================================
	// implements ICommandChain
	//==========================================================================================
	public function get sharedData():Object {
		return _sharedData ||= {};
	}

	public function get event():Event {
		return _event;
	}

	public function get progress():Number {
		switch (_state) {
			case PROGRESS_EXECUTE:
				return (_current + 1) / (_numCommands * 2);
			case PROGRESS_EXECUTE:
				return (_current + 1 + _numCommands) / (_numCommands * 2);
			default :
				return 1;
		}
	}

	public function next():void {
		if (_state === PROGRESS_EXECUTE) {
			if (++_current < _numCommands) {
				// create and execute command
				// when running this chain for execute
				var CommandClass:Class = _commandClasses[_current];
				var command:ICommand = new CommandClass;

				_commands[_current] = command;
				_injector.injectInto(command);

				command.execute(this);
			} else {
				// start commit
				_state = PROGRESS_COMMIT;
				_current = -1;
				next();
			}
		} else if (_state === PROGRESS_COMMIT) {
			if (++_state < _numCommands) {
				// commit command
				_commands[_current].commit(this);
			} else {
				// end chain to deconstruct
				deconstruct();
			}
		}
	}

	public function stop():void {
		if (_state < 0) return;

		// stop all commands
		if (_commands && _commands.length > 0) {
			var f:int = -1;
			var fmax:int = _commands.length;
			var command:ICommand;
			while (++f < fmax) {
				command = _commands[f];
				if (command is ICommand) command.stop();
			}
			_commands = null;
		}

		// stop to deconstruct
		deconstruct();
	}

	private function deconstruct():void {
		_state = STOPED;
		if (_deconstructCallback !== null) {
			_deconstructCallback(this);
			_deconstructCallback = null;
		}
	}
}
}
