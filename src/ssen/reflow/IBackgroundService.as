package ssen.reflow {

/**
 * [IMPLEMENT]
 * @see IBackgroundServiceMap#map()
 */
public interface IBackgroundService {
	/** [Hook] */
	function start():void;

	/** [Hook] */
	function stop():void;
}
}
