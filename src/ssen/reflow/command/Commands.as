package ssen.reflow.command {
import ssen.reflow.ICommandFlow;

/**
 * Default implementation of ICommandFlow
 * @see ssen.reflow.ICommandFlow
 * @see ssen.reflow.ICommandMap#map()
 */
final public class Commands implements ICommandFlow {
	private var f:int;
	private var fmax:int;
	private var commands:Vector.<Class>;

	public function Commands(...commands) {
		if (!commands || commands.length === 0) {
			throw new Error("Commands.Commands() require command classes.");
		}

		this.commands = Vector.<Class>(commands);
		
		f = -1;
		fmax = this.commands.length;
	}

	public function hasNext():Boolean {
		return f < fmax - 1;
	}

	public function next():Class {
		if (++f < fmax) return commands[f];
		return null;
	}
}
}
