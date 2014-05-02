package ssen.reflow {

/**
 * [구현 불필요] <code>IEventBus.addEventListener()</code>로 <code>Event</code> 등록 시에, Return 해준다
 *
 * @see IEventBus#addEventListener()
 */
public interface IEventListener {
	/** Event type */
	function get type():String;

	/** Event handler function */
	function get listener():Function;

	/** Remove event listener */
	function remove():void;
}
}
