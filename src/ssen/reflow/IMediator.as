package ssen.reflow {
import flash.display.DisplayObject;

/**
 * [IMPLEMENT]
 * @see IViewMap#mapView()
 */
public interface IMediator {
	/** [Hook] */
	function setView(value:DisplayObject):void;

	/** [Hook] */
	function startup():void;

	/** [Hook] */
	function shutdown():void;
}
}
