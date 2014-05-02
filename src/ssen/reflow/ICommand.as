package ssen.reflow {

/**
 * [구현 필요] <code>Command</code>를 작성할 때 필수 구현.
 *
 * @see ICommandMap#map()
 *
 * @includeExample commandSample.txt
 */
public interface ICommand {
	/**
	 * [Hook] <code>Command</code>의 실행 함수.
	 *
	 * <p><b>주의</b>: <code>Command</code>의 실행 종료 시점에 반드시 
	 * <code>chain.next()</code> 또는 <code>chain.exit()</code>를 호출해줘야 한다.</p>
	 *
	 * @see ICommandChain
	 */
	function execute(chain:ICommandChain):void;
}
}
