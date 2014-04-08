package ssen.mvc {

/**
 * Event Listener.
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
