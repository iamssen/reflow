package ssen.reflow {

/**
 * [IMPLEMENT] <code>Command</code>를 작성할 때 필수 구현.
 *
 * @see ICommandMap#map()
 * @see https://quip.com/ZQb2AAW2bZdx How to make a Command
 *
 * @includeExample commandSample.txt
 */
public interface ICommand {
	/**
	 * [Hook] Execute when <code>Command</code> start on execute time. (ex. load async data...)
	 * <p><b>Warning</b>: You must to call <code>chain.next()</code> or <code>chain.exit()</code> when end this process.</p>
	 */
	function execute(chain:ICommandChain):void;

	/**
	 * [Hook] Execute when <code>Command</code> start on commit time. (ex. set data to model)
	 * <p><b>Warning</b>: You must do call <code>chain.next()</code> or <code>chain.exit()</code> when end this process.</p>
	 */
	function commit(chain:ICommandChain):void;

	/**
	 * [Hook] Execute when stop <code>Command</code>
	 */
	function stop():void;
}
}
