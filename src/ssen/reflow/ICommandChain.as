package ssen.reflow {
import flash.events.Event;

/**
 * [DO NOT IMPLEMENT]
 * @see ICommand#execute()
 */
public interface ICommandChain {
	function get event():Event;

	function get sharedData():Object;

	function next():void;

	function stop():void;
}
}
