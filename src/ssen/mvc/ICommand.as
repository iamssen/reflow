package ssen.mvc {

/**
 * Implements this interface when make Command.
 *
 * @see ICommand#mapCommand()
 *
 * @includeExample commandSample.txt
 */
public interface ICommand {
	/**
	 * Automatically execute by Context.
	 *
	 * <p>Warning: Require call <code>chain.next()</code> or <code>chain.exit()</code>
	 * when complete of Command</p>
	 *
	 * @see ICommandChain
	 */
	function execute(chain:ICommandChain):void;
}
}
