package ssen.reflow {
import flash.display.DisplayObject;

/**
 * [구현 필요] <code>Mediator</code>를 작성할 때 필수 구현.
 *
 * @see IViewMap#mapView()
 */
public interface IMediator {
	/**
	 * <code>Mediator</code> 작동에 필요한 <code>View</code>를 보내줌
	 *
	 * @param value View
	 */
	function setView(value:DisplayObject):void;

	/** <code>View</code>가 실행 될 때 */
	function startup():void;

	/** <code>View</code>가 종료 될 때  */
	function shutdown():void;
}
}
