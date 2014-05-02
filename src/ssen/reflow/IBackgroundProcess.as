package ssen.reflow {

/**
 * [구현 필요] <code>BackgroundProcess</code>를 작성할 때 필수 구현.
 *
 * @see IBackgroundProcessMap#map()
 */
public interface IBackgroundProcess {
	/** <code>BackgroundProcess</code> 시작 함수 */
	function start():void;

	/** <code>BackgroundProcess</code> 종료 함수 */
	function stop():void;
}
}
