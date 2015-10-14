package ssen.reflow {

/**
 * [IMPLEMENT]
 * @see ICommandMap#map()
 */
public interface ICommand {
	/** [Hook] */
	function execute(chain:ICommandChain):void;

	/** [Hook] */
	function stop():void;
}
}
