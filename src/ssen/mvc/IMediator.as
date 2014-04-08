package ssen.mvc {
import flash.display.DisplayObject;

/**
 * Implements this interface when make View Mediator
 *
 * @see IViewMap#mapView()@
 */
public interface IMediator {
	/** Automatically set view display object by Context */
	function setView(value:DisplayObject):void;

	/** Automatically execute at added to stage display by Context */
	function startup():void;

	/** Automatically execute at removed from stage display by Context */
	function shutdown():void;
}
}
