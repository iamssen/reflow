package ssen.mvc.impl {
import flash.utils.Dictionary;

import ssen.mvc.Evt;
import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;

internal class ImplEventChain implements ICommandChain {

	private var _commands:Vector.<ICommand>;
	private var dic:Dictionary;
	private var c:int=-1;
	private var _trigger:Evt;

	public function ImplEventChain(trigger:Evt, commands:Vector.<ICommand>) {
		_trigger=trigger;
		_commands=commands;
	}

	public function get cache():Dictionary {
		if (dic === null) {
			dic=new Dictionary(true);
		}

		return dic;
	}

	public function get current():int {
		return c;
	}

	public function next():void {
		if (++c < _commands.length) {
			_commands[c].execute(this);
		} else {
			var f:int=_commands.length;
			while (--f >= 0) {
				_commands[f].dispose();
			}
			_commands=null;
			dic=null;
		}
	}

	public function get numCommands():int {
		return _commands.length;
	}

	public function get trigger():Evt {
		return _trigger;
	}
}
}
