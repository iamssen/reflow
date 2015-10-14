package ssen.reflow {

/**
 * [IMPLEMENT]
 * @see ssen.reflow.command.Commands
 * @see ICommandMap#map()
 */
public interface ICommandFlow {
	function hasNext():Boolean;

	function next():Class;
}
}
