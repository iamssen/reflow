package ssen.mvc {
import flash.events.Event;

/**
 * Chain manager for ICommand.
 *
 * @see ICommand#execute()
 */
public interface ICommandChain {
	/** Trigger event */
	function get event():Event;

	/** Current sequence of executed commands */
	function get current():int;

	/** Length of executed commands */
	function get numCommands():int;

	/** Shared Data on executed commands */
	function get sharedData():Object;

	/** Exit current command and execute next command */
	function next():void;

	/** Exit all commands */
	function exit():void;
}
}
