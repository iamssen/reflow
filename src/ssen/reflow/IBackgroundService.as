package ssen.reflow {

/**
 * [구현 필요] <code>BackgroundProcess</code>를 작성할 때 필수 구현.
 *
 * @see IBackgroundProcessMap#map()
 */
public interface IBackgroundService {
	/** [Hook] <code>BackgroundProcess</code> 시작 할 때 */
	function start():void;

	/** [Hook] <code>BackgroundProcess</code> 종료 할 때 */
	function stop():void;
}
}
