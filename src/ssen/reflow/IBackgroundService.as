package ssen.reflow {

/**
 * [IMPLEMENT] Interface of <code>BackgroundService</code>
 *
 * @see https://quip.com/8xkhAwa1FUg6 How to make a Background Service
 * @see IBackgroundServiceMap#map()
 */
public interface IBackgroundService {
	/** [Hook] Execute when the <code>BackgroundService</code> start */
	function start():void;

	/** [Hook] Execute when the <code>BackgroundService</code> stop */
	function stop():void;
}
}
