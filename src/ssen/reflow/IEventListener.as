package ssen.reflow {

/**
 * [DO NOT IMPLEMENT]
 * @see IEventBus#addEventListener()
 */
public interface IEventListener {
	function get type():String;

	function get listener():Function;

	function remove():void;
}
}
