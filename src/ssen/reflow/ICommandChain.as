package ssen.reflow {
import flash.events.Event;

/**
 * [구현 불필요] <code>ICommand.execute(chain:ICommandChain)</code> 실행 시 인자로 넘어오는 <code>chain</code>의 <code>Interface</code>.
 *
 * <p>다수의 <code>Command</code>들을 연속 실행하기 위한 Chain 관리자 역할을 한다.</p>
 *
 * @see ICommand#execute()
 */
public interface ICommandChain {
	/** <code>Command</code>를 실행시킨 Event */
	function get event():Event;

	/** 현재 진행 상태 */
	function get progress():Number;

	/** <code>Command</code>들이 연속 실행되는 과정에서 공유할 수 있는 임시 데이터 공간 */
	function get sharedData():Object;

	/** 현재 <code>Command</code>를 종료하고, 다음 <code>Command</code> 실행 */
	function next():void;

	/** <code>CommandChain</code>을 종료. (현재 및 남아있는 모든 <code>Command</code>를 종료) */
	function stop():void;
}
}
